# How to Rename Supabase Project from "cangrant" to "mygrants"

## 🤔 Important: Do You Actually Need to Rename?

**Short Answer:** Not really! The Supabase project name is mostly cosmetic.

### **What the Project Name Affects:**
- ✅ How it appears in your Supabase dashboard
- ✅ Your project URL (e.g., `abc123.supabase.co`)
- ❌ **Does NOT affect** your app code
- ❌ **Does NOT affect** your database
- ❌ **Does NOT affect** authentication

### **My Recommendation:**

**Option A: Don't Rename (Easiest)** ✅
- Keep the Supabase project as "cangrant"
- It's just an internal label
- Your app already says "My-Grants"
- Saves you time and avoids risk

**Option B: Create New Project**
- More work but cleanest approach
- Good if you want fresh start
- Need to migrate database

**Option C: Contact Supabase Support**
- They can rename for you
- Takes 1-2 days
- Not worth the hassle for just a name

---

## 🎯 Recommended Approach: Keep It As-Is

Here's why keeping "cangrant" project name is FINE:

```
Supabase Dashboard
├── Project Name: "cangrant" (internal only)
│   └── Nobody sees this except you!
│
Your App
├── Display Name: "My-Grants" ✅
├── Package: com.mygrants.app ✅
├── Domain: my-grants.com ✅
└── Users see: "My-Grants" everywhere ✅
```

**Users never see your Supabase project name!**

---

## 🔄 If You REALLY Want to Rename: Option B (Create New Project)

This is the cleanest way if you insist on renaming:

### **Step 1: Create New Supabase Project**

1. Go to [https://supabase.com/dashboard](https://supabase.com/dashboard)
2. Click **"New Project"**
3. Name it: **"mygrants"** or **"my-grants"**
4. Choose same region as old project
5. Set strong database password (SAVE IT!)
6. Click **"Create new project"**
7. Wait 2-3 minutes for provisioning

### **Step 2: Get New Project Credentials**

1. In new project, go to **Settings** → **API**
2. Copy these (you'll need them):
   - **Project URL**: `https://[your-new-id].supabase.co`
   - **Anon Key**: `eyJ...` (long string)
   - **Service Role Key**: `eyJ...` (even longer string)

### **Step 3: Update Your Flutter App**

You need to update your app to point to the NEW project:

#### **Find your Supabase initialization code:**

Check where you initialized Supabase. It's probably in one of these places:
- `lib/services/supabase_service.dart`
- `lib/main.dart`
- `.env` file (if you use environment variables)

#### **Update the credentials:**

```dart
// OLD (cangrant project)
await Supabase.initialize(
  url: 'https://old-id.supabase.co',
  anonKey: 'old-key-here',
);

// NEW (mygrants project)
await Supabase.initialize(
  url: 'https://new-id.supabase.co',
  anonKey: 'new-key-here',
);
```

### **Step 4: Migrate Your Database**

#### **Option 4A: Manual Migration (Recommended for small data)**

Run these SQL scripts in your NEW project:

1. **Create tables**: Run the SQL from `supabase_migration.sql`
2. **Add profiles columns**: Run the metered paywall SQL
3. **Recreate auth policies**: Copy from old project

#### **Option 4B: Use Supabase CLI (Advanced)**

```powershell
# Install Supabase CLI
npm install -g supabase

# Login
supabase login

# Link to OLD project
supabase link --project-ref old-project-id

# Dump database
supabase db dump -f old_database.sql

# Link to NEW project
supabase link --project-ref new-project-id

# Restore database
supabase db push
```

### **Step 5: Migrate Users (Auth)**

**Problem:** Users' accounts are in the old project!

**Solutions:**

#### **Option A: Users Re-Register (Easiest)**
- Keep old project running briefly
- Tell users to register again
- Good if you have few users

#### **Option B: Export/Import Users (Complex)**
1. In old project: Settings → Auth → Export users
2. Download CSV
3. In new project: Settings → Auth → Import users
4. Upload CSV

**Warning:** Passwords can't be migrated (users need to reset)

### **Step 6: Test Everything**

1. Run your app with new credentials
2. Test authentication
3. Test database queries
4. Test saving grants
5. Test paywall tracking

### **Step 7: Delete Old Project**

Once you're sure everything works:

1. Go to old "cangrant" project
2. Settings → General → Danger Zone
3. Click "Delete project"
4. Type project name to confirm

---

## 💰 Cost Implications

### **If You Keep Both Projects Temporarily:**
- Old project: Free tier (if not using)
- New project: Free tier
- **Total cost:** $0

### **After Deleting Old Project:**
- One project: Free tier
- **Total cost:** $0

No worries about double charges!

---

## ⚠️ **My Strong Recommendation: DON'T RENAME**

Here's why:

### **Pros of Renaming:**
- ✅ Consistent naming (minor benefit)
- ✅ Slightly cleaner dashboard

### **Cons of Renaming:**
- ❌ 2-4 hours of work
- ❌ Risk of breaking something
- ❌ Need to migrate users
- ❌ Downtime for your app
- ❌ Potential data loss risk
- ❌ Need to update app and redeploy

### **Verdict:**
**NOT WORTH IT!** The Supabase project name is purely internal. Focus on building features instead! 🚀

---

## 🎯 What You SHOULD Do Instead

Keep "cangrant" as the Supabase project name, but organize it well:

### **Step 1: Add a Good Description**

1. Go to your Supabase project
2. Settings → General
3. Find "Description" field
4. Add: **"My-Grants app backend - Production database for my-grants.com"**

### **Step 2: Use Organization/Tags** (if available)

Some Supabase plans let you organize projects. Use these:
- **Organization**: "NRIDL" or "My-Grants"
- **Tags**: "production", "mygrants", "mobile-app"

### **Step 3: Document It**

Create a note in your project docs:

```markdown
## Supabase Configuration

- **Project Internal Name**: cangrant (legacy, ignore this)
- **Actual App Name**: My-Grants
- **Project URL**: https://[your-id].supabase.co
- **Purpose**: Production backend for My-Grants mobile app
- **Domain**: my-grants.com
```

---

## ✅ Summary: What to Do

### **Recommended (90% of cases):**
**Keep the Supabase project named "cangrant"** - It doesn't matter! Users never see it.

### **If You Must Rename:**
**Create a new project** and migrate data (4 hours of work).

### **DON'T Do:**
- ❌ Try to rename existing project (not supported by Supabase)
- ❌ Contact support to rename (waste of their time and yours)

---

## 🚀 Next Steps

1. **Skip renaming Supabase** - focus on features!
2. **Run the database migration** (from `supabase_migration.sql`)
3. **Build your app** and submit to stores
4. **Add grant data** to your database

Your time is better spent on:
- ✅ Getting App Store approval
- ✅ Adding more grants to database
- ✅ Marketing your app
- ✅ Building admin panel

Don't waste time on cosmetic changes! 😊

---

## 📞 Still Want to Rename?

If you really, truly must rename:

1. Create new Supabase project called "mygrants"
2. Run `supabase_migration.sql` in new project
3. Update app credentials
4. Test thoroughly
5. Migrate users (if any exist)
6. Delete old project

**Estimated time:** 4 hours  
**Risk level:** Medium  
**Worth it:** NO 😅

---

**Bottom Line:** Keep your Supabase project as "cangrant". It's just an internal name that nobody except you will ever see. Focus on building a great app instead! 🎉
