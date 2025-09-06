import 'package:books_discovery_app/features/authentication/view_models/auth_notifier.dart';
import 'package:books_discovery_app/features/authentication/views/login_screen.dart';
import 'package:books_discovery_app/features/home/views/main_tab_screen.dart';
import 'package:books_discovery_app/shared/widgets/app_text.dart';
import 'package:books_discovery_app/shared/widgets/base_widget.dart';
import 'package:books_discovery_app/shared/widgets/custom_button.dart';
import 'package:books_discovery_app/shared/widgets/custom_input_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) =>
              const MainTabScreen(), // replace with your widget
        ),
        (Route<dynamic> route) => false, // removes all previous routes
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final signUpState = ref.watch(authNotifierProvider);
    return BaseWidget(
      screen: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          AppText("Sign Up", fontSize: 22, fontWeight: FontWeight.w700),
          const SizedBox(height: 5),
          AppText(
            "Enter your details below & free sign up",
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
          const SizedBox(height: 20),

          // Email
          CustomInputText(
            hintText: "Your Email",
            maxLength: 254,
            focusNode: _listOfFocusNode[0],
            isErrorBorder: listOfErrorMessages[0].isNotEmpty,
            textEditingController: _listOfTextEditingControllers[0],
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            labelText: "Email",
            isSecure: false,
            isMandatory: false,
            errorText: listOfErrorMessages[0],
          ),
          const SizedBox(height: 12),

          // Password
          CustomInputText(
            focusNode: _listOfFocusNode[1],
            isErrorBorder: listOfErrorMessages[1].isNotEmpty,
            textEditingController: _listOfTextEditingControllers[1],
            isSuffixIcon: true,
            hintText: "Password",
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
          const SizedBox(height: 20),

          // Create Account button
          CustomButton(
            text: 'Create account',
            isLoading: signUpState.isLoading,
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            isDisabled: isButtonDisabled,
            onPressed: () {
              if (!isButtonDisabled) {
                handleSignButton();
              }
            },
          ),
          const SizedBox(height: 15),

          // Terms checkbox
          Row(
            children: [
              Checkbox(
                value: agreeToTerms,
                onChanged: (val) {
                  setState(() {
                    agreeToTerms = val ?? false;
                  });
                  _validateField(0);
                },
              ),
              Expanded(
                child: AppText(
                  "By creating an account you have to agree with our terms & conditions.",
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),

          // Already have an account
          Align(
            alignment: Alignment.center,
            child: Text.rich(
              TextSpan(
                text: "Already have an account? ",
                style: const TextStyle(fontSize: 12),
                children: [
                  TextSpan(
                    text: "Log in",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
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
    );
  }
}
