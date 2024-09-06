// import 'package:flutter/material.dart';
// import 'package:flutter_application_1/pages/status/status-page.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:contacts_service/contacts_service.dart';
// // import 'package:flutter_application_1/pages/rooms/voice_room_main_screen.dart';
// // import 'package:flutter_application_1/pages/status/status-page.dart';
// // import 'package:flutter_application_1/widgets/call_invitation.dart';
// import 'package:flutter_application_1/zego%20files/initial.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// // import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// //import 'package:zego_zimkit/zego_zimkit.dart';
// import 'package:uuid/uuid.dart';
// import 'package:lottie/lottie.dart';
//
// import '../games/games.dart';
// import '../profile/profile.dart';
// import '../group/group.dart';
//
// Widget buildBottomTabs(BuildContext context, int index, String userId,
//     String name, String userAvatar) {
//   List<Widget> tabs = [
//     tabBarView(context, userId, name, userAvatar),
//     Group(
//       userId: userId,
//       userName: name,
//       userAvatar: userAvatar,
//     ),
//     // VoiceRoomMainScreen(
//     //   userId: userId,
//     //   user_name: name,
//     //   user_avatar: userAvatar,
//     // ),
//     const Games(),
//   //  const Games(),
//      Profile(userId: userId),
//   ];
//
//   return tabs[index];
// }
//
// // List<ValueNotifier<ZIMKitConversation>> filterConversationsByType(
// //   List<ValueNotifier<ZIMKitConversation>> conversations,
// //   ZIMConversationType type,
// // ) {
// //   return conversations
// //       .where((conversation) => conversation.value.type == type)
// //       .toList();
// // }
//
// String generateRandomCallId() {
//   var uuid = const Uuid();
//   return uuid.v4();
// }
//
// Future<String> _getOrGenerateCallID(int senderID, int receiverID) async {
//   final response = await http.get(Uri.parse(
//       'http://45.126.125.172:8080/api/v1/getCallerId?senderID=$senderID&receiverId=$receiverID'));
//   if (response.statusCode == 200) {
//     print(response.body);
//     final data = json.decode(response.body);
//     if (data['exists'] && data['details']['callerId'] != null) {
//       return data['details']['callerId'].toString();
//     } else {
//       var uuid = const Uuid();
//       String callID = uuid.v4();
//       const String url = 'http://45.126.125.172:8080/api/v1/addOrUpdateCall';
//       final Map<String, dynamic> queryParams = {
//         'senderID': senderID.toString(),
//         'callerId': callID.toString(),
//         'receiverId': receiverID.toString(),
//       };
//       final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
//       print(uri);
//       final saveResponse = await http.post(uri);
//       print(saveResponse.statusCode.toString());
//       print(saveResponse.body);
//       if (saveResponse.statusCode == 200) {
//         return callID;
//       } else {
//         throw Exception('Failed to save call ID');
//       }
//     }
//   } else {
//     throw Exception('Failed to fetch call ID');
//   }
// }
//
// Future<List<int>> _fetchContacts(BuildContext context) async {
//   var status = await Permission.contacts.request();
//
//   if (status.isGranted) {
//     try {
//       Iterable<Contact> contacts = await ContactsService.getContacts();
//
//       List<Map<String, String>> formattedContacts = contacts.map((contact) {
//         String mobileNumber = contact.phones?.isNotEmpty ?? false
//             ? contact.phones!.first.value ?? ''
//             : '';
//         if (mobileNumber.isNotEmpty) {
//           mobileNumber = mobileNumber.substring(1);
//         }
//         return {
//           'mobileNumber': mobileNumber,
//           'contactName': contact.displayName ?? '',
//         };
//       }).toList();
//
//       final url = Uri.parse('http://45.126.125.172:8080/api/v1/checkContacts');
//
//       final response = await http.post(
//         url,
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(formattedContacts),
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body) as List<dynamic>;
//         final List<int> userIds =
//             responseData.map<int>((e) => e['userId'] as int).toList();
//
//         print('Contacts sent successfully');
//         return userIds;
//       } else {
//         print('Failed to send contacts: ${response.statusCode}');
//         throw Exception('Failed to send contacts: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching or sending contacts: $e');
//       throw e; // Re-throw the exception to handle it elsewhere if needed
//     }
//   } else {
//     // Handle case where permission is not granted
//     print('Contacts permission not granted');
//     return []; // Return an empty list or handle accordingly in your UI
//   }
// }
//
// Future<List<Map<String, dynamic>>> fetchStatusesForUsers(
//     List<int> userIds) async {
//   List<Map<String, dynamic>> allStatuses = [];
//
//   for (int userId in userIds) {
//     try {
//       final response = await http.get(
//         Uri.parse('http://45.126.125.172:8080/api/v1/user/$userId/statuses'),
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(response.body);
//         List<Map<String, dynamic>> userStatuses = responseData
//             .map<Map<String, dynamic>>(
//                 (e) => e is Map<String, dynamic> ? e : {})
//             .toList();
//
//         allStatuses.addAll(userStatuses);
//         print('Fetched statuses for user $userId');
//       } else {
//         print(
//             'Failed to fetch statuses for user $userId: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching statuses for user $userId: $e');
//     }
//   }
//
//   return allStatuses;
// }
//
// Widget tabBarView(
//     BuildContext context, String userId, String name, String userAvatar) {
//   return TabBarView(
//     children: [
//       // ZIMKitConversationListView(
//       //   filter: (context, conversations) =>
//       //       filterConversationsByType(conversations, ZIMConversationType.peer),
//       //   onPressed: (context, conversation, defaultAction) async {
//       //     print(conversation.id);
//       //     int? receiverId = int.tryParse(conversation.id);
//       //     int? senderId = int.tryParse(userId);
//       //     if (receiverId != null && senderId != null) {
//       //       Navigator.push(context, MaterialPageRoute(
//       //         builder: (context) {
//       //           return ZIMKitMessageListPage(
//       //             conversationID: conversation.id,
//       //             conversationType: conversation.type,
//       //             appBarActions: [
//       //               IconButton(
//       //                 onPressed: () async {
//       //                   try {
//       //                     // final callID =
//       //                     //     await _getOrGenerateCallID(senderId, receiverId);
//       //                     // ZegoUIKitPrebuiltCallInvitationService().init(
//       //                     //   appID: Initial.id, // Replace with your AppID
//       //                     //   appSign:
//       //                     //       Initial.signIn, // Replace with your AppSign
//       //                     //   userID: userId,
//       //                     //   userName: name,
//       //                     //   plugins: [ZegoUIKitSignalingPlugin()],
//       //                     // );
//
//       //                     // Navigator.push(
//       //                     //   context,
//       //                     //   MaterialPageRoute(
//       //                     //     builder: (context) => CallInvitationWidget(
//       //                     //       userId: conversation.id,
//       //                     //       username: 'l',
//       //                     //       callID: callID,
//       //                     //     ),
//       //                     //   ),
//       //                     // );
//       //                   } catch (e) {
//       //                     print('Error generating call ID: $e');
//       //                   }
//       //                 },
//       //                 icon: const Icon(Icons.call),
//       //               ),
//       //               IconButton(
//       //                 onPressed: () async {
//       //                   var uuid = const Uuid();
//       //                   String callID = uuid.v4();
//
//       //                   // Uncomment and update the following lines if needed
//       //                   // await Navigator.push(context, MaterialPageRoute(
//       //                   //   builder: (context) {
//       //                   //     return CallPage(
//       //                   //       callID: callID,
//       //                   //       userID: userId,
//       //                   //       userName: name,
//       //                   //     );
//       //                   //   },
//       //                   // ));
//       //                 },
//       //                 icon: const Icon(Icons.video_call),
//       //               ),
//       //             ],
//       //           );
//       //         },
//       //       ));
//       //     } else {
//       //       print('Error: userId and conversation.id must be integers.');
//       //     }
//       //   },
//       // ),
//
//       StatusPage(userId: userId),
//       Center(
//         child: GridView.count(
//           crossAxisCount: 3, // Number of columns
//           children: [
//             Lottie.asset(
//                 'assets/animations/1.json'), // Replace with your animation files
//             Lottie.asset('assets/animations/2.json'),
//             Lottie.asset('assets/animations/3.json'),
//             Lottie.asset('assets/animations/4.json'),
//             Lottie.asset('assets/animations/5.json'),
//             Lottie.asset('assets/animations/6.json'),
//             Lottie.asset('assets/animations/7.json'),
//             Lottie.asset('assets/animations/8.json'),
//             Lottie.asset('assets/animations/9.json'),
//           ],
//         ),
//       ),
//     ],
//   );
// }

