# App Store Compliance Checklist

## ✅ Completed Fixes

### Android
- ✅ Added INTERNET permission to AndroidManifest.xml
- ✅ Changed app label from "My-Grants" to "My-Grants"
- ✅ Added proper app description in pubspec.yaml

### iOS
- ✅ Changed display name from "My-Grants" to "My-Grants"
- ✅ Updated app description

## 🚨 CRITICAL: Must Fix Before Submission

### 1. Change Package Name (REQUIRED)
**Current:** `com.example.My-Grants`  
**Required:** `com.yourcompany.My-Grants` or `com.storybee.My-Grants`

**Why:** Apple and Google reject apps with "com.example" package names.

**How to fix:**
1. Android: Update `applicationId` in `android/app/build.gradle.kts`
2. iOS: Update Bundle Identifier in Xcode

### 2. Add App Icons (REQUIRED)
**Status:** Currently using default Flutter icon  
**Required:** Custom app icon in all required sizes

**Action needed:**
- Create app icon (1024x1024px for iOS, various sizes for Android)
- Use tool like https://appicon.co to generate all sizes
- Replace icons in:
  - `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 3. Privacy Policy URL (REQUIRED for iOS)
**Status:** Privacy policy screen exists in-app but no public URL  
**Required:** Publicly accessible URL

**Action needed:**
- Host privacy policy on a public website
- Add URL to App Store Connect during submission
- Update Info.plist if needed

### 4. Release Signing (Android - REQUIRED)
**Status:** Currently using debug signing  
**Required:** Production keystore

**Action needed:**
1. Generate release keystore:
   ```bash
   keytool -genkey -v -keystore ~/My-Grants-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias My-Grants
   ```
2. Create `android/key.properties`:
   ```
   storePassword=<password>
   keyPassword=<password>
   keyAlias=My-Grants
   storeFile=<path-to-keystore>
   ```
3. Update `android/app/build.gradle.kts` to use release signing

### 5. App Store Metadata (REQUIRED)

**For Apple App Store Connect:**
- App Name: My-Grants
- Subtitle: Find Canadian Grants & Funding
- Description: (200-300 words describing the app)
- Keywords: grants, funding, canada, business, nonprofit, government
- Category: Business or Finance
- Content Rating: 4+
- Screenshots: Required (6.7", 6.5", 5.5" iPhone + iPad)
- Privacy Policy URL: [MUST PROVIDE]

**For Google Play Console:**
- App Name: My-Grants
- Short Description: Discover Canadian government grants and funding opportunities
- Full Description: (4000 char max, describe features)
- Category: Business
- Content Rating: Everyone
- Screenshots: 2-8 required
- Feature Graphic: 1024x500px
- Privacy Policy URL: [MUST PROVIDE]

## ⚠️ IMPORTANT: Recommended Improvements

### 1. Add Proper Error Handling
- Network error messages
- Offline mode handling
- Supabase connection failures

### 2. Data Privacy Compliance

**Currently collected data:**
- Email address (via Supabase authentication)
- Business profile questionnaire responses (stored locally)
- Saved grants list (stored locally)
- Language preference (stored locally)

**Required disclosures:**
- ✅ Privacy Policy screen exists
- ✅ Terms of Use screen exists
- ⚠️ Need to add data deletion capability
- ⚠️ Need to clarify data retention policy

### 3. Add Loading States
- ✅ Most screens have loading indicators
- ⚠️ Consider adding skeleton screens for better UX

### 4. Accessibility
- ✅ Using semantic widgets
- ⚠️ Add accessibility labels for icons
- ⚠️ Test with VoiceOver (iOS) and TalkBack (Android)

### 5. Localization
- ✅ English and Chinese translations implemented
- ✅ Language selection available
- ⚠️ Ensure all strings are translated (check for hardcoded strings)

## 📱 Platform-Specific Guidelines

### Apple App Store Requirements
- ✅ No third-party payment systems (not applicable - free app)
- ✅ No private APIs used
- ✅ Follows Human Interface Guidelines
- ⚠️ MUST have privacy policy URL
- ⚠️ MUST have app icon
- ⚠️ MUST change bundle identifier from com.example.*

### Google Play Store Requirements
- ✅ Target API level 33+ (using latest Flutter)
- ✅ No dangerous permissions without justification
- ✅ Follows Material Design guidelines
- ⚠️ MUST have app icon
- ⚠️ MUST change package name from com.example.*
- ⚠️ MUST provide feature graphic

## 🔒 Security & Privacy Checklist

- ✅ HTTPS only (Supabase uses HTTPS)
- ✅ Authentication implemented
- ✅ No hardcoded secrets in code
- ✅ Local data stored securely (SharedPreferences)
- ⚠️ Ensure Supabase keys are moved to environment variables
- ⚠️ Add ability for users to delete their account
- ⚠️ Add ability for users to export their data

## 🎨 Assets Needed Before Submission

### Required:
1. **App Icon** - 1024x1024px PNG (no transparency)
2. **Feature Graphic** (Android) - 1024x500px PNG
3. **Screenshots** (both platforms):
   - iPhone 6.7" (1290x2796)
   - iPhone 6.5" (1284x2778)
   - iPhone 5.5" (1242x2208)
   - iPad 12.9" (2048x2732)
   - Android Phone (1080x1920 recommended)
   - Android Tablet (optional)

### Recommended:
4. **Promotional Text** (170 chars max)
5. **App Preview Video** (optional but recommended)

## 📝 Pre-Submission Testing Checklist

### Functional Testing
- [ ] Sign up flow works
- [ ] Login flow works
- [ ] Password reset works (if implemented)
- [ ] All grants display correctly
- [ ] Filtering works properly
- [ ] Saved grants persist after app restart
- [ ] Language switching works
- [ ] Business profile update works
- [ ] All external links open correctly
- [ ] Sign out works properly

### Platform Testing
- [ ] Test on physical iPhone device
- [ ] Test on physical Android device
- [ ] Test on iPad
- [ ] Test on Android tablet
- [ ] Test different iOS versions (iOS 14+)
- [ ] Test different Android versions (Android 7+)

### Performance Testing
- [ ] App starts in < 3 seconds
- [ ] No memory leaks
- [ ] Smooth scrolling (60fps)
- [ ] Network requests complete reasonably
- [ ] Images load properly

### Accessibility Testing
- [ ] VoiceOver navigation works (iOS)
- [ ] TalkBack navigation works (Android)
- [ ] Text size adjustment works
- [ ] Color contrast meets WCAG guidelines

## 🚀 Submission Steps

### Apple App Store
1. Create App Store Connect account
2. Create App ID with proper Bundle Identifier
3. Configure app in App Store Connect
4. Upload screenshots and metadata
5. Archive and upload build using Xcode
6. Submit for review

### Google Play Store
1. Create Google Play Console account
2. Create new application
3. Configure store listing
4. Upload screenshots and metadata
5. Build signed APK/AAB: `flutter build appbundle --release`
6. Upload to Production track
7. Submit for review

## ⏱️ Estimated Review Times
- Apple App Store: 24-48 hours
- Google Play Store: 1-7 days (first submission may take longer)

## 📧 Support Email
Required for both stores. Recommendation: support@My-Grants.ca or similar

## 💰 Pricing
Currently free app with no in-app purchases.

## 🔄 Updates & Maintenance
- Plan for regular updates
- Monitor crash reports
- Respond to user reviews
- Keep dependencies updated
