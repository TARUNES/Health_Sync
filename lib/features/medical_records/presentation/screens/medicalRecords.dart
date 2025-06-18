import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class MedicalRecord {
  final String fileName;
  final String emrId;
  final String createdAt; // Added to store creation date

  MedicalRecord(
      {required this.fileName, required this.emrId, required this.createdAt});

  factory MedicalRecord.fromJson(Map<String, dynamic> json) {
    return MedicalRecord(
        fileName: json['file_name'], // Changed to match API
        emrId: json['file_id'], // Changed to match API
        createdAt: json['created_at'] // Added creation date
        );
  }
}

class MedicalRecordsPage extends StatefulWidget {
  const MedicalRecordsPage({Key? key}) : super(key: key);

  @override
  _MedicalRecordsPageState createState() => _MedicalRecordsPageState();
}

class _MedicalRecordsPageState extends State<MedicalRecordsPage> {
  bool _isLoading = false;
  List<MedicalRecord> _records = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isUploading = false;
  final String baseUrl = "https://192.168.0.8:8443";

  @override
  void initState() {
    super.initState();
    _fetchRecords();
  }

  List<MedicalRecord> _getMockRecords() {
    return [
      MedicalRecord(
          fileName: "Allergy_Test_Report.pdf",
          emrId: "EMR890123",
          createdAt: "2025-04-18T14:30:00.000Z"),
    ];
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); // Retrieve token from storage
  }

  Future<String> _getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userString = prefs.getString("user");

    if (userString != null) {
      Map<String, dynamic> userData = jsonDecode(userString);
      String userId = userData["id"];
      print("User ID: $userId");
      return userId;
    } else {
      print("No user data found in SharedPreferences.");
      throw Exception("User not logged in");
    }
  }

  Future<void> _fetchRecords() async {
    String? token = await getToken();
    String userID = await _getUserId();
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse('${baseUrl}/EMR/${userID}/emr/list'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        final List<dynamic> records =
            responseData['records']; // Extract records array

        setState(() {
          _records =
              records.map((item) => MedicalRecord.fromJson(item)).toList();
        });
      } else {
        _showSnackBar('Failed to load records: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error: $e');
      // Fallback to mock data only if API fails
      setState(() {
        _records = _getMockRecords();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _downloadRecord(MedicalRecord record) async {
    String userID = await _getUserId();
    setState(() {
      _isLoading = true;
    });
    String? token = await getToken();

    try {
      // Updated URL structure according to your curl example
      final response = await http.get(
        Uri.parse(
            '${baseUrl}/EMR/${userID}/record/${record.emrId}/emr/download'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/${record.fileName}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        _showSnackBar('File downloaded successfully');
        await OpenFile.open(filePath);
      } else {
        _showSnackBar('Failed to download: ${response.statusCode}');
      }
    } catch (e) {
      _showSnackBar('Error downloading: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _uploadFile() async {
    String userID = await _getUserId();
    setState(() {
      _isUploading = true;
    });
    String? token = await getToken();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        File file = File(result.files.single.path!);
        final fileName = result.files.single.name;

        // Create multipart request
        var request = http.MultipartRequest(
          'POST', // Using POST as this is more appropriate for uploads
          Uri.parse('${baseUrl}/EMR/${userID}/emr/upload'),
        );

        // Add authorization header
        request.headers['Authorization'] = 'Bearer ${token}';

        // Add file to request
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: fileName,
          ),
        );

        // Send request
        var response = await request.send();

        if (response.statusCode == 200) {
          _showSnackBar('File uploaded successfully');
          // Refresh the list
          _fetchRecords();
        } else {
          _showSnackBar('Upload failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      _showSnackBar('Error uploading: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
      Navigator.pop(context); // Close the bottom sheet
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text(
          'Medical Records',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _fetchRecords,
            tooltip: 'Refresh Records',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _records.isEmpty
                ? _buildEmptyState()
                : _buildRecordsList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showUploadBottomSheet,
        icon: const Icon(Icons.add),
        label: const Text('Add Record'),
        elevation: 4,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(100),
              ),
              child: Icon(
                Icons.medical_information,
                size: 80,
                color: Theme.of(context).primaryColor.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'No Medical Records Found',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your medical records will appear here once added',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _showUploadBottomSheet,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Record'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordsList() {
    return Container(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Your Records (${_records.length})',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _records.length,
              itemBuilder: (context, index) {
                final record = _records[index];
                return _buildRecordCard(record);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordCard(MedicalRecord record) {
    // Determine file type for icon and color
    IconData fileIcon;
    Color cardColor;

    if (record.fileName.toLowerCase().endsWith('.pdf')) {
      fileIcon = Icons.picture_as_pdf;
      cardColor = Colors.red.shade50;
    } else if (record.fileName.toLowerCase().endsWith('.jpg') ||
        record.fileName.toLowerCase().endsWith('.jpeg') ||
        record.fileName.toLowerCase().endsWith('.png')) {
      fileIcon = Icons.image;
      cardColor = Colors.blue.shade50;
    } else if (record.fileName.toLowerCase().endsWith('.docx') ||
        record.fileName.toLowerCase().endsWith('.doc')) {
      fileIcon = Icons.description;
      cardColor = Colors.indigo.shade50;
    } else {
      fileIcon = Icons.insert_drive_file;
      cardColor = Colors.amber.shade50;
    }

    // Format the date for display
    String formattedDate = "";
    try {
      DateTime creationDate = DateTime.parse(record.createdAt);
      formattedDate =
          "${creationDate.day}/${creationDate.month}/${creationDate.year}";
    } catch (e) {
      formattedDate = "Unknown date";
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    child: Icon(fileIcon,
                        size: 30, color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          record.fileName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today,
                                size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(width: 12),
                            Icon(Icons.fingerprint,
                                size: 12, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                record.emrId.length > 8
                                    ? record.emrId.substring(0, 8) + '...'
                                    : record.emrId,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _downloadRecord(record),
                    icon: Icon(
                      Icons.download_rounded,
                      size: 18,
                      color: Theme.of(context).primaryColor,
                    ),
                    label: Text(
                      'Download',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      // View record details
                      _showSnackBar('Viewing details for ${record.fileName}');
                      _downloadRecord(record);
                    },
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('View'),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.5)),
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

  void _showUploadBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUploadBottomSheet(),
    );
  }

  Widget _buildUploadBottomSheet() {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Upload Medical Record',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add a new document to your medical records',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.cloud_upload_outlined,
                        size: 60,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Supported formats: PDF, JPG, PNG, DOC, DOCX',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _isUploading ? null : _uploadFile,
                          icon: _isUploading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.add_to_photos),
                          label: Text(
                            _isUploading ? 'Uploading...' : 'Select File',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
