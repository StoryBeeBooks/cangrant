# 🔧 TROUBLESHOOTING: OAuth Consent Screen Setup

## Your Current Situation:
You're at the **OAuth Overview** page and you didn't see all the screens mentioned in the guide.

---

## ✅ Good News!

**1. Google Cloud is FREE for OAuth:**
- ✅ **No fees for Google Sign-In** (unlimited users!)
- ✅ Google+ API is free
- ✅ OAuth is completely free
- 💰 You only pay if you use other Google Cloud services (compute, storage, etc.)

**2. The OAuth Consent Screen might have simplified:**
Google sometimes shows a simplified version of the OAuth setup form. That's okay!

---

## 🎯 What You Need to Do NOW:

Since you're at the **OAuth Overview** page, you need to configure the OAuth Consent Screen properly.

### **Go to OAuth Consent Screen Settings:**

**Option 1: Click on "Branding" in the left sidebar**
- You should see options to edit your app information

**Option 2: Go directly to this link:**
👉 https://console.cloud.google.com/apis/credentials/consent

---

## 📝 Complete the OAuth Consent Screen:

### You need to fill in:

1. **App information:**
   - ✅ App name: `My-Grants` (you already did this)
   - ✅ User support email: `support@nridl.org` (you already did this)

2. **App domain (REQUIRED for adding test users):**
   - Click "EDIT APP" or look for "App domain" section
   - Add these if you see the fields:
     - **Application home page:** `https://my-grants.com`
     - **Application privacy policy link:** `https://my-grants.com/privacy`
     - **Application terms of service:** `https://my-grants.com/terms`
   
   *Note: These pages don't exist yet - that's okay! Google just needs URLs for testing mode.*

3. **Test users (CRITICAL - You MUST add this!):**
   - Look for "Test users" section (might be in the "Audience" tab)
   - Click "+ ADD USERS"
   - Add your Google account email: `marioxu@yahoo.ca`
   - Click "SAVE"

---

## 🔍 How to Find Test Users Section:

### Look in the left sidebar for:
- **"Audience"** tab → Click it → Look for "Test users"
- OR
- **"Branding"** tab → Scroll down → Look for "Test users"

### If you can't find it:
1. Click on "OAuth consent screen" in the left sidebar
2. Look for a button that says "EDIT APP" or "CONFIGURE"
3. Click it and go through the wizard pages:
   - Page 1: App information
   - Page 2: Scopes (skip)
   - Page 3: **Test users** ← This is where you add yourself!
   - Page 4: Summary

---

## ⚠️ CRITICAL: You MUST Add Test Users!

**Without adding yourself as a test user, you'll get this error:**
```
Access blocked: This app's request is invalid
```

**To fix it:**
1. Find the Test Users section (see instructions above)
2. Click "+ ADD USERS"
3. Add: `marioxu@yahoo.ca`
4. Click "ADD" or "SAVE"

---

## 📸 What Your Screen Should Look Like:

### OAuth Overview Page Should Show:
- ✅ Publishing status: **Testing**
- ✅ App name: **My-Grants**
- ✅ User support email: **support@nridl.org**
- ✅ Test users: **1 user** (or shows marioxu@yahoo.ca)

### If it doesn't show "1 user" or your email:
You need to add yourself as a test user! See instructions above.

---

## ✅ Once You've Added Yourself as Test User:

**Continue to STEP 5 in the main guide:**
👉 Create OAuth Client IDs (Android and Web)

**The steps are:**
1. Go to Credentials tab (left sidebar)
2. Create Android OAuth Client ID (with your SHA-1)
3. Create Web OAuth Client ID (for Supabase)
4. Update Supabase with the Web Client ID and Secret
5. Tell me your Android Client ID so I can add it to the code

---

## 💬 Tell Me Where You Are:

**After you add test user, tell me:**
- ✅ "I added myself as test user"
- ✅ "I'm ready for Step 5"
- ✅ "I can see Test users: 1 user"

**If you're stuck, tell me:**
- ❌ "I can't find Test users section"
- ❌ "I don't see Audience tab"
- ❌ "My screen looks different"

**I'll help you through it!** 💪

---

## 🎯 Summary:

| What You Need | Where to Find It |
|---------------|------------------|
| **Test Users** | OAuth Consent Screen → Audience tab → Test users |
| **App Domain** | OAuth Consent Screen → Branding tab |
| **OAuth Clients** | Credentials tab (left sidebar) |

**Next:** Once test user is added, continue to Step 5 to create OAuth clients!
