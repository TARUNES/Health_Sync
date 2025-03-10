import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart'; // Add this import
import 'package:health_sync_client/core/constants/assets.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:health_sync_client/core/utils/components/ProfileIcon.dart';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/DoctorProfile.dart';
import 'package:health_sync_client/features/home/data/model/booking_model.dart';
import 'package:health_sync_client/features/medical_records/presentation/screens/medicalRecords.dart';
import 'package:health_sync_client/features/medication/presentation/screens/MedicationAlert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  List<Booking> bookings = [];
  bool isLoading = true;
  String name = "Tarun"; // Default name
  String height = "164"; // Default name
  String weight = "59"; // Default name

  @override
  void initState() {
    super.initState();
    loadProfileData();
    fetchBookings();
  }

  Future<void> loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    String? profileData = prefs.getString('user');

    if (profileData != null) {
      Map<String, dynamic> decodedData = jsonDecode(profileData);
      setState(() {
        name = decodedData['name'] ?? "Tarun";
      });
    }
  }

  Future<void> loadFitnessData() async {
    final prefs = await SharedPreferences.getInstance();
    String? profileData = prefs.getString('profile_data');

    if (profileData != null) {
      Map<String, dynamic> decodedData = jsonDecode(profileData);
      setState(() {
        height = decodedData['height'] ?? "164";
        weight = decodedData['weight'] ?? "59";
      });
    }
  }

  Future<void> fetchBookings() async {
    Future<String?> getToken() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('token'); // Retrieve token from storage
    }

    String? token = await getToken();

    try {
      final response = await http.get(
        Uri.parse(
            'http://172.31.135.242:8080/user/bookings/users/c746b537-e359-42d1-9a96-2c0322b6f080'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          bookings = data.map((json) => Booking.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    // final DoctorModel doctor = DoctorModel(
    //   doctorId: "D001",
    //   name: "Dr. John Doe",
    //   experience: 10,
    //   ratings: 4.7,
    //   contact: "+1234567890",
    //   category: "Dentist",
    //   profileUrl: "https://picsum.photos/id/237/200/300.jpg",
    //   availability: [
    //     Availability(
    //       date: "2025-02-05",
    //       timeSlots: ["09:00 AM", "10:00 AM", "11:00 AM"],
    //     ),
    //     Availability(
    //       date: "2025-02-06",
    //       timeSlots: ["09:00 AM", "10:00 AM"],
    //     ),
    //     Availability(
    //       date: "2025-02-07",
    //       timeSlots: ["02:00 PM", "03:00 PM"],
    //     ),
    //   ],
    // );

    return Scaffold(
      backgroundColor: theme.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Section
              Row(
                children: [
                  ProfileIcon(
                    imageUrl: 'https://picsum.photos/id/238/200/300.jpg',
                    name: 'John Doe',
                    size: 60,
                    backgroundColor: theme.primary,
                    textColor: theme.onPrimary,
                    borderColor: Colors.grey,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning",
                        style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                          color: theme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: AppFonts.primaryFont,
                          color: theme.onPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              SizedBox(height: 30),

              // Health Overview Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Health Overview",
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onBackground,
                      fontWeight: FontWeight.w400,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    "Your Daily Health Stats",
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onPrimary,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),

                  // Stats and Grid Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Pie Chart Container
                      // Container(
                      //   height: screenHeight / 4.5,
                      //   width: screenWidth / 2.4,
                      //   decoration: BoxDecoration(
                      //     border: Border.all(
                      //       color: Color.fromARGB(255, 141, 144, 145),
                      //       width: .8,
                      //     ),
                      //     borderRadius: BorderRadius.circular(15),
                      //   ),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       SizedBox(
                      //         height: 120,
                      //         child: PieChart(
                      //           PieChartData(
                      //             sectionsSpace: 0,
                      //             centerSpaceRadius: 40,
                      //             sections: [
                      //               PieChartSectionData(
                      //                 value: 75, // 7500 steps of 10000
                      //                 color: theme.primary,
                      //                 radius: 20,
                      //                 showTitle: false,
                      //               ),
                      //               PieChartSectionData(
                      //                 value: 25, // remaining steps
                      //                 color: Colors.grey.shade300,
                      //                 radius: 20,
                      //                 showTitle: false,
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       ),
                      //       SizedBox(height: 8),
                      //       Text(
                      //         "7,500 / 10,000",
                      //         style: TextStyle(
                      //           fontFamily: AppFonts.primaryFont,
                      //           fontWeight: FontWeight.bold,
                      //           fontSize: 16,
                      //         ),
                      //       ),
                      //       Text(
                      //         "Daily Steps",
                      //         style: TextStyle(
                      //           fontFamily: AppFonts.primaryFont,
                      //           color: theme.onPrimary,
                      //           fontSize: 12,
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      BMICard(
                          weight: double.parse(weight),
                          height: double.parse(height)),

                      // Grid Buttons
                      SizedBox(
                        height: screenHeight / 5,
                        width: screenWidth / 2.4,
                        child: GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          padding: EdgeInsets.all(10),
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primary,
                              ),
                              child: Icon(
                                Icons.sync, // Git sync icon
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primary,
                              ),
                              child: Icon(
                                Icons.emergency_share_rounded, // Emergency icon
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primary,
                              ),
                              child: Icon(
                                Icons.settings,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MedicalRecordsScreen(
                                      patientId: "P001",
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: theme.primary,
                                ),
                                child: Icon(
                                  Icons.receipt_long,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // Medication Section (unchanged)
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth / 1.8,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 141, 144, 145),
                            width: .8,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Time For  \nyour next\nDose!',
                                  style: TextStyle(
                                    fontFamily: AppFonts.primaryFont,
                                    color: theme.onPrimary,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20,
                                  ),
                                  textAlign: TextAlign.left,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                                Image.asset(
                                  "assets/illustrations/time_med_illu.png",
                                  height: 80,
                                  width: 80,
                                  fit: BoxFit.cover,
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              height: 30,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: theme.primary,
                              ),
                              child: Center(
                                child: Text(
                                  "Mark as Taken ",
                                  style: TextStyle(
                                    fontFamily: AppFonts.primaryFont,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MedicationScreen(),
                              ));
                        },
                        child: Container(
                          height: screenHeight / 5.5,
                          width: screenWidth / 3.4,
                          padding: const EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: theme.primary,
                            border: Border.all(
                              color: Color(0xffDCE9EC),
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment
                                .center, // Center content vertically
                            children: [
                              Image.asset(
                                'assets/illustrations/goldenpill.png',
                                height: 76,
                                width: 85,
                                fit: BoxFit.fill,
                              ),
                              Text(
                                "   3\npills",
                                style: TextStyle(
                                  fontFamily: AppFonts.primaryFont,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Upcoming Appintment",
                    style: TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: theme.onPrimary,
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: 2,
                  //     itemBuilder: (context, index) {
                  //       final booking = bookings[index];
                  //       final doctor = booking.doctor;

                  //       return
                  if (bookings.isNotEmpty)
                    DoctorCard(
                        doctor: bookings[0].doctor,
                        onTap: () {
                          showAppointmentDetails(context, bookings[0]);
                        })
                  //     },
                  //   ),
                  // )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorCard({Key? key, required this.doctor, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xffECEEEF), width: 2),
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: theme.primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Hero(
                tag: "doctor_image_${doctor.id}",
                child: Material(
                  color: Colors.transparent,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child:
                        // doctor.profileUrl.isNotEmpty
                        //     ? Image.network(
                        //         doctor.profileUrl,
                        //         errorBuilder: (context, error, stackTrace) {
                        //           return const CircleAvatar(
                        //             radius: 30,
                        //             backgroundColor: Colors.grey,
                        //             child: Icon(Icons.person, size: 30, color: Colors.white),
                        //           );
                        //         },
                        //         fit: BoxFit.cover,
                        //       )
                        //     :
                        Icon(Icons.person, color: theme.primaryColor, size: 30),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: const TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: Color(0xff2A365B),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    doctor.specialization,
                    style: const TextStyle(
                      fontFamily: AppFonts.primaryFont,
                      color: Color(0xff2A365B),
                      fontWeight: FontWeight.w300,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showAppointmentDetails(BuildContext context, Booking appointment) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Appointment Details",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            _detailRow("Doctor", appointment.doctor.name),
            _detailRow("Specialization", appointment.doctor.specialization),
            _detailRow("Hospital", appointment.doctor.hospitalName),
            _detailRow("Date", appointment.bookingDate.split(' ')[0]),
            _detailRow("Time",
                "${appointment.bookingStartTime} - ${appointment.bookingEndTime}"),
            _detailRow("Status", appointment.status),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Close"),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _detailRow(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: Colors.grey[700])),
      ],
    ),
  );
}

class BMICard extends StatelessWidget {
  final double weight; // in kg
  final double height; // in meters

  const BMICard({Key? key, required this.weight, required this.height})
      : super(key: key);

  double calculateBMI() {
    return weight / (height * height);
  }

  Color getBMICategoryColor(double bmi) {
    if (bmi < 18.5) return Colors.blue; // Underweight
    if (bmi < 24.9) return Colors.green; // Normal weight
    if (bmi < 29.9) return Colors.orange; // Overweight
    return Colors.red; // Obese
  }

  String getBMICategory(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    double bmi = calculateBMI();
    Color bmiColor = getBMICategoryColor(bmi);
    String bmiCategory = getBMICategory(bmi);

    return Container(
      height: 180,
      width: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400, width: 1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(
                    value: bmi, // BMI value as part of chart
                    color: bmiColor,
                    radius: 20,
                    showTitle: false,
                  ),
                  PieChartSectionData(
                    value: 40 - bmi, // Remaining space
                    color: Colors.grey.shade300,
                    radius: 20,
                    showTitle: false,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "BMI: ${bmi.toStringAsFixed(1)}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            bmiCategory,
            style: TextStyle(color: bmiColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
