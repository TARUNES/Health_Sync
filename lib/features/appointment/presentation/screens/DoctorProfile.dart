// doctor_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:health_sync_client/features/appointment/data/model/DoctorModel.dart';
import 'package:health_sync_client/features/appointment/presentation/widgets/CustomDateChip.dart';

class DoctorProfileScreen extends StatefulWidget {
  final DoctorModel doctor;

  const DoctorProfileScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<DoctorProfileScreen> createState() => _DoctorProfileScreenState();
}

class _DoctorProfileScreenState extends State<DoctorProfileScreen> {
  String? selectedDate;
  Set<String> selectedTimeSlots = {};
  @override
  void initState() {
    super.initState();

    if (widget.doctor.availability.isNotEmpty) {
      selectedDate = widget.doctor.availability.first.date;
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
                      tag: "doctor_image_${widget.doctor.doctorId}",
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
                            child: widget.doctor.profileUrl.isNotEmpty
                                ? Image.network(
                                    "https://img.freepik.com/free-photo/doctor-smiling-with-stethoscope_1154-36.jpg",
                                    errorBuilder: (context, error, stackTrace) {
                                      return CircleAvatar(
                                        radius: 50,
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
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
                              widget.doctor.category,
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
                          "\$20/hr",
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
                              widget.doctor.ratings.toString(),
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
                Wrap(
                  spacing: 8.0,
                  children: widget.doctor.availability
                      .map((Availability availability) {
                    return CustomDateChip(
                      label: availability.date,
                      isSelected: selectedDate == availability.date,
                      onSelected: (bool selected) {
                        setState(() {
                          selectedDate = selected ? availability.date : null;
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
                          crossAxisSpacing: 8.0, // Space between columns
                          mainAxisSpacing: 8.0, // Space between rows
                        ),
                        itemCount: widget.doctor.availability
                            .where((availability) =>
                                availability.date == selectedDate)
                            .expand((availability) => availability.timeSlots)
                            .length,
                        itemBuilder: (context, index) {
                          final timeSlot = widget.doctor.availability
                              .where((availability) =>
                                  availability.date == selectedDate)
                              .expand((availability) => availability.timeSlots)
                              .toList()[index];

                          return ChoiceChip(
                            showCheckmark: false,
                            label: Text(
                              timeSlot,
                              style: TextStyle(
                                fontFamily: AppFonts.primaryFont,
                                color: selectedTimeSlots.contains(timeSlot)
                                    ? theme.background
                                    : theme.onPrimary,
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                              ),
                            ),
                            selected: selectedTimeSlots.contains(timeSlot),
                            onSelected: (isSelected) {
                              setState(() {
                                if (isSelected) {
                                  selectedTimeSlots.add(timeSlot);
                                } else {
                                  selectedTimeSlots.remove(timeSlot);
                                }
                              });
                            },
                            selectedColor: theme.primary,
                            backgroundColor: theme.background,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30), // Oval shape
                            ),
                            side: BorderSide(
                              color: selectedTimeSlots.contains(timeSlot)
                                  ? theme.primary
                                  : theme.onPrimary.withOpacity(
                                      0.5), // Border color based on selection
                              width: 1, // Border width
                            ),
                          );
                        },
                      )
                    : Container(),
                SizedBox(height: 40),
                InkWell(
                  onTap: () {},
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
