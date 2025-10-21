-- ============================================================================
-- SUPABASE MIGRATION SCRIPT
-- Purpose: Set up grants database for CanGrant app
-- Date: October 20, 2025
-- ============================================================================

-- ============================================================================
-- STEP 1: Create Tables
-- ============================================================================

-- Main grants table
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

-- Eligibility tags
CREATE TABLE IF NOT EXISTS eligibility_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Junction table: grants <-> eligibility tags
CREATE TABLE IF NOT EXISTS grant_eligibility (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES eligibility_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- Industry tags
CREATE TABLE IF NOT EXISTS industry_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Junction table: grants <-> industry tags
CREATE TABLE IF NOT EXISTS grant_industries (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES industry_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- Type tags
CREATE TABLE IF NOT EXISTS type_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

-- Junction table: grants <-> type tags
CREATE TABLE IF NOT EXISTS grant_types (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES type_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- ============================================================================
-- STEP 2: Create Indexes for Performance
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_grants_status ON grants(status);
CREATE INDEX IF NOT EXISTS idx_grants_deadline ON grants(deadline);
CREATE INDEX IF NOT EXISTS idx_grants_active ON grants(is_active);
CREATE INDEX IF NOT EXISTS idx_grants_updated ON grants(updated_at);
CREATE INDEX IF NOT EXISTS idx_grant_eligibility_grant ON grant_eligibility(grant_id);
CREATE INDEX IF NOT EXISTS idx_grant_industries_grant ON grant_industries(grant_id);
CREATE INDEX IF NOT EXISTS idx_grant_types_grant ON grant_types(grant_id);

-- ============================================================================
-- STEP 3: Enable Row Level Security (RLS)
-- ============================================================================

ALTER TABLE grants ENABLE ROW LEVEL SECURITY;
ALTER TABLE eligibility_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_eligibility ENABLE ROW LEVEL SECURITY;
ALTER TABLE industry_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_industries ENABLE ROW LEVEL SECURITY;
ALTER TABLE type_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE grant_types ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- STEP 4: Create RLS Policies
-- ============================================================================

-- Policy: Anyone can read active grants (no authentication required)
CREATE POLICY "Anyone can view active grants"
ON grants FOR SELECT
USING (is_active = true);

-- Policy: Anyone can read all tags
CREATE POLICY "Anyone can view eligibility tags"
ON eligibility_tags FOR SELECT
USING (true);

CREATE POLICY "Anyone can view grant eligibility"
ON grant_eligibility FOR SELECT
USING (true);

CREATE POLICY "Anyone can view industry tags"
ON industry_tags FOR SELECT
USING (true);

CREATE POLICY "Anyone can view grant industries"
ON grant_industries FOR SELECT
USING (true);

CREATE POLICY "Anyone can view type tags"
ON type_tags FOR SELECT
USING (true);

CREATE POLICY "Anyone can view grant types"
ON grant_types FOR SELECT
USING (true);

-- ============================================================================
-- STEP 5: Add Admin Role to Profiles (for future admin panel)
-- ============================================================================

-- Add role column if it doesn't exist
DO $$ 
BEGIN
  IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                 WHERE table_name = 'profiles' AND column_name = 'role') THEN
    ALTER TABLE profiles 
    ADD COLUMN role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin'));
  END IF;
END $$;

-- Policy: Only admins can modify grants
CREATE POLICY "Only admins can modify grants"
ON grants FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- Policy: Only admins can modify tags
CREATE POLICY "Only admins can modify eligibility tags"
ON eligibility_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Only admins can modify grant eligibility"
ON grant_eligibility FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Only admins can modify industry tags"
ON industry_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Only admins can modify grant industries"
ON grant_industries FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Only admins can modify type tags"
ON type_tags FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

CREATE POLICY "Only admins can modify grant types"
ON grant_types FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);

-- ============================================================================
-- STEP 6: Insert Initial Tag Data
-- ============================================================================

-- Insert eligibility tags
INSERT INTO eligibility_tags (name) VALUES 
  ('Corporation'),
  ('Non-profit'),
  ('Charity')
ON CONFLICT (name) DO NOTHING;

-- Insert industry tags
INSERT INTO industry_tags (name) VALUES 
  ('Art'),
  ('Education'),
  ('Environment'),
  ('Employment')
ON CONFLICT (name) DO NOTHING;

-- Insert type tags
INSERT INTO type_tags (name) VALUES 
  ('Federal'),
  ('Provincial'),
  ('Company'),
  ('City')
ON CONFLICT (name) DO NOTHING;

-- ============================================================================
-- STEP 7: Insert Your 4 Existing Grants
-- ============================================================================

-- Grant 1: Funding for Art
INSERT INTO grants (title, list_summary, full_details, status, application_open_date, deadline, amount_max, issuing_body, grant_link)
VALUES (
  'Funding for Art',
  'Federal funding for corporations seeking great artists for art projects.',
  'Funding for Art - seeking great artists. Administered by the Government of Canada, this fund is dedicated to supporting incorporated artistic ventures.',
  'Closed',
  '2025-09-01',
  '2025-09-20',
  5000,
  'Government of Canada',
  'www.storybee.space'
) ON CONFLICT DO NOTHING;

-- Link Grant 1 tags
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
INSERT INTO grants (title, list_summary, full_details, status, application_open_date, deadline, amount_max, issuing_body, grant_link)
VALUES (
  'Funding for Provincial Education',
  'Provincial funding from Ontario for organizations seeking to hire teachers.',
  'Funding for Provincial Education - seeking teachers. The Ontario government offers this grant to support educational initiatives across the province.',
  'Open',
  '2025-09-02',
  '2025-11-23',
  20000,
  'Ontario',
  'www.nridl.org'
) ON CONFLICT DO NOTHING;

-- Link Grant 2 tags
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
INSERT INTO grants (title, list_summary, full_details, status, application_open_date, deadline, amount_max, issuing_body, grant_link)
VALUES (
  'Funding for Women Entrepreneurs',
  'Corporate funding from BMO to encourage gender equity and support charitable environmental causes.',
  'Funding for Women Entrepreneurs - Encourage gender equity. BMO initiative for Women Entrepreneurs.',
  'Open',
  '2024-08-11',
  '2025-11-12',
  3400,
  'BMO',
  'www.irpartners.ca'
) ON CONFLICT DO NOTHING;

-- Link Grant 3 tags
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 3, id FROM eligibility_tags WHERE name = 'Charity'
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 3, id FROM industry_tags WHERE name = 'Environment'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 3, id FROM type_tags WHERE name = 'Company'
ON CONFLICT DO NOTHING;

-- Grant 4: Funding for Employment
INSERT INTO grants (title, list_summary, full_details, status, application_open_date, deadline, amount_max, issuing_body, grant_link)
VALUES (
  'Funding for Employment',
  'Municipal funding from the City of Toronto to encourage the hiring of local employees.',
  'Funding for Employment - encourage local employees. The City of Toronto provides this grant on a rolling basis.',
  'Rolling Basis',
  NULL,
  NULL,
  8700,
  'City of Toronto',
  'www.allcornerstone.com'
) ON CONFLICT DO NOTHING;

-- Link Grant 4 tags
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 4, id FROM eligibility_tags WHERE name IN ('Corporation', 'Non-profit')
ON CONFLICT DO NOTHING;

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 4, id FROM industry_tags WHERE name = 'Employment'
ON CONFLICT DO NOTHING;

INSERT INTO grant_types (grant_id, tag_id)
SELECT 4, id FROM type_tags WHERE name = 'City'
ON CONFLICT DO NOTHING;

-- ============================================================================
-- STEP 8: Create Function to Auto-Update "updated_at" Column
-- ============================================================================

CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_grants_updated_at
BEFORE UPDATE ON grants
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- ============================================================================
-- STEP 9: Make Yourself Admin (REPLACE WITH YOUR EMAIL!)
-- ============================================================================

-- ⚠️ IMPORTANT: Replace 'your@email.com' with your actual email
-- This gives you permission to edit grants from an admin panel later

-- UPDATE profiles 
-- SET role = 'admin' 
-- WHERE email = 'your@email.com';

-- ============================================================================
-- VERIFICATION QUERIES (Run these to check everything worked)
-- ============================================================================

-- Check grants were created
-- SELECT id, title, status, deadline FROM grants;

-- Check tags were created
-- SELECT * FROM eligibility_tags;
-- SELECT * FROM industry_tags;
-- SELECT * FROM type_tags;

-- Check grant-tag relationships
-- SELECT g.title, et.name as eligibility
-- FROM grants g
-- JOIN grant_eligibility ge ON g.id = ge.grant_id
-- JOIN eligibility_tags et ON ge.tag_id = et.id;

-- ============================================================================
-- SUCCESS! 🎉
-- Your database is now set up and ready to use.
-- Next step: Update your Flutter app to load from this database.
-- ============================================================================
