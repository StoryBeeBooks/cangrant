# Backend Architecture & Database Strategy

## 🤔 Your Current vs Ideal Setup

### **Current Implementation:**
```
App → grants.json (bundled in app) → Display grants
```
**Problems:**
- ❌ Need app update to change grant data
- ❌ Users see outdated information
- ❌ Can't add new grants without app store review
- ❌ No real-time updates

### **Ideal Implementation:**
```
App → Supabase Database → Real-time grant data
Admin Panel → Supabase Database → Update grants anytime
```
**Benefits:**
- ✅ Update grants instantly without app updates
- ✅ Add new grants immediately
- ✅ All users see latest data
- ✅ Centralized management

---

## 🗄️ Recommended Database Architecture

### **Option 1: Supabase (RECOMMENDED)**

**Why Supabase?**
- ✅ You're already using it for auth
- ✅ Free tier is VERY generous
- ✅ PostgreSQL (powerful, scalable)
- ✅ Real-time subscriptions built-in
- ✅ Row Level Security (RLS)
- ✅ Easy to use
- ✅ Can handle millions of requests

**Supabase Database Schema:**

```sql
-- Grants table (main data)
CREATE TABLE grants (
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

-- Eligibility tags (many-to-many relationship)
CREATE TABLE eligibility_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE grant_eligibility (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES eligibility_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- Industry tags (many-to-many relationship)
CREATE TABLE industry_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE grant_industries (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES industry_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- Type tags (many-to-many relationship)
CREATE TABLE type_tags (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE grant_types (
  grant_id INTEGER REFERENCES grants(id) ON DELETE CASCADE,
  tag_id INTEGER REFERENCES type_tags(id) ON DELETE CASCADE,
  PRIMARY KEY (grant_id, tag_id)
);

-- Create indexes for performance
CREATE INDEX idx_grants_status ON grants(status);
CREATE INDEX idx_grants_deadline ON grants(deadline);
CREATE INDEX idx_grants_active ON grants(is_active);
CREATE INDEX idx_grants_updated ON grants(updated_at);

-- Enable Row Level Security
ALTER TABLE grants ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read active grants
CREATE POLICY "Anyone can view active grants"
ON grants FOR SELECT
USING (is_active = true);

-- Policy: Only authenticated admins can modify
-- (You'll need an admin role in your profiles table)
CREATE POLICY "Only admins can modify grants"
ON grants FOR ALL
USING (
  EXISTS (
    SELECT 1 FROM profiles
    WHERE profiles.user_id = auth.uid()
    AND profiles.role = 'admin'
  )
);
```

### **Add Admin Role to Profiles:**

```sql
-- Add role column to profiles
ALTER TABLE profiles 
ADD COLUMN role TEXT DEFAULT 'user' CHECK (role IN ('user', 'admin'));

-- Make yourself admin (replace with your user_id)
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'your@email.com';
```

---

## 💰 Cost Analysis: 100,000 Users, 1M Searches/Day

### **Supabase Pricing Breakdown:**

#### **Free Tier (Perfect for Launch!):**
- ✅ **500 MB database** (plenty for thousands of grants)
- ✅ **Unlimited API requests** (yes, really!)
- ✅ **50,000 monthly active users**
- ✅ **1 GB file storage**
- ✅ **2 GB bandwidth**

**Cost for your scenario:** **$0/month** 🎉

#### **Pro Tier ($25/month):**
- ✅ **8 GB database**
- ✅ **Unlimited API requests** (still!)
- ✅ **100,000 monthly active users**
- ✅ **100 GB file storage**
- ✅ **250 GB bandwidth**

**Cost for 100k users, 1M requests/day:** **$25/month** 🎉

### **Bandwidth Calculation:**

**Assumptions:**
- 1 grant record ≈ 2 KB (with all fields)
- 1 million searches/day = 1M requests/day
- Each search returns ~10 grants = 20 KB per request
- Total: 1M × 20 KB = **20 GB/day** = **600 GB/month**

**Bandwidth Cost:**
- Supabase Pro: 250 GB included
- Extra: 350 GB × $0.09/GB = **$31.50/month**

**Total Monthly Cost:**
- Pro Plan: $25
- Extra Bandwidth: $31.50
- **Total: ~$57/month** for 100k users! 😮

### **Compare to Alternatives:**

| Service | 100k Users Cost | Notes |
|---------|----------------|-------|
| **Supabase** | $57/month | Best value, easiest |
| Firebase | $125-200/month | More expensive bandwidth |
| AWS RDS | $150-300/month | Complex setup |
| MongoDB Atlas | $60-100/month | Good alternative |
| Custom Server | $50-100/month | Maintenance time |

---

## 🚀 Migration Strategy: JSON → Database

### **Phase 1: Keep Both (Recommended for Launch)**

```dart
// lib/services/grant_service.dart

class GrantService {
  static Future<List<Grant>> loadGrants() async {
    try {
      // Try loading from Supabase first
      final grants = await _loadFromSupabase();
      if (grants.isNotEmpty) return grants;
    } catch (e) {
      print('Failed to load from Supabase, using local: $e');
    }
    
    // Fallback to local JSON
    return await _loadFromLocal();
  }

  static Future<List<Grant>> _loadFromSupabase() async {
    final supabase = SupabaseService().client;
    
    final response = await supabase
        .from('grants')
        .select('''
          *,
          grant_eligibility(eligibility_tags(name)),
          grant_industries(industry_tags(name)),
          grant_types(type_tags(name))
        ''')
        .eq('is_active', true)
        .order('updated_at', ascending: false);
    
    return (response as List)
        .map((json) => Grant.fromSupabaseJson(json))
        .toList();
  }

  static Future<List<Grant>> _loadFromLocal() async {
    final String response = await rootBundle.loadString('assets/data/grants.json');
    final data = json.decode(response);
    return (data['grants'] as List)
        .map((json) => Grant.fromJson(json))
        .toList();
  }
}
```

