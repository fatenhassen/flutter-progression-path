import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';
import 'product_detail_screen.dart';

class ProductDetailScreenWrapper extends ConsumerWidget {
  final String productId;
  const ProductDetailScreenWrapper({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
   
    final productsAsync = ref.watch(productsProvider);

    return productsAsync.when(
     
      data: (products) {
      
        final int idToFind = int.tryParse(productId) ?? -1;

       
        final product = products.where((p) => p.id == idToFind).firstOrNull;

        if (product == null) {
        
          return Scaffold(
            appBar: AppBar(title: const Text('Product Not Found')),
            body: const Center(child: Text('عفواً، هذا المنتج غير متوفر.')),
          );
        }

   
        return ProductDetailScreen(product: product);
      },

  
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Catalog')),
        body: const Center(child: CircularProgressIndicator()),
      ),

   
      error: (e, st) => Scaffold(
        appBar: AppBar(title: const Text('Error')),
        body: Center(child: Text('فشل تحميل بيانات المنتج: $e')),
      ),
    );
  }
}
