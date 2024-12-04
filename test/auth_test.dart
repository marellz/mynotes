import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication :', () {
    final provider = MockAuthProvider();

    test('1. Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
    });

    test('2. Cannot logout out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
    });

    test('3. Should be able to be initialized', () async {
      await provider.initialize();
      expect(provider.isInitialized, true);
    });

    test('4. User should be null after initialization', () {
      expect(provider.currentUser, null);
    });

    test(
      '5. Should be able to initialized in less than 2 seconds',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('6. Create user should delegate to login function', () async {
      final badEmailUser = provider.createUser(
        email: 'foo@bar.com',
        password: 'password',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<InvalidCredentialsException>()),
      );

      final badPasswordUser = provider.createUser(
        email: 'anyone@example.com',
        password: 'foobar',
      );

      expect(
        badPasswordUser,
        throwsA(const TypeMatcher<InvalidCredentialsException>()),
      );

      final user = await provider.createUser(
        email: 'anyone@example.com',
        password: 'password',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test('7. Logged in user should be able to get verified', () {
      provider.sendEmailVerification();

      final user = provider.currentUser;
      expect(user, isNotNull);
      expect(user!.isEmailVerified, true);
    });

    test('8. Should be able to log out and in again', () async {
      await provider.logOut();
      await provider.logIn(
        email: 'anyone@example.com',
        password: 'password',
      );

      final user = provider.currentUser;
      expect(user, isNotNull);
    });
  });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthenticatedUser? _user;
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthenticatedUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedException();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(email: email, password: password);
  }

  @override
  AuthenticatedUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthenticatedUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedException();
    if (email == 'foo@bar.com' || password == 'foobar') {
      throw InvalidCredentialsException();
    }

    const user = AuthenticatedUser(isEmailVerified: false);
    _user = user;

    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();

    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotLoggedInException();
    const user = AuthenticatedUser(isEmailVerified: true);
    _user = user;
    await Future.delayed(const Duration(seconds: 1));
  }
}
