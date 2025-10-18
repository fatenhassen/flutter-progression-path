 

import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import 'products_provider.dart';

class CartItem {
  final Product product;
  final int qty;

  CartItem({required this.product, required this.qty});

   
  Map<String, dynamic> toJson() => {'id': product.id.toString(), 'qty': qty};
}

class CartState {
 
  final Map<int, CartItem> items;
  CartState(this.items);

  double subtotal() =>
      items.values.fold(0.0, (p, e) => p + e.product.price * e.qty);

  double tax() => subtotal() * 0.14;

  double total() => subtotal() + tax();

  Map<String, dynamic> toJson() => {
 
    'items': items.map(
      (k, v) =>
          MapEntry(v.product.id.toString(), {'id': v.product.id, 'qty': v.qty}),
    ),
  };

  factory CartState.fromJson(List<dynamic> arr, List<Product> products) {
   
    final map = <int, CartItem>{};
    for (final e in arr) {
    
      final id = int.tryParse(e['id'].toString()) ?? 0;
      final qty = (e['qty'] as num).toInt();

     
      final product = products.firstWhere((p) => p.id == id);
      map[id] = CartItem(product: product, qty: qty);
    }
    return CartState(map);
  }
}

class CartNotifier extends StateNotifier<CartState> {
  static const _prefsKey = 'cart_items_v1';
  final Ref ref;

  CartNotifier(this.ref) : super(CartState({})) {
    _restore();
  }

  Future<void> _restore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final str = prefs.getString(_prefsKey);
      if (str == null) return;

      final data = json.decode(str) as List<dynamic>;
      final products = await ref.read(productsProvider.future);
      state = CartState.fromJson(data, products);
    } catch (e) {
      // ignore restore errors
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = state.items.values
       
        .map(
          (cartItem) => {
            'id': cartItem.product.id.toString(),
            'qty': cartItem.qty,
          },
        )
        .toList();
    await prefs.setString(_prefsKey, json.encode(jsonList));
  }

  void addToCart(Product product, {int qty = 1}) {
    final current = state.items[product.id];
    final newQty = (current?.qty ?? 0) + qty;
    final cappedQty = newQty.clamp(1, product.stock);

    
    final newMap = Map<int, CartItem>.from(state.items);
    newMap[product.id] = CartItem(product: product, qty: cappedQty);

    state = CartState(newMap);
    _save();
  }

  void updateQty(int id, int newQty) {
    final item = state.items[id];
    if (item == null) return;
    final capped = newQty.clamp(1, item.product.stock);

   
    final newMap = Map<int, CartItem>.from(state.items);
    newMap[id] = CartItem(product: item.product, qty: capped);
    state = CartState(newMap);
    _save();
  }

  void removeFromCart(int id) {
    if (!state.items.containsKey(id)) return;
    
    final newMap = Map<int, CartItem>.from(state.items);
    newMap.remove(id);
    state = CartState(newMap);
    _save();
  }

  void clearCart() {
    state = CartState({});
    _save();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (ref) => CartNotifier(ref),
);
