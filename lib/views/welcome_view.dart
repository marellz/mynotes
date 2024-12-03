import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        children: [
          Text(
            'Hello!',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Welcome to mynotes app!',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class WelcomeActions extends StatelessWidget {
  const WelcomeActions({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return Column(
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/notes', (route) => false);
              },
              child: const Text('Go to my notes'))
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/login', (route) => false);
              },
              child: const Text('Login')),
          TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register', (route) => false);
              },
              child: const Text('Register')),
        ],
      );
    }
  }
}

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        WelcomeBanner(),
        SizedBox(
          height: 20,
        ),
        WelcomeActions(),
      ],
    );
  }
}
