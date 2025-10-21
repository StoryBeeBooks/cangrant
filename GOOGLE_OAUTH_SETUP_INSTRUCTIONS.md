# 🔐 Google OAuth Setup - EXACT Steps You Need to Do

**⏱️ Time Required: 20 minutes**

I've already done everything possible in VS Code. Now you just need to configure Google Cloud Console and Supabase.

---

## ✅ STEP 1: Your SHA-1 Fingerprint (DONE ✓)

**Your SHA-1 Certificate Fingerprint:**
```
C1:F9:7A:0F:63:F2:9A:6D:38:83:FD:70:5B:C3:78:A5:CE:DA:8B:83
```

**📋 Copy this exactly** - you'll paste it into Google Cloud Console in Step 4.

---

## 🌐 STEP 2: Create Google Cloud Project (5 minutes)

### Go to Google Cloud Console:
👉 **Open this link:** https://console.cloud.google.com/

### Create New Project:
1. **Click the project dropdown** at the top (says "Select a project")
2. **Click "NEW PROJECT"** button (top right of the dialog)
3. **Fill in:**
   - **Project name:** `My-Grants App`
   - **Organization:** Select `nridl.org` from dropdown
4. **Click "CREATE"**
5. **Wait ~30 seconds** for project to be created
6. **Click "SELECT PROJECT"** when it appears

✅ **Checkpoint:** You should see "My-Grants App" in the project dropdown at the top

---

## 🔌 STEP 3: Enable Google Sign-In API (2 minutes)

### Go to APIs Library:
👉 **Open this link:** https://console.cloud.google.com/apis/library

### Enable the API:
1. **Make sure "My-Grants App" is selected** in the project dropdown
2. **Search for:** `Google+ API`
3. **Click on "Google+ API"** in the results
4. **Click "ENABLE"** button
5. **Wait ~10 seconds** for it to enable

✅ **Checkpoint:** You should see "API enabled" and a dashboard

---

## 👥 STEP 4: Configure OAuth Consent Screen (5 minutes)

### Go to OAuth Consent Screen:
👉 **Open this link:** https://console.cloud.google.com/apis/credentials/consent

### Choose User Type:
1. **Select "External"** (the only option available)
2. **Click "CREATE"**

### Fill in App Information (Page 1 of 4):

**App information:**
- **App name:** `My-Grants`
- **User support email:** `support@nridl.org` (select from dropdown)
- **App logo:** SKIP (leave empty)

**App domain:**
- **Application home page:** `https://my-grants.com`
- **Application privacy policy link:** `https://my-grants.com/privacy`
- **Application terms of service:** `https://my-grants.com/terms`

*Note: These pages don't exist yet - that's okay for testing mode*

**Developer contact information:**
- **Email addresses:** `support@nridl.org`

**Click "SAVE AND CONTINUE"**

### Scopes Page (Page 2 of 4):
- **Click "SAVE AND CONTINUE"** (no changes needed)

### Test Users Page (Page 3 of 4):
1. **Click "+ ADD USERS"**
2. **Enter:** `marioxu@yahoo.ca`
3. **Click "ADD"**
4. **Click "SAVE AND CONTINUE"**

### Summary Page (Page 4 of 4):
- **Click "BACK TO DASHBOARD"**

✅ **Checkpoint:** You should see "Publishing status: Testing" with your app info

---

## 🔑 STEP 5: Create OAuth Client IDs (5 minutes)

You need to create **TWO** OAuth Client IDs: one for Android, one for Web.

### Go to Credentials:
👉 **Open this link:** https://console.cloud.google.com/apis/credentials

---

### 5A: Create Android OAuth Client ID

1. **Click "+ CREATE CREDENTIALS"** (top left)
2. **Select "OAuth client ID"**
3. **Application type:** Select **"Android"**
4. **Fill in:**
   - **Name:** `My-Grants Android App`
   - **Package name:** `com.mygrants.app`
   - **SHA-1 certificate fingerprint:** `C1:F9:7A:0F:63:F2:9A:6D:38:83:FD:70:5B:C3:78:A5:CE:DA:8B:83`
     *(Copy-paste the SHA-1 I gave you above)*