//**//
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter_application_1/pages/rooms/voice_room_main_screen.dart';
import 'package:flutter_application_1/pages/status/status-page.dart';
import 'package:flutter_application_1/widgets/call_invitation.dart';
import 'package:flutter_application_1/zego%20files/initial.dart';
import 'package:permission_handler/permission_handler.dart';
// import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
// import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
// import 'package:zego_zimkit/zego_zimkit.dart';
import 'package:uuid/uuid.dart';
import 'package:lottie/lottie.dart';

import '../games/games.dart';
import '../profile/profile.dart';

Widget buildBottomTabs(BuildContext context, int index, String userId,
    String name, String userAvatar) {
  List<Widget> tabs = [
    tabBarView(context, userId, name, userAvatar),
    // Group(
    //   userId: userId,
    //   userName: name,
    //   userAvatar: userAvatar,
    // ),
    // VoiceRoomMainScreen(
    //   userId: userId,
    //   user_name: name,
    //   user_avatar: userAvatar,
    // ),
    const Games(),
    const Games(),

    Profile(userId: userId),
  ];

  return tabs[index];
}

// List<ValueNotifier<ZIMKitConversation>> filterConversationsByType(
//     List<ValueNotifier<ZIMKitConversation>> conversations,
//     ZIMConversationType type,
//     ) {
//   return conversations
//       .where((conversation) => conversation.value.type == type)
//       .toList();
// }

