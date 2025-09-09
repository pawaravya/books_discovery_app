class AuthState {
  final bool isLoading;
    final bool isLoadingGoogleSignIn;

  final String? errorMessage;
  const AuthState({
    this.isLoading = false,
    this.errorMessage,
    this.isLoadingGoogleSignIn = false 
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isLoadingGoogleSignIn
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoadingGoogleSignIn:  isLoadingGoogleSignIn ?? this.isLoadingGoogleSignIn
    );
  }
}