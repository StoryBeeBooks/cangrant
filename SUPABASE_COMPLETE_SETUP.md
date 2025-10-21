# Complete Supabase Setup Guide (Beyond SQL)

## ✅ What You Need to Do in Supabase

After running the SQL code, here are ALL the other things you need to configure in Supabase:

---

## 1️⃣ CRITICAL: Make Yourself Admin (REQUIRED!)

**Why:** So you can add/edit grants later from an admin panel.

**How:**

1. First, create an account in your app (sign up with email)
2. In Supabase, go to: **SQL Editor** → **New Query**
3. Run this (replace with YOUR email):

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'your-actual-email@example.com';
```

4. Verify it worked:

```sql
SELECT user_id, email, role FROM profiles WHERE email = 'your-actual-email@example.com';
```

Should show `role = 'admin'`.

---

## 2️⃣ CRITICAL: Check RLS Policies (REQUIRED!)

**Why:** Row Level Security protects your data but needs correct policies.

**How:**

### Check Grants Table Policies:

1. Go to: **Table Editor** → Select **grants** table
2. Click the **RLS** tab (or **Policies** button)
3. You should see these policies:
   - ✅ "Anyone can view active grants" (SELECT, using: `is_active = true`)
   - ✅ "Only admins can modify grants" (ALL, using: checks admin role)

### Check Tag Tables:

Each of these 6 tables needs policies:
- eligibility_tags
- industry_tags
- type_tags
- grant_eligibility
- grant_industries
- grant_types

**Each should have:**
- ✅ "Anyone can view" (SELECT, no conditions)
- ✅ "Only admins can modify" (INSERT/UPDATE/DELETE, checks admin role)

### If Policies Are Missing:

The SQL should have created them. If not, tell me and I'll provide the exact policy SQL.

---

## 3️⃣ IMPORTANT: Configure Authentication Settings

**Why:** Control how users sign up and authenticate.

**How:**

1. Go to: **Authentication** → **Providers**

### Email Auth Settings:

2. Click **Email** provider
3. Configure:
   - ✅ **Enable Email provider** (turn ON)
   - ✅ **Confirm email** (RECOMMENDED: turn ON for production)
   - ✅ **Secure email change** (turn ON)
   - ✅ **Secure password change** (turn ON)

4. Email Templates (optional for now):
   - You can customize the confirmation email later
   - Default templates work fine for testing

### Disable Unused Providers:

5. Turn OFF providers you don't use:
   - ❌ Phone (unless you want SMS auth)
   - ❌ Google, GitHub, etc. (unless you want social login)

This reduces attack surface.

---

## 4️⃣ IMPORTANT: Set Up Email Templates (For Production)

**Why:** Professional welcome emails for users.

**How:**

1. Go to: **Authentication** → **Email Templates**

### Customize These Templates:

#### Confirm Signup:
```
Subject: Welcome to My-Grants!

Hi {{ .Email }},

Thanks for signing up for My-Grants!

Click here to confirm your email: {{ .ConfirmationURL }}

Find your perfect grant at my-grants.com

Best regards,
The My-Grants Team
```

#### Magic Link:
```
Subject: Sign in to My-Grants

Hi {{ .Email }},

Click here to sign in: {{ .MagicLinkURL }}

Best regards,
The My-Grants Team
```

#### Reset Password:
```
Subject: Reset your My-Grants password

Hi {{ .Email }},

Click here to reset your password: {{ .ConfirmationURL }}

If you didn't request this, ignore this email.

