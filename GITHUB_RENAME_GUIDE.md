# How to Rename GitHub Repository from "cangrant" to "mygrants"

## ✅ Good News: This is EASY and SAFE!

GitHub makes repository renaming super simple, and it **automatically redirects** old URLs to the new name. Your old links won't break!

---

## 🚀 Step-by-Step Instructions

### **Method 1: Rename on GitHub.com (5 minutes)**

#### **Step 1: Go to Repository Settings**

1. Go to [https://github.com/StoryBeeBooks/cangrant](https://github.com/StoryBeeBooks/cangrant)
2. Click the **"Settings"** tab (at the top right of the repo page)
3. Scroll down to the **"Repository name"** section (near the top)

#### **Step 2: Rename**

1. In the "Repository name" field, type: **`mygrants`**
2. Click **"Rename"** button
3. Confirm the rename (GitHub will warn you about redirects - this is fine!)

#### **Step 3: Done! ✅**

Your repository is now at: `https://github.com/StoryBeeBooks/mygrants`

**Old URL still works!** GitHub auto-redirects:
- `https://github.com/StoryBeeBooks/cangrant` → `https://github.com/StoryBeeBooks/mygrants`

---

## 💻 Update Your Local Repository (IMPORTANT!)

After renaming on GitHub, update your local repo to point to the new URL:

### **Option A: Automatic Update (Recommended)**

```powershell
cd C:\src\cangrant
git remote set-url origin https://github.com/StoryBeeBooks/mygrants.git
git remote -v  # Verify it changed
```

**Expected output:**
```
origin  https://github.com/StoryBeeBooks/mygrants.git (fetch)
origin  https://github.com/StoryBeeBooks/mygrants.git (push)
```

### **Option B: Next Time You Push**

GitHub will automatically warn you and suggest the new URL. Just run the command it gives you.

---

## 📁 Should You Rename the Local Folder Too?

### **Current:** `C:\src\cangrant`  
### **New:** `C:\src\mygrants`

**My Recommendation:** YES, for consistency!

### **How to Rename Local Folder:**

#### **Option 1: Simple Rename (Windows Explorer)**

1. Close VS Code
2. Open Windows Explorer
3. Go to `C:\src\`
4. Right-click `cangrant` folder → Rename to `mygrants`
5. Open VS Code
6. File → Open Folder → Select `C:\src\mygrants`

#### **Option 2: Command Line**

```powershell
cd C:\src
Move-Item -Path cangrant -Destination mygrants
cd mygrants
code .  # Opens VS Code in new location
```

---

## 🔍 What Gets Updated Automatically?

When you rename on GitHub:

✅ **Repository URL**: Changes to new name  
✅ **All old URLs**: Automatically redirect  
✅ **Clone URLs**: Updated  
✅ **Webhook URLs**: Updated  
✅ **API endpoints**: Updated  
✅ **GitHub Pages**: Updated (if you use them)  
✅ **Git history**: Preserved completely  
✅ **Issues, PRs, commits**: All stay intact  

---

## ⚠️ What You Need to Update Manually?

After renaming, update these:

### 1. **Your Local Git Remote** (see above)

```powershell
git remote set-url origin https://github.com/StoryBeeBooks/mygrants.git
```

### 2. **CI/CD Pipelines** (if you have them)

- GitHub Actions: No change needed (relative paths)
- External CI tools: Update repository URL

### 3. **README Badges** (if you have them)

Update any shields.io or status badges in README.md

### 4. **External Documentation**

- Personal notes
- Team wikis
- Links in other projects

---

## 🚨 Common Questions

### **Q: Will I lose my commit history?**
**A:** NO! All history, commits, branches, and tags are preserved.

### **Q: Will old links break?**
**A:** NO! GitHub automatically redirects old URLs to new name forever.

### **Q: Do I need to re-clone?**
**A:** NO! Just update your remote URL (see above).

### **Q: Will this affect my local code?**
**A:** NO! Your code stays the same. Only the remote URL changes.

### **Q: Can I undo this?**
**A:** YES! You can rename back anytime. But you've already updated all your code, so stick with "mygrants"! 🎉

---

## ✅ Complete Checklist

After renaming:

- [ ] Renamed repository on GitHub.com to "mygrants"
- [ ] Updated local git remote URL
- [ ] Renamed local folder from `cangrant` to `mygrants` (optional but recommended)
- [ ] Tested: `git pull` works
- [ ] Tested: `git push` works

---

## 🎯 Summary

**Total time:** 5 minutes  
**Risk level:** Very low (GitHub handles everything)  
**Can undo:** Yes, anytime

Just rename on GitHub, update your remote URL, and you're done!

---

## 📞 Need Help?

If you get stuck, the exact commands are:

```powershell
# After renaming on GitHub:
cd C:\src\cangrant
git remote set-url origin https://github.com/StoryBeeBooks/mygrants.git
git pull  # Test it works

# Optional: Rename local folder
cd C:\src
Move-Item -Path cangrant -Destination mygrants
cd mygrants
code .
```

That's it! 🚀
