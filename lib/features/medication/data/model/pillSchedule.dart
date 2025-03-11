class PillScheduleModel {
  final String id;
  final String name;
  final String intakeTime;
  final String intakeDescription;
  final int noOfDays;
  final bool isReadByUser;
  final String createdAt;
  final String updatedAt;

  PillScheduleModel({
    required this.id,
    required this.name,
    required this.intakeTime,
    required this.intakeDescription,
    required this.noOfDays,
    required this.isReadByUser,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PillScheduleModel.fromJson(Map<String, dynamic> json) {
    // Format the time for display (convert from 24-hour format to 12-hour with AM/PM)
    String timeToDisplay =
        _formatTimeForDisplay(json['TimeToNotify'] ?? '00:00:00');

    // Get the dosage and frequency to create a meaningful description
    String dosage = json['Dosage'] ?? '';
    String frequency = json['Frequency'] ?? 'daily';
    String intakeDescription =
        dosage.isNotEmpty ? "$dosage, take $frequency" : "Take $frequency";

    // Determine number of days based on frequency
    int days = 30; // Default for daily
    if (frequency.toLowerCase() == "weekly") {
      days = 7;
    } else if (frequency.toLowerCase() == "monthly") {
      days = 30;
    }

    return PillScheduleModel(
      id: json['ID']?.toString() ?? '',
      name: json['MedicationName'] ?? 'Unknown',
      intakeTime: timeToDisplay,
      intakeDescription: intakeDescription,
      noOfDays: days,
      isReadByUser: json['IsReadbyuser'] ?? false,
      createdAt: json['CreatedAt'] ?? '',
      updatedAt: json['UpdatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'MedicationName': name,
      'TimeToNotify': intakeTime,
      'IntakeDescription': intakeDescription,
      'NoOfDays': noOfDays,
      'IsReadbyuser': isReadByUser,
      'CreatedAt': createdAt,
      'UpdatedAt': updatedAt,
    };
  }

  // Helper method to format time from HH:MM:SS to HH:MM AM/PM
  static String _formatTimeForDisplay(String timeNotify) {
    try {
      final timeParts = timeNotify.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      // Convert to AM/PM format
      String period = hour >= 12 ? 'PM' : 'AM';
      int displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      String displayMinute = minute.toString().padLeft(2, '0');
      return '$displayHour:$displayMinute $period';
    } catch (e) {
      return '12:00 AM'; // Default fallback time
    }
  }
}
