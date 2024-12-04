import 'package:flutter/material.dart';
import 'package:mynotes/constants/auth_errors.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text('Registration', style: TextStyle(fontSize: 20)),
            const SizedBox(
              height: 40,
            ),
            TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Enter email', label: Text('Email')),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _password,
              decoration: const InputDecoration(
                  hintText: 'Enter password', label: Text('Password')),
              obscureText: true,
              autocorrect: false,
            ),
            const SizedBox(
              height: 40,
            ),
            TextButton(
                onPressed: () async {
                  final String email = _email.text;
                  final String password = _password.text;

                  if (email == '' || password == '') {
                    showErrorDialog(context, 'Missing email/password');
                    return;
                  }

                  try {
                    await AuthService.firebase()
                        .createUser(email: email, password: password);

                    final user = AuthService.firebase().currentUser;

                    if (user != null) {
                      if (context.mounted) {
                        await AuthService.firebase().sendEmailVerification();
                        if (context.mounted) {
                          Navigator.of(context).pushNamed(routeVerifyEmail);
                        }
                      }
                    }
                  } on WeakPasswordException catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(context, errorWeakPassword);
                    }
                  } on EmailAlreadyInUseException catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(context, errorEmailAlreadyInUse);
                    }
                  } on InvalidEmailException catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(context, errorInvalidEmail);
                    }
                  } on GenericAuthException catch (_) {
                    if (context.mounted) {
                      await showErrorDialog(context, errorGenericError);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      await showErrorDialog(context, e.toString());
                    }
                  }
                },
                style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                        Color.fromARGB(255, 175, 243, 236))),
                //
                child: const Text('Register')),
            Row(
              children: [
                const Text('Already have an account?'),
                TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login', (route) => false);
                    },
                    child: const Text('Login')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
