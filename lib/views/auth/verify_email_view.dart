import 'package:flutter/material.dart';
import 'package:mynotes/constants/auth_errors.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/error_dialog.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  final user = AuthService.firebase().currentUser;

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
                    try {
                      await AuthService.firebase().sendEmailVerification();
                    } on ClickedTooManyTimesException catch (_) {
                      if (context.mounted) {
                        await showErrorDialog(
                          context,
                          errorClickedTooManyTimes,
                        );
                      }
                    } on GenericAuthException catch (_) {
                      if (context.mounted) {
                        await showErrorDialog(context, errorGenericError);
                      }
                    } catch (_) {
                      if (context.mounted) {
                        await showErrorDialog(context, errorGenericError);
                      }
                    }
                  },
                  child: const Text('Resend email verification'),
                ),

                // todo: have a way of confirming.
                TextButton(
                  onPressed: () async {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(routeHome, (_) => false);
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
