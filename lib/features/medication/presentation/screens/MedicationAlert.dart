import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';

import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';
import 'package:health_sync_client/features/medication/domain/repository/pillScheduleRepo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  @override
  void initState() {
    super.initState();
    _loadMedications();
  }

  void _loadMedications() {
    setState(() {
      _futureMedications = _repository.getMedications();
    });
  }

  late Future<List<PillScheduleModel>> _futureMedications;
  final Map<String, List<PillScheduleModel>> _groupedMedications = {};
  final MedicationRepository _repository = MedicationRepository();
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  TimeOfDay? _selectedTime;
  String? _selectedFrequency;

  // List of pill images to cycle through
  final List<String> _pillImages = [
    'assets/illustrations/bluepill.png',
    'assets/illustrations/goldenpill.png',
    'assets/illustrations/brownpill.png',
  ];

  @override
  void dispose() {
    _medicationNameController.dispose();
    super.dispose();
  }

  String _getPillImage(int index) {
    return _pillImages[index % _pillImages.length];
  }

  void _groupMedicationsByTime(List<PillScheduleModel> medications) {
    _groupedMedications.clear();
    for (final medication in medications) {
      final normalizedTime = _normalizeTimeFormat(medication.intakeTime);
      _groupedMedications.putIfAbsent(normalizedTime, () => []).add(medication);
    }
  }

// Add these controllers to your state class

