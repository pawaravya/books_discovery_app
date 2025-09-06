import 'package:books_discovery_app/core/constants/color_constants.dart';
import 'package:books_discovery_app/core/constants/image_constants.dart';
import 'package:books_discovery_app/features/authentication/view_models/auth_notifier.dart';
import 'package:books_discovery_app/features/authentication/views/sign_up_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
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
   bool isSuccess = await ref.read(authNotifierProvider.notifier)
        .signInWithEmailAndPassword(context, email, password);
        if(isSuccess){
Navigator.of(context).pushAndRemoveUntil(
  MaterialPageRoute(
    builder: (context) => const MainTabScreen(), // replace with your widget
  ),
  (Route<dynamic> route) => false, // removes all previous routes
);        }
  }

  void handleOnTapJoinUs() {}

  void handleOnTapForgotPasswordClick() {}

  Future<void> handleLoginSuccess() async {}

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);
    return BaseWidget(
      screen: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Title
            Text(
              "Log In",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // Email
            CustomInputText(
              hintText: "Your Email",
              maxLength: 254,
              focusNode: _listOfFocusNode[0],
              isErrorBorder: listOfErrorMessages[0].isNotEmpty,
              textEditingController: _listOfTextEditingControllers[0],
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              labelText: "Enter your Email ID",
              isSecure: false,
              isMandatory: false,
              errorText: listOfErrorMessages[0],
            ),
            const SizedBox(height: 15),

            // Password
            CustomInputText(
              focusNode: _listOfFocusNode[1],
              isErrorBorder: listOfErrorMessages[1].isNotEmpty,
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
            const SizedBox(height: 8),

            // Forgot password
            Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: handleOnTapForgotPasswordClick,
                child: Text(
                  "Forgot password?",
                  style: TextStyle(color: Colors.black, fontSize: 12),
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
                  style: TextStyle(fontSize: 12),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Divider
            Row(
              children: const [
                Expanded(child: Divider(thickness: 1)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("Or login with"),
                ),
                Expanded(child: Divider(thickness: 1)),
              ],
            ),
            const SizedBox(height: 30),

            // Google login button
            Center(
              child: InkWell(
                onTap: () {},
                child: AppViewUtils.getAssetImageSVG(
                  ImageConstants.googleIcon,
                  height: 48,
                  width: 48,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
