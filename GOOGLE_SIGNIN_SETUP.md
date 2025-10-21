# 🚀 Google Sign-In Setup Guide for My-Grants

**Current Status:** Your app UI is complete! The "Continue with Google" button is beautiful and ready to work once we configure OAuth.

## ⏱️ Time Required: ~30 minutes

---

## 📋 What You Need

1. ✅ **Google Play Console account** (you have this!)
2. ⬜ **Google Cloud Console project** (we'll create this)
3. ⬜ **SHA-1 certificate fingerprint** (we'll get this from your app)

---

## 🎯 Step-by-Step Instructions

### **STEP 1: Get Your App's SHA-1 Fingerprint** (5 minutes)

This is a unique identifier for your app that Google uses for security.

1. **Open PowerShell** in VS Code
2. **Navigate to your android folder:**
   ```powershell
   cd C:\src\cangrant\android
   ```

3. **Run this command to get your SHA-1:**
   ```powershell
   .\gradlew signingReport
   ```

4. **Look for this section in the output:**
   ```
   Variant: debug
   Config: debug
   Store: C:\Users\[YourName]\.android\debug.keystore
   Alias: AndroidDebugKey
   SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
   ```

5. **📝 Copy the SHA-1 value** (the XX:XX:XX... part)
   - Example: `A1:B2:C3:D4:E5:F6:G7:H8:I9:J0:K1:L2:M3:N4:O5:P6:Q7:R8:S9:T0`

---

### **STEP 2: Create Google Cloud Project** (10 minutes)

1. **Go to Google Cloud Console:**
   👉 https://console.cloud.google.com/

2. **Click the project dropdown** at the top (next to "Google Cloud")

3. **Click "NEW PROJECT"**
   - **Project name:** `My-Grants App`
   - **Location:** No organization
   - Click **CREATE**

4. **Wait for project to be created** (takes ~1 minute)

5. **Select your new project** from the dropdown

---

### **STEP 3: Enable Google Sign-In API** (3 minutes)

1. **In Google Cloud Console, go to:**
   👉 APIs & Services → Library
   - Or click: https://console.cloud.google.com/apis/library

2. **Search for:** `Google+ API`

3. **Click on it** → Click **ENABLE**

---

### **STEP 4: Configure OAuth Consent Screen** (5 minutes)

1. **Go to:**
   👉 APIs & Services → OAuth consent screen
   - Or click: https://console.cloud.google.com/apis/credentials/consent

2. **Choose "External"** → Click **CREATE**

3. **Fill in App Information:**
   - **App name:** `My-Grants`
   - **User support email:** `marioxu@yahoo.ca`
   - **App logo:** (optional - skip for now)
   - **Application home page:** `https://my-grants.com`
   - **Application privacy policy link:** `https://my-grants.com/privacy` (create later)
   - **Application terms of service:** `https://my-grants.com/terms` (create later)

4. **Developer contact information:**
   - **Email addresses:** `marioxu@yahoo.ca`

5. **Click SAVE AND CONTINUE**

6. **Scopes page:** Click **SAVE AND CONTINUE** (no changes needed)

7. **Test users page:** 
   - Click **+ ADD USERS**
   - Add: `marioxu@yahoo.ca`
   - Click **ADD**
   - Click **SAVE AND CONTINUE**

8. **Summary page:** Click **BACK TO DASHBOARD**

---

### **STEP 5: Create OAuth 2.0 Client ID** (5 minutes)

1. **Go to:**
   👉 APIs & Services → Credentials
   - Or click: https://console.cloud.google.com/apis/credentials

2. **Click "+ CREATE CREDENTIALS"** → Select **OAuth client ID**

3. **Application type:** Select **Android**

4. **Fill in the form:**
   - **Name:** `My-Grants Android App`
   - **Package name:** `com.mygrants.app`
   - **SHA-1 certificate fingerprint:** [Paste the SHA-1 you copied in STEP 1]

5. **Click CREATE**

6. **📝 A dialog will appear with your Client ID - DON'T WORRY!**
   - You don't need to save this Client ID
   - The package name + SHA-1 is what matters
   - Click **OK**

---

### **STEP 6: Update Supabase** (2 minutes)

1. **Go back to your Supabase project:**
   👉 https://supabase.com/dashboard/project/tvhcnjimfdfsentmngjj/auth/providers

2. **Click on "Google"** provider (already enabled in your screenshot)

3. **You need to get Google Client ID and Secret:**
   - Go back to Google Cloud Console
   - Go to: APIs & Services → Credentials
   - Find your OAuth 2.0 Client ID (type should be "Web application")
   - **If you don't have a "Web application" type, create one:**
     - Click "+ CREATE CREDENTIALS" → OAuth client ID
     - Application type: **Web application**
     - Name: `My-Grants Web`
     - Authorized redirect URIs: `https://tvhcnjimfdfsentmngjj.supabase.co/auth/v1/callback`
     - Click **CREATE**
   - **Copy the Client ID and Client Secret**

4. **Paste into Supabase:**
   - **Client ID:** [from Web application credentials]
   - **Client Secret:** [from Web application credentials]
   - Click **Save**

---

## ✅ That's It! Your Google Sign-In is Ready!

### **Test It:**
1. Open your app on the Android emulator
2. Click "Continue with Google"
3. Select your Google account
4. You should be signed in! 🎉

---

## 🍎 About Apple Sign-In

**Current Status:** ⏸️ Disabled until your Apple Developer account is approved

**What's Already Done:**
- ✅ UI is ready (button will appear on iOS/macOS)
- ✅ Code is complete in `auth_screen.dart`
- ✅ Package installed: `sign_in_with_apple: ^6.1.0`

**When Apple Developer Account is Approved:**
- Follow `AUTHENTICATION_SETUP.md` → PART 3
- Takes ~20 minutes to configure
- **IMPORTANT:** Apple Sign-In is **REQUIRED** for App Store approval if you offer any other social login

---

## 🆘 Troubleshooting

### "Sign-in attempt failed"
- Make sure SHA-1 is correct (run `gradlew signingReport` again)
- Make sure package name is exactly: `com.mygrants.app`
- Wait 5-10 minutes after creating OAuth client (Google needs time to propagate)

### "API has not been used in project before"
- Make sure you enabled Google+ API in STEP 3

### "Access blocked: This app's request is invalid"
- Complete OAuth consent screen in STEP 4
- Add yourself as a test user

---

## 📱 Next Steps After Testing

1. **Add more test users** to OAuth consent screen (max 100 in testing mode)
2. **Create privacy policy page** on my-grants.com
3. **Create terms of service page** on my-grants.com
4. **Submit app for verification** when ready to go public (no 100 user limit)

---

## 💡 Pro Tips

- Keep your app in "Testing" mode until you're ready to launch
- Test with multiple Google accounts
- The SHA-1 from `debug.keystore` is for development only
- When you publish to Play Store, you'll need to add the **release SHA-1** too

---

**Need Help?** 
- Copy any error messages you see
- Check the Android Studio logcat for detailed errors
- The callback URL in Supabase is automatically configured: `https://tvhcnjimfdfsentmngjj.supabase.co/auth/v1/callback`
