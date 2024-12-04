import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/views/auth/login_view.dart';
import 'package:mynotes/views/notes_view.dart';
import 'package:mynotes/views/auth/register_view.dart';
import 'package:mynotes/views/auth/verify_email_view.dart';
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
    // todo: fix bug: bottom overflowed.
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

class VerifyEmailWidget extends StatelessWidget {
  const VerifyEmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            color: Colors.lightGreen,
            borderRadius: BorderRadius.all(Radius.elliptical(20, 20)),
            border: Border(
              top: BorderSide(color: Colors.lightGreen),
              bottom: BorderSide(color: Colors.lightGreen),
              left: BorderSide(color: Colors.lightGreen),
              right: BorderSide(color: Colors.lightGreen),
            )),
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(left: 12.0, right: 12, bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Your email is not verified!'),
            TextButton(
                onPressed: () async {
                  await AuthService.firebase().sendEmailVerification();
                  if (context.mounted) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        routeVerifyEmail, (_) => false);
                  }
                },
                child: const Text('Verify')),
          ],
        ));
  }
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
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;

              List<Widget> homeChildren = [const WelcomeView()];

              if (user != null && !user.isEmailVerified) {
                homeChildren.insert(0, const VerifyEmailWidget());
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
