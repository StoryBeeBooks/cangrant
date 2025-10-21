# 🚀 Simple Step-by-Step Supabase Setup

Follow these steps exactly. Takes about 10 minutes total!

---

## 📋 STEP 1: Open Supabase SQL Editor (1 minute)

1. Go to https://supabase.com
2. Sign in to your account
3. Click on your project
4. In the left sidebar, click **"SQL Editor"** (looks like `</>`)
5. Click **"New Query"** button (top right)

You should see a blank editor where you can paste SQL.

---

## 📋 STEP 2: Copy the Complete SQL (1 minute)

1. In VS Code, open the file: **`supabase_complete.sql`**
2. Press **Ctrl+A** (select all)
3. Press **Ctrl+C** (copy)

---

## 📋 STEP 3: Paste and Run (2 minutes)

1. Go back to Supabase SQL Editor
2. Click in the editor (big text box)
3. Press **Ctrl+V** (paste)
4. You should see all the SQL code (starts with "COMPLETE SUPABASE SETUP")
5. Click the **"Run"** button (or press **Ctrl+Enter**)
6. Wait 10-30 seconds...

### ✅ Success Looks Like:

You'll see at the bottom:
- "Success. No rows returned" OR
- Tables showing verification results

### ❌ If You Get Errors:

- Take a screenshot of the error
- Tell me the error message
- I'll help you fix it!

---

## 📋 STEP 4: Verify Tables Were Created (2 minutes)

After running the SQL, verify it worked:

### Check in Table Editor:

1. Click **"Table Editor"** in left sidebar
2. You should see these tables:
   - ✅ profiles
   - ✅ grants
   - ✅ eligibility_tags
   - ✅ industry_tags
   - ✅ type_tags
   - ✅ grant_eligibility
   - ✅ grant_industries
   - ✅ grant_types

3. Click on **grants** table
4. You should see **4 grants** listed!

### Or Check with SQL:

In SQL Editor, run this:

```sql
SELECT id, title, status FROM grants;
```

Should show 4 grants! 🎉

---

## 📋 STEP 5: Make Yourself Admin (2 minutes)

**IMPORTANT:** This gives you permission to edit grants later!

### First, Create a Test Account:

1. Run your Flutter app: `flutter run`
2. Click "Sign Up"
3. Use your real email (you'll need it!)
4. Create an account
5. Remember this email!

### Then Make It Admin:

1. Go back to Supabase SQL Editor
2. Click **"New Query"**
3. Paste this (replace YOUR-EMAIL):

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'YOUR-ACTUAL-EMAIL@example.com';
```

4. Change `YOUR-ACTUAL-EMAIL@example.com` to the email you just signed up with
5. Click **"Run"**

### Verify It Worked:

```sql
SELECT email, role FROM profiles WHERE role = 'admin';
```

Should show your email with role = 'admin'! ✅

---

## 📋 STEP 6: Test in Your App (3 minutes)

Now test that everything works!

```powershell
flutter clean
flutter pub get
flutter run
```

### Test These Features:

1. **Sign in** with the account you created
2. **Browse grants** - should see 4 grants:
   - Funding for Art (Closed)
   - Funding for Provincial Education (Open)
   - Funding for Women Entrepreneurs (Open)
   - Funding for Employment (Rolling Basis)
3. **Save a grant** - tap the bookmark icon
4. **View saved grants** - go to saved tab
5. **View grant details** - tap on a grant

### ✅ Success Criteria:

- ✅ Can sign in
- ✅ See 4 grants on home screen
- ✅ Can save grants
- ✅ Can view grant details
- ✅ No errors or crashes

---

## 🎯 Quick Checklist

- [ ] Opened Supabase SQL Editor
- [ ] Copied `supabase_complete.sql`
- [ ] Pasted and ran the SQL
- [ ] Verified 8 tables exist
- [ ] Verified 4 grants exist
- [ ] Created test account in app
- [ ] Made yourself admin
- [ ] Tested app features

---

## 🚨 Common Issues & Fixes

### Issue 1: "relation already exists"

**This is fine!** It means you ran the script before. The script uses `IF NOT EXISTS` so it won't break anything. Your data is safe.

---

### Issue 2: "permission denied"

**Fix:** Make sure you're signed in to Supabase and on the correct project.

---

### Issue 3: "foreign key violation"

**Fix:** This shouldn't happen with the complete script. If it does, tell me the exact error and I'll help.

---

### Issue 4: App shows "no grants"

**Checks:**

1. Go to Table Editor → grants table → should see 4 rows
2. Check `is_active` column = true
3. Run in SQL Editor:

```sql
SELECT * FROM grants WHERE is_active = true;
```

Should show 4 grants.

---

### Issue 5: Can't make yourself admin

**Checks:**

1. Did you sign up in the app first?
2. Check the email matches exactly:

```sql
SELECT * FROM profiles;
```

Should show your profile with the email.

3. Try the UPDATE command again with exact email

---

## 🎉 You're Done!

If all checks passed, your database is fully set up! 

### What's Next?

1. ✅ Database is ready
2. ✅ Sample grants loaded
3. ✅ You're an admin
4. ⏳ Design app icon
5. ⏳ Wait for Apple Developer approval
6. ⏳ Take screenshots for stores
7. ⏳ Set up my-grants.com website

---

## 📞 Need Help?

If something doesn't work:

1. Take a screenshot of the error
2. Tell me which step you're on
3. Copy the exact error message
4. I'll help you fix it immediately!

Most issues are quick fixes! Don't worry! 😊

---

## 📚 What the SQL Did

For your reference, the complete script:

1. ✅ Created `profiles` table (stores users)
2. ✅ Created `grants` table (stores grants)
3. ✅ Created 3 tag tables (eligibility, industry, type)
4. ✅ Created 3 junction tables (for many-to-many relationships)
5. ✅ Set up Row Level Security (RLS) policies
6. ✅ Created admin permissions system
7. ✅ Inserted 10 initial tags
8. ✅ Inserted 4 sample grants
9. ✅ Linked grants to their tags
10. ✅ Created triggers for auto-updates

**Total:** 8 tables, 20+ policies, 2 triggers, 4 sample grants!

All done in one click! 🚀
