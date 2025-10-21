# ⚡ SUPABASE QUICK START

## 🎯 What to Do Right Now

### **Step 1: Copy SQL (1 min)**
1. Open: `supabase_complete.sql`
2. Press: **Ctrl+A** then **Ctrl+C**

### **Step 2: Run in Supabase (2 min)**
1. Go to: https://supabase.com → Your Project → SQL Editor
2. Click: **New Query**
3. Press: **Ctrl+V** (paste)
4. Click: **Run** button
5. Wait for "Success" message ✅

### **Step 3: Make Yourself Admin (2 min)**
1. Sign up in your app first (use real email!)
2. In Supabase SQL Editor, run this:

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'YOUR-EMAIL@example.com';
```

Replace `YOUR-EMAIL@example.com` with your actual email!

### **Step 4: Test (2 min)**
```powershell
flutter run
```

Should see 4 grants! ✅

---

## 📁 Which Files to Use

### **For Quick Setup:**
- **`SIMPLE_SUPABASE_STEPS.md`** ← START HERE! Full walkthrough
- **`supabase_complete.sql`** ← The SQL to copy-paste

### **For Reference:**
- `SUPABASE_COMPLETE_SETUP.md` - All other Supabase config
- `SUPABASE_ERROR_FIX.md` - If you hit errors
- `SUPABASE_AI_PROMPTS.md` - Alternative AI approach

---

## ✅ Success Checklist

After running SQL:

- [ ] 8 tables created in Supabase
- [ ] 4 grants visible in Table Editor
- [ ] You are admin (check profiles table)
- [ ] App shows 4 grants when you run it

---

## 🚨 If Something Goes Wrong

**"relation already exists"** → This is fine! Already ran it before.

**"permission denied"** → Check you're signed in to right project.

**"foreign key violation"** → Tell me the exact error, I'll fix it!

**App shows no grants** → Check Table Editor, grants should be there.

---

## 💡 Pro Tip

**Just follow `SIMPLE_SUPABASE_STEPS.md`** - It has everything with screenshots descriptions and troubleshooting!

Total time: ~10 minutes 🚀
