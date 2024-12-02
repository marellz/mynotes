// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login': (context) => const LoginView(),
      '/register': (context) => const RegisterView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
            final user = FirebaseAuth.instance.currentUser;
              if(user == null){
                return const LoginView();
              }
              print({'verified': user.emailVerified, 'email': user.email});

              if(!user.emailVerified){
                return const VerifyEmailView();
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Homepage is now'),
                  Row(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          },
                          child: const Text('Login')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/register', (route) => false);
                          },
                          child: const Text('Register')),
                    ],
                  )
                ],
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}


