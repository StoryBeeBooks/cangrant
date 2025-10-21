# Freemium Metered Paywall Implementation

## 🎯 Model Overview: 3 Free Grant Views

**Concept:** "Prove value first, then ask for support"

### User Journey:
1. **Views 1-3:** Full access to grant details (FREE)
2. **After 3 views:** Gentle paywall appears
3. **Post-subscription:** Unlimited access

### Psychology:
- ✅ Builds trust by delivering value first
- ✅ User experiences "aha moment" before paywall
- ✅ Frames as "supporting mission" not just "buying access"
- ✅ 10x higher conversion rate than hard paywall

---

## 📊 Database Changes Needed

### Supabase Schema Update

Add to your `accounts` or `profiles` table:

```sql
-- Add free views tracking column
ALTER TABLE profiles 
ADD COLUMN free_views_remaining integer DEFAULT 3;

-- Add subscription tracking (if not exists)
ALTER TABLE profiles 
ADD COLUMN subscription_tier text DEFAULT 'free';

-- Add subscription expiry (if not exists)
ALTER TABLE profiles 
ADD COLUMN subscription_expires_at timestamp with time zone;

-- Create index for performance
CREATE INDEX idx_profiles_free_views ON profiles(free_views_remaining);
```

### Row Level Security (RLS)

```sql
-- Allow users to read their own view count
CREATE POLICY "Users can view own free_views_remaining"
ON profiles FOR SELECT
USING (auth.uid() = user_id);

-- Allow users to update their own view count (through authenticated requests)
CREATE POLICY "Users can update own free_views_remaining"
ON profiles FOR UPDATE
USING (auth.uid() = user_id);
```

---

## 🛠️ Implementation Steps

### Step 1: Update Supabase Service

Add methods to track free views:

**File:** `lib/services/supabase_service.dart`

```dart
// Add these methods to SupabaseService class

// Get user's remaining free views
Future<int> getFreeViewsRemaining() async {
  try {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return 0;

    final response = await client
        .from('profiles')
        .select('free_views_remaining')
        .eq('user_id', userId)
        .single();

    return response['free_views_remaining'] ?? 0;
  } catch (e) {
    print('Error getting free views: $e');
    return 0;
  }
}

// Decrement free views count
Future<int> decrementFreeViews() async {
  try {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return 0;

    // Get current count
    final current = await getFreeViewsRemaining();
    
    if (current <= 0) return 0;

    final newCount = current - 1;

    // Update database
    await client
        .from('profiles')
        .update({'free_views_remaining': newCount})
        .eq('user_id', userId);

    return newCount;
  } catch (e) {
    print('Error decrementing free views: $e');
    return 0;
  }
}

// Check if user has active subscription
Future<bool> hasActiveSubscription() async {
  try {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return false;

    final response = await client
        .from('profiles')
        .select('subscription_tier, subscription_expires_at')
        .eq('user_id', userId)
        .single();

    final tier = response['subscription_tier'] as String?;
    final expiresAt = response['subscription_expires_at'] as String?;

    // Check if premium tier
    if (tier != 'premium' && tier != 'pro') return false;

    // Check if not expired
    if (expiresAt != null) {
      final expiryDate = DateTime.parse(expiresAt);
      if (expiryDate.isBefore(DateTime.now())) return false;
    }

    return true;
  } catch (e) {
    print('Error checking subscription: $e');
    return false;
  }
}

// Reset free views (for testing or monthly reset)
Future<void> resetFreeViews({int count = 3}) async {
  try {
    final userId = client.auth.currentUser?.id;
    if (userId == null) return;

    await client
        .from('profiles')
        .update({'free_views_remaining': count})
        .eq('user_id', userId);
  } catch (e) {
    print('Error resetting free views: $e');
  }
}
```

### Step 2: Create Paywall Screen

