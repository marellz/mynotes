import 'package:mynotes/services/auth/auth_user.dart';

abstract class AuthProvider {
  AuthenticatedUser? get currentUser;

  Future<AuthenticatedUser> logIn({
    required String email,
    required String password,
  });

  Future<AuthenticatedUser> createUser({
    required String email,
    required String password,
  });

  Future<void> logOut();
  
  Future<void> sendEmailVerification();
}
