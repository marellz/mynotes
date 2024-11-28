// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/firebase_options.dart';

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
          backgroundColor: Colors.teal,
          title: const Text('Register',
              style: TextStyle(color: Colors.white, fontSize: 16))),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Container(
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

                          print({email, password});

                          try {
                            final UserCredential userCredential =
                                await FirebaseAuth
                                    .instance
                                    .createUserWithEmailAndPassword(
                                        email: email, password: password);

                            print(userCredential);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              print('The password provided is too weak.');
                            } else if (e.code == 'email-already-in-use') {
                              print(
                                  'The account already exists for that email.');
                            } else if (e.code == 'invalid-email') {
                              print('The email provided is invalid.');
                            }
                          } catch (e) {
                            print(e);
                          }
                        },
                        style: const ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                                Color.fromARGB(255, 175, 243, 236))),
                        //
                        child: const Text('Register')),
                  ],
                ),
              );

            default:
              return const Text('Loading');
          }
        },
      ),
    );
  }
}
