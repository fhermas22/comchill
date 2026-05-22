import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Importations de tous les écrans de votre projet
import 'package:comchill_app/screens/splash/splash_screen.dart';
import 'package:comchill_app/screens/onboarding/onboarding_screen.dart';
import 'package:comchill_app/screens/auth/register_screen.dart';
import 'package:comchill_app/screens/auth/register_with_password_screen.dart';
import 'package:comchill_app/screens/auth/register_additional_screen.dart';
import 'package:comchill_app/screens/auth/login_screen.dart';
import 'package:comchill_app/screens/auth/login_with_password_screen.dart';
import 'package:comchill_app/screens/home/home_screen.dart';
import 'package:comchill_app/screens/home/chats/archive_screen.dart';
import 'package:comchill_app/screens/home/chats/message_screen.dart';
import 'package:comchill_app/screens/home/settings/setting_screen.dart';
import 'package:comchill_app/screens/home/settings/edit_profil_screen.dart';
import 'package:comchill_app/screens/home/settings/about_screen.dart';
import 'package:comchill_app/screens/home/settings/team_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      // 1. Cycle d'introduction
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),

      // 2. Cycle d'inscription
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/register-with',
        builder: (context, state) => const RegisterWithScreen(),
      ),
      GoRoute(
        path: '/setup-profile',
        builder: (context, state) => const SetupProfileScreen(),
      ),

      // 3. Cycle de connexion
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/login-with',
        builder: (context, state) => const LoginWithScreen(),
      ),

      // 4. Écran Principal (Contient DiscussionTabScreen, ContactsTabScreen, IaTabScreen via son BottomNavigationBar)
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
        routes: [
          // Écran de discussion avec une personne (Sous-route de Home)
          GoRoute(
            path: 'chat',
            builder: (context, state) => const ChatScreen(),
          ),
          // Archives de discussion
          GoRoute(
            path: 'archived-chats',
            builder: (context, state) => const ArchivedChatsScreen(),
          ),
          // Paramètres et sous-pages
          GoRoute(
            path: 'settings',
            builder: (context, state) => const SettingsScreen(),
            routes: [
              GoRoute(
                path: 'edit-profile',
                builder: (context, state) => const EditProfileScreen(),
              ),
              GoRoute(
                path: 'about',
                builder: (context, state) => const AboutScreen(),
              ),
              GoRoute(
                path: 'team',
                builder: (context, state) => const TeamScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
