import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';

@immutable
class AuthenticatedUser {
  final bool isEmailVerified;

  const AuthenticatedUser(this.isEmailVerified);

  factory AuthenticatedUser.fromFirebase(User user) => AuthenticatedUser(user.emailVerified);
}