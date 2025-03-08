import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';
import 'package:intl/intl.dart'; // Import to use date formatting

class CustomDateChip extends StatelessWidget {
  final String label; // Label in the format yyyy-MM-dd
  final bool isSelected;
  final void Function(bool) onSelected;

  const CustomDateChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;
    Size screenSize = MediaQuery.of(context).size;
    double screenWidth = screenSize.width;
    double screenHeight = screenSize.height;

    // Parse the date string
    DateTime parsedDate = DateFormat('yyyy-MM-dd').parse(label);

    // Extract day and date
    String day = DateFormat('EEE')
        .format(parsedDate); // Day in abbreviated form (Mon, Tue, etc.)
    String date = DateFormat('d')
        .format(parsedDate); // Day of the month (1, 2, 3, ..., 31)

    return GestureDetector(
      onTap: () => onSelected(!isSelected),
      child: Container(
        height: screenHeight / 10,
        width: screenWidth / 6,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.background : theme.background,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: isSelected ? 2 : 1,
            color:
                isSelected ? theme.primary : theme.secondary.withOpacity(0.5),
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: theme.primary.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  color: isSelected ? theme.primary : theme.onPrimary,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            ),
            Text(
              date,
              style: TextStyle(
                  fontFamily: AppFonts.primaryFont,
                  color: isSelected ? theme.primary : theme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
