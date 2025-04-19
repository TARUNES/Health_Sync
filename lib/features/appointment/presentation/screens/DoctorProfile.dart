// doctor_profile_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/presentation/widgets/CustomDateChip.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorProfileScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  String? selectedDate;
  Set<String> selectedTimeSlots = {};
  // @override
  // void initState() {
  //   super.initState();

  //   // if (widget.doctor.availability.isNotEmpty) {
  //   //   selectedDate = widget.doctor.availability.first.date;
  //   // }
  // }
  List<Availability> availabilityList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAvailability();
  }

  Future<void> sendSelectedDate() async {
    String userid = "";

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? doctorString = prefs.getString("user");

    if (doctorString != null) {
      Map<String, dynamic> doctorData = jsonDecode(doctorString);
      userid = doctorData["id"]; // Assuming "id" is stored as a String
      print("Doctor ID: $userid");
    } else {
      print("No doctor data found in SharedPreferences.");
    }

    if (selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a date first')),
      );
      return;
    }

    // Find the corresponding booking ID for the selected date
    final selectedAvailability = availabilityList.firstWhere(
      (availability) => availability.availabilityDate == selectedDate,
      orElse: () => Availability(
          id: '',
          startTime: '',
          endTime: "",
          availabilityDate: "",
          doctorId: "",
          isBooked: false), // Default empty object
    );

    if (selectedAvailability.id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No booking ID found for the selected date')),
      );
      return;
    }

    final String bookingid = selectedAvailability.id;

    final String apiUrl =
        "https://10.0.2.2:8443/user/bookings/users/${userid}/availability/${bookingid}";

    // final token =
    //     "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiOTc3NWE4MjctNjZjMC00OTdiLTk4YTQtNzIwZjQ1YjE5MzAwIiwicm9sZSI6InVzZXIiLCJlbWFpbCI6InRhcnVuZXNvZmZpY2lhbEBnbWFpbC5jb20iLCJleHAiOjE3NDE2MzA0OTZ9.dTsoSOetbLB4p48KrAyfwQkIQaJA5-Xoj8J6KaDGDfw";
    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token'); // Retrieve token from storage
    }

    String? token = await getToken();
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Appointment Scheduled successfully!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.body)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> fetchAvailability() async {
    final String url =
        'https://10.0.2.2:8443/doctors/${widget.doctor.id}/availability/';

    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token'); // Retrieve token from storage
    }

    String? token = await getToken();

    print(token);

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          availabilityList =
              data.map((json) => Availability.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load availability');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching availability: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        backgroundColor: theme.background,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: "doctor_image_${widget.doctor.id}",
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          width: screenWidth / 3,
                          height: screenHeight / 6,
                          decoration: BoxDecoration(
                            color: theme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child:
                                // widget.doctor.profileUrl.isNotEmpty
                                //     ? Image.network(
                                //         "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
                                //         errorBuilder: (context, error, stackTrace) {
                                //           return CircleAvatar(
                                //             radius: 50,
                                //             child: Icon(
                                //               Icons.person,
                                //               size: 50,
                                //               color: Colors.white,
                                //             ),
                                //             backgroundColor: Colors.grey,
                                //           );
                                //         },
                                //         fit: BoxFit.cover,
                                //       )
                                // :
                                Icon(
                              Icons.person,
                              color: theme.primary,
                              size: 50,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.doctor.name,
                              style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  color: theme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                            Text(
                              widget.doctor.specialization,
                              style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  color: Color(0xffA0A0A4),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "\$${widget.doctor.experience}/hr",
                          style: TextStyle(
                              fontFamily: AppFonts.primaryFont,
                              color: theme.primary,
                              fontWeight: FontWeight.w400,
                              fontSize: 16),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.doctor.experience.toString()} years',
                          style: TextStyle(
                              fontFamily: AppFonts.primaryFont,
                              color: theme.onPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                        Text(
                          "Experience",
                          style: TextStyle(
                              fontFamily: AppFonts.primaryFont,
                              color: Color(0xffA0A0A4),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            SizedBox(
                              width: 1,
                            ),
                            Text(
                              "4.5",
                              style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  color: theme.onPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                              textAlign: TextAlign.left,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
                        Text(
                          "Ratings",
                          style: TextStyle(
                              fontFamily: AppFonts.primaryFont,
                              color: Color(0xffA0A0A4),
                              fontWeight: FontWeight.w400,
                              fontSize: 14),
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Availability",
                  style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  textAlign: TextAlign.left,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                SizedBox(
                  height: 20,
                ),
                isLoading
                    ? CircularProgressIndicator()
                    : Wrap(
                        spacing: 8.0,
                        children: availabilityList
                            .map(
                                (availability) => availability.availabilityDate)
                            .toSet() // Remove duplicates
                            .map((date) {
                          return CustomDateChip(
                            label: date,
                            isSelected: selectedDate == date,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedDate = selected ? date : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                SizedBox(height: 20),
                Text(
                  "Timing",
                  style: TextStyle(
                    fontFamily: AppFonts.primaryFont,
                    color: theme.onPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                selectedDate != null
                    ? GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        itemCount: availabilityList
                            .where((slot) => !slot.isBooked)
                            .toList()
                            .where((availability) =>
                                availability.availabilityDate == selectedDate)
                            .length,
                        itemBuilder: (context, index) {
                          final availability = availabilityList
                              .where((availability) =>
                                  availability.availabilityDate == selectedDate)
                              .toList()[index];

                          final DateFormat timeFormat =
                              DateFormat('h a'); // e.g., 8 AM

                          final startTimeFormatted = timeFormat.format(
                              DateFormat("HH:mm:ss")
                                  .parse(availability.startTime));
                          final endTimeFormatted = timeFormat.format(
                              DateFormat("HH:mm:ss")
                                  .parse(availability.endTime));

                          final timeSlot =
                              "$startTimeFormatted - $endTimeFormatted";

                          return ChoiceChip(
                            showCheckmark: false,
                            label: Text(
                              timeSlot,
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                color: selectedTimeSlots.contains(timeSlot)
                                    ? Colors.white
                                    : theme.onPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            selected: selectedTimeSlots.contains(timeSlot),
                            onSelected: (bool selected) {
                              setState(() {
                                if (selected) {
                                  selectedTimeSlots.add(timeSlot);
                                } else {
                                  selectedTimeSlots.remove(timeSlot);
                                }
                              });
                            },
                            selectedColor: theme.primary,
                            backgroundColor: theme.background,
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 40),
                InkWell(
                  onTap: () => sendSelectedDate(),
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    width: double.infinity, // Occupy full width
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.2),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      "Book Appointment",
                      style: TextStyle(
                        fontFamily: AppFonts.primaryFont,
                        color: theme.background,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center, // Center the text
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Availability {
  final String id;
  final String doctorId;
  final String availabilityDate;
  final String startTime;
  final String endTime;
  final bool isBooked;

  Availability({
    required this.id,
    required this.doctorId,
    required this.availabilityDate,
    required this.startTime,
    required this.endTime,
    required this.isBooked,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      id: json['id'],
      doctorId: json['doctor_id'],
      availabilityDate: json['availability_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isBooked: json['is_booked'],
    );
  }
}
