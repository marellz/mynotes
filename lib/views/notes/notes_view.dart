import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/menu_actions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/db/database_service.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final DatabaseService _databaseService;
  AuthenticatedUser? currentUser = AuthService.firebase().currentUser;
  String get userEmail => currentUser!.email!;

  @override
  void initState() {
    _databaseService = DatabaseService();
    _databaseService.open();
    super.initState();
  }

  @override
  void dispose() {
    _databaseService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notes'),
          actions: [
            PopupMenuButton(
              onSelected: (value) async {
                switch (value) {
                  case MenuAction.logout:
                    final shouldLogout = await showLogoutDialog(context);
                    if (shouldLogout) {
                      await AuthService.firebase().logOut();
                      if (context.mounted) {
                        Navigator.of(context)
                            .pushNamedAndRemoveUntil(routeLogin, (_) => false);
                      }
                    }

                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<MenuAction>(
                      value: MenuAction.logout, child: Text('Logout'))
                ];
              },
            )
          ],
        ),
        body: FutureBuilder(
          future: _databaseService.getOrCreateUser(email: userEmail),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              
                case ConnectionState.done:
                    return const Text('Notes are here');
                    
                case ConnectionState.none:
                    return const Text("Invalid user");
                    
              default:
                  return const CircularProgressIndicator();
            }
          },
        ));
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: const Text('Logout')),
            ]);
      }).then((value) => value ?? false);
}
