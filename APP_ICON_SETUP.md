# App Icon Setup Guide

## Icon Files Analysis

We have three icon files in `assets/images/`:

1. **icon.png** - 2,107,010 bytes (~2.1 MB) ✅ **RECOMMENDED**
2. **icon medium.png** - 854,421 bytes (~854 KB)
3. **icon small.png** - 297,068 bytes (~297 KB)

**Recommendation:** Use **`icon.png`** as the source file for generating all app icons. It's the highest quality and largest file, which is perfect for generating multiple sizes without quality loss.

## App Icon Requirements

### Android Icon Sizes Required:
- **mdpi**: 48x48px (baseline)
- **hdpi**: 72x72px (1.5x)
- **xhdpi**: 96x96px (2x)
- **xxhdpi**: 144x144px (3x)
- **xxxhdpi**: 192x192px (4x)
- **Play Store**: 512x512px

### iOS Icon Sizes Required:
- **20pt**: 20x20, 40x40, 60x60
- **29pt**: 29x29, 58x58, 87x87
- **40pt**: 40x40, 80x80, 120x120
- **60pt**: 120x120, 180x180
- **76pt**: 76x76, 152x152
- **83.5pt**: 167x167
- **App Store**: 1024x1024px

## Automated Setup Options

### Option 1: Use flutter_launcher_icons Package (RECOMMENDED - Easy!)

1. Add to `pubspec.yaml`:
```yaml
dev_dependencies:
  flutter_launcher_icons: ^0.13.1

flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/icon.png"
  adaptive_icon_background: "#FFFFFF"  # White background
  adaptive_icon_foreground: "assets/images/icon.png"
```

2. Run the generator:
```bash
flutter pub get
flutter pub run flutter_launcher_icons
```

This will automatically generate all required sizes for both platforms!

### Option 2: Online Icon Generator

1. Go to: https://www.appicon.co/ or https://easyappicon.com/
2. Upload `assets/images/icon.png`
3. Download the generated icon packages
4. Manually place files in:
   - Android: `android/app/src/main/res/mipmap-*/`
   - iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`

### Option 3: Manual Resize (Not Recommended - Time Consuming)

Use image editing software (Photoshop, GIMP, etc.) to create each size manually.

## Current Status

Currently, your app is using the default Flutter icon. After setting up the custom icon, you'll need to:

1. Uninstall the app from your test device
2. Run `flutter clean`
3. Rebuild and reinstall the app

## Verification

After setup, verify the icon appears correctly:
- **Android**: Check app drawer and home screen
- **iOS**: Check home screen and App Switcher
- **Both**: Check in Settings > Apps list

## Notes

- Icon should be **square** with rounded corners handled by the OS
- Avoid text in icons (looks bad at small sizes)
- Use transparent background or solid color
- High contrast works best
- Test on both light and dark system themes

## Recommended Next Step

Run this command to set up icons automatically:

```bash
# Add the package
flutter pub add dev:flutter_launcher_icons

# Then add the config to pubspec.yaml (see Option 1 above)
# Then run:
flutter pub run flutter_launcher_icons
```
