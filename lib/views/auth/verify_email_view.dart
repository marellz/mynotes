import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:mynotes/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify email'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
                'Your email is not verified yet. Have you received the email witht the verification link? If not, you can request again.'),
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
                  child: const Text('Resend email verification'),
                ),

                // todo: have a way of confirming.
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pushNamedAndRemoveUntil(routeHome, (_)=> false);
                  },
                  child: const Text('Go back home'),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
