# 🎯 Quick Action Checklist

Copy this checklist and check off items as you complete them!

---

## ✅ Code Changes (DONE!)

- [x] Changed Android package to `com.mygrants.app`
- [x] Changed iOS bundle ID to `com.mygrants.app`
- [x] Updated app display name to "My-Grants"
- [x] Updated all imports and code references
- [x] Updated documentation
- [x] Committed and pushed to GitHub

---

## 🔄 Repository Changes (YOUR TURN - 5 minutes)

### Rename GitHub Repository

1. [ ] Go to https://github.com/StoryBeeBooks/mygrantsapp/settings
2. [ ] Scroll to "Repository name" section
3. [ ] Type: **mygrants**
4. [ ] Click "Rename" button
5. [ ] Update local git remote:

```powershell
cd C:\src\cangrant
git remote set-url origin https://github.com/StoryBeeBooks/mygrantsapp.git
git pull
```

6. [ ] (Optional) Rename local folder:

```powershell
cd C:\src
Move-Item -Path cangrant -Destination mygrants
cd mygrants
code .
```

**Full guide:** Open `GITHUB_RENAME_GUIDE.md`

---

## 🗄️ Database Setup (YOUR TURN - 15 minutes)

### Run Supabase Migration

1. [ ] Go to https://supabase.com and sign in
2. [ ] Open your project
3. [ ] Click "SQL Editor" in left sidebar
4. [ ] Click "New Query"
5. [ ] Open file: `supabase_migration.sql`
6. [ ] Copy ALL the SQL (Ctrl+A, Ctrl+C)
7. [ ] Paste into Supabase SQL Editor (Ctrl+V)
8. [ ] Click "Run" (or Ctrl+Enter)
9. [ ] Check "Table Editor" - you should see 7 new tables
10. [ ] Make yourself admin (replace YOUR-EMAIL):

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'YOUR-EMAIL@example.com';
```

11. [ ] Run this to verify grants loaded:

```sql
SELECT id, title, status FROM grants;
```

**Full guide:** Open `SUPABASE_MIGRATION_GUIDE.md`

---

## 🧪 Testing (YOUR TURN - 10 minutes)

1. [ ] Run the app:

```powershell
flutter clean
flutter pub get
flutter run
```

2. [ ] Test these features:
   - [ ] App shows "My-Grants" title
   - [ ] Sign up with new account
   - [ ] Browse grants (should show 4 grants)
   - [ ] Save a grant
   - [ ] View saved grants
   - [ ] Switch language
   - [ ] Update business profile

---

## 📝 Supabase Project Name (OPTIONAL - Skip This!)

**Recommendation:** DON'T rename your Supabase project!

- [ ] Keep Supabase project as "cangrant" (internal only)
- [ ] Users never see this name
- [ ] Not worth the hassle

**If you insist on renaming:** Open `SUPABASE_RENAME_GUIDE.md`

---

## 🚀 Next Steps After Testing

### This Week:

- [ ] Wait for Apple Developer account approval
- [ ] Design app icon (1024x1024 PNG)
- [ ] Take app screenshots (6-10 per platform)
- [ ] Write App Store description (max 4000 chars)
- [ ] Write Google Play description (max 4000 chars)
- [ ] Create privacy policy page
- [ ] Set up basic website at my-grants.com

### Before App Store Submission:

- [ ] Change signing config (Android release build)
- [ ] Set up App Store Connect listing
- [ ] Set up Google Play Console listing
- [ ] Configure RevenueCat (after stores approved)
- [ ] Test subscription flow
- [ ] Beta test with 3-5 users

---

## 📊 Current Status Overview

| Item | Status | Notes |
|------|--------|-------|
| **App Name** | ✅ Done | "My-Grants" |
| **Package Name** | ✅ Done | com.mygrants.app |
| **Domains** | ✅ Secured | my-grants.com, my-grants.ca |
| **GitHub Repo** | ⏳ Your Turn | Rename to "mygrants" |
| **Supabase DB** | ⏳ Your Turn | Run migration SQL |
| **Testing** | ⏳ Your Turn | Test rebrand works |
| **App Store** | ⏳ Waiting | Apple Developer approval |
| **Google Play** | ⏳ Not Started | Create account |

---

## 🎯 Priority Actions (Do These TODAY!)

1. **Rename GitHub repo** (5 min) → `GITHUB_RENAME_GUIDE.md`
2. **Run database SQL** (15 min) → `SUPABASE_MIGRATION_GUIDE.md`
3. **Test the app** (10 min) → Follow testing checklist above

**Total time:** ~30 minutes

---

## 📚 Reference Documents

All in this folder:

- **REBRAND_SUMMARY.md** ← You are here!
- **GITHUB_RENAME_GUIDE.md** - Rename repository
- **SUPABASE_MIGRATION_GUIDE.md** - Database setup
- **SUPABASE_RENAME_GUIDE.md** - Supabase project naming
- **BACKEND_ARCHITECTURE_GUIDE.md** - Database architecture
- **supabase_migration.sql** - SQL to copy-paste

---

## ✅ Success Criteria

You're done when:

- ✅ GitHub repo is named "mygrants"
- ✅ Local git remote points to new repo
- ✅ Supabase has 7 new tables
- ✅ App runs and shows 4 grants
- ✅ All features work

---

## 🎉 You've Got This!

The rebrand is 90% complete - I did the hard part!

Just follow the 3 priority actions above and you're done! 🚀

Questions? Check the reference documents! 📚
