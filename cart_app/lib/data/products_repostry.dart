// lib/data/products_repostry.dart
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class ProductsRepository {
  final String assetPath;
  ProductsRepository({this.assetPath = 'assets/products.json'});

  Future<List<Product>> loadAll() async {
    final jsonStr = await rootBundle.loadString(assetPath);

    final data = json.decode(jsonStr) as List<dynamic>;

    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