String generateRandomCallId() {
  var uuid = const Uuid();
  return uuid.v4();
}

Future<String> _getOrGenerateCallID(int senderID, int receiverID) async {
  final response = await http.get(Uri.parse(
      'http://45.126.125.172:8080/api/v1/getCallerId?senderID=$senderID&receiverId=$receiverID'));
  if (response.statusCode == 200) {
    print(response.body);
    final data = json.decode(response.body);
    if (data['exists'] && data['details']['callerId'] != null) {
      return data['details']['callerId'].toString();
    } else {
      var uuid = const Uuid();
      String callID = uuid.v4();
      const String url = 'http://45.126.125.172:8080/api/v1/addOrUpdateCall';
      final Map<String, dynamic> queryParams = {
        'senderID': senderID.toString(),
        'callerId': callID.toString(),
        'receiverId': receiverID.toString(),
      };
      final Uri uri = Uri.parse(url).replace(queryParameters: queryParams);
      print(uri);
      final saveResponse = await http.post(uri);
      print(saveResponse.statusCode.toString());
      print(saveResponse.body);
      if (saveResponse.statusCode == 200) {
        return callID;
      } else {
        throw Exception('Failed to save call ID');
      }
    }
  } else {
    throw Exception('Failed to fetch call ID');
  }
}

Future<List<int>> _fetchContacts(BuildContext context) async {
  var status = await Permission.contacts.request();

  if (status.isGranted) {
    try {
      Iterable<Contact> contacts = await ContactsService.getContacts();

      List<Map<String, String>> formattedContacts = contacts.map((contact) {
        String mobileNumber = contact.phones?.isNotEmpty ?? false
            ? contact.phones!.first.value ?? ''
            : '';
        if (mobileNumber.isNotEmpty) {
          mobileNumber = mobileNumber.substring(1);
        }
        return {
          'mobileNumber': mobileNumber,
          'contactName': contact.displayName ?? '',
        };
      }).toList();

      final url = Uri.parse('http://45.126.125.172:8080/api/v1/checkContacts');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(formattedContacts),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body) as List<dynamic>;
        final List<int> userIds =
        responseData.map<int>((e) => e['userId'] as int).toList();

        print('Contacts sent successfully');
        return userIds;
      } else {
        print('Failed to send contacts: ${response.statusCode}');
        throw Exception('Failed to send contacts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching or sending contacts: $e');
      throw e; // Re-throw the exception to handle it elsewhere if needed
    }
  } else {
    // Handle case where permission is not granted
    print('Contacts permission not granted');
    return []; // Return an empty list or handle accordingly in your UI
  }
}

