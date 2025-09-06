import 'package:books_discovery_app/core/constants/string_constants.dart';
import 'package:books_discovery_app/features/authentication/models/auth_state.dart';
import 'package:books_discovery_app/features/authentication/models/user_model.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {}
  // final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ➤ Login with Email & Password
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final firebaseUser = credential.user!;
      final userModel = UserModel.fromFirebase(firebaseUser);
      AppSharedPreferences.customSharedPreferences.saveUser(userModel);
      state = state.copyWith(isLoading: false);
    } on FirebaseAuthException catch (e) {
      AppViewUtils.showSnackBar(
        e.message ?? StringConstants.somethingWentWrongMessage,
        isError: true,
      );
      state = state.copyWith(errorMessage: e.message, isLoading: false);
    } catch (e) {
      state = state.copyWith(
        errorMessage: "An unexpected error occurred. Please try again.",
        isLoading: false,
      );
    }
  }

  // ➤ Sign In with Google
  // Future<void> signInWithGoogle() async {
  //   state = state.copyWith(isLoading: true, errorMessage: null);

  //   try {
  //     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
  //     if (googleUser == null) {
  //       state = state.copyWith(isLoading: false);
  //       return; // User canceled
  //     }

  //     final GoogleSignInAuthentication googleAuth =
  //         await googleUser.authentication;
  //     final OAuthCredential credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth.accessToken,
  //       idToken: googleAuth.idToken,
  //     );

  //     final UserCredential userCredential = await FirebaseAuth.instance
  //         .signInWithCredential(credential);
  //     final firebaseUser = userCredential.user!;
  //     final userModel = UserModel.fromFirebase(firebaseUser);

  //     await _saveUser(userModel);

  //     state = state.copyWith(
  //       isLoading: false,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     String message = _mapFirebaseError(e.code);
  //     state = state.copyWith(errorMessage: message, isLoading: false);
  //   } catch (e) {
  //     state = state.copyWith(
  //       errorMessage: "Google sign-in failed. Please try again.",
  //       isLoading: false,
  //     );
  //   }
  // }

  // ➤ Logout
  Future<void> signOut() async {
    // await FirebaseAuth.instance.signOut();
    // // await GoogleSignIn().signOut();
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('user_data');

    // state = const AuthState();
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  return AuthNotifier();
});