Best regards,
The My-Grants Team
```

You can customize these more later!

---

## 5️⃣ RECOMMENDED: Configure API Settings

**Why:** Control rate limiting and security.

**How:**

1. Go to: **Settings** → **API**

### Check These Settings:

- **API URL**: Copy this - you need it in your Flutter app
- **Anon Key**: Copy this - you need it in your Flutter app
- **Service Role Key**: KEEP SECRET! Don't put in app code!

### Rate Limiting (Free Tier):

Default settings are fine:
- 60 requests per minute per IP
- Good enough for development

You can increase this on Pro plan if needed later.

---

## 6️⃣ RECOMMENDED: Set Up Storage Buckets (For Future)

**Why:** If you want to store grant PDFs or images later.

**How (Future - Skip for Now):**

1. Go to: **Storage**
2. Click **New Bucket**
3. Name it: "grant-documents"
4. Public: No (keep private)
5. Set up policies later when you need it

**You don't need this yet!** Just for future reference.

---

## 7️⃣ CRITICAL: Test Your Connection

**Why:** Make sure your Flutter app can connect.

**How:**

### Check Your App Has Correct Credentials:

1. In VS Code, open: `lib/services/supabase_service.dart`
2. Look for `Supabase.initialize()`
3. Verify it has:
   - ✅ Correct **url** (from Supabase Settings → API)
   - ✅ Correct **anonKey** (from Supabase Settings → API)

### Test in Your App:

```powershell
flutter run
```

Try these:
- ✅ Sign up with new email
- ✅ Sign in
- ✅ View grants (should see your 4 sample grants)

If any fail, check:
1. API credentials are correct
2. RLS policies are set up
3. Internet connection works

---

## 8️⃣ OPTIONAL: Set Up Realtime (For Future)

**Why:** If you want grants to update live in the app without refresh.

**How (Future - Skip for Now):**

1. Go to: **Database** → **Replication**
2. Click **Enable Replication** for grants table
3. Configure your Flutter app to listen to changes

**You don't need this yet!** Just for future when you have many users.

---

## 9️⃣ OPTIONAL: Configure Webhooks (For Advanced Users)

**Why:** Get notified when events happen (new user, new grant, etc.)

**Skip this for now!** You can set this up later if needed.

---

## 🔟 IMPORTANT: Backup Configuration

**Why:** Don't lose your data!

**How:**

### Automatic Backups (Pro Plan Only):

Free tier doesn't have automatic backups, but you can manually backup:

1. Go to: **SQL Editor**
2. Run: 

```sql
-- Export all grants
SELECT * FROM grants;
```

3. Copy the data to a spreadsheet occasionally

### Or Use Supabase CLI:

```powershell
npm install -g supabase
supabase login
supabase db dump -f backup.sql
```

**Do this once a week** once you have real data!

---

## ✅ Complete Supabase Checklist

After setup, verify:

### Database:
- [ ] Grants table created with 4 sample grants
- [ ] Tag tables created (eligibility, industry, type)
- [ ] Junction tables created (grant_eligibility, etc.)
- [ ] RLS policies set up on all tables
- [ ] Your profile has role = 'admin'

### Authentication:
- [ ] Email auth enabled
- [ ] Email confirmation enabled
- [ ] Test signup works
- [ ] Test signin works

### API:
- [ ] Copied API URL to your Flutter app
- [ ] Copied Anon Key to your Flutter app
- [ ] Service Role Key kept secret

### Testing:
- [ ] Can sign up in app
- [ ] Can view grants in app
- [ ] Grants show correct data

---

## 🚨 Common Issues & Fixes

### Issue 1: "Row Level Security policy violation"

**Cause:** RLS is enabled but no policies exist.

**Fix:** Run the policy creation SQL from `SUPABASE_AI_PROMPTS.md` Requirement 3.

---

### Issue 2: "Cannot read grants"

**Cause:** Either no data or RLS blocking access.

**Fix:** 
1. Check grants exist: `SELECT * FROM grants;`
2. Check RLS policies are set up
3. Make sure `is_active = true` on grants

---

### Issue 3: "Cannot create profile"

**Cause:** Profiles table missing or RLS blocking.

**Fix:**
1. Make sure profiles table exists
2. Check RLS policy allows users to insert their own profile
3. Verify trigger creates profile on signup

---

### Issue 4: "Connection refused"

**Cause:** Wrong API URL or network issue.

**Fix:**
1. Double-check API URL in your app matches Supabase
2. Check internet connection
3. Verify Supabase project is not paused

---

## 📋 Quick Reference: Where to Find Things

| What You Need | Where to Find It |
|---------------|------------------|
| **API URL** | Settings → API → Project URL |
| **Anon Key** | Settings → API → Project API keys |
| **Service Role Key** | Settings → API → Project API keys (keep secret!) |
| **Database Tables** | Table Editor |
| **Run SQL** | SQL Editor |
| **Auth Settings** | Authentication → Providers |
| **User List** | Authentication → Users |
| **RLS Policies** | Table Editor → Select table → Policies tab |
| **Email Templates** | Authentication → Email Templates |

---

## 🎯 What to Do RIGHT NOW

1. **Run SQL Requirements** (use `SUPABASE_AI_PROMPTS.md`)
2. **Make yourself admin** (update profiles table)
3. **Verify RLS policies** exist on all tables
4. **Copy API credentials** to your Flutter app
5. **Test in your app** (sign up, view grants)

That's it! Everything else can wait.

---

## 💡 What to Do LATER (Before Production)

1. Enable email confirmation (Auth settings)
2. Customize email templates
3. Set up regular backups
4. Test with real users
5. Monitor usage (Dashboard → Reports)
6. Consider upgrading to Pro if you hit limits

---

## 📞 Need Help?

If you get stuck on any step:

1. Check the error message
2. Look at the Common Issues section above
3. Share the error with me and I'll help!

Most issues are:
- Missing RLS policies (run requirement 3 again)
- Wrong API credentials (double-check Settings → API)
- No test data (run requirement 5 again)

---

## 🎉 Summary

### MUST DO (Now):
✅ Run SQL code (6 requirements)  
✅ Make yourself admin  
✅ Test connection in app

### SHOULD DO (This Week):
⚠️ Configure auth settings  
⚠️ Set up email templates  
⚠️ Verify RLS policies

### CAN DO LATER:
💡 Storage buckets  
💡 Webhooks  
💡 Realtime subscriptions

You've got this! 🚀
