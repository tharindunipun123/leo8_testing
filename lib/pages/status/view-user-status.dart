import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:story_view/story_view.dart';

class ViewUserStatusScreen extends StatefulWidget {
  final String uploaderId;

  const ViewUserStatusScreen({Key? key, required this.uploaderId})
      : super(key: key);

  @override
  State<ViewUserStatusScreen> createState() => _ViewUserStatusScreenState();
}

class _ViewUserStatusScreenState extends State<ViewUserStatusScreen> {
  final StoryController _storyController = StoryController();
  List<Map<String, dynamic>> statuses = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchUserStatuses(widget.uploaderId);
  }

  Future<void> _fetchUserStatuses(String uploaderId) async {
    try {
      final response = await http.get(
        Uri.parse(
            'http://45.126.125.172:8080/api/v1/user/$uploaderId/statuses'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          statuses = responseData
              .map<Map<String, dynamic>>((e) => e as Map<String, dynamic>)
              .toList();
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : hasError
              ? Center(child: Text('Failed to load statuses.'))
              : Stack(
                  children: <Widget>[
                    StoryView(
                      storyItems: statuses.map((status) {
                        return StoryItem.pageImage(
                            url: status['statusImageUrl'],
                            controller: _storyController,
                            duration: Duration(seconds: 15),
                            // caption: Text(
                            //   'Uploaded at: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(status['createdAt']))}',
                            //   style: TextStyle(color: Colors.white),
                            // ),
                            caption: Text(
                              status['statusText'],
                              style: TextStyle(color: Colors.white),
                            ));
                      }).toList(),
                      onStoryShow: (storyItem, index) {
                        // Add any additional actions you want to perform
                      },
                      onComplete: () {
                        Navigator.of(context).pop();
                      },
                      progressPosition: ProgressPosition.top,
                      repeat: false,
                      controller: _storyController,
                    ),
                    
                    Positioned(
                      top: 50,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    statuses.first['profilePicUrl']),
                                radius: 30,
                              ),
                              SizedBox(width: 8),
                              Text(
                                statuses.first['userName'],
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
