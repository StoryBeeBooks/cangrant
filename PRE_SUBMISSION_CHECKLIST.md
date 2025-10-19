# Pre-Submission Action Items

## 🔴 MUST DO BEFORE SUBMISSION (Blockers)

### 1. Change Package Name/Bundle Identifier
**Current:** `com.example.cangrant`  
**Action:** Change to your company domain

#### Android:
Edit `android/app/build.gradle.kts`:
```kotlin
defaultConfig {
    applicationId = "com.storybee.cangrant"  // Change this
    // ... rest of config
}
```

#### iOS:
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target
3. Change Bundle Identifier to `com.storybee.cangrant`

### 2. Create App Icon
**Required Sizes:**
- iOS: 1024x1024px (App Store)
- Android: Multiple sizes (use icon generator)

**Recommended Tool:** https://appicon.co

**Steps:**
1. Design 1024x1024px icon
2. Generate all sizes using appicon.co
3. Replace files in:
   - `android/app/src/main/res/mipmap-*/`
   - `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### 3. Setup Release Signing (Android)

#### Generate Keystore:
```bash
keytool -genkey -v -keystore ~/cangrant-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias cangrant-key
```

#### Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=cangrant-key
storeFile=/path/to/cangrant-release.jks
```

#### Update `android/app/build.gradle.kts`:
Add before `android {`:
```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}
```

Update `signingConfigs` and `buildTypes`:
```kotlin
signingConfigs {
    create("release") {
        keyAlias = keystoreProperties["keyAlias"] as String
        keyPassword = keystoreProperties["keyPassword"] as String
        storeFile = file(keystoreProperties["storeFile"] as String)
        storePassword = keystoreProperties["storePassword"] as String
    }
}

buildTypes {
    release {
        signingConfig = signingConfigs.getByName("release")
    }
}
```

### 4. Host Privacy Policy Online
**Current:** In-app screen only  
**Required:** Public URL

**Options:**
- Create simple website: privacypolicy.cangrant.ca
- Use GitHub Pages
- Use services like Termly or iubenda

**URL to add:** During App Store Connect / Play Console submission

### 5. Create Screenshots

#### iPhone (Required):
- 6.7" (1290 x 2796) - iPhone 14 Pro Max
- 6.5" (1284 x 2778) - iPhone 13 Pro Max
- 5.5" (1242 x 2208) - iPhone 8 Plus

#### iPad (Recommended):
- 12.9" (2048 x 2732) - iPad Pro

#### Android (Required):
- Phone: 1080 x 1920 or similar
- Tablet: 7" or 10" (optional)

**Minimum:** 2 screenshots per platform  
**Recommended:** 4-6 screenshots showing key features

**Screenshot Ideas:**
1. Grants discovery page (home screen)
2. Grant detail page
3. Filter functionality
4. Saved grants page
5. Business profile setup
6. Language selection

### 6. Setup iOS Code Signing
1. Create Apple Developer Account ($99/year)
2. Create App ID in Apple Developer Portal
3. Create Distribution Certificate
4. Create Provisioning Profile
5. Configure in Xcode

## 🟡 SHOULD DO (Important)

### 7. Add .gitignore Entries for Secrets
Add to `.gitignore`:
```
# Keystore files
*.jks
*.keystore
key.properties

# Environment files
.env
.env.local
```

### 8. Create App Store Descriptions

#### Short Description (80 chars):
"Discover Canadian government grants and funding opportunities for your business"