Future<List<Map<String, dynamic>>> fetchStatusesForUsers(
    List<int> userIds) async {
  List<Map<String, dynamic>> allStatuses = [];

  for (int userId in userIds) {
    try {
      final response = await http.get(
        Uri.parse('http://45.126.125.172:8080/api/v1/user/$userId/statuses'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        List<Map<String, dynamic>> userStatuses = responseData
            .map<Map<String, dynamic>>(
                (e) => e is Map<String, dynamic> ? e : {})
            .toList();

        allStatuses.addAll(userStatuses);
        print('Fetched statuses for user $userId');
      } else {
        print(
            'Failed to fetch statuses for user $userId: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching statuses for user $userId: $e');
    }
  }

  return allStatuses;
}

Widget tabBarView(
    BuildContext context, String userId, String name, String userAvatar) {
  return TabBarView(
    children: [
      // ZIMKitConversationListView(
      //   filter: (context, conversations) =>
      //       filterConversationsByType(conversations, ZIMConversationType.peer),
      //   onPressed: (context, conversation, defaultAction) async {
      //     print(conversation.id);
      //     int? receiverId = int.tryParse(conversation.id);
      //     int? senderId = int.tryParse(userId);
      //     if (receiverId != null && senderId != null) {
      //       Navigator.push(context, MaterialPageRoute(
      //         builder: (context) {
      //           return ZIMKitMessageListPage(
      //             conversationID: conversation.id,
      //             conversationType: conversation.type,
      //             appBarActions: [
      //               IconButton(
      //                 onPressed: () async {
      //                   try {
      //                     final callID =
      //                     await _getOrGenerateCallID(senderId, receiverId);
      //                     ZegoUIKitPrebuiltCallInvitationService().init(
      //                       appID: Initial.id, // Replace with your AppID
      //                       appSign:
      //                       Initial.signIn, // Replace with your AppSign
      //                       userID: userId,
      //                       userName: name,
      //                       plugins: [ZegoUIKitSignalingPlugin()],
      //                     );
      //
      //                     Navigator.push(
      //                       context,
      //                       MaterialPageRoute(
      //                         builder: (context) => CallInvitationWidget(
      //                           userId: conversation.id,
      //                           username: 'l',
      //                           callID: callID,
      //                         ),
      //                       ),
      //                     );
      //                   } catch (e) {
      //                     print('Error generating call ID: $e');
      //                   }
      //                 },
      //                 icon: const Icon(Icons.call),
      //               ),
      //               IconButton(
      //                 onPressed: () async {
      //                   var uuid = const Uuid();
      //                   String callID = uuid.v4();
      //
      //                   // Uncomment and update the following lines if needed
      //                   // await Navigator.push(context, MaterialPageRoute(
      //                   //   builder: (context) {
      //                   //     return CallPage(
      //                   //       callID: callID,
      //                   //       userID: userId,
      //                   //       userName: name,
      //                   //     );
      //                   //   },
      //                   // ));
      //                 },
      //                 icon: const Icon(Icons.video_call),
      //               ),
      //             ],
      //           );
      //         },
      //       ));
      //     } else {
      //       print('Error: userId and conversation.id must be integers.');
      //     }
      //   },
      // ),
      Center(
        child: Text("Chat Page"),
      ),
      StatusPage(userId: userId),
      Center(
        child: GridView.count(
          crossAxisCount: 3, // Number of columns
          children: [
            Lottie.asset(
                'assets/animations/1.json'), // Replace with your animation files
            Lottie.asset('assets/animations/2.json'),
            Lottie.asset('assets/animations/3.json'),
            Lottie.asset('assets/animations/4.json'),
            Lottie.asset('assets/animations/5.json'),
            Lottie.asset('assets/animations/6.json'),
            Lottie.asset('assets/animations/7.json'),
            Lottie.asset('assets/animations/8.json'),
            Lottie.asset('assets/animations/9.json'),
          ],
        ),
      ),
    ],
  );
}

