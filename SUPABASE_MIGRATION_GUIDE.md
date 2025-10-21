# How to Run the Supabase Migration (Step-by-Step)

## 📋 What You'll Do
You'll copy-paste SQL into Supabase's SQL Editor. Takes about 5 minutes!

---

## 🚀 Step-by-Step Instructions

### **Step 1: Open Supabase Dashboard**

1. Go to [https://supabase.com](https://supabase.com)
2. Sign in to your account
3. Click on your **My-Grants** project (or whatever you named it)

---

### **Step 2: Open SQL Editor**

1. In the left sidebar, click the **"SQL Editor"** icon (looks like `</>`)
2. Click **"New Query"** button (top right)

---

### **Step 3: Copy the Migration Script**

1. Open the file: **`supabase_migration.sql`** (in this folder)
2. Select ALL the text (Ctrl+A)
3. Copy it (Ctrl+C)

---

### **Step 4: Paste and Run**

1. Go back to Supabase SQL Editor
2. Paste the entire script (Ctrl+V)
3. Click the **"Run"** button (or press Ctrl+Enter)
4. Wait 5-10 seconds...

---

### **Step 5: Verify It Worked**

You should see a success message at the bottom!

**Check your tables were created:**

1. In the left sidebar, click **"Table Editor"**
2. You should now see these new tables:
   - ✅ `grants`
   - ✅ `eligibility_tags`
   - ✅ `grant_eligibility`
   - ✅ `industry_tags`
   - ✅ `grant_industries`
   - ✅ `type_tags`
   - ✅ `grant_types`

3. Click on the **`grants`** table
4. You should see your 4 grants listed!

---

### **Step 6: Make Yourself Admin (IMPORTANT!)**

This gives you permission to edit grants later.

1. Go back to **SQL Editor**
2. Click **"New Query"**
3. Paste this (replace with YOUR email):

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'your@email.com';
```

4. Click **"Run"**
5. Should say: **"Success. 1 row affected"**

---

### **Step 7: Test the Database**

Let's verify everything works by querying your grants:

1. Go back to **SQL Editor**
2. Click **"New Query"**
3. Paste this:

```sql
-- Get all grants with their tags
SELECT 
  g.id,
  g.title,
  g.status,
  g.deadline,
  g.amount_max,
  array_agg(DISTINCT et.name) as eligibility,
  array_agg(DISTINCT it.name) as industries,
  array_agg(DISTINCT tt.name) as types
FROM grants g
LEFT JOIN grant_eligibility ge ON g.id = ge.grant_id
LEFT JOIN eligibility_tags et ON ge.tag_id = et.id
LEFT JOIN grant_industries gi ON g.id = gi.grant_id
LEFT JOIN industry_tags it ON gi.tag_id = it.id
LEFT JOIN grant_types gt ON g.id = gt.grant_id
LEFT JOIN type_tags tt ON gt.tag_id = tt.id
GROUP BY g.id, g.title, g.status, g.deadline, g.amount_max
ORDER BY g.id;
```

4. Click **"Run"**
5. You should see a nice table with all 4 grants and their tags! 🎉

---

## ✅ Success Checklist

After completing the steps above, verify:

- [ ] 7 new tables created
- [ ] 4 grants inserted
- [ ] Tags created and linked
- [ ] Your profile has `role = 'admin'`
- [ ] Test query returns all grants with tags

---

## 🚨 Common Issues & Fixes

### **Error: "relation 'profiles' does not exist"**

**Cause:** You haven't set up user profiles yet.

**Fix:** First run this to create the profiles table:

```sql
CREATE TABLE IF NOT EXISTS profiles (
  user_id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email TEXT,
  business_profile JSONB,
  free_views_remaining INTEGER DEFAULT 3,
  subscription_tier TEXT CHECK (subscription_tier IN ('free', 'premium', 'pro')),
  subscription_expires_at TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
ON profiles FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can update own profile"
ON profiles FOR UPDATE
USING (auth.uid() = user_id);
```

Then re-run the main migration script.

---

### **Error: "duplicate key value violates unique constraint"**

**Cause:** You already ran the script before.

**Fix:** This is actually fine! The script uses `ON CONFLICT DO NOTHING` so it won't duplicate data. Your grants are already inserted.

---

### **Error: "permission denied for table grants"**

**Cause:** RLS policies are blocking you.

**Fix:** Run this:

```sql
-- Temporarily disable RLS for setup
ALTER TABLE grants DISABLE ROW LEVEL SECURITY;

-- Re-enable after you're done
ALTER TABLE grants ENABLE ROW LEVEL SECURITY;
```

---

## 🎉 What's Next?

Once the migration is complete, you need to:

1. **Update your Flutter app** to load grants from Supabase
2. **Keep grants.json as fallback** (for offline mode)
3. **Test the app** to ensure it loads from database

I can help you with the Flutter code updates! Just let me know when you're ready. 🚀

---

## 📧 Need Help?

If you get stuck:

1. Take a screenshot of the error
2. Share it with me
3. I'll help you fix it!

The migration is very safe - it won't break anything existing. You can run it multiple times without issues.
