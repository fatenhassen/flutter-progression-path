import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

import '../providers/filters_provider.dart';
import '../widgets/product_card.dart';
 

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  void _onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(filtersProvider.notifier).setQuery(value.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);
    final categoriesAsync = ref.watch(availableCategoriesProvider);
    final currentCategory = ref.watch(filtersProvider).category;
    final filtersNotifier = ref.read(filtersProvider.notifier);

    return Scaffold(
     
      body: SafeArea(
        
        child: Column(
          children: [
          
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: "Search products...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
 
            categoriesAsync.when(
              data: (categories) => CategoryFilterBar(
                categories: categories,
                currentCategory: currentCategory,
                onCategorySelected: filtersNotifier.setCategory,
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Center(child: LinearProgressIndicator()),
              ),
              error: (error, stack) => const SizedBox.shrink(),
            ),

     
            Expanded(
              child: productsAsync.when(
                data: (products) {
                  if (products.isEmpty) {
                    return const Center(child: Text("No products found"));
                  }
                  return RefreshIndicator(
                    onRefresh: () => ref.refresh(allProductsProvider.future),
                    child: GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: products.length,
                      physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.72,
                          ),
                      itemBuilder: (context, index) {
                        return ProductCard(product: products[index]);
                      },
                    ),
                  );
                },
                error: (error, stack) => Center(child: Text('Error: $error')),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 
class CategoryFilterBar extends StatelessWidget {
  final List<String> categories;
  final String? currentCategory;
  final ValueChanged<String?> onCategorySelected;
 

  const CategoryFilterBar({
    super.key,
    required this.categories,
    required this.currentCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final allCategories = ['all', ...categories];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: allCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemBuilder: (context, index) {
          final category = allCategories[index];
          final isSelected = category == 'all'
              ? currentCategory == null
              : category == currentCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ChoiceChip(
              label: Text(
                category.toUpperCase(),
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              selected: isSelected,
              selectedColor: Theme.of(context).primaryColor,
              backgroundColor: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade200,
              onSelected: (selected) {
                if (category == 'all') {
                  onCategorySelected(null);
                } else {
                  final categoryToPass = category == currentCategory
                      ? null
                      : category;
                  onCategorySelected(categoryToPass);
                }
              },
            ),
          );
        },
      ),
    );
  }
}
