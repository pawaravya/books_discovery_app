import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/authentication/view_models/auth_notifier.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/custom_button.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen>
    with WidgetsBindingObserver {
  final List<TextEditingController> _listOfTextEditingControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> _listOfFocusNode = [
    FocusNode(), // 0 -> Email
    FocusNode(), // 1 -> Password
  ];

  final List<String> listOfErrorMessages = ["", ""]; // error per field
  bool isButtonDisabled = true;
  bool showEyeIconOff = true;
  bool agreeToTerms = false;

  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _listOfFocusNode.length; i++) {
      _listOfFocusNode[i].addListener(() {
        _validateField(i);
        if (!_listOfFocusNode[i].hasFocus) {
          listOfErrorMessages[i] = getTheErrorMessageAsPerIndex(i);
        }
      });
    }
    for (int i = 0; i < _listOfTextEditingControllers.length; i++) {
      _listOfTextEditingControllers[i].addListener(() {
        _validateField(i);
      });
    }
  }

  void _validateField(int currentIndex) {
    listOfErrorMessages[currentIndex] = "";
    String emailError = _validateEmail(_listOfTextEditingControllers[0].text);
    String passError = _validatePassword(_listOfTextEditingControllers[1].text);

    if (emailError.isEmpty && passError.isEmpty && agreeToTerms) {
      isButtonDisabled = false;
    } else {
      isButtonDisabled = true;
    }
    setState(() {});
  }

  String _validateEmail(String email) {
    if (email.isEmpty) return "Email cannot be empty";
    if (email.length > 50) return "Email cannot exceed 50 characters";
    if (!emailRegExp.hasMatch(email)) return "Please enter a valid Email.";
    return "";
  }

  String _validatePassword(String value) {
    if (value.isEmpty) return 'Password cannot be empty.';
    if (value.length < 5) return 'Password must be at least 5 characters';
    if (value.length > 25) return 'Password cannot exceed 25 characters';
    return "";
  }

  String getTheErrorMessageAsPerIndex(int i) {
    switch (i) {
      case 0:
        return _validateEmail(_listOfTextEditingControllers[i].text);
      case 1:
        return _validatePassword(_listOfTextEditingControllers[i].text);
      default:
        return "";
    }
  }

  void handleSignButton() async {
    FocusScope.of(context).unfocus();
    final email = _listOfTextEditingControllers[0].text.trim();
    final password = _listOfTextEditingControllers[1].text.trim();
    bool isSuccess = await ref
        .read(authNotifierProvider.notifier)
        .signUpWithEmailAndPassword(context, email, password);
    if (isSuccess) {
      AppViewUtils.showPopup(
        context,
        "Success",
        () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) =>
                  const MainTabScreen(), // replace with your widget
            ),
            (Route<dynamic> route) => false, // removes all previous routes
          );
        },
        isRequiredSubheading: true,
        popUpSubHeading:
            "Congratulations, you have completed your registration!",
        buttonText: "Done",
        isbarrierDismissible: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(authNotifierProvider);
    return BaseWidget(
      sidePadding: 0,
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 20, right: 20, top: 80, bottom: 10),
            color: HexColor(ColorConstants.greyShade2),
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "Sign Up",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: HexColor(ColorConstants.blackShade1),
                ),
                const SizedBox(height: 5),
                AppText(
                  "Enter your details below & free sign up",
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: HexColor(ColorConstants.greyShade3),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                CustomInputText(
                  hintText: "Enter your Email",
                  maxLength: 40,
                  focusNode: _listOfFocusNode[0],
                  isErrorBorder: listOfErrorMessages[0].isNotEmpty,
                  textEditingController: _listOfTextEditingControllers[0],
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  labelText: "Your  Email",
                  isMandatory: false,
                  errorText: listOfErrorMessages[0],
                ),
                const SizedBox(height: 18),
                CustomInputText(
                  focusNode: _listOfFocusNode[1],
                  isErrorBorder: listOfErrorMessages[1].isNotEmpty,
                  textEditingController: _listOfTextEditingControllers[1],
                  isSuffixIcon: true,
                  hintText: "Enter your password",
                  maxLength: 30,
                  labelText: "Password",
                  isSecure: showEyeIconOff,
                  errorText: listOfErrorMessages[1],
                  onSuffixIconTap: () {
                    setState(() {
                      showEyeIconOff = !showEyeIconOff;
                    });
                  },
                  isMandatory: false,
                ),
                const SizedBox(height: 24),

                // Create Account button
                CustomButton(
                  text: 'Create account',
                  isLoading: signUpState.isLoading,

                  isDisabled:  isButtonDisabled,
                  onPressed: () {
                    if (!isButtonDisabled) {
                      handleSignButton();
                    }
                  },
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // align text to top of checkbox
                  children: [
                    Checkbox(
                      activeColor: HexColor(ColorConstants.themeColor),
                      checkColor: Colors.white,
                      side: WidgetStateBorderSide.resolveWith((states) {
                        if (states.contains(WidgetState.selected)) {
                          return BorderSide(
                            color: HexColor(ColorConstants.themeColor),
                            width: 1,
                          ); // checked border
                        }
                        return BorderSide(
                          color: HexColor(ColorConstants.greyShade3),
                          width: 1,
                        ); // unchecked border
                      }),
                      value: agreeToTerms,
                      onChanged: (val) {
                        setState(() {
                          agreeToTerms = val ?? false;
                        });
                        _validateField(0);
                      },
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          "By creating an account you have to agree with our terms & conditions.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: HexColor(ColorConstants.greyShade1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 54),
                  ],
                ),
                const SizedBox(height: 25),

                // Already have an account
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: StringConstants.poppinsFontFamily,
                        fontWeight: FontWeight.w400,
                        color: HexColor(ColorConstants.greyShade1),
                      ),
                      children: [
                        TextSpan(
                          text: "Log in",
                          style: TextStyle(
                            color: HexColor(ColorConstants.themeColor),
                            fontSize: 12,
                            fontFamily: StringConstants.poppinsFontFamily,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
