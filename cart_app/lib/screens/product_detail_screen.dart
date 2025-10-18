import 'package:cart_app/models/product.dart';
import 'package:cart_app/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

 
final _qtyProvider = StateProvider.family.autoDispose<int, int>((
  ref,
  productId,
) {
  
  final currentCartItem = ref.watch(cartProvider).items[productId];
  return currentCartItem?.qty ?? 1;  
});

class ProductDetailScreen extends ConsumerWidget {
  final Product product;

 
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final quantity = ref.watch(_qtyProvider(product.id));
    final quantityNotifier = ref.read(_qtyProvider(product.id).notifier);

    final maxStock = product.stock;
    final isMaxStock = quantity >= maxStock;

    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.network(
                product.thumbnail,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),

            Text(
              product.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

         
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                ),
               
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      product.rating.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),
 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Stock: ${product.stock}",
                  style: TextStyle(
                    fontSize: 16,
                    color: maxStock > 0 ? Colors.black54 : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                  
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: quantity > 1
                          ? () => quantityNotifier.state--
                          : null,  
                    ),
                    Text(
                      "$quantity",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  
                    IconButton(
                      icon: const Icon(Icons.add),
                  
                      onPressed: isMaxStock
                          ? null
                          : () => quantityNotifier.state++,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 15),
            const Divider(),
            const SizedBox(height: 15),

           
            Text(
              product.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),

            const SizedBox(height: 50),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: maxStock > 0 ? Colors.blue : Colors.grey,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
             
                onPressed: maxStock == 0
                    ? null
                    : () {
                      
                        ref
                            .read(cartProvider.notifier)
                            .addToCart(product, qty: quantity);

                       
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "$quantity x ${product.title} added to cart!",
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                child: Text(
                  maxStock == 0 ? "Out of Stock" : "Add to Cart",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
