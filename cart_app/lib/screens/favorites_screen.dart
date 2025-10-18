import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/favorites_provider.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/product_card.dart';
import '../providers/products_provider.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(allProductsProvider);

    return productsAsync.when(
     
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error loading products: $e")),
      data: (allProducts) {
        final favoriteProducts = allProducts
            .where((p) => favoriteIds.contains(p.id))
            .toList();

        if (favoriteProducts.isEmpty) {
        
          return EmptyStateWidget(
           
            title: "No items in favorites",
            subtitle: "Explore more and shortlist some items",
            buttonText: "Add Items",
            imagePath: 'assets/download2.png',
            onAddItems: () {
              final statefulShell = context
                  .findAncestorWidgetOfExactType<StatefulNavigationShell>();
              if (statefulShell != null) {
                statefulShell.goBranch(0);  
              } else {
                context.go('/');
              }
            },
          );
        }

 
        return GridView.builder(
        
          padding: const EdgeInsets.all(12),
          itemCount: favoriteProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: favoriteProducts[index]);
          },
        );
      },
 
    );
  }
}

 
class FavoritesScreenWithScaffold extends ConsumerWidget {
  const FavoritesScreenWithScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
     
      body: FavoritesScreenContent(ref: ref),
    );
  }
}

class FavoritesScreenContent extends ConsumerWidget {
  const FavoritesScreenContent({super.key, required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favoriteIds = ref.watch(favoritesProvider);
    final productsAsync = ref.watch(allProductsProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Center(child: Text("Error loading products: $e")),
      data: (allProducts) {
        final favoriteProducts = allProducts
            .where((p) => favoriteIds.contains(p.id))
            .toList();

        if (favoriteProducts.isEmpty) {
          return EmptyStateWidget(
            title: "No items in favorites",
            subtitle: "Explore more and shortlist some items",
            buttonText: "Add Items",
            imagePath: 'assets/download5.png',
            onAddItems: () {
              final statefulShell = context
                  .findAncestorWidgetOfExactType<StatefulNavigationShell>();
              if (statefulShell != null) {
                statefulShell.goBranch(0);
              } else {
                context.go('/');
              }
            },
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: favoriteProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            return ProductCard(product: favoriteProducts[index]);
          },
        );
      },
    );
  }
}