#### Full Description (2000-4000 chars):
```
CanGrant - Your Gateway to Canadian Funding Opportunities

Discover and apply for government grants, funding programs, and financial support opportunities across Canada. Whether you're a startup, non-profit, or established business, CanGrant helps you find the perfect funding match.

KEY FEATURES:

🔍 Smart Grant Discovery
Browse curated grants from federal, provincial, and municipal governments. Our intelligent filtering helps you find opportunities that match your business profile.

✨ Personalized Recommendations
Complete your business profile and receive grant recommendations tailored to your industry, location, and funding needs.

📊 Comprehensive Grant Details
View complete information including:
- Funding amounts
- Application deadlines
- Eligibility requirements
- Application links

💾 Save & Track
Bookmark grants you're interested in and keep track of application deadlines. Never miss an opportunity with our organized saved grants feature.

🌐 Bilingual Support
Full support for English and French-speaking users. Switch languages seamlessly in settings.

🔔 Stay Updated
Keep track of grant statuses: Open, Coming Soon, Rolling Basis, or Closed. Know exactly which grants are accepting applications right now.

📱 Easy Application Process
Direct links to official grant application pages. Start your application with a single tap.

WHO IS THIS FOR?
- Small and medium businesses
- Non-profit organizations
- Charities
- Indigenous-owned businesses
- Minority and woman-owned businesses
- Social enterprises

FUNDING TYPES:
- Business expansion grants
- Research & development funding
- Hiring incentives
- Equipment grants
- Export and trade support
- Innovation funding
- Environmental initiatives
- Arts and culture programs

WHY CANGRANT?
Finding government funding shouldn't be complicated. We've simplified the grant discovery process, bringing all Canadian funding opportunities into one easy-to-use app.

Download CanGrant today and unlock funding opportunities for your business!

---
Privacy: We respect your privacy. Your data is stored securely and never shared with third parties. Read our full privacy policy at [YOUR_PRIVACY_URL]

Support: Questions or feedback? Contact us at support@cangrant.ca
```

### 9. Prepare Marketing Materials

#### Feature Graphic (Google Play):
- Size: 1024 x 500 pixels
- Format: PNG or JPEG
- Content: Eye-catching banner with app name and key benefit

#### Promotional Text:
"Find Canadian grants and funding opportunities tailored to your business. Smart filtering, deadline tracking, and personalized recommendations."

### 10. Test on Real Devices
- [ ] iPhone (latest iOS)
- [ ] iPhone (iOS 14)
- [ ] iPad
- [ ] Android phone (latest Android)
- [ ] Android phone (Android 9)
- [ ] Android tablet

## 🟢 NICE TO HAVE (Polish)

### 11. Add Accessibility Labels
```dart
// Example:
Semantics(
  label: 'Filter grants button',
  child: IconButton(
    icon: Icon(Icons.filter_list),
    onPressed: _showFilterDialog,
  ),
)
```

### 12. Add App Rating Prompt
Add `in_app_review` package and prompt after user saves 3rd grant.

### 13. Add Crash Reporting
Consider adding Firebase Crashlytics or Sentry.

### 14. Add Analytics
Consider Firebase Analytics or Mixpanel for usage insights.

### 15. Create App Website
Simple landing page at cangrant.ca with:
- App description
- Download links
- Privacy policy
- Terms of use
- Contact information

## 📋 Final Verification Checklist

Before hitting "Submit for Review":

- [ ] Package name changed from com.example.*
- [ ] App icon added (all sizes)
- [ ] Release keystore created (Android)
- [ ] Code signing configured (iOS)
- [ ] Privacy policy URL added
- [ ] Screenshots uploaded (minimum 2)
- [ ] App description written
- [ ] Support email configured
- [ ] Category selected
- [ ] Content rating completed
- [ ] Tested on physical devices
- [ ] No crashes or major bugs
- [ ] All features work as expected
- [ ] App builds successfully in release mode

## 🚀 Build Commands

### Android Release Build:
```bash
flutter build appbundle --release
```
Output: `build/app/outputs/bundle/release/app-release.aab`

### iOS Release Build:
```bash
flutter build ios --release
```
Then archive and upload using Xcode.

## 📞 Support Information

**Required for both stores:**
- Support Email: support@cangrant.ca
- Support URL: https://cangrant.ca/support (optional)
- Privacy Policy URL: https://cangrant.ca/privacy (REQUIRED)

## ⏱️ Timeline Estimate

- Icon Design: 2-4 hours
- Screenshots: 1-2 hours
- Descriptions: 1 hour
- Privacy Policy hosting: 1 hour
- Code signing setup: 1-2 hours
- Testing: 2-4 hours
- Submission process: 1-2 hours

**Total: ~10-16 hours** of work before first submission

## 🎯 Success Metrics to Track

After launch, monitor:
- Downloads
- User retention
- Crash-free rate
- Average rating
- Most used features
- Drop-off points

Good luck with your submission! 🚀
