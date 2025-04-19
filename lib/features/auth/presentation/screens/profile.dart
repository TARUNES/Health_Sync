import 'package:flutter/material.dart';
import 'package:health_sync_client/core/constants/fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isEditing = false;
  final _formKey = GlobalKey<FormState>();

  // User Profile Data
  String name = "John Doe";
  String patientId = "#12345";

  // Emergency Contact
  String emergencyName = "Kannan";
  String relationship = "Parent";
  String emergencyPhone = "+1 (555) 123-4567";

  // Medical Information
  String bloodType = "O+";
  String height = "5'10\" (178 cm)";
  String weight = "165 lbs (75 kg)";
  String bmi = "23.7 (Normal)";

  // Medical Conditions
  String allergies = "Penicillin, Peanuts";
  String chronicConditions = "Type 2 Diabetes";
  String pastSurgeries = "Appendectomy (2019)";

  // Current Medications
  List<Medication> medications = [
    Medication(name: "Metformin", dosage: "500mg", frequency: "2x daily"),
    Medication(name: "Fish Oil", dosage: "1000mg", frequency: "1x daily"),
    Medication(name: "Vitamin D", dosage: "2000 IU", frequency: "1x daily"),
  ];

  // Healthcare Providers
  String primaryPhysician = "Dr. Sarah Smith";
  String specialist = "Dr. Michael Johnson";
  String preferredHospital = "City General Hospital";

  @override
  Widget build(BuildContext context) {
    final ColorScheme theme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(
              fontFamily: AppFonts.primaryFont,
              color: theme.onPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save_rounded : Icons.edit_rounded,
                color: theme.onBackground),
            onPressed: () {
              if (_isEditing) {
                // Save changes if form is valid
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  // Here you would typically save to database/backend
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Profile updated successfully!")));
                  setState(() {
                    _isEditing = false;
                  });
                }
              } else {
                // Enter edit mode
                setState(() {
                  _isEditing = true;
                });
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Header
                  _buildProfileHeader(theme),

                  SizedBox(height: 32),

                  // Emergency Contact Card
                  _buildEmergencyContactCard(theme),

                  SizedBox(height: 16),

                  // Medical Information Card
                  _buildMedicalInfoCard(theme),

                  SizedBox(height: 16),

                  // Medical Conditions Card
                  _buildMedicalConditionsCard(theme),

                  SizedBox(height: 16),

                  // // Current Medications Card
                  // _buildMedicationsCard(theme),

                  SizedBox(height: 16),

                  // Healthcare Providers Card
                  _buildHealthcareProvidersCard(theme),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ColorScheme theme) {
    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.primary,
                  border: Border.all(
                    color: theme.primary,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    name
                        .split(' ')
                        .map((e) => e.isNotEmpty ? e[0] : '')
                        .join(''),
                    style: TextStyle(
                      color: theme.onPrimary,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_isEditing)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: theme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: theme.onPrimary,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 16),
          if (_isEditing)
            TextFormField(
              initialValue: name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.onBackground,
              ),
              decoration: InputDecoration(
                hintText: "Full Name",
                border: UnderlineInputBorder(),
              ),
              onSaved: (value) {
                if (value != null) name = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name cannot be empty";
                }
                return null;
              },
            )
          else
            Text(
              name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: theme.onBackground,
              ),
            ),
          Text(
            "Patient ID: $patientId",
            style: TextStyle(
              color: theme.onBackground.withOpacity(0.6),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyContactCard(ColorScheme theme) {
    return _buildCard(
      theme,
      "Emergency Contact",
      Icons.emergency,
      [
        _buildEditableRow(
          theme,
          "Name",
          emergencyName,
          (value) => emergencyName = value ?? emergencyName,
        ),
        _buildEditableRow(
          theme,
          "Relationship",
          relationship,
          (value) => relationship = value ?? relationship,
        ),
        _buildEditableRow(
          theme,
          "Phone",
          emergencyPhone,
          (value) => emergencyPhone = value ?? emergencyPhone,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildMedicalInfoCard(ColorScheme theme) {
    return _buildCard(
      theme,
      "Medical Information",
      Icons.medical_information,
      [
        _buildEditableRow(
          theme,
          "Blood Type",
          bloodType,
          (value) => bloodType = value ?? bloodType,
        ),
        _buildEditableRow(
          theme,
          "Height",
          height,
          (value) => height = value ?? height,
        ),
        _buildEditableRow(
          theme,
          "Weight",
          weight,
          (value) => weight = value ?? weight,
        ),
        _buildEditableRow(
          theme,
          "BMI",
          bmi,
          (value) => bmi = value ?? bmi,
          enabled: false,
        ),
      ],
    );
  }

  Widget _buildMedicalConditionsCard(ColorScheme theme) {
    return _buildCard(
      theme,
      "Medical Conditions",
      Icons.healing,
      [
        _buildEditableRow(
          theme,
          "Allergies",
          allergies,
          (value) => allergies = value ?? allergies,
        ),
        _buildEditableRow(
          theme,
          "Chronic Conditions",
          chronicConditions,
          (value) => chronicConditions = value ?? chronicConditions,
        ),
        _buildEditableRow(
          theme,
          "Past Surgeries",
          pastSurgeries,
          (value) => pastSurgeries = value ?? pastSurgeries,
        ),
      ],
    );
  }

  Widget _buildMedicationsCard(ColorScheme theme) {
    return _buildCard(
      theme,
      "Current Medications",
      Icons.medication,
      [
        ...medications.asMap().entries.map((entry) {
          int idx = entry.key;
          Medication med = entry.value;
          return _buildEditableMedicationRow(theme, idx, med);
        }).toList(),
        if (_isEditing)
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: OutlinedButton.icon(
              icon: Icon(Icons.add),
              label: Text("Add Medication"),
              style: OutlinedButton.styleFrom(
                foregroundColor: theme.primary,
                side: BorderSide(color: theme.primary),
                padding: EdgeInsets.symmetric(vertical: 12),
                minimumSize: Size(double.infinity, 0),
              ),
              onPressed: () {
                setState(() {
                  medications.add(Medication(
                    name: "",
                    dosage: "",
                    frequency: "",
                  ));
                });
              },
            ),
          ),
      ],
    );
  }

  Widget _buildHealthcareProvidersCard(ColorScheme theme) {
    return _buildCard(
      theme,
      "Healthcare Providers",
      Icons.local_hospital,
      [
        _buildEditableRow(
          theme,
          "Primary Physician",
          primaryPhysician,
          (value) => primaryPhysician = value ?? primaryPhysician,
        ),
        _buildEditableRow(
          theme,
          "Endocrinologist",
          specialist,
          (value) => specialist = value ?? specialist,
        ),
        _buildEditableRow(
          theme,
          "Preferred Hospital",
          preferredHospital,
          (value) => preferredHospital = value ?? preferredHospital,
        ),
      ],
    );
  }

  Widget _buildCard(
    ColorScheme theme,
    String title,
    IconData icon,
    List<Widget> children,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.primary.withOpacity(0.05),
        border: Border.all(color: theme.primary.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: theme.primary),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: theme.onBackground,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: theme.primary.withOpacity(0.2)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableRow(
    ColorScheme theme,
    String label,
    String value,
    Function(String?) onSaved, {
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _isEditing && enabled
                ? TextFormField(
                    initialValue: value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: theme.outline),
                      ),
                    ),
                    keyboardType: keyboardType,
                    onSaved: onSaved,
                  )
                : Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableMedicationRow(
    ColorScheme theme,
    int index,
    Medication medication,
  ) {
    if (_isEditing) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Medication ${index + 1}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.red[400]),
                    onPressed: () {
                      setState(() {
                        medications.removeAt(index);
                      });
                    },
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              SizedBox(height: 8),
              _buildMedicationField(
                theme,
                "Name",
                medication.name,
                (value) {
                  setState(() {
                    medications[index].name = value ?? medication.name;
                  });
                },
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildMedicationField(
                      theme,
                      "Dosage",
                      medication.dosage,
                      (value) {
                        setState(() {
                          medications[index].dosage =
                              value ?? medication.dosage;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildMedicationField(
                      theme,
                      "Frequency",
                      medication.frequency,
                      (value) {
                        setState(() {
                          medications[index].frequency =
                              value ?? medication.frequency;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                medication.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                medication.dosage,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Text(
                medication.frequency,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildMedicationField(
    ColorScheme theme,
    String label,
    String value,
    Function(String?) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 4),
        TextFormField(
          initialValue: value,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            isDense: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          style: TextStyle(fontSize: 14),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

// Model class for medications
class Medication {
  String name;
  String dosage;
  String frequency;

  Medication({
    required this.name,
    required this.dosage,
    required this.frequency,
  });
}