// Add this list for frequency options
  final List<String> _frequencyOptions = ['daily', 'weekly', 'monthly'];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _showAddMedicationForm(BuildContext context, ColorScheme theme) {
    showModalBottomSheet(
      backgroundColor: theme.background,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Add Medication',
                      style: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: theme.onBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Medication Name Field
                  TextField(
                    controller: _medicationNameController,
                    decoration: InputDecoration(
                      labelText: 'Medication Name',
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                        color: theme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Dosage Field
                  TextField(
                    controller: _dosageController,
                    decoration: InputDecoration(
                      labelText: 'Dosage (e.g., 10mg)',
                      labelStyle: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                        color: theme.onBackground,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Frequency Selection
                  Text(
                    'Frequency:',
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    children: _frequencyOptions.map((frequency) {
                      return ChoiceChip(
                        label: Text(frequency),
                        selected: _selectedFrequency == frequency,
                        onSelected: (selected) {
                          setState(() {
                            _selectedFrequency = selected ? frequency : null;
                          });
                        },
                        selectedColor: theme.secondary,
                        labelStyle: TextStyle(
                          color: _selectedFrequency == frequency
                              ? theme.onSecondary
                              : theme.onBackground,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Time Picker
                  Text(
                    'Time to take:',
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? pickedTime = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime ?? TimeOfDay.now(),
                      );
                      if (pickedTime != null && pickedTime != _selectedTime) {
                        setState(() {
                          _selectedTime = pickedTime;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.outline),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _selectedTime != null
                                ? _selectedTime!.format(context)
                                : 'Select Time',
                            style: TextStyle(
                              color: theme.onBackground,
                              fontSize: 14,
                            ),
                          ),
                          Icon(Icons.access_time, color: theme.onBackground),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        // Validation
                        if (_medicationNameController.text.isEmpty ||
                            _dosageController.text.isEmpty ||
                            _selectedFrequency == null ||
                            _selectedTime == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Please fill all fields"),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        // Format time to HH:MM:SS as required by API
                        String formattedHour =
                            _selectedTime!.hour.toString().padLeft(2, '0');
                        String formattedMinute =
                            _selectedTime!.minute.toString().padLeft(2, '0');
                        String timeToNotify =
                            "$formattedHour:$formattedMinute:00";

                        // Prepare API data
                        Map<String, dynamic> medicationData = {
                          "medication_name":
                              _medicationNameController.text.trim(),
                          "dosage": _dosageController.text.trim(),
                          "time_to_notify": timeToNotify,
                          "frequency": _selectedFrequency
                        };

                        final medicationService = MedicationRepository();
                        await medicationService.scheduleMedications(
                            medicationData["medication_name"],
                            medicationData["dosage"],
                            medicationData["time_to_notify"],
                            medicationData["frequency"]);
                        Navigator.of(context).pop();
                        setState(() {
                          _medicationNameController.clear();
                          _dosageController.clear();
                          _selectedFrequency = null;
                          _selectedTime = null;
                        });

                        // Close the modal sheet

                        // Show success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Medication scheduled successfully"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text(
                        'Save Medication',
                        style: TextStyle(
                          color: theme.onSecondary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  String _normalizeTimeFormat(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    final hour = timeParts[0].padLeft(2, '0');
    return '$hour:${timeParts[1]} ${parts[1]}';
  }

  List<String> _sortTimeSlots(List<String> timeSlots) {
    return timeSlots.toList()
      ..sort((a, b) {
        final timeA = _convertTo24Hour(a);
        final timeB = _convertTo24Hour(b);
        return timeA.compareTo(timeB);
      });
  }

  String _convertTo24Hour(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    int hours = int.parse(timeParts[0]);
    final minutes = int.parse(timeParts[1]);

    if (parts[1] == 'PM' && hours != 12) {
      hours += 12;
    } else if (parts[1] == 'AM' && hours == 12) {
      hours = 0;
    }

    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  Widget _buildMedicationCard(
      PillScheduleModel medication, ColorScheme theme, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: theme.background,
        border: Border.all(width: 2, color: const Color(0xffDCE9EC)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Image.asset(
                _getPillImage(index),
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    medication.name,
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    medication.intakeDescription,
                    style: const TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: Color(0xff91939C),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Text(
            "${medication.noOfDays} Days",
            style: const TextStyle(
              fontFamily: AppFonts.primaryFont,
              color: Color(0xff91939C),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddMedicationForm(context, theme),
        backgroundColor: theme.secondary,
        child: Icon(Icons.add, color: theme.onSecondary, size: 30),
      ),
      appBar: AppBar(
        backgroundColor: theme.background,
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text(
          "Medication Schedule",
          style: TextStyle(
            fontFamily: AppFonts.primaryFont,
            color: theme.onBackground,
            fontWeight: FontWeight.w400,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<PillScheduleModel>>(
          future: _futureMedications,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No medications scheduled.'));
            }

            _groupMedicationsByTime(snapshot.data!);
            final sortedTimeSlots =
                _sortTimeSlots(_groupedMedications.keys.toList());

            return Padding(
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: sortedTimeSlots.length,
                itemBuilder: (context, index) {
                  final timeSlot = sortedTimeSlots[index];
                  final medications = _groupedMedications[timeSlot]!;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        timeSlot,
                        style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                          color: theme.onBackground,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...medications
                          .asMap()
                          .entries
                          .map((entry) => _buildMedicationCard(
                              entry.value, theme, entry.key))
                          .toList(),
                      const SizedBox(height: 20),
                    ],
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class MedicationRepository {
  final String baseUrl = "http://172.31.135.242:8080";
  final String userId = "6788a3bf-5258-4dc1-8892-1ae9af9af215";

  Future<List<PillScheduleModel>> getMedications() async {
    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token'); // Retrieve token from storage
    }

    String? token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl/user/$userId/medications'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      print(response.body);
      print(response.statusCode);

      return data.map((e) => PillScheduleModel.fromJson(e)).toList();
    } else {
      print(response.body);
      print(response.statusCode);
      throw Exception("Failed to load medications");
    }
  }

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<List<PillScheduleModel>> scheduleMedications(
      String name, String dosage, String timeNotify, String frequency) async {
    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    }

    String? token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl/user/$userId/medications'),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: json.encode({
        "medication_name": name,
        "dosage": dosage,
        "time_to_notify": timeNotify,
        "frequency": frequency,
      }),
    );
    print(name);
    print(dosage);
    print(timeNotify);
    print(frequency);

    if (response.statusCode == 201) {
      Map<String, dynamic> data = json.decode(response.body);
      print(response.body);

      final medication = data["medication"]["medication"];

      // Show an instant notification
      sendInstantNotification(name, dosage);

      return [PillScheduleModel.fromJson(medication)];
    } else {
      print(response.body);
      throw Exception("Failed to schedule medications");
    }
  }

  // **Function to Show an Instant Notification**
  void sendInstantNotification(String name, String dosage) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'medication_channel',
      'Medication Reminders',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      "Medication Scheduled",
      "$name - $dosage has been scheduled successfully.",
      platformChannelSpecifics,
    );
  }
}
