// class DoctorModel {
//   final String doctorId;
//   final String name;
//   final int experience;
//   final double ratings;
//   final String contact;
//   final String category;
//   final String profileUrl;
//   final List<Availability> availability;

//   DoctorModel({
//     required this.doctorId,
//     required this.name,
//     required this.experience,
//     required this.ratings,
//     required this.contact,
//     required this.category,
//     required this.profileUrl,
//     required this.availability,
//   });

//   factory DoctorModel.fromJson(Map<String, dynamic> json) {
//     var availabilityList = (json['availability'] as List)
//         .map((availability) => Availability.fromJson(availability))
//         .toList();

//     return DoctorModel(
//       doctorId: json['doctorId'],
//       name: json['name'],
//       experience: json['experience'],
//       ratings: json['ratings'],
//       contact: json['contact'],
//       category: json['category'],
//       profileUrl: json['profileUrl'],
//       availability: availabilityList,
//     );
//   }
// }

// class Availability {
//   final String date;
//   final List<String> timeSlots;

//   Availability({required this.date, required this.timeSlots});

//   factory Availability.fromJson(Map<String, dynamic> json) {
//     return Availability(
//       date: json['date'],
//       timeSlots: List<String>.from(json['timeSlots']),
//     );
//   }
// }
class DoctorModel {
  final String id;
  final String name;
  final String specialization;
  final int experience;
  final String qualification;
  final String hospitalName;

  DoctorModel({
    required this.id,
    required this.name,
    required this.specialization,
    required this.experience,
    required this.qualification,
    required this.hospitalName,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'],
      name: json['name'],
      specialization: json['specialization'],
      experience: json['experience'],
      qualification: json['qualification'],
      hospitalName: json['hospital_name'],
    );
  }
}
