import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:country_picker/country_picker.dart';
import "package:circle_flags/circle_flags.dart";
import "package:country_code_picker/country_code_picker.dart";
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/audio-room/live_page.dart';
import 'package:flutter_application_1/pages/rooms/password_swtich.dart';

class BackgroundImage {
  final String bgImageUrl;
  final int id;

  BackgroundImage({required this.bgImageUrl, required this.id});

  factory BackgroundImage.fromJson(Map<String, dynamic> json) {
    return BackgroundImage(
      bgImageUrl: json['bgImageUrl'],
      id: json['id'],
    );
  }
}

class CreateVoiceRoomScreen extends StatefulWidget {
  final String defaultRoomName;
  final String defaultRoomDescription;
  final String defaultRoomCountry;
  final String defaultRoomDLanguage;
  final String userId;
  final String user_name;
  final String user_avatar;

  const CreateVoiceRoomScreen({
    Key? key,
    this.defaultRoomName = '',
    this.defaultRoomDescription = '',
    this.defaultRoomCountry = '',
    this.defaultRoomDLanguage = '',
    required this.userId,
    required this.user_name,
    required this.user_avatar,
  }) : super(key: key);

  @override
  State<CreateVoiceRoomScreen> createState() => _CreateVoiceRoomScreenState();
}

class _CreateVoiceRoomScreenState extends State<CreateVoiceRoomScreen> {
  late TextEditingController _roomNameController;
  late TextEditingController _roomCountryController;
  late TextEditingController _roomLanguageController;
  List<BackgroundImage> _backgroundImages = [];
  late int selectedBackgroundImageId = 1;

  @override
  void initState() {
    super.initState();
    _roomNameController = TextEditingController(text: widget.defaultRoomName);
    _roomCountryController =
        TextEditingController(text: widget.defaultRoomCountry);
    _roomLanguageController =
        TextEditingController(text: widget.defaultRoomDLanguage);
    fetchBackgroundImages();
  }

  @override
  void dispose() {
    _roomNameController.dispose();
    _roomCountryController.dispose();
    _roomLanguageController.dispose();
    super.dispose();
  }

  bool isOn = false;

  void _toggleSwitch(bool value) {
    setState(() {
      isOn = value;
    });
    print(isOn);
    print("hi");
  }

