class PillScheduleModel {
  final String name;
  final String intakeTime;
  final String intakeDescription;
  final int noOfDays;

  PillScheduleModel({
    required this.name,
    required this.intakeTime,
    required this.intakeDescription,
    required this.noOfDays,
  });

  factory PillScheduleModel.fromJson(Map<String, dynamic> json) {
    return PillScheduleModel(
      name: json['name'],
      intakeTime: json['intakeTime'],
      intakeDescription: json['intakeDescription'],
      noOfDays: json['noOfDays'],
    );
  }
}
