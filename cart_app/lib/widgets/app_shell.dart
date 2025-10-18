import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart'; 
import '../screens/catalog_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/favorites_screen.dart';

class AppShell extends ConsumerStatefulWidget {
  const AppShell({super.key});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  int _currentIndex = 0;  

  
  final List<Widget> _screens = [
    const CatalogScreen(),
    const FavoritesScreen(),
    const CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
   
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      
      body: _screens[_currentIndex], 

      
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
         
          if (index < _screens.length) {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        type: BottomNavigationBarType.fixed,  
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.grey,
        items: [
        
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
       
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
       
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
         
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
              
                themeNotifier.toggleTheme();
              },
            ),
            label: isDarkMode ? 'Light' : 'Dark',
          ),
        ],
      ),
    );
  }
}