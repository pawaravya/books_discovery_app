import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/core/services/permission_handler_service.dart';
import 'package:books_discovery_app/features/authentication/view_models/auth_notifier.dart';
import 'package:books_discovery_app/features/authentication/views/sign_up_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
import 'package:books_discovery_app/shared/widgets/app_loade.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/custom_button.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hexcolor/hexcolor.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with WidgetsBindingObserver {
  final List<TextEditingController> _listOfTextEditingControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  final List<FocusNode> _listOfFocusNode = [
    FocusNode(), // 0 -> Email
    FocusNode(), // 1 -> Password
  ];

  // Error messages for each field
  final List<String> listOfErrorMessages = ["", ""];

  bool isButtonDisabled = true;
  bool showEyeIconOff = true;

  // Basic email pattern
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void initState() {
    super.initState();
 PermissionHandlerService.requestRequiredPermissions() ;

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
    showErrorMesagesIfPreviousForPreviosFiled(currentIndex);
    String validationMessage = "";

    if (_validateEmail(_listOfTextEditingControllers[0].text) == "" &&
        _validatePassword(_listOfTextEditingControllers[1].text) == "") {
      isButtonDisabled = false;
    } else {
      isButtonDisabled = true;
    }
    setState(() {});
  }

  void showErrorMesagesIfPreviousForPreviosFiled(int currentIndex) {
    for (int i = currentIndex - 1; i >= 0; i--) {
      listOfErrorMessages[i] = getTheErrorMessageAsPerIndex(i);
    }
  }

  String _validateEmail(String email) {
    if (email.isEmpty) return "Email cannot be empty";
    if (email.length > 50)
      return "Email cannot exceed 50 characters"; // Added max length check
    if (!emailRegExp.hasMatch(email)) return "Please enter a valid Email.";
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

  @override
  void dispose() {
    for (final c in _listOfTextEditingControllers) {
      c.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset == 0) {
      for (int i = 0; i < _listOfFocusNode.length; i++) {
        if (_listOfFocusNode[i].hasFocus) {
          listOfErrorMessages[i] = getTheErrorMessageAsPerIndex(i);
          _listOfFocusNode[i].unfocus();
        }
      }
      setState(() {});
    }
  }

  void _checkIfButtonShouldBeDisabled() {
    for (int i = 0; i < _listOfTextEditingControllers.length; i++) {
      final potentialError = getTheErrorMessageAsPerIndex(i);
      if (potentialError.isNotEmpty) {
        setState(() => isButtonDisabled = true);
        return;
      }
    }
    setState(() => isButtonDisabled = false);
  }

  String _validatePassword(String value) {
    if (value.isEmpty) return 'Password cannot be empty.';
    if (value.length < 5)
      return 'Password must be at least 5 characters'; // Added min length
    if (value.length > 25)
      return 'Password cannot exceed 25 characters'; // Added max length
    return "";
  }

  void handleSignButton() async {
    FocusScope.of(context).unfocus(); // Dismiss keyboard
    final email = _listOfTextEditingControllers[0].text.trim();
    final password = _listOfTextEditingControllers[1].text.trim();
    bool isSuccess = await ref
        .read(authNotifierProvider.notifier)
        .signInWithEmailAndPassword(context, email, password);
    if (isSuccess) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              const MainTabScreen(), // replace with your widget
        ),
        (Route<dynamic> route) => false, // removes all previous routes
      );
    }
  }

  void handleOnTapJoinUs() {}

  void handleOnTapForgotPasswordClick() {}

  Future<void> handleLoginSuccess() async {}

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);
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
                  "Log In",
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  color: HexColor(ColorConstants.blackShade1),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  labelText: "Your Email",
                  isMandatory: false,
                  errorText: listOfErrorMessages[0],
                ),
                const SizedBox(height: 18),

                // Password
                CustomInputText(
                  focusNode: _listOfFocusNode[1],
                  isErrorBorder: listOfErrorMessages[1].isNotEmpty,
                  textEditingController: _listOfTextEditingControllers[1],
                  isSuffixIcon: true,
                  hintText: "Enter your password",
                  maxLength: 64,
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
                const SizedBox(height: 8),

                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: handleOnTapForgotPasswordClick,
                    child: AppText(
                      "Forgot password?",
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: HexColor(ColorConstants.greyShade1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Login button
                CustomButton(
                  text: 'Log In',
                  isLoading: loginState.isLoading,
                  textStyle: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  isDisabled: isButtonDisabled,
                  onPressed: () {
                    if (!isButtonDisabled) {
                      FocusScope.of(context).unfocus();
                      handleSignButton();
                    }
                  },
                ),
                const SizedBox(height: 15),

                // Sign up link
                Align(
                  alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: "Don’t have an account? ",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: StringConstants.poppinsFontFamily,
                        fontWeight: FontWeight.w400,
                        color: HexColor(ColorConstants.greyShade1),
                      ),
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpScreen(),
                                ),
                              );
                            },

                          text: "Sign up",
                          style: TextStyle(
                            color: HexColor(ColorConstants.themeColor),
                            fontSize: 12,
                            fontFamily: StringConstants.poppinsFontFamily,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(thickness: 0.5)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22),
                      child: AppText(
                        "Or login with",
                        fontSize: 12,
                        fontFamily: StringConstants.poppinsFontFamily,
                        fontWeight: FontWeight.w400,
                        color: HexColor(ColorConstants.greyShade1),
                      ),
                    ),
                    Expanded(child: Divider(thickness: 0.5)),
                  ],
                ),
                const SizedBox(height: 30),

                Center(
                  child: Visibility(
                    visible: !loginState.isLoadingGoogleSignIn,
                    replacement: AppLoader.loaderWidget(),
                    child: InkWell(
                      onTap: () async {
                        var isSuccess = await ref
                            .read(authNotifierProvider.notifier)
                            .signInWithGoogle(context);
                        if (isSuccess) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (context) =>
                                  const MainTabScreen(), // replace with your widget
                            ),
                            (Route<dynamic> route) =>
                                false, // removes all previous routes
                          );
                        }
                      },
                      child: AppViewUtils.getAssetImageSVG(
                        ImageConstants.googleIcon,
                        height: 48,
                        width: 48,
                      ),
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
