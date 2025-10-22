# 🎨 Custom Icon Guide for Sign-In Buttons

## ✅ CURRENT STATUS:

I've updated the auth screen with **modern square icon buttons**:
- ✅ **Google button**: 72x72px white square with Google logo (loaded from web)
- ✅ **Apple button**: 72x72px black square with Apple icon (built-in Flutter icon)
- ✅ Centered side-by-side
- ✅ Beautiful shadows and rounded corners
- ✅ Tap animation
- ✅ Loading state with spinner

**Changes committed to GitHub!** ✓

---

## 🖼️ If You Want Custom Brand Logos:

### **Option 1: Use Your Own PNG Icons**

If you have better quality Google/Apple logos, follow these steps:

#### **1. Prepare Your Icons:**
- **Size:** 500x500 pixels (PNG format, transparent background)
- **Google logo:** The multicolor "G" logo
- **Apple logo:** The white Apple symbol (on transparent background)

#### **2. Upload Icons to This Folder:**
```
c:\src\cangrant\assets\images\
```

Create the folder structure if it doesn't exist:
- `assets/` (already exists)
- `assets/images/` (you may need to create this)

#### **3. Add These Files:**
- `assets/images/google_icon.png` (500x500px, transparent background)
- `assets/images/apple_icon.png` (500x500px, white Apple logo, transparent background)

#### **4. Update pubspec.yaml:**

I'll need to add these assets to the pubspec.yaml file.

#### **5. Update the Code:**

I'll change the code to use your local PNG files instead of loading from the web.

---

## 📁 Current Folder Structure:

```
c:\src\cangrant\
├── assets/
│   └── data/
│       └── grants.json (this was deleted earlier)
│   
│   (You can create:)
│   └── images/          ← Add your PNG files here
│       ├── google_icon.png
│       └── apple_icon.png
```

---

## 🎯 What to Do AFTER You Upload Icons:

### **Tell me:**
✅ "I uploaded the Google and Apple icons to assets/images/"

### **Then I'll:**
1. Update `pubspec.yaml` to include the images
2. Update `auth_screen.dart` to use local PNG files instead of web URL
3. Test and commit changes

---

## 💡 Current Design (No Upload Needed):

**Right now, the app uses:**
- **Google**: Loads logo from Google's CDN (https://www.gstatic.com/...)
- **Apple**: Uses Flutter's built-in Apple icon

**This works great!** Unless you want custom high-resolution brand logos, you don't need to upload anything.

---

## 📱 What the New Buttons Look Like:

```
┌─────────────────────────────────┐
│                                 │
│     Welcome to My-Grants       │
│                                 │
│  Discover Canadian grants...   │
│                                 │
│    Sign in to continue          │
│                                 │
│      ┌────┐    ┌────┐          │
│      │ G  │    │    │          │  ← Square buttons
│      │    │    │    │          │     side by side
│      └────┘    └────┘          │
│     Google     Apple            │
│                                 │
│  By signing in, you agree...   │
│                                 │
└─────────────────────────────────┘
```

**Features:**
- 72x72 pixel square buttons
- Rounded corners (16px radius)
- Subtle shadows
- Clean, modern look
- Professional spacing

---

## 🚀 Next Steps:

**Option A: Keep Current Design (Recommended)**
- ✅ Already committed to GitHub
- ✅ Works great with web-loaded Google logo
- ✅ Clean Apple icon
- ✅ No additional setup needed

**Option B: Use Custom Icons**
1. Upload `google_icon.png` and `apple_icon.png` to `assets/images/`
2. Tell me "Icons uploaded"
3. I'll update the code to use your custom icons

---

**Which option do you prefer?** The current design looks professional and modern! 🎨
