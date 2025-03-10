import 'package:flutter/material.dart';
import 'package:health_sync_client/features/auth/presentation/screens/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/initial_page.dart';

class MainRoute extends StatelessWidget {
  const MainRoute({super.key});

  Future<bool> inAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token'); // Retrieve token

    return token != null && token.isNotEmpty;
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
