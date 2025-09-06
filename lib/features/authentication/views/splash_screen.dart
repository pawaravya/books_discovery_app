import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/core/navigation/app_routes.dart';

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

    if (!isOnboardingSeen) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    } else if (authToken != null && authToken.isNotEmpty) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainTabs);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }

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
