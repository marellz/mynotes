// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
              'Your email is not verified yet. Click the button to verify'),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  try {
                    await user?.sendEmailVerification();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'too-many-requests') {
                      print('You\'ve clicked too many times');
                    } else {
                      print('[${e.code}: ${e.message}]');
                    }
                  }
                },
                child: const Text('Verify email'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.signOut();
                  } on FirebaseAuthException catch (e) {
                    print(e);
                  }
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ],
      ),
    );
  }
}
