import 'package:cart_app/data/products_repostry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import 'filters_provider.dart';  

final productsRepositoryProvider = Provider((ref) => ProductsRepository());

 
final allProductsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.read(productsRepositoryProvider);
  return repo.loadAll();
});

 
final productsProvider = FutureProvider<List<Product>>((ref) async {
 
  final filters = ref.watch(filtersProvider);
  
 
  final allProducts = await ref.watch(allProductsProvider.future);
  
  
  return allProducts.where((product) {
 
    final categoryMatch = filters.category == null || 
                          product.category == filters.category;

    
    final queryMatch = filters.query.isEmpty ||
                       product.title.toLowerCase().contains(filters.query.toLowerCase());

    return categoryMatch && queryMatch;
  }).toList();
});

 
final availableCategoriesProvider = FutureProvider<List<String>>((ref) async {
  final allProducts = await ref.watch(allProductsProvider.future);
  
  return allProducts.map((p) => p.category).toSet().toList();
});