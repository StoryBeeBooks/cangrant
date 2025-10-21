# 🚨 Supabase Error Fix: Profiles Table Missing

## What Happened?

You got this error:
```
ERROR: 42P01: relation "public.profiles" does not exist
```

**Why:** You need to create the `profiles` table BEFORE creating the admin policies!

---

## ✅ Solution: Updated Requirements Order

I've updated `SUPABASE_AI_PROMPTS.md` with the correct order:

### **New Correct Order:**

1. ✅ Create Grants Table
2. ✅ Create Tag Tables (you've done these already!)
3. **🆕 Create Profiles Table** ← NEW! Do this now
4. Create Admin System (needs profiles table)
5. Insert Initial Tag Data
6. Insert Sample Grant Data
7. Create Query Helper Function (optional)

---

## 🔧 What To Do Now

### **Option 1: Use AI Copilot with New Requirement 3**

Go to Supabase SQL Editor and paste this into AI Copilot:

```
Create a PostgreSQL table called "profiles" with the following structure:

- user_id: UUID primary key, references auth.users(id) with cascade delete
- email: text (user's email address)
- business_profile: jsonb (stores business questionnaire data)
- free_views_remaining: integer, default 3 (for metered paywall)
- subscription_tier: text, optional, must be one of: 'free', 'premium', 'pro'
- subscription_expires_at: timestamp with timezone, optional
- role: text, default 'user', must be one of: 'user' or 'admin'
- created_at: timestamp with timezone, default now()
- updated_at: timestamp with timezone, default now()

Add check constraints:
- subscription_tier must be 'free', 'premium', or 'pro' if not null
- role must be 'user' or 'admin'

Enable Row Level Security (RLS) on this table.

Create these policies:
1. Users can view their own profile (SELECT where auth.uid() = user_id)
2. Users can update their own profile (UPDATE where auth.uid() = user_id)
3. Users can insert their own profile (INSERT where auth.uid() = user_id)

Create a trigger function that automatically creates a profile record when a new user signs up in auth.users.
The trigger should:
- Insert a new row in profiles with user_id = NEW.id and email = NEW.email
- Set default values for free_views_remaining (3) and role ('user')
- Run AFTER INSERT on auth.users
```

Let AI generate the SQL, then click **Run**.

---

### **Option 2: Use This Exact SQL**

If AI doesn't work, copy-paste this exact SQL:

```sql
-- Create profiles table
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

-- Enable RLS
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Policy: Users can view their own profile
CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (auth.uid() = user_id);

-- Policy: Users can update their own profile
CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = user_id);

-- Policy: Users can insert their own profile
CREATE POLICY "Users can insert own profile"
ON profiles FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- Trigger function to auto-create profile on signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (user_id, email, free_views_remaining, role)
  VALUES (NEW.id, NEW.email, 3, 'user');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to call function when new user signs up
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

---

## ✅ After Running Profiles Table SQL

### Verify It Worked:

```sql
-- Check table exists
SELECT table_name 
FROM information_schema.tables 
WHERE table_name = 'profiles';

-- Check trigger exists
SELECT trigger_name 
FROM information_schema.triggers 
WHERE trigger_name = 'on_auth_user_created';
```

Should show the profiles table and trigger!

---

## 🔄 Then Continue With Remaining Requirements

After creating profiles table, go back to `SUPABASE_AI_PROMPTS.md` and continue:

- ✅ Requirement 1: Grants Table (done)
- ✅ Requirement 2: Tag Tables (done)
- ✅ **Requirement 3: Profiles Table** ← Just did this!
- ⏳ **Requirement 4: Admin System** ← Do this now (should work!)
- ⏳ Requirement 5: Insert Tag Data
- ⏳ Requirement 6: Insert Grant Data
- ⏳ Requirement 7: Helper Function (optional)

---

## 🎯 Quick Summary

**The Problem:** Requirements were in wrong order - admin policies need profiles table to exist first.

**The Fix:** Create profiles table (new Requirement 3) before admin system.

**What To Do:** 
1. Run the SQL above (Option 1 or 2)
2. Verify it worked
3. Continue with Requirements 4-7

You're almost there! 🚀
