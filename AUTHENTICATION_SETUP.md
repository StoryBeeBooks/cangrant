# COMPLETE AUTHENTICATION SETUP GUIDE
## My-Grants App - Email, Google, and Apple Sign-In

---

## 🎯 WHAT'S NEW

Your authentication system has been **completely rewritten** with:

✅ **Fixed Email/Password Authentication** - Better error handling, proper navigation  
✅ **Google Sign-In** - One-tap login with Google account  
✅ **Apple Sign-In** - Required for App Store, shows only on iOS/macOS  
✅ **Debug Logging** - See exactly what's happening in the console  
✅ **Better UX** - Error messages, loading states, forgot password

---

## 📋 SETUP CHECKLIST

### PART 1: Supabase Dashboard Setup (Required for Social Login)

### PART 2: Google Cloud Console Setup (for Google Sign-In)

### PART 3: Apple Developer Setup (for Apple Sign-In - iOS only)

### PART 4: Test Authentication

---

## PART 1: SUPABASE DASHBOARD SETUP

### Step 1: Enable Google Provider in Supabase

1. Go to your Supabase Dashboard: https://supabase.com/dashboard
2. Select your project: **CanGrant**
3. Click **Authentication** → **Providers** in the left sidebar
4. Scroll to **Google** and click to expand
5. Toggle **"Enable Sign in with Google"** to ON
6. **IMPORTANT**: Copy these two values (you'll need them in Part 2):
   - **Authorized Client IDs**: (leave empty for now, we'll fill this in Part 2)
   - **Redirect URL**: Copy this URL (e.g., `https://tvhcnjimfdfsentmngij.supabase.co/auth/v1/callback`)
7. Click **Save**

### Step 2: Enable Apple Provider in Supabase

1. Still in **Authentication** → **Providers**
2. Scroll to **Apple** and click to expand
3. Toggle **"Enable Sign in with Apple"** to ON
4. **IMPORTANT**: Copy the **Redirect URL** (you'll need it in Part 3)
5. Leave other fields empty for now (we'll fill them in Part 3)
6. Click **Save**

---

## PART 2: GOOGLE CLOUD CONSOLE SETUP

### Step 1: Create Google Cloud Project

1. Go to: https://console.cloud.google.com/
2. Click **Select a project** → **NEW PROJECT**
3. Project name: **My-Grants** (or any name)
4. Click **CREATE**

### Step 2: Enable Google Sign-In API

1. In your new project, go to **APIs & Services** → **Library**
2. Search for **"Google+ API"** or **"Google Sign-In API"**
3. Click **ENABLE**

### Step 3: Create OAuth 2.0 Credentials

#### For Android:

1. Go to **APIs & Services** → **Credentials**
2. Click **CREATE CREDENTIALS** → **OAuth client ID**
3. Application type: **Android**
4. Name: **My-Grants Android**
5. **Package name**: `com.mygrants.app`
6. **SHA-1 certificate fingerprint**: You need to get this by running:
   ```powershell
   cd C:\src\cangrant\android
   .\gradlew signingReport
   ```
   Look for the **SHA-1** under `Variant: debug` and copy it (looks like `AA:BB:CC:...`)
7. Click **CREATE**
8. **COPY THE CLIENT ID** (looks like `123456789-abcdef.apps.googleusercontent.com`)

#### For iOS:

1. Click **CREATE CREDENTIALS** → **OAuth client ID** again
2. Application type: **iOS**
3. Name: **My-Grants iOS**
4. **Bundle ID**: `com.mygrants.app`
5. Click **CREATE**
6. **COPY THE CLIENT ID**

#### For Web (Required for Supabase):

1. Click **CREATE CREDENTIALS** → **OAuth client ID** again
2. Application type: **Web application**
3. Name: **My-Grants Supabase**
4. **Authorized JavaScript origins**: (leave empty)
5. **Authorized redirect URIs**: Paste the Supabase Redirect URL from Part 1 Step 1
   - Example: `https://tvhcnjimfdfsentmngij.supabase.co/auth/v1/callback`
6. Click **CREATE**
7. **COPY THE CLIENT ID AND CLIENT SECRET**

### Step 4: Update Supabase with Google Credentials

1. Go back to **Supabase Dashboard** → **Authentication** → **Providers** → **Google**
2. Paste the **Web Client ID** into the **Client ID** field
3. Paste the **Web Client Secret** into the **Client Secret** field
4. In **Authorized Client IDs**, add:
   - Your Android Client ID
   - Your iOS Client ID
   - Your Web Client ID
   (One per line)
5. Click **Save**

### Step 5: Update Your App Code

1. Open: `c:\src\cangrant\lib\services\supabase_service.dart`
2. Find line with `YOUR_ANDROID_CLIENT_ID.apps.googleusercontent.com`
3. Replace it with your actual Android Client ID from Step 3
4. Save the file

---

## PART 3: APPLE DEVELOPER SETUP (iOS Only)

**NOTE**: You need an **Apple Developer Account** ($99/year) for this.

### Step 1: Create App ID

1. Go to: https://developer.apple.com/account/
2. Click **Certificates, Identifiers & Profiles**
3. Click **Identifiers** → **+** button
4. Select **App IDs** → Click **Continue**
5. Select **App** → Click **Continue**
6. Fill in:
   - **Description**: My-Grants
   - **Bundle ID**: Explicit → `com.mygrants.app`
   - **Capabilities**: Check **Sign In with Apple**
7. Click **Continue** → **Register**

### Step 2: Create Service ID

1. Click **Identifiers** → **+** button
2. Select **Services IDs** → Click **Continue**
3. Fill in:
   - **Description**: My-Grants Web Service
   - **Identifier**: `com.mygrants.app.service`
   - Check **Sign In with Apple**
4. Click **Continue** → **Register**
5. Click on the service ID you just created
6. Check **Sign In with Apple** → Click **Configure**
7. Fill in:
   - **Primary App ID**: Select `com.mygrants.app`
   - **Domains and Subdomains**: `tvhcnjimfdfsentmngij.supabase.co`
   - **Return URLs**: Paste the Supabase Apple Redirect URL from Part 1 Step 2
8. Click **Save** → **Continue** → **Done**

### Step 3: Create Private Key

1. Click **Keys** → **+** button
2. **Key Name**: My-Grants Apple Sign In Key
3. Check **Sign In with Apple**
4. Click **Configure** next to Sign In with Apple
5. Select **Primary App ID**: `com.mygrants.app`
6. Click **Save** → **Continue** → **Register**
7. **DOWNLOAD THE KEY FILE** (you can only download it once!)
8. **Copy the Key ID** (shows at the top)

### Step 4: Update Supabase with Apple Credentials

1. Go back to **Supabase Dashboard** → **Authentication** → **Providers** → **Apple**
2. Fill in:
   - **Services ID**: `com.mygrants.app.service`
   - **Team ID**: Find this in Apple Developer Account → Membership (10-character ID)
   - **Key ID**: From Step 3
   - **Private Key**: Open the downloaded `.p8` file in Notepad, copy all the text (including the BEGIN/END lines)
3. Click **Save**

---

## PART 4: TEST AUTHENTICATION

### Test Email/Password Sign-Up (Works Immediately)

1. Run your app:
   ```powershell
   flutter run
   ```

2. On the auth screen, enter:
   - Email: `support@storybee.space`
   - Password: `test123456`
   - Click **"Create Account with Email"**

3. Watch the debug console for:
   ```
   DEBUG AUTH: Attempting signup with email: support@storybee.space
   DEBUG AUTH: Signup successful! User: support@storybee.space
   ```

4. **Check Supabase**:
   - Go to **Authentication** → **Users**
   - You should see `support@storybee.space` listed

### Test Google Sign-In (After Part 2 Setup)

1. Run your app
2. Click **"Sign in with Google"**
3. Select your Google account
4. Watch console for:
   ```
   DEBUG AUTH: Attempting Google sign-in
   DEBUG AUTH: Google sign-in successful! User: your-email@gmail.com
   ```

### Test Apple Sign-In (iOS only, after Part 3 Setup)

1. Run on iOS simulator or device
2. Click **"Sign in with Apple"**
3. Use your Apple ID
4. Watch console for success message

---

## 🐛 TROUBLESHOOTING

### Email Sign-Up Not Working

**Symptom**: "User registered but not showing in Supabase"

**Solution**:
- Check debug console for actual error
- Verify Supabase URL and Anon Key are correct in `supabase_service.dart`
- Check Supabase **Authentication** → **Email Auth** is enabled

### Google Sign-In "Sign-in was cancelled"

**Symptom**: User clicks Google button, nothing happens or cancels

**Solution**:
- Make sure you added the SHA-1 fingerprint correctly
- Verify Android Client ID is updated in the code
- Check Google Cloud Console → Credentials shows your app

### Apple Sign-In "Failed to get Apple ID token"

**Symptom**: Error when trying to sign in with Apple

**Solution**:
- Verify Service ID matches exactly in Supabase
- Check private key was copied completely (including BEGIN/END lines)
- Make sure app Bundle ID matches in Xcode

### User Shows as `user@example.com` Instead of Real Email

**Symptom**: Logged in but showing placeholder email

**Solution**:
- This was the old test account!
- Sign out completely:
  ```powershell
  flutter run
  ```
  Then go to Profile → Sign Out
- Delete the app data or reinstall the app
- Sign up again with your real email

---

## 📊 DATABASE VERIFICATION

After signing up, verify the user in Supabase:

```sql
-- Check all users
SELECT id, email, created_at FROM auth.users ORDER BY created_at DESC;

-- Check if profile was auto-created
SELECT user_id, email, role, free_views_remaining 
FROM profiles 
WHERE email = 'support@storybee.space';
```

If profile wasn't created automatically, the trigger might not have fired. Run:

```sql
-- Manually create profile
INSERT INTO profiles (user_id, email, free_views_remaining, role)
SELECT id, email, 3, 'user'
FROM auth.users
WHERE email = 'support@storybee.space'
ON CONFLICT (user_id) DO NOTHING;
```

---

## ✅ FINAL CHECKLIST

Before submitting to app stores:

- [ ] Email/Password auth tested and working
- [ ] Google Sign-In configured and tested on Android
- [ ] Apple Sign-In configured and tested on iOS
- [ ] Profile auto-creation trigger working
- [ ] Paywall tracking users correctly
- [ ] Business profile saving to database
- [ ] All placeholder text removed (`user@example.com`, etc.)
- [ ] Forgot Password flow tested
- [ ] Sign out functionality working

---

## 🎉 YOU'RE DONE!

Your app now has professional authentication with:
- ✅ Email/Password (universal)
- ✅ Google Sign-In (easy for users)
- ✅ Apple Sign-In (required for iOS)
- ✅ Automatic profile creation
- ✅ Proper error handling
- ✅ Debug logging for troubleshooting

Users can now sign up and their data will sync properly across all features!
