// import 'dart:convert';
// import 'package:health_sync_client/features/home/data/model/pillSchedule.dart';
// import 'package:http/http.dart' as http;

// class MedicationService {
//   static const String apiUrl =
//       "https://example.com/api/medications"; // Replace with actual API

//   Future<List<PillScheduleModel>> fetchMedications() async {
//     final response = await http.get(Uri.parse(apiUrl));

//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       return data.map((json) => PillScheduleModel.fromJson(json)).toList();
//     } else {
//       throw Exception("Failed to load medications");
//     }
//   }
// }
import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';

class MedicationService {
  Future<List<PillScheduleModel>> fetchMedications() async {
    await Future.delayed(Duration(seconds: 1)); // Simulate API delay
    return [
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
  }
}
