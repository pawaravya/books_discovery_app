import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/authentication/models/auth_state.dart';
import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  // ➤ Sign Up with Email & Password
  Future<bool> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email.trim(),
            password: password,
          );

      final firebaseUser = credential.user!;
      final token = await firebaseUser.getIdToken();
      final userModel = UserModel.fromFirebase(firebaseUser);
      await AppSharedPreferences.customSharedPreferences.saveUser(userModel);
      await AppSharedPreferences.customSharedPreferences.setAuthToken(token ?? "");

      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      AppViewUtils.showTopSnackbar(
        context,
        e.message ?? StringConstants.somethingWentWrongMessage,
        isError: true,
      );
      state = state.copyWith(errorMessage: e.message, isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
      return false;
    }
  }

  // ➤ Sign In with Email & Password
  Future<bool> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final firebaseUser = credential.user!;
      final token = await firebaseUser.getIdToken();
      final userModel = UserModel.fromFirebase(firebaseUser);

      await AppSharedPreferences.customSharedPreferences.saveUser(userModel);
      await AppSharedPreferences.customSharedPreferences.setAuthToken(token ??'');

      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      AppViewUtils.showTopSnackbar(
        context,
        e.message ?? StringConstants.somethingWentWrongMessage,
        isError: true,
      );
      state = state.copyWith(errorMessage: e.message, isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
      return false;
    }
  }

  // ➤ Sign In with Google
  Future<bool> signInWithGoogle(BuildContext context) async {
    return false ;
    // state = state.copyWith(isLoading: true, errorMessage: null);

    // try {
    //   final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    //   if (googleUser == null) {
    //     state = state.copyWith(isLoading: false);
    //     return false; // User canceled
    //   }

    //   final GoogleSignInAuthentication googleAuth =
    //       await googleUser.authentication;

    //   final OAuthCredential credential = GoogleAuthProvider.credential(
    //     accessToken: googleAuth.accessToken,
    //     idToken: googleAuth.idToken,
    //   );

    //   final UserCredential userCredential = await FirebaseAuth.instance
    //       .signInWithCredential(credential);

    //   final firebaseUser = userCredential.user!;
    //   final token = await firebaseUser.getIdToken();
    //   final userModel = UserModel.fromFirebase(firebaseUser);

    //   await AppSharedPreferences.customSharedPreferences.saveUser(userModel);
    //   await AppSharedPreferences.customSharedPreferences.saveAuthToken(token);

    //   state = state.copyWith(isLoading: false);
    //   return true;
    // } on FirebaseAuthException catch (e) {
    //   AppViewUtils.showTopSnackbar(
    //     context,
    //     e.message ?? StringConstants.somethingWentWrongMessage,
    //     isError: true,
    //   );
    //   state = state.copyWith(errorMessage: e.message, isLoading: false);
    //   return false;
    // } catch (e) {
    //   state = state.copyWith(
    //     errorMessage: "Google sign-in failed. Please try again.",
    //     isLoading: false,
    //   );
    //   return false;
    // }
  }

  // ➤ Logout
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.signOut();
    await AppSharedPreferences.customSharedPreferences.clearSharedPreference();
    state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier();
});
