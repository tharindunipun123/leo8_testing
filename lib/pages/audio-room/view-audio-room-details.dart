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
        title: Text(''),
        actions: [
          Icon(Icons.share),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Profile Section
              Container(
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Color.fromARGB(255, 116, 13, 225),
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(
                          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'), // Replace with actual image URL
                    ),
                    SizedBox(height: 8),
                    Text(
                      '❤️❤️💕 Group Name',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'VoiceClub ID: ${widget.roomId}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Chip(label: Text('Basse')),
                        SizedBox(width: 4),
                        Chip(label: Text('Music')),
                        SizedBox(width: 4),
                        Chip(label: Text('Voiceroom')),
                        SizedBox(width: 4),
                        Chip(label: Text('Game')),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(height: 32, thickness: 1, color: Colors.grey),

              // VoiceClub Room Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                  // boxShadow: [
                  //   BoxShadow(
                  //     color:
                  //         Colors.grey.withOpacity(0.5), // color of the shadow
                  //     spreadRadius: 5, // spread radius
                  //     blurRadius: 7, // blur radius
                  //     offset: Offset(0, 3), // changes position of shadow
                  //   ),
                  // ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VoiceClub Room',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 16),
                      ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://example.com/avatar1.png'), // Replace with actual image URL
                        ),
                        title: Text('💕💕 මා නිවේදන්...'),
                        trailing: Icon(Icons.signal_cellular_alt),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 32, thickness: 1, color: Colors.grey),

              // Group Members Section
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Group Members',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text('3938 people'),
                        ],
                      ),
                      SizedBox(height: 16),
                      FutureBuilder<List<UserDetails>>(
                        future: _futureRoomDetails,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No members found.'));
                          } else {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                UserDetails userDetails = snapshot.data![index];
                                return ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(userDetails.profilePicUrl),
                                  ),
                                  title: Text(userDetails.userName),
                                  subtitle: Text(userDetails.phoneNumber),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
