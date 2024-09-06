import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/pages/status/add-status.dart';
import 'dart:convert';

import 'package:flutter_application_1/pages/status/view-user-status.dart';

class StatusPage extends StatelessWidget {
  final String userId;

  StatusPage({required this.userId});

  Future<Map<String, List<Map<String, dynamic>>>> _fetchUserStatuses(
      String userId) async {
    try {
      final response = await http.post(
        Uri.parse(
            'http://45.126.125.172:8080/api/v1/getUserStatusesForFriends?userId=$userId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Map<String, dynamic>> userStatuses = responseData
            .map<Map<String, dynamic>>(
                (e) => e is Map<String, dynamic> ? e : {})
            .toList();

        // Group statuses by userName
        Map<String, List<Map<String, dynamic>>> groupedStatuses = {};

        for (var status in userStatuses) {
          String createdAt =
              status['createdAt'].toString().split('T')[0]; // Extract date
          status['createdAt'] = createdAt; // Update createdAt to date only

          String userName = status['userName'] ?? 'Unknown';
          if (!groupedStatuses.containsKey(userName)) {
            groupedStatuses[userName] = [];
          }

          groupedStatuses[userName]!.add(status);
        }

        print('Fetched statuses for user $userId');
        print(groupedStatuses); // Print grouped statuses
        return groupedStatuses;
      } else {
        print(
            'Failed to fetch statuses for user $userId: ${response.statusCode}');
        throw Exception('Failed to fetch statuses');
      }
    } catch (e) {
      print('Error fetching statuses: $e');
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statuses'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
              future: _fetchUserStatuses(userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  Map<String, List<Map<String, dynamic>>> groupedStatuses =
                      snapshot.data!;
                  List<String> userNames = groupedStatuses.keys.toList();
                  Set<String> displayedUserNames = {};

                  return ListView.builder(
                    itemCount: userNames.length,
                    itemBuilder: (context, index) {
                      String userName = userNames[index];
                      List<Map<String, dynamic>> userStatuses =
                          groupedStatuses[userName]!;

                      // Check if userName has been displayed
                      if (displayedUserNames.contains(userName)) {
                        // Skip this userName if already displayed
                        return Container();
                      } else {
                        // Add userName to the set of displayed userNames
                        displayedUserNames.add(userName);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewUserStatusScreen(
                                    uploaderId: userStatuses.first['userId']),
                              ),
                            );
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            padding: EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      image: NetworkImage(userStatuses
                                              .first['profilePicUrl'] ??
                                          'https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg'), // Replace with your image URL
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.0),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        userName, // Use userName variable
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 5.0),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(child: Text('No statuses available.'));
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 10.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddStatusPage(userId: userId)),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
