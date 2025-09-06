import 'package:books_discovery_app/core/navigation/app_routes.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/features/authentication/views/onboarding_screen.dart';
import 'package:books_discovery_app/features/authentication/views/sign_up_screen.dart';
import 'package:books_discovery_app/features/authentication/views/splash_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AppSharedPreferences.customSharedPreferences.initPrefs();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        // Handle top-level routes
        switch (settings.name) {
          case AppRoutes.splash:
            return MaterialPageRoute(builder: (_) => SplashScreen());
          case AppRoutes.onboarding:
            return MaterialPageRoute(builder: (_) => OnboardingScreen());
          case AppRoutes.login:
            return MaterialPageRoute(builder: (_) => LoginScreen());
          case AppRoutes.signup:
            return MaterialPageRoute(builder: (_) => SignUpScreen());
          case AppRoutes.mainTabs:
            // This leads to the tabbed interface
            return MaterialPageRoute(builder: (_) => MainTabScreen());

          default:
            return MaterialPageRoute(builder: (_) => SplashScreen());
        }
      },
    );
  }
}
