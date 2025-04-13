import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// Main Emergency Screen
class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({Key? key}) : super(key: key);

  @override
  _EmergencyScreenState createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String? _emergencyContact = "";
  bool _isLoading = true;
  bool _isMessageSent = false;
  String _statusMessage = "Initializing emergency...";

  @override
  void initState() {
    super.initState();
    _initializeEmergency();
  }

  Future<void> _initializeEmergency() async {
    setState(() {
      _isLoading = true;
      _statusMessage = "Preparing emergency alert...";
    });

    // Load emergency contact
    await loadProfileData();

    // Send static emergency message
    if (_emergencyContact != null) {
      await _sendEmergencySMS();
    } else {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error: No emergency contact found.";
      });
    }
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String? profileData = prefs.getString('profile_data');
    print(profileData);

    if (profileData != null) {
      Map<String, dynamic> decodedData = jsonDecode(profileData);
      print("Decode");
      print(decodedData);
      setState(() {
        _emergencyContact =
            decodedData['emergency_contact_number'] ?? "924259581";
      });
    }
  }

  Future<void> _sendEmergencySMS() async {
    if (_emergencyContact == null) return;

    print(_emergencyContact);

    // Static emergency message
    final message =
        "EMERGENCY: I need help! Please contact me as soon as possible. https://www.google.com/maps?q=12.9207931,80.2399035";

    // Using url_launcher to send SMS
    final url = Uri.parse(
        'sms:+91$_emergencyContact?body=${Uri.encodeComponent(message)}');

    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
        setState(() {
          _isLoading = false;
          _isMessageSent = true;
          _statusMessage =
              "Emergency message prepared..... Contacting emergency contact : $_emergencyContact";
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = "(Could not launch messaging app.)";
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = "Error sending message: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Alert'),
        backgroundColor: Colors.red,
      ),
      body: Container(
        color: Colors.red.shade50,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.emergency,
                  color: Colors.red,
                  size: 80.0,
                ),
                const SizedBox(height: 20),
                Text(
                  _isMessageSent
                      ? "Emergency Alert"
                      : "Emergency Mode Activated",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _statusMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                const SizedBox(height: 30),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Return to Home'),
                ),
                // if (_emergencyContact == null)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 20),
                //     child: ElevatedButton(
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.red,
                //         foregroundColor: Colors.white,
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 32, vertical: 16),
                //       ),
                //       onPressed: () {},
                //       child: const Text('Set Emergency Contact'),
                //     ),
                //   ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
