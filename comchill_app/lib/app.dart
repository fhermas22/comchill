import 'package:flutter/material.dart';
import 'config/routes/app_router.dart';
import 'utils/colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ComChill',
      debugShowCheckedModeBanner: false,
      
      // Configuration de GoRouter pour la navigation
      routerConfig: AppRouter.router,
      
      // Configuration du thème avec vos couleurs personnalisées
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
          surface: surfaceColor,
          error: errorColor,
        ),
        
        // Style global des textes pour correspondre à vos couleurs
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: primaryTextColor),
          bodyMedium: TextStyle(color: secondaryTextColor),
        ),
      ),
    );
  }
}
