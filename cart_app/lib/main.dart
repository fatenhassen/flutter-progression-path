import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router.dart';
import 'providers/theme_provider.dart';
import 'config/app_colors.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    final fixedPrimaryButtonStyle = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final fixedTextButtonStyle = TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: primaryBlue),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Cart App',
      routerConfig: router,

      theme: ThemeData(
        primarySwatch: primaryBlue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: primaryBlue,
          accentColor: accentRed,
          brightness: Brightness.light,
        ).copyWith(secondary: accentRed),

        elevatedButtonTheme: fixedPrimaryButtonStyle,
        textButtonTheme: fixedTextButtonStyle,

        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: primaryBlue,
        ),

        useMaterial3: true,
      ),

      darkTheme: ThemeData(
        primarySwatch: primaryBlue,
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: primaryBlue,
              accentColor: accentRed,
              brightness: Brightness.dark,
            ).copyWith(
              secondary: accentRed,
              background: darkScaffoldColor,
              surface: const Color(0xFF1E1E1E),
            ), // Surface for Cards

        scaffoldBackgroundColor: darkScaffoldColor,

        cardColor: const Color(0xFF1E1E1E),

        elevatedButtonTheme: fixedPrimaryButtonStyle,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: Colors.white),
        ),

        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
          backgroundColor: darkScaffoldColor,
        ),

        useMaterial3: true,
      ),

      themeMode: themeMode,
    );
  }
}
