import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';

import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';
import 'package:health_sync_client/features/medication/domain/repository/pillScheduleRepo.dart';

class MedicationScreen extends StatefulWidget {
  const MedicationScreen({super.key});

  @override
  State<MedicationScreen> createState() => _MedicationScreenState();
}

class _MedicationScreenState extends State<MedicationScreen> {
  late Future<List<PillScheduleModel>> _futureMedications;
  final Map<String, List<PillScheduleModel>> _groupedMedications = {};
  final MedicationRepository _repository = MedicationRepository();
  final TextEditingController _medicationNameController =
      TextEditingController();
  final TextEditingController _intakeController = TextEditingController();
  TimeOfDay? _selectedTime;

  String? _selectedTimeSlot;
  String? _selectedIntake;

  // List of pill images to cycle through
  final List<String> _pillImages = [
    'assets/illustrations/bluepill.png',
    'assets/illustrations/goldenpill.png',
    'assets/illustrations/brownpill.png',
  ];

  // List of time slots and intake options
  final List<String> _timeSlots = ['Morning', 'Afternoon', 'Evening', 'Night'];
  final List<String> _intakeOptions = ['Before Food', 'After Food'];

  @override
  void initState() {
    super.initState();
    _futureMedications = _repository.getMedications();
  }

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _showAddMedicationForm(BuildContext context, ColorScheme theme) {
    showModalBottomSheet(
      backgroundColor: theme.background,
      isScrollControlled: true,
      context: context,
      builder: (context) {
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
                Text(
                  'Medication intake:',
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
                  children: _intakeOptions.map((intake) {
                    return ChoiceChip(
                      label: Text(intake),
                      selected: _selectedIntake == intake,
                      onSelected: (selected) {
                        setState(() {
                          _selectedIntake = selected ? intake : null;
                        });
                      },
                      selectedColor: theme.secondary,
                      labelStyle: TextStyle(
                        color: _selectedIntake == intake
                            ? theme.onSecondary
                            : theme.onBackground,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                Text(
                  'Time slot:',
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
                  children: _timeSlots.map((slot) {
                    return ChoiceChip(
                      label: Text(slot),
                      selected: _selectedTimeSlot == slot,
                      onSelected: (selected) {
                        setState(() {
                          _selectedTimeSlot = selected ? slot : null;
                        });
                      },
                      selectedColor: theme.secondary,
                      labelStyle: TextStyle(
                        color: _selectedTimeSlot == slot
                            ? theme.onSecondary
                            : theme.onBackground,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                InkWell(
                  onTap: () => _selectTime(context),
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
                Row(
                  children: [
                    Text(
                      'No of intake:',
                      style: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                        color: theme.onBackground,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                        width: 10), // Use width instead of height inside Row
                    Expanded(
                      child: TextField(
                        controller: _intakeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'in Quantity',
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
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                    onPressed: () {
                      // Add validation and save logic here
                      Navigator.pop(context);
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
