// // import 'dart:convert';
// // import 'package:health_sync_client/features/home/data/model/pillSchedule.dart';
// // import 'package:http/http.dart' as http;

// // class DoctorService {
// //   static const String apiUrl =
// //       "https://example.com/api/medications"; // Replace with actual API

// //   Future<List<DoctorModel>> fetchDoctors() async {
// //     final response = await http.get(Uri.parse(apiUrl));

// //     if (response.statusCode == 200) {
// //       List<dynamic> data = jsonDecode(response.body);
// //       return data.map((json) => DoctorModel.fromJson(json)).toList();
// //     } else {
// //       throw Exception("Failed to load medications");
// //     }
// //   }
// // }
// import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
// import 'package:health_sync_client/features/medication/data/model/pillSchedule.dart';

// class DoctorService {
//   Future<List<DoctorModel>> fetchDoctors() async {
//     await Future.delayed(Duration(seconds: 1)); // Simulate API delay
//     return [
//       DoctorModel(
//         doctorId: "D001",
//         name: "Dr. John Doe",
//         experience: 10,
//         ratings: 4.7,
//         contact: "+1234567890",
//         category: "Dentist",
//         profileUrl:
//             "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-05",
//             timeSlots: ["09:00 AM", "10:00 AM", "11:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-06",
//             timeSlots: ["09:00 AM", "10:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-07",
//             timeSlots: ["02:00 PM", "03:00 PM"],
//           ),
//         ],
//       ),
//       DoctorModel(
//         doctorId: "D002",
//         name: "Dr. Jane Smith",
//         experience: 8,
//         ratings: 4.5,
//         contact: "+1987654321",
//         category: "Cardiologist",
//         profileUrl:
//             "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-05",
//             timeSlots: ["09:00 AM", "10:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-06",
//             timeSlots: ["02:00 PM", "03:00 PM"],
//           ),
//         ],
//       ),
//       DoctorModel(
//         doctorId: "D003",A
//         name: "Dr. Alice Brown",
//         experience: 12,
//         ratings: 4.9,
//         contact: "+1122334455",
//         category: "Ophthalmologist",
//         profileUrl:
//             "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-05",
//             timeSlots: ["08:00 AM", "09:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-07",
//             timeSlots: ["02:00 PM", "03:00 PM"],
//           ),
//         ],
//       ),
//       DoctorModel(
//         doctorId: "D004",
//         name: "Dr. Robert Wilson",
//         experience: 15,
//         ratings: 4.8,
//         contact: "+1223344556",
//         category: "Neurologist",
//         profileUrl:
//             "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-06",
//             timeSlots: ["09:00 AM", "10:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-07",
//             timeSlots: ["02:00 PM", "03:00 PM"],
//           ),
//         ],
//       ),
//       DoctorModel(
//         doctorId: "D005",
//         name: "Dr. Emily Davis",
//         experience: 7,
//         ratings: 4.6,
//         contact: "+1445566778",
//         category: "Pediatrician",
//         profileUrl:
//             "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-05",
//             timeSlots: ["09:00 AM", "10:00 AM"],
//           ),
//           Availability(
//             date: "2025-02-06",
//             timeSlots: ["01:00 PM", "02:00 PM"],
//           ),
//         ],
//       ),
//       DoctorModel(
//         doctorId: "D006",
//         name: "Dr. Michael Johnson",
//         experience: 9,
//         ratings: 4.4,
//         contact: "+1556677889",
//         category: "Orthopedic",
//         profileUrl: "https://picsum.photos/id/238/200/300.jpg",
//         availability: [
//           Availability(
//             date: "2025-02-05",
//             timeSlots: ["10:00 AM", "11:00 AM - 12:00 PM"],
//           ),
//           Availability(
//             date: "2025-02-06",
//             timeSlots: ["01:00 PM", "02:00 PM"],
//           ),
//         ],
//       ),
//     ];
//   }
// }
