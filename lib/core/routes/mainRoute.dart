import 'package:flutter/material.dart';
import 'package:health_sync_client/features/auth/presentation/screens/auth.dart';

import '../../features/initial_page.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  Future<bool> inAuthenticated() async {
    await Future.delayed(Duration(seconds: 1));
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: inAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasData && snapshot.data == true) {
          return MainScreen();
        } else {
          return AuthPage();
          // return CircularProgressIndicator();
        }
      },
    );
  }
}
