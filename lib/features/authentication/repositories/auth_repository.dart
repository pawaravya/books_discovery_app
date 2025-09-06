import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);
  Future<dynamic> loginWithEmail(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      return {'error': true, 'message': e.message, 'code': e.code};
    } catch (e) {
      return {'error': true, 'message': 'Something went wrong'};
    }
  }
}
