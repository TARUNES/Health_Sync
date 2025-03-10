import 'dart:convert';

import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';

class Booking {
  final String id;
  final String userId;
  final String doctorId;
  final String bookingDate;
  final String bookingStartTime;
  final String bookingEndTime;
  final String status;
  final DoctorModel doctor;

  Booking({
    required this.id,
    required this.userId,
    required this.doctorId,
    required this.bookingDate,
    required this.bookingStartTime,
    required this.bookingEndTime,
    required this.status,
    required this.doctor,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      userId: json['user_id'],
      doctorId: json['doctor_id'],
      bookingDate: json['booking_date'],
      bookingStartTime: json['booking_start_time'],
      bookingEndTime: json['booking_end_time'],
      status: json['status'],
      doctor: DoctorModel.fromJson(json['doctor']),
    );
  }
}
