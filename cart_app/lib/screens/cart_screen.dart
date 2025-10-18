import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/cart_provider.dart';
import '../widgets/payment_success_bottom_sheet.dart';
import '../widgets/empty_state_widget.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  static void _showPaymentSuccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => const PaymentSuccessBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final primaryColor = Theme.of(context).primaryColor;

    final statefulShell = context
        .findAncestorWidgetOfExactType<StatefulNavigationShell>();

    const double deliveryCharge = 10.0;
    final totalWithDelivery = cart.total() + deliveryCharge;
    final totalItemsCount = cart.items.values.fold(
      0,
      (sum, item) => sum + item.qty,
    );

    if (cart.items.isEmpty) {
      return Scaffold(
        body: SafeArea(
          child: EmptyStateWidget(
            title: "Cart is empty",
            subtitle: "Please add your favorite items in cart",
            buttonText: "Add Items",
            imagePath: 'assets/download4.png',
            onAddItems: () {
              if (statefulShell != null) {
                statefulShell.goBranch(0);
              } else {
                context.go('/');
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                
                TextButton(
                  onPressed: () {
                    if (statefulShell != null) {
                      statefulShell.goBranch(0);
                    } else {
                      context.go('/');
                    }
                  },
                  child: Text(
                    "Add more",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

             
                TextButton(
                  onPressed: () {
                    cartNotifier.clearCart();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cart cleared!")),
                    );
                  },
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

           
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items.values.toList()[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: _buildCartItemCard(context, item, cartNotifier),
                );
              },
            ),

            const SizedBox(height: 24),

           
            SummaryRow(
              label: "Items :",
              value: totalItemsCount.toDouble(),
              isCurrency: false,
            ),
            SummaryRow(
              label: "Delivery charge :",
              value: deliveryCharge,
              isCurrency: true,
            ),
            SummaryRow(
              label: "Sub Total :",
              value: cart.total(),
              isCurrency: true,
            ),

            const SizedBox(height: 16),

            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${totalWithDelivery.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

          
            const PaymentMethodCard(),

            const SizedBox(height: 16),

        
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPaymentSuccess(context);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  "Proceed To Checkout",
                  style: TextStyle(fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemCard(
    BuildContext context,
    dynamic item,
    dynamic cartNotifier,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    final lightPrimaryBackground = primaryColor.withOpacity(0.1);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.product.thumbnail,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    "\$${item.product.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "M",
                    style: TextStyle(color: Colors.pink, fontSize: 12),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: lightPrimaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.remove, size: 20, color: primaryColor),
                    onPressed: () {
                      if (item.qty > 1) {
                        cartNotifier.updateQty(item.product.id, item.qty - 1);
                      } else {
                        cartNotifier.removeFromCart(item.product.id);
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "${item.qty}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: lightPrimaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.add, size: 20, color: primaryColor),
                    onPressed: () {
                      cartNotifier.updateQty(item.product.id, item.qty + 1);
                    },
                  ),
                ),

              
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.delete, size: 24, color: Colors.red),
                  onPressed: () {
                    cartNotifier.removeFromCart(item.product.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${item.product.title} removed.")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

 
class PaymentMethodCard extends StatelessWidget {
  const PaymentMethodCard({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.payment, color: primaryColor),
              const SizedBox(width: 10),
              const Text(
                "Paypal **** **** 6714",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Icon(Icons.edit, color: primaryColor, size: 20),
        ],
      ),
    );
  }
}

class SummaryRow extends StatelessWidget {
  final String label;
  final double value;
  final bool isCurrency;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    required this.isCurrency,
  });

  @override
  Widget build(BuildContext context) {
    String displayValue = isCurrency
        ? "\$${value.toStringAsFixed(2)}"
        : value.toStringAsFixed(0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
          Text(displayValue, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
