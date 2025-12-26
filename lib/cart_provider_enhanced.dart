// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../models/menu_models.dart';
// import '../../constants/app_constants.dart';
// import '../../utils/app_utils.dart';
//
// class CartProviderEnhanced extends ChangeNotifier {
//   List<CartItem> _items = [];
//   late SharedPreferences _prefs;
//   bool _isInitialized = false;
//
//   // Getters
//   List<CartItem> get items => _items;
//   bool get isEmpty => _items.isEmpty;
//   bool get isNotEmpty => _items.isNotEmpty;
//   int get itemCount => _items.length;
//   int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);
//
//   double get subtotal {
//     return _items.fold(0.0, (sum, item) => sum + item.total);
//   }
//
//   double get tax {
//     return AppUtils.calculateTax(subtotal);
//   }
//
//   double get total {
//     return subtotal + tax;
//   }
//
//   CartProviderEnhanced() {
//     _initialize();
//   }
//
//   /// Initialize cart provider and load saved data
//   Future<void> _initialize() async {
//     try {
//       _prefs = await SharedPreferences.getInstance();
//       await _loadCart();
//       _isInitialized = true;
//       AppLogger.log('Cart provider initialized');
//       notifyListeners();
//     } catch (e) {
//       AppLogger.error('Failed to initialize cart provider', error: e);
//     }
//   }
//
//   /// Load cart from local storage
//   Future<void> _loadCart() async {
//     try {
//       final cartJson = _prefs.getString(AppConstants.cartKey);
//       if (cartJson != null) {
//         final cartData = jsonDecode(cartJson) as List;
//         _items = cartData
//             .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
//             .toList();
//         AppLogger.log('Cart loaded: ${_items.length} items');
//       }
//     } catch (e) {
//       AppLogger.error('Failed to load cart', error: e);
//       _items = [];
//     }
//   }
//
//   /// Save cart to local storage
//   Future<void> _saveCart() async {
//     try {
//       final cartJson = jsonEncode(_items.map((item) => item.toJson()).toList());
//       await _prefs.setString(AppConstants.cartKey, cartJson);
//       AppLogger.log('Cart saved: ${_items.length} items');
//     } catch (e) {
//       AppLogger.error('Failed to save cart', error: e);
//     }
//   }
//
//   /// Add item to cart
//   void addItem(String id, String name, double price, String image) {
//     try {
//       final existingItemIndex = _items.indexWhere((item) => item.id == id);
//
//       if (existingItemIndex >= 0) {
//         // Item already exists, increase quantity
//         _items[existingItemIndex].quantity++;
//         AppLogger.log('Increased quantity for item: $name');
//       } else {
//         // Add new item
//         _items.add(CartItem(
//           id: id,
//           name: name,
//           price: price,
//           image: image,
//           quantity: 1,
//         ));
//         AppLogger.log('Added item to cart: $name');
//       }
//
//       _saveCart();
//       notifyListeners();
//     } catch (e) {
//       AppLogger.error('Failed to add item to cart', error: e);
//     }
//   }
//
//   /// Remove item from cart
//   void removeItem(String id) {
//     try {
//       _items.removeWhere((item) => item.id == id);
//       AppLogger.log('Removed item from cart: $id');
//       _saveCart();
//       notifyListeners();
//     } catch (e) {
//       AppLogger.error('Failed to remove item from cart', error: e);
//     }
//   }
//
//   /// Update item quantity
//   void updateQuantity(String id, int quantity) {
//     try {
//       if (quantity <= 0) {
//         removeItem(id);
//         return;
//       }
//
//       final itemIndex = _items.indexWhere((item) => item.id == id);
//       if (itemIndex >= 0) {
//         _items[itemIndex].quantity = quantity;
//         AppLogger.log('Updated quantity for item: $id to $quantity');
//         _saveCart();
//         notifyListeners();
//       }
//     } catch (e) {
//       AppLogger.error('Failed to update item quantity', error: e);
//     }
//   }
//
//   /// Increase item quantity
//   void increaseQuantity(String id) {
//     try {
//       final itemIndex = _items.indexWhere((item) => item.id == id);
//       if (itemIndex >= 0) {
//         _items[itemIndex].quantity++;
//         AppLogger.log('Increased quantity for item: $id');
//         _saveCart();
//         notifyListeners();
//       }
//     } catch (e) {
//       AppLogger.error('Failed to increase quantity', error: e);
//     }
//   }
//
//   /// Decrease item quantity
//   void decreaseQuantity(String id) {
//     try {
//       final itemIndex = _items.indexWhere((item) => item.id == id);
//       if (itemIndex >= 0) {
//         if (_items[itemIndex].quantity > 1) {
//           _items[itemIndex].quantity--;
//           AppLogger.log('Decreased quantity for item: $id');
//         } else {
//           removeItem(id);
//           return;
//         }
//         _saveCart();
//         notifyListeners();
//       }
//     } catch (e) {
//       AppLogger.error('Failed to decrease quantity', error: e);
//     }
//   }
//
//   /// Clear entire cart
//   void clearCart() {
//     try {
//       _items.clear();
//       AppLogger.log('Cart cleared');
//       _saveCart();
//       notifyListeners();
//     } catch (e) {
//       AppLogger.error('Failed to clear cart', error: e);
//     }
//   }
//
//   /// Get cart item by ID
//   CartItem? getCartItem(String id) {
//     try {
//       return _items.firstWhere((item) => item.id == id);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Check if item exists in cart
//   bool containsItem(String id) {
//     return _items.any((item) => item.id == id);
//   }
//
//   /// Get quantity of specific item
//   int getItemQuantity(String id) {
//     final item = getCartItem(id);
//     return item?.quantity ?? 0;
//   }
//
//   /// Apply discount code (placeholder)
//   void applyDiscountCode(String code) {
//     // This would be implemented with actual discount logic
//     AppLogger.log('Discount code applied: $code');
//     notifyListeners();
//   }
//
//   /// Get cart summary
//   Map<String, dynamic> getCartSummary() {
//     return {
//       'itemCount': itemCount,
//       'totalQuantity': totalQuantity,
//       'subtotal': subtotal,
//       'tax': tax,
//       'total': total,
//       'items': _items,
//     };
//   }
//
//   /// Convert cart to order
//   Order convertToOrder() {
//     return Order(
//       id: AppUtils.generateUniqueId(),
//       items: List.from(_items),
//       subtotal: subtotal,
//       tax: tax,
//       total: total,
//       createdAt: DateTime.now(),
//       status: 'pending',
//     );
//   }
//
//   /// Validate cart before checkout
//   bool validateCart() {
//     if (_items.isEmpty) {
//       AppLogger.warning('Cart is empty');
//       return false;
//     }
//
//     for (final item in _items) {
//       if (item.quantity <= 0) {
//         AppLogger.warning('Invalid quantity for item: ${item.id}');
//         return false;
//       }
//     }
//
//     return true;
//   }
//
//   /// Get checkout summary
//   String getCheckoutSummary() {
//     final summary = StringBuffer();
//     summary.writeln('=== ORDER SUMMARY ===');
//     summary.writeln('Items: $itemCount');
//     summary.writeln('Total Quantity: $totalQuantity');
//     summary.writeln('Subtotal: ${AppUtils.formatCurrency(subtotal)}');
//     summary.writeln('Tax (10%): ${AppUtils.formatCurrency(tax)}');
//     summary.writeln('Total: ${AppUtils.formatCurrency(total)}');
//     return summary.toString();
//   }
//
//   /// Export cart as JSON
//   String exportCartAsJson() {
//     return jsonEncode(_items.map((item) => item.toJson()).toList());
//   }
//
//   /// Import cart from JSON
//   Future<void> importCartFromJson(String jsonString) async {
//     try {
//       final cartData = jsonDecode(jsonString) as List;
//       _items = cartData
//           .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
//           .toList();
//       await _saveCart();
//       AppLogger.log('Cart imported: ${_items.length} items');
//       notifyListeners();
//     } catch (e) {
//       AppLogger.error('Failed to import cart', error: e);
//     }
//   }
//
//   /// Get most expensive item
//   CartItem? getMostExpensiveItem() {
//     if (_items.isEmpty) return null;
//     return _items.reduce((a, b) => a.price > b.price ? a : b);
//   }
//
//   /// Get cheapest item
//   CartItem? getCheapestItem() {
//     if (_items.isEmpty) return null;
//     return _items.reduce((a, b) => a.price < b.price ? a : b);
//   }
//
//   /// Get average item price
//   double getAverageItemPrice() {
//     if (_items.isEmpty) return 0.0;
//     return subtotal / itemCount;
//   }
//
//   /// Sort items by price (ascending)
//   void sortByPriceAscending() {
//     _items.sort((a, b) => a.price.compareTo(b.price));
//     notifyListeners();
//   }
//
//   /// Sort items by price (descending)
//   void sortByPriceDescending() {
//     _items.sort((a, b) => b.price.compareTo(a.price));
//     notifyListeners();
//   }
//
//   /// Sort items by name
//   void sortByName() {
//     _items.sort((a, b) => a.name.compareTo(b.name));
//     notifyListeners();
//   }
//
//   /// Sort items by quantity
//   void sortByQuantity() {
//     _items.sort((a, b) => b.quantity.compareTo(a.quantity));
//     notifyListeners();
//   }
//
//   /// Get items above price threshold
//   List<CartItem> getItemsAbovePrice(double price) {
//     return _items.where((item) => item.price > price).toList();
//   }
//
//   /// Get items below price threshold
//   List<CartItem> getItemsBelowPrice(double price) {
//     return _items.where((item) => item.price < price).toList();
//   }
//
//   /// Calculate savings (if discounts are applied)
//   double calculateSavings() {
//     // This would be implemented with actual discount logic
//     return 0.0;
//   }
//
//   /// Get estimated delivery time (placeholder)
//   String getEstimatedDeliveryTime() {
//     // This would be calculated based on restaurant and delivery settings
//     return '30-45 minutes';
//   }
//
//   /// Check if cart has changed since last save
//   bool hasChanges() {
//     // This would compare current cart with saved version
//     return true;
//   }
// }
