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
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // List to store mock data for fallback
  final List<PillScheduleModel> _mockMedications = [
    PillScheduleModel(
      id: "1",
      name: "Paracetamol",
      intakeTime: "08:00 AM",
      intakeDescription: "Take after breakfast",
      noOfDays: 5,
      isReadByUser: false,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
    PillScheduleModel(
      id: "2",
      name: "Omega 3",
      intakeTime: "08:00 AM",
      intakeDescription: "Take after lunch",
      noOfDays: 7,
      isReadByUser: false,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
    PillScheduleModel(
      id: "3",
      name: "Vitamin D",
      intakeTime: "08:00 AM",
      intakeDescription: "Take with evening snack",
      noOfDays: 30,
      isReadByUser: true,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
    PillScheduleModel(
      id: "4",
      name: "Antibiotic",
      intakeTime: "06:00 PM",
      intakeDescription: "Take after dinner",
      noOfDays: 10,
      isReadByUser: true,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
    PillScheduleModel(
      id: "5",
      name: "Vitamin D",
      intakeTime: "06:00 PM",
      intakeDescription: "Take with evening snack",
      noOfDays: 30,
      isReadByUser: false,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
    PillScheduleModel(
      id: "6",
      name: "Antibiotic",
      intakeTime: "09:00 PM",
      intakeDescription: "Take after dinner",
      noOfDays: 10,
      isReadByUser: false,
      createdAt: "2025-03-11T08:00:00Z",
      updatedAt: "2025-03-11T08:00:00Z",
    ),
  ];

  // List to store locally added medications (when API fails)
  final List<PillScheduleModel> _locallyAddedMedications = [];

  // Get user ID from shared preferences
  Future<String> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");

    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);
      String userId = userData["id"];
      print("User ID: $userId");
      return userId;
    } else {
      print("No user data found in SharedPreferences.");
      throw Exception("User not logged in");
    }
  }

  // Get token from shared preferences
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<PillScheduleModel>> getMedications() async {
    try {
      String userId = await _getUserId();
      String? token = await _getToken();

      print("Fetching medications for user: $userId");

      final response = await http.get(
        Uri.parse('$baseUrl/user/getmedications/$userId'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      print("API Response Status: ${response.statusCode}");
      print("API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        List<PillScheduleModel> apiMedications = [];

        if (responseData.containsKey('medications') &&
            responseData['medications'] is List) {
          final medications = responseData['medications'] as List;

          print("Found ${medications.length} medications in response");

          for (var medicationData in medications) {
            try {
              final medication = PillScheduleModel.fromJson(medicationData);
              print(
                  "Parsed medication: ${medication.name} at ${medication.intakeTime}");
              apiMedications.add(medication);
            } catch (e) {
              print("Error parsing medication: $e");
              print("Problematic data: $medicationData");
            }
          }
        }

        print(
            "Successfully parsed ${apiMedications.length} medications from API");
        return [...apiMedications, ..._locallyAddedMedications];
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        return [..._mockMedications, ..._locallyAddedMedications];
      }
    } catch (e) {
      print("Exception while fetching medications: $e");
      return [..._mockMedications, ..._locallyAddedMedications];
    }
  }

  // Schedule medication with fallback to local storage
  Future<List<PillScheduleModel>> scheduleMedications(
      String name, String dosage, String timeNotify, String frequency) async {
    try {
      String userId = await _getUserId();
      String? token = await _getToken();

      final response = await http
          .post(
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
          )
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (response.statusCode == 201) {
        Map<String, dynamic> data = json.decode(response.body);
        PillScheduleModel newMedication;

        // Handle different response structures
        if (data.containsKey("medication") && data["medication"] is Map) {
          if (data["medication"].containsKey("medication")) {
            // Original structure: data["medication"]["medication"]
            newMedication =
                PillScheduleModel.fromJson(data["medication"]["medication"]);
          } else {
            // Alternative structure: data["medication"]
            newMedication = PillScheduleModel.fromJson(data["medication"]);
          }
        } else {
          // Fallback: create medication locally with API response id if available
          String id = data.containsKey('id')
              ? data['id']
              : DateTime.now().millisecondsSinceEpoch.toString();
          newMedication =
              _createLocalMedication(name, dosage, timeNotify, frequency, id);
        }

        // Show notification
        sendInstantNotification(name, dosage);

        return [newMedication];
      } else {
        print("API Error: ${response.statusCode} - ${response.body}");
        // Create medication locally
        PillScheduleModel newMedication =
            _createLocalMedication(name, dosage, timeNotify, frequency);

        // Add to local list
        _locallyAddedMedications.add(newMedication);

        // Show notification
        sendInstantNotification(name, dosage);

        return [newMedication];
      }
    } catch (e) {
      print("Exception while scheduling medication: $e");
      // Create medication locally
      PillScheduleModel newMedication =
          _createLocalMedication(name, dosage, timeNotify, frequency);

      // Add to local list
      _locallyAddedMedications.add(newMedication);

      // Show notification
      sendInstantNotification(name, dosage);

      return [newMedication];
    }
  }

  // Create a local medication model when API fails
  PillScheduleModel _createLocalMedication(
      String name, String dosage, String timeNotify, String frequency,
      [String? id]) {
    // Format time to display format
    final timeParts = timeNotify.split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Convert to AM/PM format
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    String displayTime = '$displayHour:${timeParts[1]} $period';

    // Default values based on frequency
    int days = 0;
    switch (frequency.toLowerCase()) {
      case 'daily':
        days = 30; // Assume a month for daily medications
        break;
      case 'weekly':
        days = 7; // One week
        break;
      case 'monthly':
        days = 30; // One month
        break;
      default:
        days = 10; // Default
    }

    return PillScheduleModel(
      id: id ??
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(), // Generate ID if not provided
      createdAt: DateTime.now().toIso8601String(), // Generate current timestamp
      updatedAt: DateTime.now().toIso8601String(), // Ensure updatedAt is set
      name: name,
      intakeTime: displayTime,
      intakeDescription: "$dosage, take as directed",
      noOfDays: days,
      isReadByUser: false, // Default value for unread state
    );
  }

  // Send notification when medication is scheduled
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

  // Delete a medication (with fallback)
  Future<bool> deleteMedication(String medicationId) async {
    try {
      // First check if this is a locally added medication
      bool isLocalMedication =
          _locallyAddedMedications.any((med) => med.name == medicationId);

      if (isLocalMedication) {
        _locallyAddedMedications.removeWhere((med) => med.name == medicationId);
        return true;
      }

      // If not local, try to delete from API
      String userId = await _getUserId();
      String? token = await _getToken();

      final response = await http.delete(
        Uri.parse('$baseUrl/user/$userId/medications/$medicationId'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return true;
      } else {
        print(
            "API Error while deleting: ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      print("Exception while deleting medication: $e");
      return false;
    }
  }
}
