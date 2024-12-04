import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthenticatedUser {
  final bool isEmailVerified;
  const AuthenticatedUser({required this.isEmailVerified});

  factory AuthenticatedUser.fromFirebase(User user) =>
      AuthenticatedUser(isEmailVerified: user.emailVerified);
}
