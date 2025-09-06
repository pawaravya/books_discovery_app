import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/features/authentication/models/onboarding_item_model.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/features/authentication/views/sign_up_screen.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // screen width & height
    final isSmallHeight = size.height < 700;

    return BaseWidget(
      screen: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: InkWell(
                onTap: () {
                  _controller.animateToPage(
                    onboardingData.length - 1, // last page index
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: AppText("Skip"),
              ),
            ),
          ),

          /// Onboarding Content
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: onboardingData.length,
              onPageChanged: (index) {
                setState(() => currentPage = index);
                if (index == onboardingData.length - 1) {
                  AppSharedPreferences.customSharedPreferences
                      .setOnBoardingSeen(true);
                }
              },
              itemBuilder: (_, index) {
                final item = onboardingData[index];
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    /// Responsive image size
                    AppViewUtils.getAssetImageSVG(
                      item.imagePath,
                      height: size.height * 0.28, // 28% of screen height
                      width: size.width * 0.6, // 60% of screen width
                    ),
                    const SizedBox(height: 24),
                    AppText(
                      item.title,
                      fontWeight: FontWeight.w700,
                      fontSize: isSmallHeight ? 20 : 22,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    AppText(
                      item.subtitle,
                      fontWeight: FontWeight.w400,
                      fontSize: isSmallHeight ? 14 : 16,
                      color: HexColor(ColorConstants.greyShade1),
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                width: currentPage == index ? 50 : 10,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: currentPage == index
                      ? HexColor(ColorConstants.themeColor)
                      : HexColor(ColorConstants.greyColor),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),
          Visibility(
            visible: currentPage == onboardingData.length - 1,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                    text: "Sign up",
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                    text: "Login",
                    isSecondaryButton: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
