import 'package:flutter_riverpod/flutter_riverpod.dart';

class Filters {
  final String? category;  
  final String query;

  Filters({this.category, this.query = ''});

  
  Filters copyWith({String? category, String? query}) => Filters(
    category:
        category, 
    query: query ?? this.query,
  );
}

final filtersProvider = StateNotifierProvider<FiltersNotifier, Filters>((ref) {
  return FiltersNotifier();
});

class FiltersNotifier extends StateNotifier<Filters> {
  FiltersNotifier() : super(Filters());

  
  void setCategory(String? newCategory) {
    state = state.copyWith(category: newCategory);
  }

  void setQuery(String newQuery) {
    state = state.copyWith(query: newQuery);
  }
}
