import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fl_chart/fl_chart.dart'; // Add this import
import 'package:health_sync_client/core/constants/assets.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:health_sync_client/core/utils/components/ProfileIcon.dart';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/DoctorProfile.dart';
import 'package:health_sync_client/features/medical_records/presentation/screens/medicalRecords.dart';
import 'package:health_sync_client/features/medication/presentation/screens/MedicationAlert.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;
    final DoctorModel doctor = DoctorModel(
      doctorId: "D001",
      name: "Dr. John Doe",
      experience: 10,
      ratings: 4.7,
      contact: "+1234567890",
      category: "Dentist",
      profileUrl: "https://picsum.photos/id/237/200/300.jpg",
      availability: [
        Availability(
          date: "2025-02-05",
          timeSlots: ["09:00 AM", "10:00 AM", "11:00 AM"],
        ),
        Availability(
          date: "2025-02-06",
          timeSlots: ["09:00 AM", "10:00 AM"],
        ),
        Availability(
          date: "2025-02-07",
          timeSlots: ["02:00 PM", "03:00 PM"],
        ),
      ],
    );

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
                        "Selvan",
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
                      Container(
                        height: screenHeight / 4.5,
                        width: screenWidth / 2.4,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 141, 144, 145),
                            width: .8,
                          ),
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
                                      value: 75, // 7500 steps of 10000
                                      color: theme.primary,
                                      radius: 20,
                                      showTitle: false,
                                    ),
                                    PieChartSectionData(
                                      value: 25, // remaining steps
                                      color: Colors.grey.shade300,
                                      radius: 20,
                                      showTitle: false,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "7,500 / 10,000",
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Daily Steps",
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                color: theme.onPrimary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

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

                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DoctorProfileScreen(doctor: doctor),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 15),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: const Color(0xffECEEEF), width: 2),
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
                                color: theme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Hero(
                                tag:
                                    "doctor_image_${doctor.doctorId}", // Make sure this matches exactly
                                child: Material(
                                  // Wrap with Material widget
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: theme.primary.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: doctor.profileUrl.isNotEmpty
                                          ? Image.network(
                                              "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return CircleAvatar(
                                                  radius: 30,
                                                  child: Icon(
                                                    Icons.person,
                                                    size: 30,
                                                    color: Colors.white,
                                                  ),
                                                  backgroundColor: Colors.grey,
                                                );
                                              },
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.person,
                                              color: theme.primary,
                                              size: 30,
                                            ),
                                    ),
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
                                        color: const Color(0xff2A365B),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    doctor.category,
                                    style: TextStyle(
                                        fontFamily: AppFonts.primaryFont,
                                        color: const Color(0xff2A365B),
                                        fontWeight: FontWeight.w300,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
