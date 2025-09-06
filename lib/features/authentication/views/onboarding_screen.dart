import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/features/authentication/models/onboarding_item_model.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int currentPage = 0;
  final List<OnboardingItem> onboardingData = [
    OnboardingItem(
      imagePath: ImageConstants.onBoardingImage1,
      title: "Numerous free trial courses",
      subtitle: "Free courses for you to find your way to learning",
    ),
    OnboardingItem(
      imagePath: ImageConstants.onBoardingImage2,
      title: "Quick and easy learning",
      subtitle:
          "Easy and fast learning at any time to help you improve various skills",
    ),
    OnboardingItem(
      imagePath: ImageConstants.onBoardingImage3,
      title: "Create your own study plan",
      subtitle: "Study according to the study plan, make study more motivated",
    ),
  ];
  Future<void> _finishOnboarding() async {
    AppSharedPreferences.customSharedPreferences.setOnBoardingSeen(true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (_, index) {
                  final item = onboardingData[index];
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppViewUtils.getAssetImageSVG(
                          item.imagePath,
                          height: 260,
                          width: 260,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          item.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.subtitle,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      onboardingData.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(right: 6),
                        width: currentPage == index ? 12 : 8,
                        height: currentPage == index ? 12 : 8,
                        decoration: BoxDecoration(
                          color: currentPage == index
                              ? Colors.blue
                              : Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (currentPage == onboardingData.length - 1) {
                        _finishOnboarding();
                      } else {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                    child: Text(
                      currentPage == onboardingData.length - 1
                          ? "Get Started"
                          : "Next",
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
