import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductCard extends ConsumerWidget {
  final Product product;
  const ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isFavorite = ref.watch(isFavoriteProvider(product.id));
    final favNotifier = ref.read(favoritesProvider.notifier);

    return Card(
      child: InkWell(
        onTap: () => context.push('/product/${product.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
         
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 4 / 3,
                  child: Image.network(product.thumbnail, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 0,
                  right: 0,

                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : Colors.white,
                      shadows: isFavorite
                          ? null
                          : [
                              const Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                              ),
                            ],
                    ),
                    onPressed: () {
                      favNotifier.toggleFavorite(product.id);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isFavorite
                                ? "${product.title} removed from favorites."
                                : "${product.title} added to favorites!",
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

        
            Padding(
              padding: const EdgeInsets.fromLTRB(
                8.0,
                8.0,
                8.0,
                4.0,
              ),  
              child: Text(
                product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),

       
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$${product.price.toStringAsFixed(2)}'),
                  IconButton(
                    onPressed: () {
                      ref.read(cartProvider.notifier).addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("${product.title} added!")),
                      );
                    },
                    icon: const Icon(Icons.add_shopping_cart),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
