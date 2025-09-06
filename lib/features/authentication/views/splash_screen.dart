import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/features/authentication/views/onboarding_screen.dart';
import 'package:books_discovery_app/features/authentication/views/sign_up_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  double _scale = 0.5;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    navigateScreenBasedOnCondition();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      _opacity = 1.0;
      _scale = 1.0;
    });
  }

  Future<void> navigateScreenBasedOnCondition() async {
    await Future.delayed(const Duration(seconds: 3));

    final bool isOnboardingSeen = AppSharedPreferences.customSharedPreferences
        .isOnBoardingSeen();
    final String? authToken = AppSharedPreferences.customSharedPreferences
        .getAuthToken();

    Widget nextScreen;

    if (!isOnboardingSeen) {
      nextScreen = const OnboardingScreen();
    } else if (authToken != null && authToken.isNotEmpty) {
      nextScreen = const MainTabScreen();
    } else {
      nextScreen = const LoginScreen();
    }

    if (!mounted) return;

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => nextScreen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: const Duration(seconds: 2),
          opacity: _opacity,
          child: AnimatedScale(
            scale: _scale,
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOutBack,
            child: AppText(
              StringConstants.appName,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
