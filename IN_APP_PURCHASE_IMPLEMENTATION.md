# In-App Purchase Implementation Plan

## 💰 Monetization Strategy

**Pricing Model:**
- Weekly Subscription: $1.99 CAD/week
- Annual Subscription: $49.99 CAD/year (saves ~50%)
- Free trial: Consider offering 3-7 days free

**What's Behind Paywall:**
- Grant detail pages (full details, application links)
- Ability to save grants
- Filter functionality (optional - could keep basic search free)

**What Stays Free:**
- Grant list browsing (titles and summaries)
- Account creation
- Onboarding/business profile

## 🛠️ Technical Implementation

### Required Packages

Add to `pubspec.yaml`:
```yaml
dependencies:
  # Existing dependencies...
  
  # In-app purchases (official Flutter package)
  in_app_purchase: ^3.1.13
  
  # Or use RevenueCat (recommended for easier management)
  purchases_flutter: ^6.26.0
```

**Recommendation:** Use **RevenueCat** - it handles:
- Server-side receipt validation
- Cross-platform subscription management
- Analytics and metrics
- Grace periods and trial management
- Webhook integration

### Architecture Overview

```
┌─────────────────────────────────────────────┐
│         Home Screen (Free)                  │
│  - List of grants (title + summary)        │
│  - Tap to view details →                   │
└─────────────────┬───────────────────────────┘
                  │
                  ↓
         ┌────────────────┐
         │ Check Sub      │
         │ Status         │
         └────┬───────┬───┘
              │       │
      Active  │       │  Not Active
              ↓       ↓
     ┌──────────┐  ┌──────────────┐
     │ Show     │  │ Show Paywall │
     │ Details  │  │ Screen       │
     └──────────┘  └──────────────┘
```

## 📱 Implementation Steps

### Step 1: Setup App Store Configurations

#### Apple App Store Connect:
1. Create in-app purchase products:
   - Product ID: `com.storybee.My-Grants.weekly`
   - Product ID: `com.storybee.My-Grants.annual`
2. Set pricing
3. Add descriptions
4. Submit for review with app

#### Google Play Console:
1. Create subscription products:
   - Product ID: `weekly_subscription`
   - Product ID: `annual_subscription`
2. Set pricing
3. Configure billing period
4. Add descriptions

### Step 2: Create Subscription Service

**File:** `lib/services/subscription_service.dart`

```dart
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final InAppPurchase _iap = InAppPurchase.instance;
  
  // Product IDs
  static const String weeklyId = 'com.storybee.My-Grants.weekly';
  static const String annualId = 'com.storybee.My-Grants.annual';
  
  // Subscription status
  bool _isSubscribed = false;
  DateTime? _expiryDate;

  bool get isSubscribed => _isSubscribed;
  DateTime? get expiryDate => _expiryDate;

  // Initialize subscription status
  Future<void> initialize() async {
    // Check if IAP is available
    final available = await _iap.isAvailable();
    if (!available) {
      return;
    }

    // Listen to purchase updates
    _iap.purchaseStream.listen(_onPurchaseUpdate);

    // Check existing purchases
    await _restorePurchases();
  }

  // Get available products
  Future<List<ProductDetails>> getProducts() async {
    final Set<String> ids = {weeklyId, annualId};
    final ProductDetailsResponse response = await _iap.queryProductDetails(ids);
    
    if (response.error != null) {
      throw Exception('Failed to load products: ${response.error}');
    }
    
    return response.productDetails;
  }

  // Purchase subscription
  Future<bool> purchaseSubscription(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    
    try {
      final success = await _iap.buyNonConsumable(purchaseParam: purchaseParam);
      return success;
    } catch (e) {
      print('Purchase error: $e');
      return false;
    }
  }

  // Restore purchases
  Future<void> _restorePurchases() async {
    try {
      await _iap.restorePurchases();
    } catch (e) {
      print('Restore error: $e');
    }
  }

  // Handle purchase updates
  void _onPurchaseUpdate(List<PurchaseDetails> purchases) {
    for (var purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased) {
        _verifyAndActivateSubscription(purchase);
      } else if (purchase.status == PurchaseStatus.error) {
        // Handle error
        print('Purchase error: ${purchase.error}');
      }
      
      // Complete purchase
      if (purchase.pendingCompletePurchase) {
        _iap.completePurchase(purchase);
      }
    }
  }

  // Verify and activate subscription
  Future<void> _verifyAndActivateSubscription(PurchaseDetails purchase) async {
    // TODO: Verify receipt with your backend or RevenueCat
    // For now, just activate locally (NOT SECURE for production)
    
    _isSubscribed = true;
    
    // Calculate expiry based on product
    if (purchase.productID == weeklyId) {
      _expiryDate = DateTime.now().add(Duration(days: 7));
    } else if (purchase.productID == annualId) {
      _expiryDate = DateTime.now().add(Duration(days: 365));
    }
    
    // Save to local storage
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_subscribed', true);
    await prefs.setString('expiry_date', _expiryDate!.toIso8601String());
  }

  // Check subscription status
  Future<bool> checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isSubscribed = prefs.getBool('is_subscribed') ?? false;
    
    final expiryString = prefs.getString('expiry_date');
    if (expiryString != null) {
      _expiryDate = DateTime.parse(expiryString);
      
      // Check if expired
      if (_expiryDate!.isBefore(DateTime.now())) {
        _isSubscribed = false;
        await prefs.setBool('is_subscribed', false);
      }
    }
    
    return _isSubscribed;
  }

  // Cancel subscription (for testing)
  Future<void> cancelSubscription() async {
    _isSubscribed = false;
    _expiryDate = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_subscribed');
    await prefs.remove('expiry_date');
  }
}
```

