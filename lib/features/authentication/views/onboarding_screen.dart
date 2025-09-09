import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/core/services/permission_handler_service.dart';
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
  void initState() {
 PermissionHandlerService.requestRequiredPermissions() ;
 super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // screen width & height
    final isSmallHeight = size.height < 700;
    return BaseWidget(
      screen: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min, // Take minimum vertical space
        children: [
          SizedBox(height: 40),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 10, right: 16),
              child: InkWell(
                onTap: () {
                  _controller.animateToPage(
                    onboardingData.length - 1,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AppText(
                    currentPage < onboardingData.length - 1 ? "Skip" : "",
                    color: HexColor(ColorConstants.greyShade1),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),

          // Limit height of PageView instead of Expanded
          SizedBox(
            height: size.height * 0.6, // adjust as needed
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
                    AppViewUtils.getAssetImageSVG(
                      item.imagePath,
                      height: size.height * 0.35,
                      width: size.width * 0.6,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (size.width - size.width * 0.6) / 2,
                      ),
                      child: AppText(
                        item.title,
                        fontWeight: FontWeight.w700,
                        fontSize: isSmallHeight ? 20 : 22,
                        textAlign: TextAlign.center,
                        color: HexColor(ColorConstants.blackShade1),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: (size.width - size.width * 0.6) / 2,
                      ),

                      child: AppText(
                        item.subtitle,
                        fontWeight: FontWeight.w400,
                        fontSize: isSmallHeight ? 14 : 16,
                        color: HexColor(ColorConstants.greyShade1),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              onboardingData.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 10),
                width: currentPage == index ? 50 : 15,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: currentPage == index
                      ? HexColor(ColorConstants.themeColor)
                      : HexColor(ColorConstants.greyColor),
                ),
              ),
            ),
          ),

          const SizedBox(height: 50),
          Visibility(
            visible: currentPage == onboardingData.length - 1,
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => SignUpScreen()),
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
                        MaterialPageRoute(builder: (_) => LoginScreen()),
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
