import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

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
                      devtools.log('You\'ve clicked too many times');
                    } else {
                      devtools.log('[${e.code}: ${e.message}]');
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
                    devtools.log(e.message ?? e.toString());
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
