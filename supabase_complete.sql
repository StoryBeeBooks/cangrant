-- ============================================================================
-- COMPLETE SUPABASE SETUP FOR MY-GRANTS APP
-- Run this entire script in Supabase SQL Editor
-- Just copy everything and paste it, then click "Run"
-- ============================================================================

-- ============================================================================
-- STEP 1: CREATE PROFILES TABLE
-- This stores user data, including admin role and metered paywall info
-- ============================================================================

CREATE TABLE IF NOT EXISTS profiles (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  business_profile JSONB,
  free_views_remaining INTEGER DEFAULT 3,
  subscription_tier TEXT CHECK (subscription_tier IN ('free', 'premium', 'pro')),
  subscription_expires_at TIMESTAMP WITH TIME ZONE,
  role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin')),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable Row Level Security
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Users can view their own profile
CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (auth.uid() = user_id);

-- Users can update their own profile
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = user_id);

-- Users can insert their own profile
CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Auto-create profile when user signs up
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, free_views_remaining, role)
  VALUES (NEW.id, NEW.email, 3, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- ============================================================================
-- STEP 2: CREATE GRANTS TABLE
-- This is the main table storing all grant information
-- ============================================================================

CREATE TABLE IF NOT EXISTS grants (
  id SERIAL PRIMARY KEY,
  title TEXT NOT NULL,
  list_summary TEXT NOT NULL,
  full_details TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('Open', 'Closed', 'Coming Soon', 'Rolling Basis')),
  application_open_date DATE,
  deadline DATE,
  amount_max INTEGER NOT NULL,
  issuing_body TEXT NOT NULL,
  grant_link TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  is_active BOOLEAN DEFAULT TRUE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_grants_status ON grants(status);
CREATE INDEX IF NOT EXISTS idx_grants_deadline ON grants(deadline);
CREATE INDEX IF NOT EXISTS idx_grants_active ON grants(is_active);
CREATE INDEX IF NOT EXISTS idx_grants_updated ON grants(updated_at);

-- Enable Row Level Security
ALTER TABLE grants ENABLE ROW LEVEL SECURITY;

-- Anyone can read active grants (no login required)
CREATE POLICY "Anyone can view active grants"
ON grants FOR SELECT
USING (is_active = true);

-- Auto-update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS update_grants_updated_at ON grants;
CREATE TRIGGER update_grants_updated_at
BEFORE UPDATE ON grants
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STEP 3: CREATE TAG TABLES (ELIGIBILITY, INDUSTRY, TYPE)
-- Tags categorize grants with many-to-many relationships
-- ============================================================================

-- Eligibility tags (who can apply)
CREATE TABLE IF NOT EXISTS eligibility_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Industry tags (what sector)
CREATE TABLE IF NOT EXISTS industry_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Type tags (government level)
CREATE TABLE IF NOT EXISTS type_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- ============================================================================
-- STEP 4: CREATE JUNCTION TABLES (MANY-TO-MANY RELATIONSHIPS)
-- These link grants to their tags
-- ============================================================================

-- Grant to Eligibility tags
CREATE TABLE IF NOT EXISTS grant_eligibility (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES eligibility_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_grant_eligibility_grant ON grant_eligibility(grant_id);

-- Grant to Industry tags
CREATE TABLE IF NOT EXISTS grant_industries (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES industry_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_grant_industries_grant ON grant_industries(grant_id);

-- Grant to Type tags
CREATE TABLE IF NOT EXISTS grant_types (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES type_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_grant_types_grant ON grant_types(grant_id);

-- ============================================================================
-- STEP 5: ENABLE RLS ON TAG TABLES
-- Anyone can read tags, only admins can modify
-- ============================================================================

ALTER TABLE eligibility_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE industry_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE type_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_eligibility ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_industries ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_types ENABLE ROW LEVEL SECURITY;

-- Anyone can read tags
CREATE POLICY "Anyone can view eligibility tags" ON eligibility_tags FOR SELECT USING (true);
CREATE POLICY "Anyone can view industry tags" ON industry_tags FOR SELECT USING (true);
CREATE POLICY "Anyone can view type tags" ON type_tags FOR SELECT USING (true);
CREATE POLICY "Anyone can view grant eligibility" ON grant_eligibility FOR SELECT USING (true);
CREATE POLICY "Anyone can view grant industries" ON grant_industries FOR SELECT USING (true);
CREATE POLICY "Anyone can view grant types" ON grant_types FOR SELECT USING (true);

-- ============================================================================
-- STEP 6: CREATE ADMIN POLICIES
-- Only users with role='admin' can modify grants and tags
-- ============================================================================

-- Admin can modify grants
CREATE POLICY "Admins can modify grants"
ON grants FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify eligibility tags
CREATE POLICY "Admins can modify eligibility tags"
ON eligibility_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify industry tags
CREATE POLICY "Admins can modify industry tags"
ON industry_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify type tags
CREATE POLICY "Admins can modify type tags"
ON type_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify grant-eligibility links
CREATE POLICY "Admins can modify grant eligibility"
ON grant_eligibility FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify grant-industry links
CREATE POLICY "Admins can modify grant industries"
ON grant_industries FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Admin can modify grant-type links
CREATE POLICY "Admins can modify grant types"
ON grant_types FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- ============================================================================
-- STEP 7: INSERT INITIAL TAG DATA
-- Pre-populate with common tags
-- ============================================================================

-- Eligibility tags
INSERT INTO eligibility_tags (name) VALUES 
  ('Corporation'),
  ('Non-profit'),
  ('Charity')
ON CONFLICT (name) DO NOTHING;

-- Industry tags
INSERT INTO industry_tags (name) VALUES 
  ('Art'),
  ('Education'),
  ('Environment'),
  ('Employment')
ON CONFLICT (name) DO NOTHING;

-- Type tags
INSERT INTO type_tags (name) VALUES 
  ('Federal'),
  ('Provincial'),
  ('Company'),
  ('City')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- STEP 8: INSERT SAMPLE GRANTS
-- 4 sample grants to test your app
-- ============================================================================

-- Insert grants (will get IDs 1-4)
INSERT INTO grants (title, list_summary, full_details, status, application_open_date, deadline, amount_max, issuing_body, grant_link)
VALUES 
  (
    'Funding for Art',
    'Federal funding for corporations seeking great artists for art projects.',
    'Funding for Art - seeking great artists. Administered by the Government of Canada, this fund is dedicated to supporting incorporated artistic ventures.',
    'Closed',
    '2025-09-01',
    '2025-09-20',
    5000,
    'Government of Canada',
    'www.storybee.space'
  ),
  (
    'Funding for Provincial Education',
    'Provincial funding from Ontario for organizations seeking to hire teachers.',
    'Funding for Provincial Education - seeking teachers. The Ontario government offers this grant to support educational initiatives across the province.',
    'Open',
    '2025-09-02',
    '2025-11-23',
    20000,
    'Ontario',
    'www.nridl.org'
  ),
  (
    'Funding for Women Entrepreneurs',
    'Corporate funding from BMO to encourage gender equity and support charitable environmental causes.',
    'Funding for Women Entrepreneurs - Encourage gender equity. BMO initiative for Women Entrepreneurs.',
    'Open',
    '2024-08-11',
    '2025-11-12',
    3400,
    'BMO',
    'www.irpartners.ca'
  ),
  (
    'Funding for Employment',
    'Municipal funding from the City of Toronto to encourage the hiring of local employees.',
    'Funding for Employment - encourage local employees. The City of Toronto provides this grant on a rolling basis.',
    'Rolling Basis',
    NULL,
    NULL,
    8700,
    'City of Toronto',
    'www.allcornerstone.com'
  )
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 9: LINK GRANTS TO TAGS
-- Connect each grant to its appropriate tags
-- ============================================================================

-- Grant 1: Funding for Art
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 1, id FROM eligibility_tags WHERE name = 'Corporation'
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 1, id FROM industry_tags WHERE name = 'Art'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 1, id FROM type_tags WHERE name = 'Federal'
ON CONFLICT DO NOTHING;

-- Grant 2: Funding for Provincial Education
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 2, id FROM eligibility_tags WHERE name = 'Non-profit'
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 2, id FROM industry_tags WHERE name = 'Education'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 2, id FROM type_tags WHERE name = 'Provincial'
ON CONFLICT DO NOTHING;

-- Grant 3: Funding for Women Entrepreneurs
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 3, id FROM eligibility_tags WHERE name = 'Charity'
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 3, id FROM industry_tags WHERE name = 'Environment'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 3, id FROM type_tags WHERE name = 'Company'
ON CONFLICT DO NOTHING;

-- Grant 4: Funding for Employment (has 2 eligibility tags!)
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 4, id FROM eligibility_tags WHERE name = 'Corporation'
ON CONFLICT DO NOTHING;

INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 4, id FROM eligibility_tags WHERE name = 'Non-profit'
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 4, id FROM industry_tags WHERE name = 'Employment'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 4, id FROM type_tags WHERE name = 'City'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- SUCCESS! 🎉
-- Your database is now fully set up!
-- ============================================================================

-- Run these queries to verify everything worked:

-- 1. Check all tables exist
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN ('profiles', 'grants', 'eligibility_tags', 'industry_tags', 'type_tags', 'grant_eligibility', 'grant_industries', 'grant_types')
ORDER BY table_name;

-- 2. Check grants were created
SELECT id, title, status, deadline FROM grants ORDER BY id;

-- 3. Check tags were created
SELECT 'eligibility' as type, name FROM eligibility_tags
UNION ALL
SELECT 'industry', name FROM industry_tags
UNION ALL
SELECT 'type', name FROM type_tags
ORDER BY type, name;

-- 4. Check grant-tag relationships
SELECT 
  g.id,
  g.title,
  string_agg(DISTINCT et.name, ', ') as eligibility,
  string_agg(DISTINCT it.name, ', ') as industries,
  string_agg(DISTINCT tt.name, ', ') as types
FROM grants g
LEFT JOIN grant_eligibility ge ON g.id = ge.grant_id
LEFT JOIN eligibility_tags et ON ge.tag_id = et.id
LEFT JOIN grant_industries gi ON g.id = gi.grant_id
LEFT JOIN industry_tags it ON gi.tag_id = it.id
LEFT JOIN grant_types gt ON g.id = gt.grant_id
LEFT JOIN type_tags tt ON gt.tag_id = tt.id
GROUP BY g.id, g.title
ORDER BY g.id;
