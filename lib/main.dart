import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:health_sync_client/core/services/notification_service.dart';
import 'firebase_options.dart';
import 'package:health_sync_client/core/routes/mainRoute.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/Appointment.dart';

import 'features/medication/presentation/screens/MedicationAlert.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await NotificationService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: MainRoute(),
    );
  }
}