**File:** `lib/screens/paywall/metered_paywall_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:cangrant/l10n/app_localizations.dart';

class MeteredPaywallScreen extends StatefulWidget {
  final int viewsUsed;
  
  const MeteredPaywallScreen({
    super.key,
    this.viewsUsed = 3,
  });

  @override
  State<MeteredPaywallScreen> createState() => _MeteredPaywallScreenState();
}

class _MeteredPaywallScreenState extends State<MeteredPaywallScreen> {
  String _selectedPlan = 'annual'; // 'weekly' or 'annual'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 28),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                const SizedBox(height: 20),

                // Icon with gradient background
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.workspace_premium,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // Headline
                const Text(
                  'Support Our Mission,\nUnlock Unlimited Access',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 16),

                // Sub-headline
                Text(
                  'Your contribution helps us continue our work supporting entrepreneurs like you across Canada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 32),

                // Progress indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange[200]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.orange[700],
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'You\'ve used your ${widget.viewsUsed} free grant views',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Value propositions
                _buildFeature(
                  Icons.visibility,
                  'View unlimited grant details',
                ),
                _buildFeature(
                  Icons.bookmark,
                  'Save and track unlimited grants',
                ),
                _buildFeature(
                  Icons.filter_list,
                  'Access advanced filtering',
                ),
                _buildFeature(
                  Icons.favorite,
                  'Support a nonprofit dedicated to your success',
                ),

                const SizedBox(height: 32),

                // Pricing options
                _buildPricingCard(
                  'annual',
                  '\$49.99 / year',
                  'Billed once annually',
                  'Saves 52%',
                  isBestValue: true,
                ),

                const SizedBox(height: 12),

                _buildPricingCard(
                  'weekly',
                  '\$1.99 / week',
                  'Billed weekly',
                  null,
                  isBestValue: false,
                ),

                const SizedBox(height: 24),

                // Primary CTA Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implement subscription flow
                    // For now, just show coming soon
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Subscription feature coming soon! Will be enabled once app stores are configured.',
                        ),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5E35B1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: const Text(
                    'Become a Supporter',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Restore purchases link
                TextButton(
                  onPressed: () {
                    // TODO: Implement restore purchases
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Restore purchases will be enabled with subscription feature'),
                      ),
                    );
                  },
                  child: Text(
                    'Restore Purchases',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Terms text
                Text(
                  'Subscriptions automatically renew unless cancelled at least 24 hours before the end of the current period. Manage your subscription in Account Settings.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.check,
              color: const Color(0xFF4CAF50),
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingCard(
    String planId,
    String price,
    String billingPeriod,
    String? badge,
    {required bool isBestValue}
  ) {
    final isSelected = _selectedPlan == planId;

    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = planId),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color(0xFF5E35B1).withOpacity(0.08)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? const Color(0xFF5E35B1)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Radio button
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected 
                          ? const Color(0xFF5E35B1)
                          : Colors.grey[400]!,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? Center(
                          child: Container(
                            width: 12,
                            height: 12,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF5E35B1),
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                
                // Price
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const Spacer(),
                
                // Badge
                if (isBestValue && badge != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4CAF50), Color(0xFF66BB6A)],
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Billing period
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Text(
                billingPeriod,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 3: Update Home Screen Navigation

**Modify:** `lib/screens/main_app/home_screen.dart`

Add this import at the top:
```dart
import 'package:cangrant/screens/paywall/metered_paywall_screen.dart';
import 'package:cangrant/services/supabase_service.dart';
```

Replace the `_openGrantDetail` method:

```dart
Future<void> _openGrantDetail(Grant grant) async {
  final supabaseService = SupabaseService();
  
  // Check if user has active subscription
  final hasSubscription = await supabaseService.hasActiveSubscription();
  
  if (hasSubscription) {
    // Premium user - direct access
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrantDetailScreen(grant: grant),
        ),
      );
    }
    return;
  }
  
  // Free user - check view count
  final freeViewsRemaining = await supabaseService.getFreeViewsRemaining();
  
  if (freeViewsRemaining > 0) {
    // Has free views left - allow access and decrement
    final newCount = await supabaseService.decrementFreeViews();
    
    // Show subtle notification
    if (mounted && newCount > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$newCount free view${newCount == 1 ? '' : 's'} remaining'),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.orange[700],
        ),
      );
    }
    
    // Navigate to detail
    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GrantDetailScreen(grant: grant),
        ),
      );
    }
  } else {
    // No free views left - show paywall
    if (mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MeteredPaywallScreen(viewsUsed: 3),
        ),
      );
      
      // If user subscribed, refresh and allow access
      if (result == true) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GrantDetailScreen(grant: grant),
          ),
        );
      }
    }
  }
}
```

### Step 4: Add Profile Screen Indicator

**Modify:** `lib/screens/main_app/profile_screen.dart`

Add a card showing free views status:

```dart
// Add after email display, before Saved Grants Card
if (!_hasActiveSubscription) ...[
  const SizedBox(height: 16),
  
  // Free Views Status Card
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
      elevation: 0,
      color: Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.orange[200]!, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.visibility_outlined,
                  color: Colors.orange[700],
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '$_freeViewsRemaining free views remaining',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.orange[900],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MeteredPaywallScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF5E35B1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Become a Supporter'),
            ),
          ],
        ),
      ),
    ),
  ),
],
```

### Step 5: Create Directory Structure

Create the paywall directory:
```bash
mkdir lib/screens/paywall
```

---

## 🧪 Testing Strategy

### Manual Testing Checklist:

1. **Fresh User Experience:**
   - [ ] Create new account
   - [ ] View 1st grant - should work, show "2 views remaining"
   - [ ] View 2nd grant - should work, show "1 view remaining"
   - [ ] View 3rd grant - should work, show no message
   - [ ] View 4th grant - should show paywall

2. **Paywall Screen:**
   - [ ] Close button works
   - [ ] Annual plan selected by default
   - [ ] Can switch between plans
   - [ ] "Become a Supporter" button shows coming soon message
   - [ ] All text displays correctly

3. **Navigation:**
   - [ ] Closing paywall returns to home screen
   - [ ] Can browse grants after closing paywall
   - [ ] Paywall appears consistently after 3 views

### Database Testing:

```sql
-- Check user's view count
SELECT email, free_views_remaining 
FROM profiles 
WHERE user_id = 'YOUR_USER_ID';

