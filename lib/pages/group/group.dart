import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/audio-room/live_page.dart';
import 'package:flutter_application_1/pages/group/GroupMembers.dart';
import 'package:flutter_application_1/widgets/blink_button.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:zego_zimkit/zego_zimkit.dart';

import '../audio-room/audio_room_screen.dart';

class Group extends StatefulWidget {
  final String userId;
  final String userName;
  final String userAvatar;

  const Group(
      {Key? key,
      required this.userId,
      required this.userName,
      required this.userAvatar})
      : super(key: key);

  @override
  _GroupState createState() => _GroupState();
}

class _GroupState extends State<Group> {
  List<String> publicGroupIds = [];
  List<String> privateGroupIds = [];
  bool showPublicChats = false; // Default to private chats

  @override
  void initState() {
    super.initState();
    fetchPublicGroups();
    fetchPrivateGroups(); // Fetch private groups on initialization
  }

  Future<void> fetchPublicGroups() async {
    Uri url =
        Uri.parse('http://45.126.125.172:8080/api/v1/publicgroups/groups');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<String> groupIds =
            jsonResponse.map((group) => group['groupId'].toString()).toList();
        setState(() {
          publicGroupIds = groupIds;
        });
        print(groupIds);
      } else {
        throw Exception('Failed to load public groups');
      }
    } catch (e) {
      print('Error fetching public groups: $e');
    }
  }

  Future<void> fetchPrivateGroups() async {
    Uri url =
        Uri.parse('http://45.126.125.172:8080/api/v1/groups/privategroups');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<String> groupIds =
            jsonResponse.map((group) => group['groupId'].toString()).toList();
        setState(() {
          privateGroupIds = groupIds;
        });
        print(groupIds);
      } else {
        throw Exception('Failed to load private groups');
      }
    } catch (e) {
      print('Error fetching private groups: $e');
    }
  }

  // Future<bool> isUserAdmin(String groupId, String userId) async {
  //   print(groupId);
  //   print(userId);
  //   Uri url =
  //       Uri.parse('http://45.126.125.172:8080/api/v1/groups/$groupId/admin');
  //   try {
  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       Map<int, dynamic> jsonResponse = json.decode(response.body);
  //       print('admin - ${jsonResponse['adminId']}');
  //       print('im id - ${userId}');
  //       return jsonResponse['adminId'].toString() == userId;
  //     } else {
  //       throw Exception('Failed to load admin details');
  //     }
  //   } catch (e) {
  //     print('Error checking admin status: $e');
  //     return false;
  //   }
  // }
  Future<bool> isUserAdminPrivateGp(String groupId, String userId) async {
    print(groupId);
    print(userId);

    Uri url =
        Uri.parse('http://45.126.125.172:8080/api/v1/groups/${groupId}/admin');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('admin - ${jsonResponse['adminName']}');
        print('im id - ${userId}');
        // Assuming adminId is an int, convert userId to int for comparison
        // int userIdInt = int.tryParse(userId) ?? 0;
        return jsonResponse['adminId'].toString() == userId;
        //return '14' == userId;
      } else {
        throw Exception('Failed to load admin details');
      }
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  Future<bool> isUserAdminPublicGp(String groupId, String userId) async {
    print(groupId);
    print(userId);

    Uri url = Uri.parse(
        'http://45.126.125.172:8080/api/v1/publicgroups/${groupId}/admin');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print(response.body);
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        print('admin - ${jsonResponse['adminId']}');
        print('im id - ${userId}');
        // Assuming adminId is an int, convert userId to int for comparison
        // int userIdInt = int.tryParse(userId) ?? 0;
        return jsonResponse['adminId'].toString() == userId;
        //return '14' == userId;
      } else {
        throw Exception('Failed to load admin details');
      }
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  Future<void> saveVoiceRoom(String groupId, String voiceRoomId) async {
    Map<String, dynamic> requestBodyData = {
      'groupId': groupId,
      'voiceRoomId': voiceRoomId,
      'isCreated': true,
    };

    var jsonData = json.encode(requestBodyData);

    Uri url = Uri.parse('http://45.126.125.172:8080/api/v1/voiceroom/save');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonData,
      );
      if (response.statusCode == 200) {
        print('Voice room saved successfully');
      } else {
        print('Failed to save voice room: ${response.statusCode}');
      }
      print('ullali');
      print('ullali - ${response.body}');
    } catch (e) {
      print('Error saving voice room: $e');
    }
  }

  // List<ValueNotifier<ZIMKitConversation>> filterConversationsByType(
  //   List<ValueNotifier<ZIMKitConversation>> conversations,
  //   ZIMConversationType type,
  // ) {
  //   List<ValueNotifier<ZIMKitConversation>> filteredConversations = [];
  //
  //   conversations.forEach((conversation) {
  //     try {
  //       String conversationId = conversation.value.id;
  //       bool isPublicGroup = publicGroupIds.contains(conversationId);
  //       bool isPrivateGroup = privateGroupIds.contains(conversationId);
  //       if (conversation.value.type == type) {
  //         if (showPublicChats && isPublicGroup) {
  //           filteredConversations.add(conversation);
  //         } else if (!showPublicChats && isPrivateGroup) {
  //           filteredConversations.add(conversation);
  //         }
  //       }
  //     } catch (e) {
  //       print('Error parsing conversation ID: $e');
  //     }
  //   });
  //
  //   return filteredConversations;
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Group Conversations'),
        actions: [
          IconButton(
            icon: Icon(Icons.public),
            onPressed: () {
              setState(() {
                showPublicChats = true;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.lock),
            onPressed: () {
              setState(() {
                showPublicChats = false;
              });
            },
          ),
        ],
      ),
      // body: Center(
      //   child: ZIMKitConversationListView(
      //     // filter: (context, conversations) => filterConversationsByType(
      //     //   conversations,
      //     //   ZIMConversationType.group,
      //     // ),
      //     onPressed: (context, conversation, defaultAction) async {
      //       bool isAdmin = false;
      //       if (conversation.type == ZIMConversationType.group) {
      //         try {
      //           String conversationId = conversation.id;
      //           if (publicGroupIds.contains(conversationId)) {
      //             isAdmin =
      //                 await isUserAdminPublicGp(conversationId, widget.userId);
      //           } else if (privateGroupIds.contains(conversationId)) {
      //             isAdmin =
      //                 await isUserAdminPrivateGp(conversationId, widget.userId);
      //           } else {
      //             return;
      //           }
      //           //isAdmin = await isUserAdmin(conversation.id, widget.userId);
      //         } catch (e) {
      //           print('Error checking admin status: $e');
      //         }
      //       } else {
      //         return;
      //       }
      //       // Navigator.push(
      //       //   context,
      //       //   MaterialPageRoute(
      //       //     builder: (context) {
      //       //       return
      //       //         ZIMKitMessageListPage(
      //       //         conversationID: conversation.id,
      //       //         conversationType: conversation.type,
      //       //         appBarBuilder: (context, defaultAppBar) {
      //       //           return AppBar(
      //       //             title: Row(
      //       //               children: [
      //       //                 CircleAvatar(child: conversation.icon),
      //       //                 const SizedBox(width: 15),
      //       //                 Column(
      //       //                   crossAxisAlignment: CrossAxisAlignment.start,
      //       //                   children: [
      //       //                     Text(conversation.name,
      //       //                         style: const TextStyle(fontSize: 16),
      //       //                         overflow: TextOverflow.clip),
      //       //                     Text(conversation.id,
      //       //                         style: const TextStyle(fontSize: 12),
      //       //                         overflow: TextOverflow.clip)
      //       //                   ],
      //       //                 )
      //       //               ],
      //       //             ),
      //       //             actions: [
      //       //               if (conversation.type == ZIMConversationType.group &&
      //       //                   isAdmin) ...[
      //       //                 GestureDetector(
      //       //                   behavior: HitTestBehavior.opaque,
      //       //                   onTap: () {
      //       //                     Navigator.push(
      //       //                       context,
      //       //                       MaterialPageRoute(
      //       //                         builder: (context) => GroupMembersPage(
      //       //                           groupID: conversation.id,
      //       //                           myId: widget.userId,
      //       //                         ),
      //       //                       ),
      //       //                     );
      //       //                   },
      //       //                   child: const Icon(Icons.group),
      //       //                 ),
      //       //                 const SizedBox(
      //       //                   width: 20,
      //       //                 ),
      //       //                 if (showPublicChats) // Show only for public groups
      //       //                   MyBlinkingButton(
      //       //                     onPressed: () async {
      //       //                       var uuid = const Uuid();
      //       //                       String voiceChatID;
      //       //                       String groupId = conversation
      //       //                           .id; // Replace with the appropriate groupId
      //       //                       String url =
      //       //                           'http://45.126.125.172:8080/api/v1/voiceroom/roomdetails/$groupId';
      //       //
      //       //                       // Check if the voice room ID is available
      //       //                       try {
      //       //                         var response =
      //       //                             await http.get(Uri.parse(url));
      //       //                         var responseBody =
      //       //                             json.decode(response.body);
      //       //
      //       //                         if (response.statusCode == 200 &&
      //       //                             responseBody['isCreated'] == true) {
      //       //                           // If the voice room details are available
      //       //                           voiceChatID = responseBody['voiceRoomId'];
      //       //                           print(
      //       //                               'Existing Voice Chat ID: $voiceChatID');
      //       //                         } else {
      //       //                           // If no voice room details are found, create a new ID
      //       //                           voiceChatID = uuid.v4();
      //       //                           print(
      //       //                               'Generated Voice Chat ID: $voiceChatID');
      //       //                           await saveVoiceRoom(groupId, voiceChatID);
      //       //                         }
      //       //
      //       //                         // Navigate to LivePage2
      //       //                         Navigator.push(
      //       //                           context,
      //       //                           MaterialPageRoute(
      //       //                             builder: (context) => LivePage2(
      //       //                               roomID: voiceChatID,
      //       //                               userId: widget.userId,
      //       //                               user_name: widget.userName,
      //       //                               isHost: true,
      //       //                               user_avatar: widget.userAvatar,
      //       //                             ),
      //       //                           ),
      //       //                         );
      //       //                       } catch (e) {
      //       //                         print('Error checking voice room ID: $e');
      //       //                       }
      //       //                     },
      //       //                     title: "Start Now",
      //       //                     // child: const Text('Start Now'),
      //       //                   ),
      //       //                 const SizedBox(
      //       //                   width: 5,
      //       //                 )
      //       //
      //       //                 //  MyBlinkingButton()
      //       //               ] else ...[
      //       //                 ElevatedButton(
      //       //                   onPressed: () async {
      //       //                     var uuid = const Uuid();
      //       //                     String voiceChatID;
      //       //                     String groupId = conversation
      //       //                         .id; // Replace with the appropriate groupId
      //       //                     String url =
      //       //                         'http://45.126.125.172:8080/api/v1/voiceroom/roomdetails/$groupId';
      //       //
      //       //                     // Check if the voice room ID is available
      //       //                     try {
      //       //                       var response = await http.get(Uri.parse(url));
      //       //                       var responseBody = json.decode(response.body);
      //       //
      //       //                       if (response.statusCode == 200 &&
      //       //                           responseBody['isCreated'] == true) {
      //       //                         // If the voice room details are available
      //       //                         voiceChatID = responseBody['voiceRoomId'];
      //       //                         print(
      //       //                             'Existing Voice Chat ID: $voiceChatID');
      //       //
      //       //                         Navigator.push(
      //       //                           context,
      //       //                           MaterialPageRoute(
      //       //                             builder: (context) => LivePage2(
      //       //                               roomID: voiceChatID,
      //       //                               userId: widget.userId,
      //       //                               user_name: widget.userName,
      //       //                               isHost: false,
      //       //                               user_avatar: widget.userAvatar,
      //       //                             ),
      //       //                           ),
      //       //                         );
      //       //                       } else {
      //       //                         // If no voice room details are found, create a new ID
      //       //                         // voiceChatID = uuid.v4();
      //       //                         // print('Generated Voice Chat ID: $voiceChatID');
      //       //                         // await saveVoiceRoom(groupId, voiceChatID);
      //       //                         print('No Voice Roomm available');
      //       //                       }
      //       //
      //       //                       // Navigate to LivePage2
      //       //                     } catch (e) {
      //       //                       print('Error checking voice room ID: $e');
      //       //                     }
      //       //                   },
      //       //                   child: const Text('Join Now'),
      //       //                 ),
      //       //               ],
      //       //             ],
      //       //           );
      //       //         },
      //       //       );
      //       //     },
      //       //   ),
      //       // );
      //     },
      //   ),
      // ),
    );
  }

  void printGroupMembers(String conversationId) {
    // Replace with the actual logic to fetch and print group members
    print('Group members of conversation ID: $conversationId');
  }
}
