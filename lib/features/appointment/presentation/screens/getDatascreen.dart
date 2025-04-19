import 'package:flutter/material.dart';
import 'package:health_sync_client/features/initial_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GetDataPatient extends StatefulWidget {
  const GetDataPatient({Key? key}) : super(key: key);

  @override
  _GetDataPatientState createState() => _GetDataPatientState();
}

class _GetDataPatientState extends State<GetDataPatient> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  final TextEditingController _emergencyContactController =
      TextEditingController();
  final TextEditingController _emergencyRelationshipController =
      TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'A+';
  bool _isLoading = false;
  String _statusMessage = '';

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'AB+',
    'AB-',
    'O+',
    'O-'
  ];
  String name = "Tarun";

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final profileData = prefs.getString('profile_data');

    if (profileData != null) {
      final data = json.decode(profileData);
      setState(() {
        _nameController.text = data['name'] ?? '';
        _ageController.text = data['age']?.toString() ?? '';
        _selectedGender = data['gender'] ?? 'Male';
        _selectedBloodGroup = data['blood_group'] ?? 'A+';
        _emergencyContactController.text =
            data['emergency_contact_number'] ?? '';
        _emergencyRelationshipController.text =
            data['emergency_contact_relationship'] ?? '';
      });
    }
  }

  Future<void> _saveProfile() async {
    setState(() {
      _isLoading = true;
      _statusMessage = '';
    });

    // Create profile data object from form inputs
    final profileData = {
      'name': _nameController.text,
      'age': int.tryParse(_ageController.text) ?? 0,
      'weight': int.tryParse(_weightController.text) ?? 0,
      'height': int.tryParse(_heightController.text) ?? 0,
      'gender': _selectedGender,
      'blood_group': _selectedBloodGroup,
      'emergency_contact_number': _emergencyContactController.text,
      'emergency_contact_relationship': _emergencyRelationshipController.text,
    };

    try {
      // First, save the data locally to ensure it's stored regardless of API result
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_data', json.encode(profileData));

      // Get user token and ID for API call
      String? token = await getToken();
      String userid = "";

      final String? userString = prefs.getString("user");
      if (userString != null) {
        Map<String, dynamic> userData = jsonDecode(userString);
        userid = userData["id"];
        print("User ID: $userid");
      } else {
        print("No user data found in SharedPreferences.");
      }

      // Now attempt API call
      if (userid.isNotEmpty) {
        try {
          final response = await http.put(
            Uri.parse('https://10.0.2.2:8443/user/updateprofile/$userid'),
            headers: {
              'Content-Type': 'application/json',
              "Authorization": "Bearer $token",
            },
            body: json.encode(profileData),
          );
          print(response.statusCode);
          print(response.body);
          print(profileData);
          print("API Response Status: ${response.statusCode}");

          if (response.statusCode == 200 || response.statusCode == 201) {
            setState(() {
              _statusMessage = 'Profile updated successfully!';
            });
          } else {
            setState(() {
              _statusMessage =
                  'Warning: Profile saved locally but server update failed (${response.statusCode})';
            });
          }
        } catch (apiError) {
          print("API Error: $apiError");
          setState(() {
            _statusMessage =
                'Warning: Profile saved locally but server update failed';
          });
        }
      } else {
        setState(() {
          _statusMessage = 'Profile saved locally only (no user ID found)';
        });
      }

      // Navigate regardless of API success since data is saved locally
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainScreen()),
      );
    } catch (e) {
      print("Error saving profile: $e");
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error saving profile: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

// Helper function to get token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

// Add this function to load profile data anywhere in your app
  Future<Map<String, dynamic>?> loadProfileData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final profileDataString = prefs.getString('profile_data');

      if (profileDataString != null && profileDataString.isNotEmpty) {
        return json.decode(profileDataString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error loading profile data: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emergencyContactController.dispose();
    _emergencyRelationshipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Name field
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Age field
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Weight',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your weight';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Height',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your height';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Gender dropdown
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  decoration: const InputDecoration(
                    labelText: 'Gender',
                    border: OutlineInputBorder(),
                  ),
                  items: _genders.map((gender) {
                    return DropdownMenuItem(
                      value: gender,
                      child: Text(gender),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Blood group dropdown
                DropdownButtonFormField<String>(
                  value: _selectedBloodGroup,
                  decoration: const InputDecoration(
                    labelText: 'Blood Group',
                    border: OutlineInputBorder(),
                  ),
                  items: _bloodGroups.map((bloodGroup) {
                    return DropdownMenuItem(
                      value: bloodGroup,
                      child: Text(bloodGroup),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBloodGroup = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Emergency contact number
                TextFormField(
                  controller: _emergencyContactController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an emergency contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Emergency contact relationship
                TextFormField(
                  controller: _emergencyRelationshipController,
                  decoration: const InputDecoration(
                    labelText: 'Emergency Contact Relationship',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your relationship with the emergency contact';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Update Profile',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 16),

                // Status message
                if (_statusMessage.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _statusMessage.contains('success')
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _statusMessage,
                      style: TextStyle(
                        color: _statusMessage.contains('success')
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