  Future<void> fetchBackgroundImages() async {
    try {
      final response = await http.get(Uri.parse(
          'http://45.126.125.172:8080/api/v1/voiceRoomTeam/backgroundImages'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<BackgroundImage> images =
            data.map((json) => BackgroundImage.fromJson(json)).toList();
        setState(() {
          _backgroundImages = images;
        });
      } else {
        throw Exception('Failed to load background images');
      }
    } catch (e) {
      print('Error fetching background images: $e');
    }
  }

  void _navigateToVoiceRoomPage(BuildContext context, String roomID,
      String userId, String user_name, String user_avatar, bool isHost) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => LivePage2(
                roomID: roomID,
                userId: userId,
                user_name: user_name,
                isHost: isHost,
                user_avatar: user_avatar)));
  }

  void _createRoom() async {
    String roomName = _roomNameController.text;
    String roomCountry = _roomCountryController.text;
    String roomLanguage = _roomLanguageController.text;

    int creatorId = int.tryParse(widget.userId) ?? 0;
    if (creatorId == 0) return;

    if (roomName.isEmpty) {
      showPopup(context, "Error", "VoiceRoom name can't be empty");
      return;
    }
    if (roomLanguage.isEmpty) {
      showPopup(context, "Error", "VoiceRoom language can't be empty");
      return;
    }

    int voiceRoomId = generateId(creatorId);
    print(voiceRoomId);

    // Example API endpoint
    Uri url =
        Uri.parse('http://45.126.125.172:8080/api/v1/voiceRoomTeam/saveRoom');

    // Adjusted JSON body to include additional parameters
    Map<String, dynamic> requestBody = {
      "roomId": voiceRoomId,
      "roomName": roomName,
      "country": roomCountry,
      "language": roomLanguage,
      "roomOwnerId": creatorId,
      "backgroundImageId": selectedBackgroundImageId,
    };

    // Make API call
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      // print('ll');
      print(response.body);

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        String statusMessage = responseData['status'];

        if (statusMessage == "Room saved successfully") {
          // _navigateToVoiceRoomPage(context, voiceRoomId.toString(),
          //     creatorId.toString(), widget.user_name, widget.user_avatar, true);
          joinUserVoiceRoom(creatorId, voiceRoomId);
        }
        // Successfully created room
        //  print('Room created successfully!');
        // Navigator.pop(context);
      } else {
        // Handle other status codes
        print('Failed to create room. Error ${response.statusCode}');
        // Optionally, show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create room. Please try again.'),
          ),
        );
      }
    } catch (e) {
      // Handle network errors
      print('Error creating room: $e');
      // Optionally, show an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Error creating room. Please check your internet connection.'),
        ),
      );
    }
  }

  void showNameInputModal() {
    TextEditingController nameController = TextEditingController();
    showInputModal(context, 'Enter Room Name', nameController, () {
      //  _roomNameController.text = nameController.text;
      // showLanguageInputModal();
      setState(() {
        _roomNameController.text = nameController.text;
      });
      print(nameController.text);
    });
  }

  void showBackgroundSelectModal() {
    TextEditingController nameController = TextEditingController();
    showSelectImageModal(
      context,
      'Select Room Background Image',
      nameController,
      () {
        // Handle submission logic if needed
      },
      _backgroundImages, // Pass fetched background images
    );
  }

  void showLanguageInputModal() {
    TextEditingController languageController = TextEditingController();
    showInputModal(context, 'Enter Language', languageController, () {
      setState(() {
        _roomLanguageController.text = languageController.text;
      });
    });
  }

  // void showCountryInputModal() {
  //   TextEditingController languageController = TextEditingController();
  //   showInputModal(context, 'Enter Country', languageController, () {
  //     setState(() {
  //       _roomLanguageController.text = languageController.text;
  //     });
  //   });
  // }

  void showCountryPickerBottomSheet() {
    TextEditingController countryController = TextEditingController();
    // showCountryPicker(
    //   context: context,
    //   showPhoneCode: false,
    //   favorite: ['LK'],
    //   countryListTheme: CountryListThemeData(
    //     bottomSheetHeight: 600,
    //     // backgroundColor: Theme.of(context).backgroundColor,
    //     flagSize: 22,
    //     borderRadius: BorderRadius.circular(20),
    //     textStyle: const TextStyle(
    //       color: Colors.grey,
    //     ),
    //     inputDecoration: InputDecoration(
    //       labelStyle: const TextStyle(color: Colors.grey),
    //       prefixIcon: const Icon(
    //         Icons.language,
    //         color: Colors.blue,
    //       ),
    //       hintText: 'Search country by code or name',
    //       enabledBorder: UnderlineInputBorder(
    //         borderSide: BorderSide(
    //           color: Colors.grey.withOpacity(.2),
    //         ),
    //       ),
    //       focusedBorder: const UnderlineInputBorder(
    //         borderSide: BorderSide(
    //           color: Colors.green,
    //         ),
    //       ),
    //     ),
    //   ),
    //   onSelect: (country) {
    //     setState(() {
    //       _roomCountryController.text = country.name;
    //     });
    //   },
    // );
    CountryCodePicker(
      onChanged: (country) => setState(() {
        // _onCountryChange(country as Country);
      }),
      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      initialSelection: 'IT',
      favorite: ['+39', 'FR'],
      // optional. Shows only country name and flag
      showCountryOnly: false,
      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,
      // optional. aligns the flag and the Text left
      alignLeft: false,
    );
  }

  void _onCountryChange(String country) {
    // Update your state with the selected country data (name, code, etc.)
    setState(() {
      _roomCountryController.text = country;
    });
  }

  int generateId(int userId) {
    // Get current timestamp in milliseconds
    int timestamp = DateTime.now().millisecondsSinceEpoch;

    // Generate a random number between 1000 and 9999
    int randomNumber = Random().nextInt(9000) + 1000;

    // Combine userId, timestamp, and randomNumber to form the ID
    String idString = '${userId.abs()}$timestamp$randomNumber';

    // Take the last 8 characters to ensure it's an 8-character ID
    idString = idString.substring(idString.length - 8);

    // Convert the string to an integer
    int id = int.tryParse(idString) ?? 0; // Default to 0 if parsing fails

    return id;
  }

  Future<void> joinUserVoiceRoom(int userId, int roomId) async {
    final url =
        Uri.parse('http://45.126.125.172:8080/api/v1/roomDetails/joinRoom');

    Map<String, dynamic> body = {"userId": userId, "roomId": roomId};
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['status'] == "User joined room successfully") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => LivePage2(
                      roomID: roomId.toString(),
                      userId: userId.toString(),
                      user_name: widget.user_name,
                      isHost: true,
                      user_avatar: widget.user_avatar)));
        } else {
          // Handle other cases where deletion status update was not successful
          // This block can be optional depending on your specific requirements
          throw Exception('Failed to join voice rooms');
        }
      } else {
        throw Exception('Failed to join voice rooms');
      }
    } catch (e) {
      print('Error join voice rooms: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          background2(context),
          Column(
            children: [
              screenAppBar(context), // Positioned at the top
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 30),
                        // Space below the app bar
                        GestureDetector(
                            onTap: showNameInputModal,
                            child: enterRoomName(context)),
                        const SizedBox(height: 20),
                        announcementContainer(context),
                        const SizedBox(height: 20),
                        GestureDetector(
                            onTap: showBackgroundSelectModal,
                            child: modifyBackgroundContrainer(context)),
                        const SizedBox(height: 20),

                        GestureDetector(
                            onTap: showLanguageInputModal,
                            child: selectLangContrainer(context)),
                        const SizedBox(height: 20),

                        selectCountryContainer(context),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _createRoom,
                          child: const Text(
                            'Start Live',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // void showInputModal(BuildContext context, String title,
  //     TextEditingController controller, VoidCallback onSubmit) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Text(title),
  //             IconButton(
  //               icon: const Icon(Icons.close),
  //               onPressed: () {
  //                 Navigator.pop(context);
  //               },
  //             ),
  //           ],
  //         ),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             TextField(
  //               controller: controller,
  //               decoration: const InputDecoration(
  //                 border: OutlineInputBorder(),
  //               ),
  //             ),
  //             const SizedBox(height: 16.0),
  //             ElevatedButton(
  //               onPressed: () {
  //                 onSubmit();
  //                 Navigator.pop(context); // Close the modal
  //               },
  //               child: const Text('Save'),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  void showInputModal(BuildContext context, String title,
      TextEditingController controller, VoidCallback onSubmit) {
    // Define your gradient colors
    List<Color> gradientColors = [
      Colors.blue.shade300,
      Colors.blue.shade700,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Ensure the dialog content fits the content size
          insetPadding: EdgeInsets.all(30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Your title row with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                // Your text field and save button
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              15.0), // Set border radius here
                        ),
                        fillColor: Colors.white,
                        filled: true,
                      ),
                    )),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    onSubmit();
                    Navigator.pop(context); // Close the modal
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(120, 40), // Adjust width and height as needed
                  ),
                  child: Text('Save'),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
        );
      },
    );
  }

  void showSelectImageModal(
    BuildContext context,
    String title,
    TextEditingController controller,
    VoidCallback onSubmit,
    List<BackgroundImage> backgroundImageList, // Pass list of background images
  ) {
    List<Color> gradientColors = [
      Colors.blue.shade300,
      Colors.blue.shade700,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Ensure the dialog content fits the content size
          insetPadding: EdgeInsets.zero,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
                // List of selectable images
                Expanded(
                  child: ListView.builder(
                    itemCount: backgroundImageList.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Image.network(
                          backgroundImageList[index].bgImageUrl,
                          fit: BoxFit.cover,
                        ),
                        onTap: () {
                          // controller.text =
                          //     backgroundImageList[index].bgImageUrl;
                          setState(() {
                            selectedBackgroundImageId =
                                backgroundImageList[index].id;
                            print(selectedBackgroundImageId);
                          });
                          onSubmit();
                          Navigator.pop(context); // Close the modal
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showPopup(BuildContext context, String title, String description) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(description),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('Close'),
              ),
            ],
          );
        });
  }

  // void showCountryPickerDialog(BuildContext context) {
  //   List<Color> gradientColors = [
  //     Colors.blue.shade300,
  //     Colors.blue.shade700,
  //   ];
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("Select Country"),
  //         content: CountryCodePicker(
  //           onChanged: (country) {
  //             setState(() {
  //               _roomCountryController.text = country.code ?? "";
  //             });
  //             Navigator.pop(context); // Close the dialog after selection
  //           },
  //           // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
  //           initialSelection: 'SL',
  //           //favorite: ['+39', 'FR'],
  //           // optional. Shows only country name and flag
  //           showCountryOnly: true,
  //           // optional. Shows only country name and flag when popup is closed.
  //           showOnlyCountryWhenClosed: false,
  //           // optional. aligns the flag and the Text left
  //           alignLeft: false,
  //         ),
  //       );
  //     },
  //   );
  // }
  void showCountryPickerDialog(BuildContext context) {
    List<Color> gradientColors = [
      Colors.blue.shade300,
      Colors.blue.shade700,
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          // Ensure the dialog content fits the content size
          insetPadding: EdgeInsets.all(30),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title with close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Country",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
                // Country code picker
                CountryCodePicker(
                  onChanged: (country) {
                    setState(() {
                      _roomCountryController.text = country.code ?? "";
                    });
                    Navigator.pop(context); // Close the dialog after selection
                  },
                  // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                  initialSelection: 'SL',
                  //favorite: ['+39', 'FR'],
                  // optional. Shows only country name and flag
                  showCountryOnly: true,
                  // optional. Shows only country name and flag when popup is closed.
                  showOnlyCountryWhenClosed: false,
                  // optional. aligns the flag and the Text left
                  alignLeft: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Widget background2(BuildContext context) {
  //   return Container(
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topCenter,
  //         end: Alignment.bottomCenter,
  //         colors: [
  //           Color(0xFF525b96),
  //           Color(0xFF836797),
  //         ],
  //       ),
  //     ),
  //     child: BackdropFilter(
  //       filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
  //       child: Container(
  //         color: Colors.black.withOpacity(0.0), // Adjust opacity as needed
  //       ),
  //     ),
  //   );
  // }
  Widget background2(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade300, // Convert to regular color
            Colors.blue.shade700, // Convert to regular color
          ],
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.0),
        ),
      ),
    );
  }

  Widget screenAppBar(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     begin: Alignment.centerLeft,
      //     end: Alignment.centerRight,
      //     colors: [Color(0xFF525b96), Color(0xFF836797)],
      //   ),
      // ),
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0, // Remove elevation
        title: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                  width: 2.0,
                  color: Colors.white), // Adjust thickness and color as needed
            ),
          ),
          child: Text(
            'VoiceRoom',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Close button logic
          },
        ),
      ),
    );
  }

  Widget enterRoomName(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            //  width: 450,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 50.0, // Adjust the width of the image container
                    height: 50.0, // Adjust the height of the image container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          8.0), // Adjust the radius as needed
                      border: Border.all(
                          color: Colors.white, width: 2.0), // Example border
                      image: const DecorationImage(
                        image: NetworkImage(
                            'https://i.ibb.co/hgvYFjV/125886727-Cartoon-Style-Robot.jpg'), // Replace with your image
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                      width: 8.0), // Adjust spacing between image and text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _roomNameController.text.isEmpty
                              ? "Enter Room name"
                              : _roomNameController.text,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Welcome Room',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget announcementContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            //  width: 450,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(
                    Icons.chat_outlined,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  Text(
                    'Please Enter the room annoucement',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget modifyBackgroundContrainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            //  width: 450,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Modify the room background',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 16.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget passwordStatusContainer(BuildContext context) {
  //   bool switchValue = false;
  //   return Container(
  //     //  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
  //     child: ClipRRect(
  //       borderRadius: const BorderRadius.all(Radius.circular(10)),
  //       child: BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
  //         child: Container(
  //           //  width: 450,
  //           decoration: BoxDecoration(
  //               color: Colors.grey.withOpacity(0.4),
  //               borderRadius: const BorderRadius.all(Radius.circular(10))),
  //           child: Padding(
  //             padding: EdgeInsets.all(8.0),
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Text(
  //                   'Room Password',
  //                   style: TextStyle(
  //                     color: Colors.white,
  //                     fontSize: 16.0,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 // Switch(
  //                 //   value: switchValue,
  //                 //   onChanged: (value) {
  //                 //     print("hi");
  //                 //     // Handle switch state change
  //                 //     switchValue = value;
  //                 //     // Add your logic here when switch is toggled
  //                 //   },
  //                 //   activeColor: Colors.white, // Color when switch is on
  //                 //   inactiveThumbColor: Colors.grey, // Color when switch is off
  //                 //   inactiveTrackColor: Colors.grey
  //                 //       .withOpacity(0.5), // Track color when switch is off
  //                 // ),
  //                 PasswordStatusContainer(),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget selectLangContrainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            //  width: 450,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.4),
                borderRadius: const BorderRadius.all(Radius.circular(10))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Room Language',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _roomLanguageController.text.isEmpty
                            ? "Select Language"
                            : _roomLanguageController.text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 16.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget selectCountryContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room Country',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showCountryPickerDialog(context);
                    },
                    child: Row(
                      children: [
                        Text(
                          _roomCountryController.text.isEmpty
                              ? "Select Country"
                              : _roomCountryController.text,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 16.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget background3(BuildContext context) {
    return Container(
      // backgroundColor: const Color(0xff1C1760),
      decoration: const BoxDecoration(color: Color(0xff1C1760)),
      child: Stack(
        children: [
          Positioned(
              top: 130,
              left: 220,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xff744ff9),
                      Color(0xff8369de),
                      Color(0xff8da0cb)
                    ])),
              )),
          Positioned(
              bottom: 250,
              right: 150,
              child: Transform.rotate(
                angle: 8,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color(0xff744ff9),
                        Color(0xff8369de),
                        Color(0xff8da0cb)
                      ])),
                ),
              )),
          // Center(
          //   child: ClipRRect(
          //     borderRadius: const BorderRadius.all(Radius.circular(25)),
          //     child: BackdropFilter(
          //       filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
          //       child: Container(
          //         width: 450,
          //         height: 250,
          //         decoration: BoxDecoration(
          //             color: Colors.grey.withOpacity(0.4),
          //             borderRadius:
          //                 const BorderRadius.all(Radius.circular(25))),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
