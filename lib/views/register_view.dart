import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';
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

                  if(email == '' || password == ''){
                    showErrorDialog(context, 'Missing email/password');
                    return;
                  }

                  try {
                    final UserCredential userCredential = await FirebaseAuth
                        .instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    if (userCredential.user != null) {
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(routeNotes, (_) => false);
                      }
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      if (context.mounted) {
                        showErrorDialog(
                            context, 'The password provided is too weak.');
                      }
                    } else if (e.code == 'email-already-in-use') {
                      if (context.mounted) {
                        showErrorDialog(context,
                            'The account already exists for that email.');
                      }
                    } else if (e.code == 'invalid-email') {
                      if (context.mounted) {
                        showErrorDialog(
                            context, 'The email provided is invalid.');
                      }
                    } else {
                      if (context.mounted) {
                        await showErrorDialog(
                            context, e.message ?? 'An unknown error');
                      }
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
