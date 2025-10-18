import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

 
class FavoritesNotifier extends StateNotifier<Set<int>> {
  static const _prefsKey = 'favorites_ids_v1';

  FavoritesNotifier() : super({});

 
  Future<void> _restore() async {
    final prefs = await SharedPreferences.getInstance();
    final str = prefs.getString(_prefsKey);
    if (str != null) {
      final List<dynamic> data = json.decode(str);
    
      final favoriteIds = data.map((e) => int.tryParse(e.toString()) ?? 0).where((id) => id > 0).toSet();
      state = favoriteIds;
    }
  }

 
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
  
    final jsonList = state.map((id) => id.toString()).toList(); 
    await prefs.setString(_prefsKey, json.encode(jsonList));
  }

 
  void toggleFavorite(int productId) {
    
    final newState = Set<int>.from(state);

    if (newState.contains(productId)) {
      newState.remove(productId);
    } else {
      newState.add(productId);
    }

    state = newState;
    _save();
  }
}

 
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<int>>((ref) {
  final notifier = FavoritesNotifier();
  notifier._restore();  
  return notifier;
});

 
final isFavoriteProvider = Provider.family<bool, int>((ref, productId) {
  final favorites = ref.watch(favoritesProvider);
  return favorites.contains(productId);
});