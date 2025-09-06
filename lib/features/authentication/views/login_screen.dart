import 'package:books_discovery_app/features/authentication/view_models/auth_notifier.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/custom_button.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    ref
        .read(authNotifierProvider.notifier)
        .signInWithEmailAndPassword(email, password);
  }

  void handleOnTapJoinUs() {}

  void handleOnTapForgotPasswordClick() {}

  Future<void> handleLoginSuccess() async {}

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);
    return BaseWidget(
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Expanded(
            // Ensures this section expands to available space
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(), // Enables smooth scrolling
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize:
                    MainAxisSize.min, // Prevents unnecessary height expansion
                children: [
                  AppText(
                    "Login using Email ID",
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 13),

                  // Email Input
                  CustomInputText(
                    hintText: "Email",
                    maxLength: 254,
                    focusNode: _listOfFocusNode[0],
                    isErrorBorder: listOfErrorMessages[0].isNotEmpty,
                    // ||
                    // _authViewModel.errorMessage.value != "",
                    textEditingController: _listOfTextEditingControllers[0],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    labelText: "Enter your Email ID",
                    isSecure: false,
                    isMandatory: false,
                    errorText: listOfErrorMessages[0],
                  ),
                  const SizedBox(height: 12),

                  // Password Input
                  CustomInputText(
                    focusNode: _listOfFocusNode[1],
                    isErrorBorder: listOfErrorMessages[1]
                        .isNotEmpty, // ||_authViewModel.errorMessage.value != "",
                    textEditingController: _listOfTextEditingControllers[1],
                    isSuffixIcon: true,
                    hintText: "Password",
                    maxLength: 64,
                    labelText: "Enter your password",
                    isSecure: showEyeIconOff,
                    errorText: listOfErrorMessages[1],
                    onSuffixIconTap: () {
                      setState(() {
                        showEyeIconOff = !showEyeIconOff;
                      });
                    },
                    isMandatory: false,
                  ),
                  const SizedBox(height: 5),

                  // Forgot Password
                  GestureDetector(
                    onTap: handleOnTapForgotPasswordClick,
                    child: Text.rich(
                      TextSpan(
                        text: "Forgot Password? ",
                        style: TextStyle(
                          // fontFamily: Constants.interFontFamily,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(
                            text: "Click here",
                            style: const TextStyle(
                              // fontFamily: Constants.interFontFamily,
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  // Create Profile
                  GestureDetector(
                    onTap: handleOnTapJoinUs,
                    child: Text.rich(
                      TextSpan(
                        text: "Create a Profile? ",
                        style: const TextStyle(fontSize: 12),
                        children: [
                          TextSpan(
                            text: "Click here",
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Server error, if any
                  // Visibility(
                  //       visible: _authViewModel.errorMessage.value.isNotEmpty,
                  //       child: Center(
                  //         child: RichText(
                  //           text: TextSpan(
                  //             children: [
                  //               TextSpan(
                  //                 text: _authViewModel.errorMessage.value,
                  //                 style: TextStyle(
                  //                   fontSize: 12.5,
                  //                   fontFamily: Constants.appFontFamily,
                  //                   color: HexColor(ColorConstants.redShade),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  const SizedBox(height: 22),

                  // Login Button
                  CustomButton(
                    text: 'LOGIN',
                    isLoading: loginState.isLoading,
                    textStyle: const TextStyle(
                      fontSize: 13,
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
                  const SizedBox(height: 10),

                  // Terms & Conditions
                  Align(
                    alignment: Alignment.center,
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "I agree with your  ",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: "Terms of Service",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _termsTextClick,
                          ),
                          TextSpan(text: " & ", style: TextStyle(fontSize: 10)),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = _termsAndPrivacyTextClick,
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _termsAndPrivacyTextClick() {}

  void _termsTextClick() {}
}