### Step 3: Create Paywall Screen

**File:** `lib/screens/paywall/paywall_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:My-Grants/services/subscription_service.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  final _subscriptionService = SubscriptionService();
  List<ProductDetails> _products = [];
  bool _isLoading = true;
  ProductDetails? _selectedProduct;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _subscriptionService.getProducts();
      setState(() {
        _products = products;
        _isLoading = false;
        // Default to annual (better value)
        _selectedProduct = products.firstWhere(
          (p) => p.id == SubscriptionService.annualId,
          orElse: () => products.first,
        );
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  Future<void> _purchase() async {
    if (_selectedProduct == null) return;

    setState(() => _isLoading = true);
    
    final success = await _subscriptionService.purchaseSubscription(_selectedProduct!);
    
    setState(() => _isLoading = false);

    if (success) {
      // Navigate back with success
      if (mounted) Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Close button
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      
                      const SizedBox(height: 20),

                      // Icon
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF5E35B1).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.workspace_premium,
                          size: 80,
                          color: Color(0xFF5E35B1),
                        ),
                      ),

                      const SizedBox(height: 30),

                      // Title
                      const Text(
                        'Unlock Full Access',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subtitle
                      Text(
                        'Get unlimited access to all grant details and features',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Features list
                      _buildFeature(Icons.visibility, 'View all grant details'),
                      _buildFeature(Icons.link, 'Access application links'),
                      _buildFeature(Icons.bookmark, 'Save unlimited grants'),
                      _buildFeature(Icons.filter_list, 'Advanced filtering'),
                      _buildFeature(Icons.notifications, 'Deadline reminders'),

                      const SizedBox(height: 40),

                      // Subscription options
                      ..._products.map((product) => _buildSubscriptionCard(product)),

                      const SizedBox(height: 20),

                      // Subscribe button
                      ElevatedButton(
                        onPressed: _purchase,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E35B1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Start Subscription',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Restore purchases
                      TextButton(
                        onPressed: () async {
                          await _subscriptionService._restorePurchases();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Purchases restored')),
                            );
                          }
                        },
                        child: const Text('Restore Purchases'),
                      ),

                      const SizedBox(height: 20),

                      // Terms
                      Text(
                        'Subscriptions auto-renew. Cancel anytime in your account settings.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
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
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF4CAF50), size: 20),
          ),
          const SizedBox(width: 16),
          Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscriptionCard(ProductDetails product) {
    final isSelected = _selectedProduct?.id == product.id;
    final isAnnual = product.id == SubscriptionService.annualId;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedProduct = product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF5E35B1).withOpacity(0.1) : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF5E35B1) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF5E35B1) : Colors.grey,
            ),
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        product.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (isAnnual) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF4CAF50),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SAVE 50%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Price
            Text(
              product.price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5E35B1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### Step 4: Update Grant Detail Screen

**Modify:** `lib/screens/main_app/grant_detail_screen.dart`

Add this check at the beginning of the build method or when navigating:

```dart
@override
void initState() {
  super.initState();
  _checkSubscriptionAndLoadGrant();
}

