import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/domain/repository/DoctorRepo.dart';
import 'package:health_sync_client/features/appointment/presentation/screens/DoctorProfile.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  final DoctorRepo _doctorRepo = DoctorRepo();
  int selectedSpecialty = 0;
  final List<String> specialties = [
    'General Surgeon',
    'Dermatologist',
    'Cardiologist',
    'Pediatrician',
    'Neurologist'
  ];

  final List<Map<String, dynamic>> doctors = [
    {
      'name': 'Dr. Sarah Wilson',
      'specialty': 'General Surgeon',
      'rating': 4.8,
      'experience': '8 years'
    },
    {
      'name': 'Dr. John Smith',
      'specialty': 'Dermatologist',
      'rating': 4.9,
      'experience': '12 years'
    },
    {
      'name': 'Dr. Emily Brown',
      'specialty': 'Cardiologist',
      'rating': 4.7,
      'experience': '10 years'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: theme.background,
        //   leading: const Icon(Icons.arrow_back_ios),
        //   centerTitle: true,
        //   title: Text(
        //     "Appointment Schedule",
        //     style: TextStyle(
        //       fontFamily: AppFonts.primaryFont,
        //       color: theme.onBackground,
        //       fontWeight: FontWeight.w400,
        //       fontSize: 18,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: screenHeight / 3.2,
                  width: screenWidth,
                  decoration: BoxDecoration(
                      color: theme.primary.withOpacity(.6),
                      borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Let\'s Find Your \nDocter!',
                        style: TextStyle(
                            fontFamily: AppFonts.primaryFont,
                            color: const Color(0xff2A365B),
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.onSecondary,
                            ),
                            child: const Icon(
                              Icons.medical_services_rounded,
                              size: 25,
                              color: Colors.amber,
                            ),
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.onSecondary,
                            ),
                            child: const Icon(
                              Icons.favorite_rounded,
                              size: 25,
                              color: Colors.pink,
                            ),
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.onSecondary,
                            ),
                            child: const Icon(
                              Icons.remove_red_eye_rounded,
                              size: 25,
                              color: Colors.purple,
                            ),
                          ),
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: theme.onSecondary,
                            ),
                            child: const Icon(
                              Icons.vaccines,
                              size: 25,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search Doctor',
                              hintStyle: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 16,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.grey.shade400,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Specialty Choice Chips
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: specialties.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          side: BorderSide(
                            color: selectedSpecialty == index
                                ? theme.primary
                                : theme.onPrimary.withOpacity(0.3),
                            width: 1, // Border width
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30), // Oval shape
                          ),
                          showCheckmark: false,
                          label: Text(
                            specialties[index],
                            style: TextStyle(
                              color: selectedSpecialty == index
                                  ? Colors.black
                                  : theme.onBackground,
                            ),
                          ),
                          selected: selectedSpecialty == index,
                          onSelected: (selected) {
                            setState(() {
                              selectedSpecialty = index;
                            });
                          },
                          backgroundColor: Colors.white,
                          selectedColor: theme.primary,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                FutureBuilder<List<DoctorModel>>(
                  future: _doctorRepo.getDoctors(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No doctors available"));
                    }

                    final doctors = snapshot.data!;

                    return Expanded(
                      child: ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (context, index) {
                          final doctor = doctors[index];

                          return GestureDetector(
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
                                              color: theme.primary
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: doctor
                                                      .profileUrl.isNotEmpty
                                                  ? Image.network(
                                                      doctor.profileUrl,
                                                      errorBuilder: (context,
                                                          error, stackTrace) {
                                                        return CircleAvatar(
                                                          radius: 30,
                                                          child: Icon(
                                                            Icons.person,
                                                            size: 30,
                                                            color: Colors.white,
                                                          ),
                                                          backgroundColor:
                                                              Colors.grey,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            doctor.name,
                                            style: const TextStyle(
                                                fontFamily:
                                                    AppFonts.primaryFont,
                                                color: const Color(0xff2A365B),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            doctor.category,
                                            style: TextStyle(
                                                fontFamily:
                                                    AppFonts.primaryFont,
                                                color: const Color(0xff2A365B),
                                                fontWeight: FontWeight.w300,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ));
  }
}