**Benefits:**
- ✅ App works offline with cached data
- ✅ Graceful degradation if Supabase down
- ✅ Zero risk migration

### **Phase 2: Add Caching**

```dart
class GrantService {
  static List<Grant>? _cachedGrants;
  static DateTime? _lastFetch;
  static const _cacheDuration = Duration(hours: 1);

  static Future<List<Grant>> loadGrants({bool forceRefresh = false}) async {
    // Return cached if fresh
    if (!forceRefresh && 
        _cachedGrants != null && 
        _lastFetch != null &&
        DateTime.now().difference(_lastFetch!) < _cacheDuration) {
      return _cachedGrants!;
    }

    // Fetch fresh data
    final grants = await _loadFromSupabase();
    _cachedGrants = grants;
    _lastFetch = DateTime.now();
    return grants;
  }
}
```

**Benefits:**
- ✅ Reduces API calls by 95%
- ✅ Faster app performance
- ✅ Lower costs

---

## 🛠️ Admin Panel Options

You need a way to manage grants without touching code!

### **Option 1: Supabase Studio (Built-in, FREE)**

**Pros:**
- ✅ Already included with Supabase
- ✅ Can add/edit/delete grants directly
- ✅ No extra cost
- ✅ Works immediately

**Cons:**
- ❌ Technical interface (not user-friendly for non-devs)
- ❌ No validation or custom workflows

**Good for:** You personally managing grants

### **Option 2: Build Custom Admin Panel (RECOMMENDED)**

**Tech Stack:**
- Frontend: Flutter Web (reuse your code!) or Next.js
- Backend: Supabase (same database)
- Hosting: Vercel (FREE) or Netlify (FREE)

**Features:**
- ✅ Custom forms for adding grants
- ✅ Validation before saving
- ✅ Preview before publishing
- ✅ Schedule grant expiry automatically
- ✅ Dashboard with analytics
- ✅ Multiple admin users

**Cost:** $0 (hosting is free)

**Development time:** ~8-12 hours

### **Option 3: Use Retool or Budibase (Low-Code)**

**Cost:** $10-50/month  
**Time:** 2-4 hours setup  
**Good for:** Quick admin panel without coding

---

## 📊 Optimized Cost Breakdown (Realistic)

### **Actual Usage Patterns:**

Most apps don't have constant traffic. More realistic:

**Assumptions:**
- 100k registered users
- 20k monthly active users (MAU)
- 10k daily active users (DAU)
- Average 10 searches per active user per day
- 100k searches/day (not 1M)

**Bandwidth:**
- 100k searches × 20 KB = 2 GB/day
- 60 GB/month

**Cost:**
- Supabase Pro: $25/month (includes 250 GB)
- **Total: $25/month** 🎉

### **Growth Scaling:**

| Users | Searches/Day | Bandwidth/Month | Cost |
|-------|-------------|-----------------|------|
| 10k | 10k | 6 GB | **$0** (free tier) |
| 50k | 50k | 30 GB | **$0** (free tier) |
| 100k | 100k | 60 GB | **$25** |
| 500k | 500k | 300 GB | **$30** |
| 1M | 1M | 600 GB | **$57** |

**You won't go broke!** 😊

---

## 🎯 Recommended Implementation Plan

### **Step 1: Setup Database (1-2 hours)**
```sql
-- Run the SQL schema above in Supabase
-- Migrate your 4 existing grants
-- Make yourself admin
```

### **Step 2: Update App Code (2-3 hours)**
```dart
// Update GrantService to load from Supabase
// Keep JSON as fallback
// Add caching
```

### **Step 3: Test (1 hour)**
```dart
// Verify grants load from database
// Test fallback to JSON
// Check caching works
```

### **Step 4: Build Simple Admin Panel (Optional, 8 hours)**
```dart
// Flutter Web admin panel
// Or use Supabase Studio directly
```

---

## 🔥 Quick Start: Migrate Your 4 Grants

Here's SQL to insert your existing grants:

```sql
-- Insert grants
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
);

-- Insert tags
INSERT INTO eligibility_tags (name) VALUES 
('Corporation'), ('Non-profit'), ('Charity');

INSERT INTO industry_tags (name) VALUES 
('Art'), ('Education'), ('Environment'), ('Employment');

INSERT INTO type_tags (name) VALUES 
('Federal'), ('Provincial'), ('Company'), ('City');

-- Link Grant 1 to tags
INSERT INTO grant_eligibility (grant_id, tag_id)
SELECT 1, id FROM eligibility_tags WHERE name = 'Corporation';

INSERT INTO grant_industries (grant_id, tag_id)
SELECT 1, id FROM industry_tags WHERE name = 'Art';

INSERT INTO grant_types (grant_id, tag_id)
SELECT 1, id FROM type_tags WHERE name = 'Federal';

-- Repeat for other grants...
```

---

## ✅ Final Recommendation

**Use Supabase for everything!**

1. **Immediate:** Keep grants.json for now (safety)
2. **This Week:** Set up Supabase grants table
3. **Next Week:** Update app to load from Supabase (with JSON fallback)
4. **Later:** Build admin panel or use Supabase Studio

**Cost:** $0 for first 50k users, then $25/month

**You will NOT go broke!** Even with 1M users and heavy usage, you're looking at ~$100-200/month, which is incredibly cheap for a successful app.

---

Would you like me to:
1. **Create the full Supabase migration SQL script?**
2. **Update your app code to load from Supabase?**
3. **Build a simple admin panel for managing grants?**

Let me know and I'll implement it! 🚀
