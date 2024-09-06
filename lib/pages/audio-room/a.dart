import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserDetails {
  final int detailId;
  final String userName;
  final int userId;
  final int roomId;
  final String phoneNumber;
  final String profilePicUrl;
  final String joinedDateTime;
  final String about;

  UserDetails({
    required this.detailId,
    required this.userName,
    required this.userId,
    required this.roomId,
    required this.phoneNumber,
    required this.profilePicUrl,
    required this.joinedDateTime,
    required this.about,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      detailId: json['detailId'],
      userName: json['userName'],
      userId: json['userId'],
      roomId: json['roomId'],
      phoneNumber: json['phoneNumber'],
      profilePicUrl: json['profilePicUrl'],
      joinedDateTime: json['joinedDateTime'],
      about: json['about'],
    );
  }
}

class ViewAudioRoomDetails extends StatefulWidget {
  final String roomId;

  const ViewAudioRoomDetails({Key? key, required this.roomId})
      : super(key: key);

  @override
  State<ViewAudioRoomDetails> createState() => _ViewAudioRoomDetailsState();
}

class _ViewAudioRoomDetailsState extends State<ViewAudioRoomDetails> {
  late Future<List<UserDetails>> _futureRoomDetails;

  @override
  void initState() {
    super.initState();
    _futureRoomDetails = fetchRoomDetails();
  }

  Future<List<UserDetails>> fetchRoomDetails() async {
    int roomId = int.tryParse(widget.roomId) ?? 0;
    if (roomId == 0) return [];

    final url =
        Uri.parse('http://45.126.125.172:8080/api/v1/roomDetails/room/$roomId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<UserDetails> userDetailsList =
            data.map((e) => UserDetails.fromJson(e)).toList();
        return userDetailsList;
      } else {
        throw Exception('Failed to load room details');
      }
    } catch (e) {
      print('Error fetching voice rooms: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text('Group Details'),
      ),
      body: FutureBuilder<List<UserDetails>>(
        future: _futureRoomDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<UserDetails> members = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container for group information
                Container(
                  height: 250,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.network(
                          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg',
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Group Name",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "ID: 123456",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider with text for members list
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Members",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4), // Adjust the height as needed
                            Container(
                              height: 1,
                              width: 60, // Adjust the width as needed
                              color: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable list of members
                Expanded(
                  child: ListView.builder(
                    itemCount: members.length,
                    itemBuilder: (context, index) {
                      UserDetails member = members[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(member.profilePicUrl),
                        ),
                        title: Text(member.userName),
                        subtitle: Text(member.about),
                      );
                    },
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
