import 'package:cart_app/providers/cart_provider.dart';
import 'package:cart_app/providers/theme_provider.dart';
import 'package:cart_app/screens/cart_screen.dart';
import 'package:cart_app/screens/catalog_screen.dart';
import 'package:cart_app/screens/favorites_screen.dart';
import 'package:cart_app/screens/product_detail_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

 
class ScaffoldWithNavBar extends ConsumerWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

 
  Widget _buildNavIcon(
    BuildContext context,
    int index,
    IconData iconData,
    int currentIndex,
    Color activeColor,
  ) {
    final bool isSelected = index == currentIndex;
    
    const Color unselectedIconColor = Color(0xFF6C6C6C);

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
       
        color: isSelected ? activeColor : Colors.transparent,
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        size: 30,
       
        color: isSelected ? Colors.white : Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeNotifier = ref.read(themeProvider.notifier);
    final isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    final cartItemsCount = ref.watch(cartProvider).items.length;

    final primaryColor = Theme.of(context).primaryColor;
    final currentIndex = navigationShell.currentIndex;
 
    final List<Widget> items = [
      
      _buildNavIcon(context, 0, Icons.home, currentIndex, primaryColor),

     
      _buildNavIcon(
        context,
        1,
        Icons.favorite,
        currentIndex,
        primaryColor,
      ),  
     
      Stack(
        alignment: Alignment.center,
        children: [
         
          _buildNavIcon(
            context,
            2,
            Icons.shopping_cart,
            currentIndex,
            primaryColor,
          ),

          if (cartItemsCount > 0)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,  
                ),
                child: Text(
                  cartItemsCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
        ],
      ),
    ];

 
    final String title = navigationShell.currentIndex == 0
        ? 'Catalog'
        : navigationShell.currentIndex == 1
        ? 'Favorites'
        : 'My Cart';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeNotifier.toggleTheme,
          ),
          const SizedBox(width: 8),
        ],
      ),

      body: navigationShell,

    
      bottomNavigationBar: CurvedNavigationBar(
        index: navigationShell.currentIndex,
        height: 60.0,
        items: items,

         
        color: Theme.of(context).primaryColor,

        
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,

        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}

 
final GoRouter router = GoRouter(
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      
      branches: [
        
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              name: 'catalog',
              builder: (context, state) => const CatalogScreen(),
              routes: [
                GoRoute(
                  path: 'product/:productId',
                  builder: (context, state) {
                    final productId = state.pathParameters['productId']!;
                    return ProductDetailScreenWrapper(productId: productId);
                  },
                ),
              ],
            ),
          ],
        ),
        
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              name: 'cart',
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
