import 'package:books_discovery_app/core/services/firebase_auth_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:books_discovery_app/shared/app_shared_preferences.dart';
import 'package:books_discovery_app/features/authentication/models/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:books_discovery_app/shared/widgets/app_view_utils.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(this._authService) : super(const AuthState());

  final FirebaseAuthService _authService;

  Future<bool> signUpWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _authService.signUp(email, password);
      if (user == null) return false;

      final token = await _authService.getIdToken();
      await AppSharedPreferences.customSharedPreferences.saveUser(user);
      await AppSharedPreferences.customSharedPreferences.setAuthToken(token);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      AppViewUtils.showTopSnackbar(context, e.toString(), isError: true);
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final user = await _authService.signIn(email, password);
      if (user == null) return false;

      final token = await _authService.getIdToken();
      await AppSharedPreferences.customSharedPreferences.saveUser(user);
      await AppSharedPreferences.customSharedPreferences.setAuthToken(token);

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      AppViewUtils.showTopSnackbar(context, e.toString(), isError: true);
      state = state.copyWith(errorMessage: e.toString(), isLoading: false);
      return false;
    }
  }

  Future<bool> signInWithGoogle(BuildContext context) async {
    state = state.copyWith(isLoadingGoogleSignIn: true, errorMessage: null);

    try {
      final user = await _authService.signInWithGoogle();
      if (user == null) {
        state = state.copyWith(isLoadingGoogleSignIn: false);
        return false;
      }

      final token = await _authService.getIdToken();
      await AppSharedPreferences.customSharedPreferences.saveUser(user);
      await AppSharedPreferences.customSharedPreferences.setAuthToken(token);

      state = state.copyWith(isLoadingGoogleSignIn: false);
      return true;
    } catch (e) {
      AppViewUtils.showTopSnackbar(context, e.toString(), isError: true);
      state = state.copyWith(
        errorMessage: e.toString(),
        isLoadingGoogleSignIn: false,
      );
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    await AppSharedPreferences.customSharedPreferences.clearSharedPreference();
    state = const AuthState();
  }
}

// Provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>((
  ref,
) {
  final service = FirebaseAuthService();
  return AuthNotifier(service);
});