5. **Click "CREATE"**
6. **A dialog will appear** - Just click **"OK"** (you don't need to save anything)

✅ **Checkpoint:** You should see "My-Grants Android App" in your credentials list

---

### 5B: Create Web OAuth Client ID (for Supabase)

1. **Click "+ CREATE CREDENTIALS"** again
2. **Select "OAuth client ID"**
3. **Application type:** Select **"Web application"**
4. **Fill in:**
   - **Name:** `My-Grants Web (Supabase)`
   - **Authorized JavaScript origins:** LEAVE EMPTY
   - **Authorized redirect URIs:** Click **"+ ADD URI"** and paste:
     ```
     https://tvhcnjimfdfsentmngjj.supabase.co/auth/v1/callback
     ```
5. **Click "CREATE"**

### 🚨 IMPORTANT: Save These Credentials!

**A dialog will appear with:**
- **Your Client ID** (looks like: `123456789-abc123def456.apps.googleusercontent.com`)
- **Your Client secret** (looks like: `GOCSPX-abc123_def456xyz`)

**📋 COPY BOTH OF THESE** - You need them for Step 6!

---

## 🗄️ STEP 6: Update Supabase (3 minutes)

### Go to Supabase Auth Providers:
👉 **Open this link:** https://supabase.com/dashboard/project/tvhcnjimfdfsentmngjj/auth/providers

### Configure Google Provider:
1. **Find "Google" in the list** (you should see it's already enabled)
2. **Click on "Google"** to expand it
3. **Fill in:**
   - **Authorized Client IDs:** Paste your **Web Client ID** from Step 5B
     *(The long string ending in `.apps.googleusercontent.com`)*
   - **Client ID (for OAuth):** Paste the same **Web Client ID** again
   - **Client Secret (for OAuth):** Paste your **Web Client secret** from Step 5B
     *(The string starting with `GOCSPX-`)*
4. **Click "Save"** at the bottom

✅ **Checkpoint:** Google provider should show "Enabled" with a green checkmark

---

## 🎉 THAT'S IT! Now Test It!

### Test Google Sign-In:
1. **Open your app** on the Android emulator (should already be running)
2. **Click "Continue with Google"**
3. **Select your Google account** (marioxu@yahoo.ca)
4. **You should be signed in!** 🎉

### If It Doesn't Work:
- Wait 5-10 minutes (Google needs time to propagate changes)
- Try again
- If still failing, tell me the error message you see

---

## 📝 What I Already Did for You in VS Code:

✅ Got your SHA-1 fingerprint
✅ Fixed all compile errors
✅ Implemented Google Sign-In code
✅ Implemented Apple Sign-In code (for when you're ready)
✅ Beautiful UI with gradient background
✅ Error handling with user-friendly messages
✅ Navigation flow (new users → onboarding, returning → main screen)

---

## 🍎 Apple Sign-In Status:

**Currently:** Hidden (automatically - won't show on Android)
**When visible:** Only on iOS/macOS devices
**Required for:** App Store approval (if you offer any other social login)
**Setup time:** ~20 minutes (but you need Apple Developer account first - $99/year)

---

## 🆘 Common Issues:

### "Sign-in attempt failed"
- Wait 5-10 minutes after completing setup
- Make sure you're using the test account (marioxu@yahoo.ca)
- Check that app is in "Testing" mode in Google Cloud Console

### "Access blocked: This app's request is invalid"
- Make sure you added yourself as a test user in Step 4
- Verify OAuth consent screen is complete

### "API has not been used in project"
- Double-check you enabled Google+ API in Step 3
- Wait 5 minutes for it to propagate

---

## 🎯 After Google Sign-In Works:

1. ✅ Test signing in with your account
2. ✅ Test business profile saves correctly
3. ✅ Test grant matching works
4. 📱 Add more Canadian grants to database
5. 🎨 Create app icon (1024x1024)
6. 📸 Take screenshots for Google Play Store
7. 📄 Create privacy policy page on my-grants.com
8. 🚀 Publish to Google Play Store!

---

**Questions?** Just tell me:
- Which step you're on
- Any error messages you see
- I'll help you through it! 💪
