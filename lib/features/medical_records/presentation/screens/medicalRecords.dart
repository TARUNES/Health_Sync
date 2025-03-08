import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MedicalRecordsScreen extends StatefulWidget {
  final String patientId;

  const MedicalRecordsScreen({
    Key? key,
    required this.patientId,
  }) : super(key: key);

  @override
  State<MedicalRecordsScreen> createState() => _MedicalRecordsScreenState();
}

class _MedicalRecordsScreenState extends State<MedicalRecordsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Sample medical records data
  List<MedicalRecord> _records = [
    MedicalRecord(
      id: 'REC123456',
      title: 'Annual Physical Examination',
      date: DateTime(2024, 1, 15),
      doctor: 'Dr. Sarah Smith',
      facility: 'City General Hospital',
      type: RecordType.examination,
      notes:
          'Patient is in good health overall. Blood pressure is slightly elevated (130/85). Recommended lifestyle changes including reduced sodium intake and increased exercise.',
      attachments: ['Blood work report', 'ECG results'],
      followUpDate: DateTime(2025, 1, 15),
    ),
    MedicalRecord(
      id: 'REC123457',
      title: 'Diabetes Management Checkup',
      date: DateTime(2023, 11, 10),
      doctor: 'Dr. Michael Johnson',
      facility: 'Endocrinology Associates',
      type: RecordType.consultation,
      notes:
          'HbA1c levels at 6.8% (improved from 7.2%). Patient is adhering to medication regimen. Continue current treatment plan with follow-up in 3 months.',
      attachments: ['HbA1c lab results', 'Glucose monitoring chart'],
      followUpDate: DateTime(2024, 2, 10),
    ),
    MedicalRecord(
      id: 'REC123458',
      title: 'Dental Cleaning',
      date: DateTime(2023, 9, 22),
      doctor: 'Dr. Jennifer Lee',
      facility: 'Bright Smile Dental',
      type: RecordType.dentistry,
      notes:
          'Routine cleaning performed. No cavities detected. Mild gingivitis on lower left quadrant - recommended improved flossing technique.',
      attachments: ['Dental X-rays'],
      followUpDate: DateTime(2024, 3, 22),
    ),
    MedicalRecord(
      id: 'REC123459',
      title: 'COVID-19 Vaccination',
      date: DateTime(2023, 8, 5),
      doctor: 'Nurse Robert Wilson',
      facility: 'Community Health Clinic',
      type: RecordType.immunization,
      notes:
          'Administered COVID-19 booster (Pfizer-BioNTech). No immediate adverse reactions. Patient monitored for 15 minutes post-vaccination.',
      attachments: ['Vaccination certificate'],
      followUpDate: null,
    ),
    MedicalRecord(
      id: 'REC123460',
      title: 'Ophthalmology Consultation',
      date: DateTime(2023, 6, 30),
      doctor: 'Dr. Amelia Parker',
      facility: 'Vision Care Center',
      type: RecordType.consultation,
      notes:
          'Visual acuity: Right 20/25, Left 20/30. Early signs of diabetic retinopathy detected. Recommended more frequent eye exams (every 6 months).',
      attachments: ['Eye examination report', 'Retinal scan images'],
      followUpDate: DateTime(2023, 12, 30),
    ),
    MedicalRecord(
      id: 'REC123461',
      title: 'Blood Work Panel',
      date: DateTime(2023, 5, 18),
      doctor: 'Dr. Sarah Smith',
      facility: 'City General Hospital',
      type: RecordType.labTest,
      notes:
          'Comprehensive metabolic panel and lipid profile. Cholesterol levels slightly elevated (Total: 215 mg/dL). Liver and kidney function tests within normal range.',
      attachments: ['Lab results report'],
      followUpDate: null,
    ),
    MedicalRecord(
      id: 'REC123462',
      title: 'Physical Therapy Session',
      date: DateTime(2023, 4, 5),
      doctor: 'Dr. Marcus Chen, PT',
      facility: 'Active Life Rehabilitation',
      type: RecordType.therapy,
      notes:
          'Session focused on lower back strengthening exercises. Patient reports 30% reduction in pain levels since starting therapy.',
      attachments: ['Exercise program PDF'],
      followUpDate: DateTime(2023, 4, 12),
    ),
    MedicalRecord(
      id: 'REC123463',
      title: 'Urgent Care Visit - Flu Symptoms',
      date: DateTime(2023, 2, 8),
      doctor: 'Dr. Olivia Thompson',
      facility: 'ExpressCare Urgent Clinic',
      type: RecordType.urgentCare,
      notes:
          'Patient presented with fever (101.5°F), sore throat, and fatigue. Diagnosed with seasonal influenza. Prescribed Tamiflu and recommended rest and hydration.',
      attachments: ['Prescription', 'Flu information sheet'],
      followUpDate: null,
    ),
    MedicalRecord(
      id: 'REC123464',
      title: 'Dermatology Consultation',
      date: DateTime(2023, 1, 20),
      doctor: 'Dr. William Hayes',
      facility: 'Dermatology Specialists',
      type: RecordType.consultation,
      notes:
          'Evaluated suspicious mole on upper back. Performed biopsy. Results came back benign. Recommended annual skin checks due to family history of melanoma.',
      attachments: ['Biopsy results', 'Skin check guidelines'],
      followUpDate: DateTime(2024, 1, 20),
    ),
    MedicalRecord(
      id: 'REC123465',
      title: 'Colonoscopy Screening',
      date: DateTime(2022, 11, 15),
      doctor: 'Dr. Elena Rodriguez',
      facility: 'Digestive Health Center',
      type: RecordType.procedure,
      notes:
          'Routine screening colonoscopy. Two small polyps removed and sent for biopsy. Results showed benign adenomas. Recommended follow-up colonoscopy in 5 years.',
      attachments: [
        'Procedure report',
        'Biopsy results',
        'Post-procedure care'
      ],
      followUpDate: DateTime(2027, 11, 15),
    ),
  ];

  List<MedicalRecord> get filteredRecords {
    if (_searchQuery.isEmpty) {
      return _records;
    }

    return _records.where((record) {
      return record.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record.doctor.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record.notes.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          record.facility.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  List<MedicalRecord> get filteredRecordsByType {
    if (_tabController.index == 0) {
      return filteredRecords;
    } else {
      RecordType selectedType = RecordType.values[_tabController.index - 1];
      return filteredRecords
          .where((record) => record.type == selectedType)
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: RecordType.values.length + 1, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: theme.primary,
        title: Text(
          "Medical Records",
          style: TextStyle(color: theme.onSurface),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search records...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: theme.outline),
                    ),
                    filled: true,
                    fillColor: theme.primary.withOpacity(0.5),
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: [
                  Tab(text: "All"),
                  ...RecordType.values
                      .map((type) => Tab(text: type.displayName))
                      .toList(),
                ],
                labelColor: theme.secondary,
                unselectedLabelColor: theme.onSurface.withOpacity(0.7),
                indicatorColor: theme.onSecondary,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                onTap: (_) => setState(() {}),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
      body: filteredRecordsByType.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: 64, color: theme.onBackground.withOpacity(0.5)),
                  SizedBox(height: 16),
                  Text(
                    "No records found",
                    style: TextStyle(
                      fontSize: 18,
                      color: theme.onBackground.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Try adjusting your search or filter",
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.onBackground.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filteredRecordsByType.length,
              itemBuilder: (context, index) {
                final record = filteredRecordsByType[index];
                return _buildRecordCard(context, record, theme);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a form for adding a new record
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content:
                  Text("Add new record functionality (to be implemented)")));
        },
        backgroundColor: theme.primary,
        child: Icon(Icons.add, color: theme.onPrimary),
      ),
    );
  }

  Widget _buildRecordCard(
      BuildContext context, MedicalRecord record, ColorScheme theme) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: theme.outline.withOpacity(0.3)),
      ),
      child: InkWell(
        onTap: () {
          _showRecordDetails(context, record);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTypeIcon(record.type, theme),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.onSurface,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "${DateFormat.yMMMMd().format(record.date)} • ${record.facility}",
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.onSurface.withOpacity(0.7),
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          record.doctor,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                record.notes.length > 120
                    ? "${record.notes.substring(0, 120)}..."
                    : record.notes,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.onSurface.withOpacity(0.8),
                ),
              ),
              if (record.attachments.isNotEmpty) ...[
                SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.attach_file, size: 16, color: theme.primary),
                    SizedBox(width: 4),
                    Text(
                      "${record.attachments.length} attachment${record.attachments.length > 1 ? 's' : ''}",
                      style: TextStyle(
                        fontSize: 14,
                        color: theme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
              if (record.followUpDate != null) ...[
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: record.followUpDate!.isAfter(DateTime.now())
                        ? theme.tertiary.withOpacity(0.1)
                        : theme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.event,
                        size: 16,
                        color: record.followUpDate!.isAfter(DateTime.now())
                            ? theme.tertiary
                            : theme.error,
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Follow-up: ${DateFormat.yMMMd().format(record.followUpDate!)}",
                        style: TextStyle(
                          fontSize: 12,
                          color: record.followUpDate!.isAfter(DateTime.now())
                              ? theme.tertiary
                              : theme.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeIcon(RecordType type, ColorScheme theme) {
    IconData icon;
    Color color;

    switch (type) {
      case RecordType.examination:
        icon = Icons.health_and_safety;
        color = Colors.green;
        break;
      case RecordType.consultation:
        icon = Icons.person;
        color = Colors.blue;
        break;
      case RecordType.labTest:
        icon = Icons.science;
        color = Colors.purple;
        break;
      case RecordType.procedure:
        icon = Icons.medical_services;
        color = Colors.red;
        break;
      case RecordType.surgery:
        icon = Icons.cut;
        color = Colors.red[700]!;
        break;
      case RecordType.immunization:
        icon = Icons.vaccines;
        color = Colors.teal;
        break;
      case RecordType.therapy:
        icon = Icons.accessibility_new;
        color = Colors.orange;
        break;
      case RecordType.dentistry:
        icon = Icons.medical_information;
        color = Colors.cyan;
        break;
      case RecordType.urgentCare:
        icon = Icons.local_hospital;
        color = Colors.deepOrange;
        break;
      case RecordType.other:
        icon = Icons.more_horiz;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  void _showRecordDetails(BuildContext context, MedicalRecord record) {
    final ColorScheme theme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.onSurface.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTypeIcon(record.type, theme),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: theme.onSurface,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Record ID: ${record.id}",
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.onSurface.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  _buildDetailSection(
                      theme, "Date", DateFormat.yMMMMd().format(record.date)),
                  _buildDetailSection(
                      theme, "Healthcare Provider", record.doctor),
                  _buildDetailSection(theme, "Facility", record.facility),
                  _buildDetailSection(theme, "Type", record.type.displayName),
                  _buildDetailSection(
                    theme,
                    "Notes",
                    record.notes,
                    isMultiline: true,
                  ),
                  if (record.attachments.isNotEmpty) ...[
                    SizedBox(height: 16),
                    Text(
                      "Attachments",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: theme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8),
                    ...record.attachments.map((attachment) {
                      return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          _getAttachmentIcon(attachment),
                          color: theme.primary,
                        ),
                        title: Text(attachment),
                        trailing: IconButton(
                          icon: Icon(Icons.download, color: theme.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Downloading $attachment...")));
                          },
                        ),
                      );
                    }).toList(),
                  ],
                  if (record.followUpDate != null) ...[
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: record.followUpDate!.isAfter(DateTime.now())
                            ? theme.primary.withOpacity(0.1)
                            : theme.error.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Follow-up Appointment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color:
                                  record.followUpDate!.isAfter(DateTime.now())
                                      ? theme.primary
                                      : theme.error,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            DateFormat.yMMMMd().format(record.followUpDate!),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  record.followUpDate!.isAfter(DateTime.now())
                                      ? theme.primary
                                      : theme.error,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            record.followUpDate!.isAfter(DateTime.now())
                                ? "Upcoming in ${_daysUntil(record.followUpDate!)} days"
                                : "Overdue by ${_daysUntil(record.followUpDate!).abs()} days",
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  record.followUpDate!.isAfter(DateTime.now())
                                      ? theme.primary.withOpacity(0.8)
                                      : theme.error.withOpacity(0.8),
                            ),
                          ),
                          SizedBox(height: 16),
                          if (record.followUpDate!.isAfter(DateTime.now()))
                            OutlinedButton(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Adding to calendar (to be implemented)")));
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: theme.primary),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minimumSize: Size(double.infinity, 45),
                              ),
                              child: Text(
                                "Add to Calendar",
                                style: TextStyle(color: theme.primary),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                  SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: Icon(Icons.share),
                          label: Text("Share"),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: theme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Sharing record (to be implemented)")));
                          },
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: Icon(Icons.print),
                          label: Text("Print"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primary,
                            foregroundColor: theme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Printing record (to be implemented)")));
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDetailSection(
    ColorScheme theme,
    String label,
    String value, {
    bool isMultiline = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: theme.onSurface.withOpacity(0.6),
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: theme.onSurface,
              height: isMultiline ? 1.5 : 1.2,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getAttachmentIcon(String attachment) {
    final String extension = attachment.split('.').last.toLowerCase();

    if (attachment.contains('report') || extension == 'pdf') {
      return Icons.description;
    } else if (attachment.contains('image') ||
        extension == 'jpg' ||
        extension == 'png' ||
        attachment.contains('scan')) {
      return Icons.image;
    } else if (attachment.contains('certificate')) {
      return Icons.verified;
    } else if (attachment.contains('prescription')) {
      return Icons.receipt;
    } else {
      return Icons.insert_drive_file;
    }
  }

  int _daysUntil(DateTime date) {
    final now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }
}

enum RecordType {
  examination,
  consultation,
  labTest,
  procedure,
  surgery,
  immunization,
  therapy,
  dentistry,
  urgentCare,
  other,
}

extension RecordTypeExtension on RecordType {
  String get displayName {
    switch (this) {
      case RecordType.examination:
        return "Examination";
      case RecordType.consultation:
        return "Consultation";
      case RecordType.labTest:
        return "Lab Test";
      case RecordType.procedure:
        return "Procedure";
      case RecordType.surgery:
        return "Surgery";
      case RecordType.immunization:
        return "Immunization";
      case RecordType.therapy:
        return "Therapy";
      case RecordType.dentistry:
        return "Dental";
      case RecordType.urgentCare:
        return "Urgent Care";
      case RecordType.other:
        return "Other";
    }
  }
}

class MedicalRecord {
  final String id;
  final String title;
  final DateTime date;
  final String doctor;
  final String facility;
  final RecordType type;
  final String notes;
  final List<String> attachments;
  final DateTime? followUpDate;

  MedicalRecord({
    required this.id,
    required this.title,
    required this.date,
    required this.doctor,
    required this.facility,
    required this.type,
    required this.notes,
    required this.attachments,
    this.followUpDate,
  });
}
