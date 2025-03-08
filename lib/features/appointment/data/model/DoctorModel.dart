class DoctorModel {
  final String doctorId;
  final String name;
  final int experience;
  final double ratings;
  final String contact;
  final String category;
  final String profileUrl;
  final List<Availability> availability;

  DoctorModel({
    required this.doctorId,
    required this.name,
    required this.experience,
    required this.ratings,
    required this.contact,
    required this.category,
    required this.profileUrl,
    required this.availability,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    var availabilityList = (json['availability'] as List)
        .map((availability) => Availability.fromJson(availability))
        .toList();

    return DoctorModel(
      doctorId: json['doctorId'],
      name: json['name'],
      experience: json['experience'],
      ratings: json['ratings'],
      contact: json['contact'],
      category: json['category'],
      profileUrl: json['profileUrl'],
      availability: availabilityList,
    );
  }
}

class Availability {
  final String date;
  final List<String> timeSlots;

  Availability({required this.date, required this.timeSlots});

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      date: json['date'],
      timeSlots: List<String>.from(json['timeSlots']),
    );
  }
}
