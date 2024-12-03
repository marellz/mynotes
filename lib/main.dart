import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mynotes/firebase_options.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:mynotes/views/welcome_view.dart';
import 'constants/routes.dart';

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
      routeHome: (context) => const HomePage(),
      routeLogin: (context) => const LoginView(),
      routeRegister: (context) => const RegisterView(),
      routeNotes: (context) => const NotesView(),
      routeVerifyEmail: (context) => const VerifyEmailView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyNotes'),
        
      ),
      body: FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = FirebaseAuth.instance.currentUser;

              List<Widget> homeChildren = [];

              if (user != null && !user.emailVerified) {
                homeChildren.add(
                  Container(
                    decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.all(Radius.elliptical(20,20)),
                      border: Border(
                        top: BorderSide(color: Colors.lightGreen),
                        bottom: BorderSide(color: Colors.lightGreen),
                        left: BorderSide(color: Colors.lightGreen),
                        right: BorderSide(color: Colors.lightGreen),
                      )
                    ),
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(left: 12.0, right: 12, bottom: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Your email is not verified!'),
                          TextButton(
                              onPressed: () async {
                                final user = FirebaseAuth.instance.currentUser;
                                await user?.sendEmailVerification();
                                if (context.mounted) {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      routeVerifyEmail, (_) => false);
                                }
                              },
                              child: const Text('Verify')),
                        ],
                      )),
                );
              }

              if (user != null && user.emailVerified) {
                homeChildren
                    .addAll([const VerifyEmailView(), const WelcomeView()]);
              } else {
                homeChildren.add(const WelcomeView());
              }
              
              return Column(children: homeChildren);

            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
