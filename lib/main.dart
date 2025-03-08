import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/theme.dart';
import 'package:health_sync_client/core/routes/mainRoute.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/Appointment.dart';

import 'features/medication/presentation/screens/MedicationAlert.dart';

void main() {
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