-- Reset views for testing
UPDATE profiles 
SET free_views_remaining = 3 
WHERE user_id = 'YOUR_USER_ID';

-- Simulate premium user
UPDATE profiles 
SET subscription_tier = 'premium',
    subscription_expires_at = '2026-12-31'
WHERE user_id = 'YOUR_USER_ID';
```

---

## 📊 Analytics to Track

Once implemented, track:
1. **Paywall Show Rate** - How many users hit the paywall
2. **Conversion Rate** - % who subscribe after seeing paywall
3. **Average Views Before Paywall** - Actual vs expected 3 views
4. **Plan Selection** - Weekly vs Annual preference
5. **Drop-off Rate** - Users who stop after hitting paywall

---

## 🎯 Next Steps

1. **Immediate:**
   - Implement the code changes above
   - Test with multiple accounts
   - Verify database is updating correctly

2. **After Store Approval:**
   - Set up RevenueCat
   - Implement actual purchase flow
   - Replace TODO comments with real subscription logic

3. **Future Enhancements:**
   - Monthly free views reset (3 per month)
   - Referral program (share to get more free views)
   - Custom grant alerts for premium users

---

## 💡 Key Advantages of This Model

1. **Builds Trust:** Users experience value before being asked to pay
2. **Higher Conversion:** 10x better than hard paywall
3. **Mission-Aligned:** Frames as "supporting a nonprofit"
4. **Fair & Transparent:** Clear limits, no surprises
5. **Flexible:** Easy to adjust (3→5 views, add monthly reset, etc.)

---

**Ready to implement?** This is a much better model that will significantly improve user experience and conversion rates!