Future<void> _checkSubscriptionAndLoadGrant() async {
  final subscriptionService = SubscriptionService();
  final isSubscribed = await subscriptionService.checkSubscriptionStatus();
  
  if (!isSubscribed) {
    // Show paywall
    if (mounted) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PaywallScreen()),
      );
      
      // If user didn't subscribe, go back
      if (result != true && mounted) {
        Navigator.pop(context);
      }
    }
  } else {
    // Load grant details
    _loadSavedState();
  }
}
```

### Step 5: Update Home Screen Navigation

**Modify:** `lib/screens/main_app/home_screen.dart`

```dart
void _openGrantDetail(Grant grant) async {
  final subscriptionService = SubscriptionService();
  final isSubscribed = await subscriptionService.checkSubscriptionStatus();
  
  if (!isSubscribed) {
    // Show paywall
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PaywallScreen()),
    );
    
    // If user subscribed, open grant detail
    if (result == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GrantDetailScreen(grant: grant)),
      );
    }
  } else {
    // Directly open grant detail
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GrantDetailScreen(grant: grant)),
    );
  }
}
```

### Step 6: Initialize Subscription Service

**Modify:** `lib/main.dart`

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseService.initialize();
  
  // Initialize subscription service
  await SubscriptionService().initialize();
  
  runApp(const MyApp());
}
```

## 🔒 Important Security Considerations

### ⚠️ CRITICAL: Receipt Validation

The code above stores subscription status locally, which is **NOT SECURE**. Users can bypass by:
- Clearing app data
- Modifying SharedPreferences

**Production Solution: Use Server-Side Validation**

#### Option 1: Use RevenueCat (Recommended)
```dart
// Much simpler and secure
import 'package:purchases_flutter/purchases_flutter.dart';

await Purchases.configure(
  PurchasesConfiguration("YOUR_API_KEY")
);

// Check entitlement
final purchaserInfo = await Purchases.getCustomerInfo();
final isPro = purchaserInfo.entitlements.active.containsKey("pro");
```

#### Option 2: Build Your Own Backend
1. Send receipts to your server
2. Verify with Apple/Google APIs
3. Store subscription status in Supabase
4. Check status from server on app launch

## 📊 Store Requirements for Subscriptions

### Additional App Store Requirements:

1. **Clearly state subscription terms** in paywall
2. **Allow users to manage subscriptions** in settings
3. **Link to Terms of Service**
4. **Link to Privacy Policy**
5. **Show price and billing period** clearly
6. **Provide easy cancellation instructions**

### Required UI Elements:

Add to your PaywallScreen bottom:
```dart
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    TextButton(
      onPressed: () => _launchUrl('https://My-Grants.ca/terms'),
      child: Text('Terms'),
    ),
    Text(' • '),
    TextButton(
      onPressed: () => _launchUrl('https://My-Grants.ca/privacy'),
      child: Text('Privacy'),
    ),
  ],
)
```

## 💡 Monetization Best Practices

### Free Trial Strategy:
- Offer 7-day free trial with annual plan
- Increases conversion by 3-5x
- Set up in App Store Connect / Play Console

### Pricing Psychology:
- Show annual as "best value" with badge
- Display weekly as \$1.99/week vs \$49.99/year
- Highlight savings: "Save \$54/year"

### Conversion Optimization:
- Show paywall after user shows interest (views 3+ grants)
- Allow browsing before paywall (builds value)
- Use social proof if available ("Join 10,000+ users")

## 📈 Analytics to Track

1. Paywall shown events
2. Purchase initiated events
3. Purchase completed events
4. Conversion rate by plan
5. Churn rate
6. Lifetime value (LTV)

## 🧪 Testing

### Test Accounts:
- iOS: Create Sandbox tester in App Store Connect
- Android: Create test accounts in Play Console

### Test Scenarios:
- [ ] Purchase weekly subscription
- [ ] Purchase annual subscription
- [ ] Restore purchases
- [ ] Cancel subscription (test grace period)
- [ ] Expired subscription behavior
- [ ] Subscription across devices

## 🎯 Next Steps

1. Decide: RevenueCat or custom implementation?
2. Set up products in App Store Connect
3. Set up products in Play Console
4. Implement subscription service
5. Create paywall UI
6. Add checks to grant detail navigation
7. Test thoroughly with sandbox accounts
8. Update privacy policy (mention purchases)
9. Submit for review

## 📝 Estimated Implementation Time

- Backend setup (RevenueCat): 2 hours
- UI implementation: 4-6 hours
- Testing: 2-3 hours
- Store setup: 1-2 hours

**Total: ~10-15 hours**

Would you like me to implement this feature for you?
