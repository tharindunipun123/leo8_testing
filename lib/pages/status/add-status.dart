import 'dart:io';
import 'dart:convert';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class AddStatusPage extends StatefulWidget {
  final String userId;
  const AddStatusPage({Key? key, required this.userId}) : super(key: key);

  @override
  _AddStatusPageState createState() => _AddStatusPageState();
}

class _AddStatusPageState extends State<AddStatusPage> {
  bool _isUploading = false;
  String _statusText = '';
  File? _selectedFile;
  final ImagePicker _picker = ImagePicker();
  List<Map<String, dynamic>>? _contactsResponse; // List of contacts

  Future<void> _fetchContacts() async {
    var status = await Permission.contacts.request();
    if (status.isGranted) {
      try {
        Iterable<Contact> contacts = await ContactsService.getContacts();
        List<Map<String, String>> formattedContacts = contacts.map((contact) {
          String mobileNumber = contact.phones?.isNotEmpty ?? false
              ? contact.phones!.first.value ?? ''
              : '';
          if (mobileNumber.isNotEmpty) {
            // Remove any non-digit characters
            mobileNumber = mobileNumber.replaceAll(RegExp(r'\D'), '');

            // If the number starts with '0', remove it
            if (mobileNumber.startsWith('0')) {
              mobileNumber = mobileNumber.substring(1);
            }

            // Add '94' at the beginning
            mobileNumber = '94' + mobileNumber;
          }
          return {
            'mobileNumber': mobileNumber,
            'contactName': contact.displayName ?? '',
          };
        }).toList();

        final url =
            Uri.parse('http://45.126.125.172:8080/api/v1/checkContacts');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(formattedContacts),
        );

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body) as List<dynamic>;
          final List<Map<String, dynamic>> contactsResponse = responseData
              .map<Map<String, dynamic>>((e) =>
                  e is Map<String, dynamic> ? e.cast<String, dynamic>() : {})
              .toList();
          setState(() {
            _contactsResponse = contactsResponse;
          });
          print('Contacts fetched successfully');
        } else {
          print('Failed to fetch contacts: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching contacts: $e');
      }
    } else {
      print('Permission denied');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Permission denied. Unable to access contacts.'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchContacts();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadStatus() async {
    // Ensure _selectedFile is not null and other validation checks
    if (_selectedFile == null && _statusText.isEmpty) {
      return;
    }

    setState(() {
      _isUploading = true;
    });

    final Uuid uuid = Uuid();

    try {
      var uri = Uri.parse('http://45.126.125.172:8080/api/v1/addStatus');
      var request = http.MultipartRequest('POST', uri);

      request.fields['userId'] = widget.userId;
      request.fields['statusText'] = _statusText;

      if (_selectedFile != null) {
        File imageFile = File(_selectedFile!.path);
        String newFileName = '${uuid.v4()}.${imageFile.path.split('.').last}';
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
          filename: newFileName,
        ));
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        // Handle response data if needed
        print('Status uploaded successfully.');
        _showSuccessDialog();

        // After uploading status, send contacts
        await sendStatusFriends();
      } else {
        print('Failed to upload status. Please try again.');
        _showErrorDialog('Failed to upload status. Please try again.');
      }
    } catch (e) {
      print('An error occurred. Please try again.');
      _showErrorDialog('An error occurred. Please try again.');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> sendStatusFriends() async {
    try {
      var uri = Uri.parse('http://45.126.125.172:8080/api/v1/addContacts');
      var headers = {'Content-Type': 'application/json'};

      // Ensure _contactsResponse is not null and has the correct structure
      if (_contactsResponse == null || !(_contactsResponse is List)) {
        print('Invalid contacts response.');
        return;
      }

      // Extract userIds from _contactsResponse
      List<int> contactUserIds = _contactsResponse!
          .map((contact) => contact['userId'] as int)
          .toList();

      var requestBody = jsonEncode({
        'userId': int.parse(widget.userId),
        'contactUserIds': contactUserIds,
      });

      var response = await http.post(
        uri,
        headers: headers,
        body: requestBody,
      );

      if (response.statusCode == 200) {
        print('Contacts sent successfully.');
      } else {
        print('Failed to send contacts.');
      }
    } catch (e) {
      print('Error sending contacts: $e');
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Status Posted Successfully',
            style: TextStyle(fontSize: 15),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Pop twice to navigate back
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Status'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _showImagePicker(context);
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: _selectedFile == null
                      // ? Icon(
                      //     Icons.camera_alt,
                      //     size: 80.0,
                      //     color: Colors.grey,
                      //   )
                      ? Image.network(
                          'https://img.freepik.com/premium-vector/illustration-vector-graphic-cartoon-character-image-upload_516790-1874.jpg?w=2000',
                        )
                      : Image.file(
                          _selectedFile!,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              onChanged: (value) {
                setState(() {
                  _statusText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Type a status',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              ),
              onPressed: _isUploading ? null : _uploadStatus,
              child: _isUploading
                  ? CircularProgressIndicator()
                  : Text(
                      'Upload Status',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
