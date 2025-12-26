// import 'package:flutter/foundation.dart';
// import 'dart:convert';
// import 'package:flutter/services.dart';
// import '../models/menu_models.dart';
// import '../utils/app_utils.dart';
//
// class MenuProviderEnhanced extends ChangeNotifier {
//   late Restaurant _restaurant;
//   List<MenuCategory> _categories = [];
//   List<MenuItem> _allItems = [];
//   List<MenuItem> _filteredItems = [];
//   bool _isLoading = true;
//   String? _error;
//   String _searchQuery = '';
//   String? _selectedCategoryId;
//   List<String> _selectedDietaryFilters = [];
//   String _sortBy = 'price_low_to_high';
//
//   // Getters
//   Restaurant get restaurant => _restaurant;
//   List<MenuCategory> get categories => _categories;
//   List<MenuItem> get items => _filteredItems.isEmpty ? _allItems : _filteredItems;
//   bool get isLoading => _isLoading;
//   String? get error => _error;
//   String get searchQuery => _searchQuery;
//   String? get selectedCategoryId => _selectedCategoryId;
//   List<String> get selectedDietaryFilters => _selectedDietaryFilters;
//   String get sortBy => _sortBy;
//
//   MenuProviderEnhanced() {
//     _loadMenuData();
//   }
//
//   /// Load menu data from JSON
//   Future<void> _loadMenuData() async {
//     try {
//       _isLoading = true;
//       _error = null;
//       notifyListeners();
//
//       final jsonString = await rootBundle.loadString('assets/data/menu.json');
//       final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
//
//       // Parse restaurant
//       _restaurant = Restaurant.fromJson(jsonData['restaurant']);
//
//       // Parse categories
//       _categories = (jsonData['categories'] as List?)
//               ?.map((cat) => MenuCategory.fromJson(cat as Map<String, dynamic>))
//               .toList() ??
//           [];
//
//       // Parse items
//       _allItems = (jsonData['items'] as List?)
//               ?.map((item) => MenuItem.fromJson(item as Map<String, dynamic>))
//               .toList() ??
//           [];
//
//       _filteredItems = List.from(_allItems);
//       _isLoading = false;
//       _applyFiltersAndSort();
//
//       AppLogger.log('Menu loaded successfully: ${_allItems.length} items');
//     } catch (e) {
//       _error = 'Failed to load menu: $e';
//       _isLoading = false;
//       AppLogger.error('Error loading menu', error: e);
//     }
//     notifyListeners();
//   }
//
//   /// Get item by ID
//   MenuItem? getItemById(String itemId) {
//     try {
//       return _allItems.firstWhere((item) => item.id == itemId);
//     } catch (e) {
//       AppLogger.warning('Item not found: $itemId');
//       return null;
//     }
//   }
//
//   /// Get items by category
//   List<MenuItem> getItemsByCategory(String categoryId) {
//     return _allItems.where((item) => item.categoryId == categoryId).toList();
//   }
//
//   /// Search items by name and description
//   void searchItems(String query) {
//     _searchQuery = query.toLowerCase();
//     _applyFiltersAndSort();
//     AppLogger.log('Search query: $_searchQuery');
//     notifyListeners();
//   }
//
//   /// Clear search
//   void clearSearch() {
//     _searchQuery = '';
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
//
//   /// Filter by category
//   void filterByCategory(String? categoryId) {
//     _selectedCategoryId = categoryId;
//     _applyFiltersAndSort();
//     AppLogger.log('Filter by category: $categoryId');
//     notifyListeners();
//   }
//
//   /// Add dietary filter
//   void addDietaryFilter(String filter) {
//     if (!_selectedDietaryFilters.contains(filter)) {
//       _selectedDietaryFilters.add(filter);
//       _applyFiltersAndSort();
//       AppLogger.log('Added dietary filter: $filter');
//       notifyListeners();
//     }
//   }
//
//   /// Remove dietary filter
//   void removeDietaryFilter(String filter) {
//     if (_selectedDietaryFilters.contains(filter)) {
//       _selectedDietaryFilters.remove(filter);
//       _applyFiltersAndSort();
//       AppLogger.log('Removed dietary filter: $filter');
//       notifyListeners();
//     }
//   }
//
//   /// Clear all dietary filters
//   void clearDietaryFilters() {
//     _selectedDietaryFilters.clear();
//     _applyFiltersAndSort();
//     notifyListeners();
//   }
//
//   /// Sort items
//   void sortItems(String sortOption) {
//     _sortBy = sortOption;
//     _applyFiltersAndSort();
//     AppLogger.log('Sorted by: $sortOption');
//     notifyListeners();
//   }
//
//   /// Apply all filters and sorting
//   void _applyFiltersAndSort() {
//     _filteredItems = List.from(_allItems);
//
//     // Apply search filter
//     if (_searchQuery.isNotEmpty) {
//       _filteredItems = _filteredItems
//           .where((item) =>
//               item.name.toLowerCase().contains(_searchQuery) ||
//               item.description.toLowerCase().contains(_searchQuery) ||
//               item.ingredients
//                   .any((ing) => ing.toLowerCase().contains(_searchQuery)))
//           .toList();
//     }
//
//     // Apply category filter
//     if (_selectedCategoryId != null) {
//       _filteredItems = _filteredItems
//           .where((item) => item.categoryId == _selectedCategoryId)
//           .toList();
//     }
//
//     // Apply dietary filters
//     if (_selectedDietaryFilters.isNotEmpty) {
//       _filteredItems = _filteredItems
//           .where((item) => _selectedDietaryFilters
//               .every((filter) => item.matchesDietaryRestriction(filter)))
//           .toList();
//     }
//
//     // Apply sorting
//     _applySorting();
//   }
//
//   /// Apply sorting to filtered items
//   void _applySorting() {
//     switch (_sortBy) {
//       case 'price_low_to_high':
//         _filteredItems.sort((a, b) => a.price.compareTo(b.price));
//         break;
//       case 'price_high_to_low':
//         _filteredItems.sort((a, b) => b.price.compareTo(a.price));
//         break;
//       case 'rating':
//         _filteredItems.sort((a, b) => b.rating.compareTo(a.rating));
//         break;
//       case 'newest':
//         // Assuming items are added in order, reverse the list
//         _filteredItems = _filteredItems.reversed.toList();
//         break;
//       case 'most_popular':
//         _filteredItems.sort((a, b) => b.reviews.compareTo(a.reviews));
//         break;
//       default:
//         break;
//     }
//   }
//
//   /// Get featured items
//   List<MenuItem> getFeaturedItems() {
//     return _allItems.where((item) => item.featured).toList();
//   }
//
//   /// Get items on sale (if implemented)
//   List<MenuItem> getOnSaleItems() {
//     // This would be implemented if sale prices are added to the model
//     return [];
//   }
//
//   /// Get recommended items based on category
//   List<MenuItem> getRecommendedItems(String categoryId, {int limit = 5}) {
//     return getItemsByCategory(categoryId).take(limit).toList();
//   }
//
//   /// Get vegetarian items
//   List<MenuItem> getVegetarianItems() {
//     return _allItems.where((item) => item.vegetarian).toList();
//   }
//
//   /// Get vegan items
//   List<MenuItem> getVeganItems() {
//     return _allItems.where((item) => item.vegan).toList();
//   }
//
//   /// Get gluten-free items
//   List<MenuItem> getGlutenFreeItems() {
//     return _allItems.where((item) => item.glutenFree).toList();
//   }
//
//   /// Get items by spicy level
//   List<MenuItem> getItemsBySpicyLevel(String spicyLevel) {
//     return _allItems
//         .where((item) => item.spicyLevel?.toLowerCase() == spicyLevel)
//         .toList();
//   }
//
//   /// Get items under calorie limit
//   List<MenuItem> getItemsUnderCalories(int calorieLimit) {
//     return _allItems
//         .where((item) => item.calories != null && item.calories! < calorieLimit)
//         .toList();
//   }
//
//   /// Get items with quick prep time
//   List<MenuItem> getQuickPrepItems({int maxMinutes = 15}) {
//     return _allItems.where((item) {
//       if (item.prepTime == null) return false;
//       try {
//         final minutes = int.parse(item.prepTime!.split(' ')[0]);
//         return minutes <= maxMinutes;
//       } catch (e) {
//         return false;
//       }
//     }).toList();
//   }
//
//   /// Get items with high rating
//   List<MenuItem> getHighRatedItems({double minRating = 4.5}) {
//     return _allItems.where((item) => item.rating >= minRating).toList();
//   }
//
//   /// Get items with AR models available
//   List<MenuItem> getItemsWithARModels() {
//     return _allItems.where((item) => item.model != null).toList();
//   }
//
//   /// Get category by ID
//   MenuCategory? getCategoryById(String categoryId) {
//     try {
//       return _categories.firstWhere((cat) => cat.id == categoryId);
//     } catch (e) {
//       return null;
//     }
//   }
//
//   /// Get total number of items
//   int getTotalItemCount() {
//     return _allItems.length;
//   }
//
//   /// Get average rating
//   double getAverageRating() {
//     if (_allItems.isEmpty) return 0.0;
//     final totalRating =
//         _allItems.fold<double>(0.0, (sum, item) => sum + item.rating);
//     return totalRating / _allItems.length;
//   }
//
//   /// Get price range
//   Map<String, double> getPriceRange() {
//     if (_allItems.isEmpty) {
//       return {'min': 0.0, 'max': 0.0};
//     }
//     final prices = _allItems.map((item) => item.price).toList();
//     return {
//       'min': prices.reduce((a, b) => a < b ? a : b),
//       'max': prices.reduce((a, b) => a > b ? a : b),
//     };
//   }
//
//   /// Refresh menu data
//   Future<void> refreshMenu() async {
//     await _loadMenuData();
//   }
//
//   /// Reset all filters
//   void resetAllFilters() {
//     _searchQuery = '';
//     _selectedCategoryId = null;
//     _selectedDietaryFilters.clear();
//     _sortBy = 'price_low_to_high';
//     _filteredItems = List.from(_allItems);
//     AppLogger.log('All filters reset');
//     notifyListeners();
//   }
//
//   /// Get filter summary
//   String getFilterSummary() {
//     final filters = <String>[];
//
//     if (_searchQuery.isNotEmpty) {
//       filters.add('Search: "$_searchQuery"');
//     }
//
//     if (_selectedCategoryId != null) {
//       final category = getCategoryById(_selectedCategoryId!);
//       if (category != null) {
//         filters.add('Category: ${category.name}');
//       }
//     }
//
//     if (_selectedDietaryFilters.isNotEmpty) {
//       filters.add('Dietary: ${_selectedDietaryFilters.join(", ")}');
//     }
//
//     if (_sortBy != 'price_low_to_high') {
//       filters.add('Sort: $_sortBy');
//     }
//
//     return filters.isEmpty ? 'No filters applied' : filters.join(' | ');
//   }
// }
