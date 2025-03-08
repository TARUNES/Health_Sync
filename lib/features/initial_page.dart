import 'package:flutter/material.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/Appointment.dart';
import 'package:health_sync_client/features/medical_records/presentation/screens/medicalRecords.dart';
import 'package:health_sync_client/features/notification/presentation/screens/notification.dart';
import 'package:health_sync_client/features/profile/presentation/screens/profile.dart';

import '../core/utils/components/BottomNavBar.dart';
import 'home/presentation/screens/home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const AppointmentScreen(),
    const NotificationPage(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Main content
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),

          // Custom navigation bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: CustomDotNavigationBar(
              selectedIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedColor: Theme.of(context).colorScheme.onSecondary,
              unselectedColor: Colors.grey,
              dotColor: Colors.blue,
              duration: const Duration(milliseconds: 300),
            ),
          ),
        ],
      ),
    );
  }
}
