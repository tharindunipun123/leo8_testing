import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_application_1/pages/edit%20profile/main_profile.dart';

class Profile extends StatefulWidget {
  final String userId;
  const Profile({Key? key, required this.userId}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> userData = {
    "id":"1",
    "name":"TestName",
    "profilePicUrl":"https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg"
  };

  Future<void> readUserData() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user.json');
      final exists = await file.exists();

      if (exists) {
        final contents = await file.readAsString();
        final data = json.decode(contents);

        setState(() {
          userData = data; // Update userData with local data
        });

        // Fetch updated user data from API
        await fetchAndUpdateUserData();
      } else {
        print("User data file does not exist.");
      }
    } catch (e) {
      // Handle any errors here
      print("Error reading user data: $e");
    }
  }

  Future<void> fetchAndUpdateUserData() async {
    try {
      final response = await http.get(
          Uri.parse('http://45.126.125.172:8080/api/v1/user/${widget.userId}'));

      if (response.statusCode == 200) {
        final userDataFromApi = json.decode(response.body);

        // Update local userData with API data
        setState(() {
          userData = userDataFromApi;
        });

        // Save updated user data to local storage (user.json)
        await saveUserDataToLocal(userDataFromApi);
      } else {
        print('Failed to fetch user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> saveUserDataToLocal(Map<String, dynamic> userData) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/user.json');

      // Write user data to file
      await file.writeAsString(json.encode(userData));

      print('User data saved locally.');
    } catch (e) {
      print('Error saving user data locally: $e');
    }
  }

  Future<void> updateUserName(String newName) async {
    try {
      final response = await http.put(
        Uri.parse('http://45.126.125.172:8080/api/v1/user/${widget.userId}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'name': newName,
        }),
      );

      if (response.statusCode == 200) {
        // Fetch updated user data after successful update
        await fetchAndUpdateUserData();
        print('User name updated successfully.');
      } else {
        print('Failed to update user name: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating user name: $e');
    }
  }

  @override
  void initState() {
    super.initState();
   // readUserData();
    // Fetch initial user data on widget initialization
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure user data is updated if returning to this page
    if (ModalRoute.of(context)?.isCurrent == true) {
      readUserData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Account',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: Center(
        child: userData.isNotEmpty
            ? Container(
                margin: const EdgeInsets.all(8),
                child: ListView(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: userData['profilePicUrl'] != null
                                ? NetworkImage(userData['profilePicUrl'])
                                : const NetworkImage(
                                    'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'),
                            radius: 24,
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${userData['name']}', // Display user's name
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => MainProfile(
                                        name: userData['name'],
                                        userId: userData['id'].toString(),
                                        profileImgUrl:
                                            userData['profilePicUrl'],
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildListItem(context, Icons.account_balance_wallet,
                        'Leo Wallet', '/wallet'),
                    _buildListItem(
                        context, Icons.emoji_events, 'Nobel', '/nobel'),
                    _buildListItem(
                        context, Icons.star, 'Achivement', '/achievement'),
                    _buildListItem(
                        context, Icons.switch_video_sharp, 'Svip', '/svip'),
                    _buildListItem(
                        context, Icons.graphic_eq, 'Level', '/level'),
                    _buildListItem(
                        context, Icons.group_add, 'Invite Friends', '/invite'),
                    SizedBox(height: 16),
                    _buildListItem(
                        context, Icons.language, 'Language', '/language'),
                    _buildListItem(
                        context, Icons.feedback, 'Feedback', '/feedback'),
                    _buildListItem(
                        context, Icons.settings, 'Settings', '/settings'),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, IconData icon, String title, String routeName) {
    return Card(
      color: Colors.blue[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          leading: Icon(
            icon,
            color: Colors.blue[600],
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pushNamed(context, routeName);
          },
        ),
      ),
    );
  }
}
