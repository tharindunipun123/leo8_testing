// import 'dart:convert';
// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:virtual_gift_demo/pages/audio-room/live_page.dart';
// import 'package:virtual_gift_demo/pages/audio-room/view-audio-room-details.dart';
// import 'package:virtual_gift_demo/pages/rooms/create-voice_room_screen.dart';
// import 'package:http/http.dart' as http;
// import 'package:carousel_slider/carousel_slider.dart';
//
// class VoiceRoom {
//   final String country;
//   final bool isDeleted;
//   final int roomOwnerId;
//   final String language;
//   final int roomId;
//   final String roomName;
//   final String backgroundImageUrl;
//   int participantCount; // New field for participant count
//
//   VoiceRoom({
//     required this.country,
//     required this.isDeleted,
//     required this.roomOwnerId,
//     required this.language,
//     required this.roomId,
//     required this.roomName,
//     required this.backgroundImageUrl,
//     required this.participantCount, // Initialize with 0 or default value
//   });
//
//   factory VoiceRoom.fromJson(Map<String, dynamic> json) {
//     return VoiceRoom(
//       country: json['country'],
//       isDeleted: json['isDeleted'],
//       roomOwnerId: json['roomOwnerId'],
//       language: json['language'],
//       roomId: json['roomId'],
//       roomName: json['roomName'],
//       backgroundImageUrl: json['backgroundImageUrl'],
//       participantCount:
//           json['participantCount'] ?? 0, // Initialize with default value
//     );
//   }
// }
//
// class VoiceRoomMainScreen extends StatefulWidget {
//   final String userId;
//   final String user_name;
//   final String user_avatar;
//   const VoiceRoomMainScreen({
//     Key? key,
//     required this.userId,
//     required this.user_name,
//     required this.user_avatar,
//   }) : super(key: key);
//
//   @override
//   State<VoiceRoomMainScreen> createState() => _VoiceRoomMainScreenState();
// }
//
// class _VoiceRoomMainScreenState extends State<VoiceRoomMainScreen>
//     with TickerProviderStateMixin {
//   late final TabController _MaintabController;
//   late final TabController _MineRoomsTabController;
//   TextEditingController _inputSearchController = TextEditingController();
//   List<VoiceRoom> voiceRooms = [];
//   List<VoiceRoom> followedVoiceRooms = [];
//   List<Map<String, dynamic>> popularRoomDetails = [];
//   List<Map<String, dynamic>> searchRoomDetails = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _MaintabController = TabController(length: 3, vsync: this);
//     _MineRoomsTabController = TabController(length: 2, vsync: this);
//     fetchMyVoiceRooms();
//     fetchPopularRooms();
//   }
//
//   @override
//   void dispose() {
//     _MaintabController.dispose();
//     _MineRoomsTabController.dispose(); // Make sure to dispose of the controller
//     _inputSearchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (ModalRoute.of(context)?.isCurrent == true) {
//       fetchMyVoiceRooms(); // Example: Update voice rooms when returning to this screen
//       fetchPopularRooms();
//     }
//   }
//
//   Widget buildImageCarousel(BuildContext context) {
//     List<String> imageUrls = [
//       'assets/banners/1.png',
//       'assets/banners/2.png',
//       'assets/banners/3.png',
//       // Add more image URLs as needed
//     ];
//
//      return Container(child: Text("hello")),
//     //   options: CarouselOptions(
//     //     height: 200.0,
//     //     // autoPlay: true,
//     //     enlargeCenterPage: true,
//     //     aspectRatio: 16 / 9,
//     //     autoPlayCurve: Curves.fastOutSlowIn,
//     //     enableInfiniteScroll: true,
//     //     //  autoPlayAnimationDuration: Duration(milliseconds: 800),
//     //     viewportFraction: 0.8,
//     //   ),
//
//
//       items: imageUrls.map((url) {
//         return Builder(
//           builder: (BuildContext context) {
//             return Container(
//               width: MediaQuery.of(context).size.width,
//               margin: EdgeInsets.symmetric(horizontal: 5.0),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(
//                     10.0), // Adjust border radius as needed
//                 border: Border.all(
//                   color: Colors.blue, // Set border color here
//                   width: 2.0, // Set border width here
//                 ),
//               ),
//               child: ClipRRect(
//                 borderRadius:
//                     BorderRadius.circular(10.0), // Same border radius as above
//                 child: Image.asset(
//                   url,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//             );
//           },
//         );
//       }).toList(),
//     );
//   }
//
//   void searchRoomById(String searchText) {
//     // Filter rooms whose roomId starts with searchText
//     setState(() {
//       searchRoomDetails = popularRoomDetails
//           .where(
//               (room) => room['roomId'].toString().startsWith(searchText.trim()))
//           .toList();
//     });
//   }
//
//   void _navigateToCreateVoiceRoomPage(BuildContext context) {
//     Navigator.push(
//         context,
//         MaterialPageRoute(
//             builder: (context) => CreateVoiceRoomScreen(
//                   userId: widget.userId,
//                   user_name: widget.user_name,
//                   user_avatar: widget.user_avatar,
//                 )));
//   }
//
//   void _navigateToVoiceRoomPage(
//       BuildContext context,
//       String roomID,
//       String userId,
//       String user_name,
//       String user_avatar,
//       String bg_img,
//       bool isHost) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text("Confirm"),
//             content: Text("Are you sure go to Room"),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   //deleteMySingleVoiceRoom(RoomId);
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('Cancle'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   int myId = int.tryParse(userId) ?? 0;
//                   int intRoomId = int.tryParse(roomID) ?? 0;
//                   if (myId == 0 || intRoomId == 0) return;
//                   Navigator.of(context).pop();
//                   joinUserVoiceRoom(myId, intRoomId, bg_img);
//
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => AudioRoomPage(
//                   //               roomID: roomID,
//                   //               role: ZegoLiveAudioRoomRole.host,
//                   //             )));
//                 },
//                 child: const Text('Go'),
//               ),
//             ],
//           );
//         });
//   }
//
//   Future<void> fetchMyVoiceRooms() async {
//     int myId = int.tryParse(widget.userId) ?? 0;
//     if (myId == 0) return;
//
//     final url = Uri.parse(
//         'http://45.126.125.172:8080/api/v1/voiceRoomTeam/roomsByOwner/${widget.userId}');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = json.decode(response.body);
//         List<VoiceRoom> rooms =
//             responseData.map((data) => VoiceRoom.fromJson(data)).toList();
//
//         // Fetch participant count for each room
//         for (int i = 0; i < rooms.length; i++) {
//           int roomId =
//               rooms[i].roomId; // Adjust according to your VoiceRoom model
//           int participantCount = await fetchParticipantCount(roomId);
//           print("memeb count");
//           print(roomId);
//           print(participantCount);
//           rooms[i].participantCount = participantCount;
//         }
//
//         setState(() {
//           voiceRooms = rooms;
//         });
//       } else {
//         throw Exception('Failed to fetch voice rooms');
//       }
//     } catch (e) {
//       print('Error fetching voice rooms: $e');
//     }
//   }
//
//   Future<void> fetchMyFollowVoiceRooms() async {
//     int myId = int.tryParse(widget.userId) ?? 0;
//     if (myId == 0) return;
//
//     final url = Uri.parse(
//         'http://45.126.125.172:8080/api/v1/roomDetails/followingRooms/${widget.userId}');
//
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = json.decode(response.body);
//         List<VoiceRoom> rooms =
//             responseData.map((data) => VoiceRoom.fromJson(data)).toList();
//
//         // Fetch participant count for each room
//         for (int i = 0; i < rooms.length; i++) {
//           int roomId =
//               rooms[i].roomId; // Adjust according to your VoiceRoom model
//           int participantCount = await fetchParticipantCount(roomId);
//           print("memeb count");
//           print(roomId);
//           print(participantCount);
//           rooms[i].participantCount = participantCount;
//         }
//
//         setState(() {
//           followedVoiceRooms = rooms;
//         });
//       } else {
//         throw Exception('Failed to fetch voice rooms');
//       }
//     } catch (e) {
//       print('Error fetching voice rooms: $e');
//     }
//   }
//
//   Future<int> fetchParticipantCount(int roomId) async {
//     final countUrl = Uri.parse(
//         'http://45.126.125.172:8080/api/v1/roomDetails/countParticipants/$roomId');
//
//     try {
//       final response = await http.get(countUrl);
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//         int participantCount = responseData['participantCount'];
//         return participantCount;
//       } else {
//         throw Exception('Failed to fetch participant count for room $roomId');
//       }
//     } catch (e) {
//       print('Error fetching participant count: $e');
//       return 0; // or handle error as per your application's logic
//     }
//   }
//
//   Future<void> deleteMySingleVoiceRoom(int voiceRoomId) async {
//     final url = Uri.parse(
//         'http://45.126.125.172:8080/api/v1/voiceRoomTeam/updateDeletionStatus/${voiceRoomId}?isDeleted=true');
//     try {
//       final response = await http.put(url);
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//
//         if (responseData['status'] ==
//             "Room deletion status updated successfully") {
//           setState(() {
//             // voiceRooms.clear();
//             fetchMyVoiceRooms();
//           });
//         } else {
//           // Handle other cases where deletion status update was not successful
//           // This block can be optional depending on your specific requirements
//           throw Exception('Failed to delete voice rooms');
//         }
//       } else {
//         throw Exception('Failed to delete voice rooms');
//       }
//     } catch (e) {
//       print('Error delete voice rooms: $e');
//     }
//   }
//
//   Future<void> joinUserVoiceRoom(int userId, int roomId, String bg_img) async {
//     final url =
//         Uri.parse('http://45.126.125.172:8080/api/v1/roomDetails/joinRoom');
//
//     Map<String, dynamic> body = {"userId": userId, "roomId": roomId};
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(body),
//       );
//       print(response.body);
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> responseData = json.decode(response.body);
//
//         if (responseData['status'] == "User joined room successfully") {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => LivePage2(
//                       roomID: roomId.toString(),
//                       userId: userId.toString(),
//                       user_name: widget.user_name,
//                       isHost: true,
//                       bgImg: bg_img,
//                       user_avatar: widget.user_avatar)));
//         } else {
//           // Handle other cases where deletion status update was not successful
//           // This block can be optional depending on your specific requirements
//           throw Exception('Failed to join voice rooms');
//         }
//       } else {
//         throw Exception('Failed to join voice rooms');
//       }
//     } catch (e) {
//       print('Error join voice rooms: $e');
//     }
//   }
//
//   void showPopupDeleteConfirm(
//       BuildContext context, String title, String description, int RoomId) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(title),
//             content: Text(description),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   //deleteMySingleVoiceRoom(RoomId);
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('Cancle'),
//               ),
//               TextButton(
//                 onPressed: () {
//                   deleteMySingleVoiceRoom(RoomId);
//                   Navigator.of(context).pop(); // Close the dialog
//                 },
//                 child: const Text('Confrim'),
//               ),
//             ],
//           );
//         });
//   }
//
//   Future<void> fetchPopularRooms() async {
//     final url =
//         Uri.parse('http://45.126.125.172:8080/api/v1/voiceRoomTeam/rooms');
//     final response = await http.get(url);
//
//     if (response.statusCode == 200) {
//       List<dynamic> data = jsonDecode(response.body);
//       setState(() {
//         popularRoomDetails = List<Map<String, dynamic>>.from(data);
//         print(popularRoomDetails);
//       });
//     } else {
//       throw Exception('Failed to load room details');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(
//             height: 35,
//           ),
//           Container(
//             decoration: const BoxDecoration(
//                 // decoration properties
//                 ),
//             child: TabBar(
//               controller: _MaintabController,
//               labelColor: Colors.black87,
//               unselectedLabelColor: Colors.black45,
//               indicatorColor: Colors.pink,
//               tabs: const [
//                 Tab(text: 'Mine'),
//                 Tab(text: 'Hot'),
//                 Tab(text: 'Discover'),
//               ],
//             ),
//           ),
//           Expanded(
//             child: TabBarView(
//               controller: _MaintabController,
//               children: [
//                 buildMineTabContent(context),
//                 buildPopularTabContent(context),
//                 buildDiscoverTabContent(context),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget buildMineTabContent(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: const EdgeInsets.all(4.0),
//         child: GestureDetector(
//           onTap: () {
//             _navigateToCreateVoiceRoomPage(context);
//           },
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               //  const SizedBox(height: 2),
//               blueBoxContainer(context),
//               // const Padding(
//               //   padding: EdgeInsets.symmetric(horizontal: 8.0),
//               //   child: Text('Recent'),
//               // ),
//               TabBar(
//                 controller: _MineRoomsTabController,
//                 labelColor: Colors.black87,
//                 unselectedLabelColor: Colors.black45,
//                 indicatorColor: Colors.pink,
//                 tabs: const [
//                   Tab(text: 'Recent'),
//                   Tab(text: 'Follow'),
//                 ],
//               ),
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 0),
//                   child: Column(
//                     children: [
//                       //  const SizedBox(height: 20), // Adjust the height as needed
//                       Expanded(
//                         child: TabBarView(
//                           controller: _MineRoomsTabController,
//                           children: [
//                             buildRecentVoiceRooms(context),
//                             buildFollowVoiceRooms(context)
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Widget buildRecentVoiceRooms(BuildContext context) {
//   //   return GridView.builder(
//   //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//   //       crossAxisCount: 2,
//   //       crossAxisSpacing: 8.0,
//   //       mainAxisSpacing: 8.0,
//   //       childAspectRatio: 1.0,
//   //     ),
//   //     itemCount: voiceRooms.length,
//   //     itemBuilder: (context, index) {
//   //       VoiceRoom room = voiceRooms[index];
//   //       return GestureDetector(
//   //         onTap: () {
//   //           // Implement navigation to the detail screen or handle onTap as needed
//   //           _navigateToVoiceRoomPage(context, room.roomId.toString(),
//   //               widget.userId, widget.user_name, widget.user_avatar, true);
//   //         },
//   //         child: Container(
//   //           decoration: BoxDecoration(
//   //             color: Colors.white,
//   //             borderRadius: BorderRadius.circular(8.0),
//   //             boxShadow: [
//   //               BoxShadow(
//   //                 color: Colors.grey.withOpacity(0.5),
//   //                 spreadRadius: 2,
//   //                 blurRadius: 5,
//   //                 offset: Offset(0, 2),
//   //               ),
//   //             ],
//   //           ),
//   //           child: Column(
//   //             crossAxisAlignment: CrossAxisAlignment.stretch,
//   //             children: [
//   //               Center(
//   //                 child: ClipRRect(
//   //                   borderRadius: BorderRadius.circular(8.0),
//   //                   child: Image.asset(
//   //                     "assets/robot.jpg",
//   //                     fit: BoxFit.cover,
//   //                     width: 150,
//   //                     height: 150,
//   //                   ),
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 10),
//   //               Padding(
//   //                 padding: const EdgeInsets.symmetric(horizontal: 25.0),
//   //                 child: Row(
//   //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                   children: [
//   //                     Text(
//   //                       room.roomName,
//   //                       style: const TextStyle(
//   //                         fontWeight: FontWeight.bold,
//   //                         fontSize: 16.0,
//   //                       ),
//   //                     ),
//   //                     Container(
//   //                       width: 30.0, // Adjust width and height for desired size
//   //                       height: 30.0,
//   //                       decoration: BoxDecoration(
//   //                         shape: BoxShape.circle,
//   //                         color: Colors.red, // Change color as needed
//   //                         boxShadow: [
//   //                           BoxShadow(
//   //                             color: Colors.grey.withOpacity(0.5),
//   //                             spreadRadius: 2,
//   //                             blurRadius: 5,
//   //                             offset: const Offset(0, 2),
//   //                           ),
//   //                         ],
//   //                       ),
//   //                       child: Center(
//   //                         child: IconButton(
//   //                           onPressed: () {
//   //                             // Handle delete button press
//   //                           },
//   //                           icon: Icon(
//   //                             Icons.delete,
//   //                             color: Colors.white,
//   //                             size: 24.0, // Adjust icon size as needed
//   //                           ),
//   //                         ),
//   //                       ),
//   //                     )
//   //                   ],
//   //                 ),
//   //               ),
//   //             ],
//   //           ),
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//   Widget buildRecentVoiceRooms(BuildContext context) {
//     if (voiceRooms.isEmpty) {
//       return Center(
//         child: Text("No VoiceRoom found"),
//       );
//     } else {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//           childAspectRatio: 1.0,
//         ),
//         itemCount: voiceRooms.length,
//         itemBuilder: (context, index) {
//           VoiceRoom room = voiceRooms[index];
//           return GestureDetector(
//             onTap: () {
//               _navigateToVoiceRoomPage(
//                 context,
//                 room.roomId.toString(),
//                 widget.userId,
//                 widget.user_name,
//                 widget.user_avatar,
//                 room.backgroundImageUrl,
//                 true,
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.network(
//                             room.backgroundImageUrl,
//                             fit: BoxFit.cover,
//                             width: 150,
//                             height: 150,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           // Ensures the room name doesn't overflow
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 room.roomName,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Row(
//                                 children: [
//                                   Text(room.country ?? ""),
//                                   CountryCodePicker(
//                                     initialSelection: room.country,
//                                     hideMainText:
//                                         true, // Hide default country name and code
//                                     showFlagMain:
//                                         true, // Ensure flag is displayed
//                                     showFlag: true, // Ensure flag is displayed
//                                     enabled:
//                                         false, // Disable country selection (optional)
//                                   ), // Display country name
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Display participant count
//                         Container(
//                           padding: EdgeInsets.all(6.0),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.6),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               bottomRight: Radius.circular(8.0),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 18.0,
//                               ),
//                               SizedBox(width: 4.0),
//                               Text(
//                                 room.participantCount?.toString() ?? '0',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   Widget buildFollowVoiceRooms(BuildContext context) {
//     if (voiceRooms.isEmpty) {
//       return Center(
//         child: Text("No VoiceRoom found"),
//       );
//     } else {
//       return GridView.builder(
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 2,
//           crossAxisSpacing: 8.0,
//           mainAxisSpacing: 8.0,
//           childAspectRatio: 1.0,
//         ),
//         itemCount: voiceRooms.length,
//         itemBuilder: (context, index) {
//           VoiceRoom room = voiceRooms[index];
//           return GestureDetector(
//             onTap: () {
//               _navigateToVoiceRoomPage(
//                 context,
//                 room.roomId.toString(),
//                 widget.userId,
//                 widget.user_name,
//                 widget.user_avatar,
//                 room.backgroundImageUrl,
//                 true,
//               );
//             },
//             child: Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(8.0),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.grey.withOpacity(0.5),
//                     spreadRadius: 2,
//                     blurRadius: 5,
//                     offset: const Offset(0, 2),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Expanded(
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8.0),
//                           child: Image.network(
//                             room.backgroundImageUrl,
//                             fit: BoxFit.cover,
//                             width: 150,
//                             height: 150,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Flexible(
//                           // Ensures the room name doesn't overflow
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 room.roomName,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16.0,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                               Row(
//                                 children: [
//                                   Text(room.country ?? ""),
//                                   CountryCodePicker(
//                                     initialSelection: room.country,
//                                     hideMainText:
//                                         true, // Hide default country name and code
//                                     showFlagMain:
//                                         true, // Ensure flag is displayed
//                                     showFlag: true, // Ensure flag is displayed
//                                     enabled:
//                                         false, // Disable country selection (optional)
//                                   ), // Display country name
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                         // Display participant count
//                         Container(
//                           padding: EdgeInsets.all(6.0),
//                           decoration: BoxDecoration(
//                             color: Colors.black.withOpacity(0.6),
//                             borderRadius: BorderRadius.only(
//                               topLeft: Radius.circular(8.0),
//                               bottomRight: Radius.circular(8.0),
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               Icon(
//                                 Icons.person,
//                                 color: Colors.white,
//                                 size: 18.0,
//                               ),
//                               SizedBox(width: 4.0),
//                               Text(
//                                 room.participantCount?.toString() ?? '0',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 14.0,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       );
//     }
//   }
//
//   Widget buildPopularTabContent(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(3.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               //  const SizedBox(height: 16),
//               buildImageCarousel(context),
//               const SizedBox(height: 10),
//               // const Padding(
//               //   padding: EdgeInsets.symmetric(horizontal: 16.0),
//               //   child: Text('Scrollable Images'),
//               // ),
//               // const SizedBox(height: 8),
//               // SizedBox(
//               //   height: 200,
//               //   width: double.infinity,
//               //   child: SingleChildScrollView(
//               //     scrollDirection: Axis.horizontal,
//               //     child: Row(
//               //       children: [
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //         buildImageCard('https://via.placeholder.com/150'),
//               //       ],
//               //     ),
//               //   ),
//               // ),
//               // SizedBox(height: 16),
//               Padding(
//                 padding: const EdgeInsets.all(4.0),
//                 child: GestureDetector(
//                     onTap: () {
//                       _navigateToCreateVoiceRoomPage(context);
//                     },
//                     child: blueBoxContainer2(context)),
//               ),
//               const SizedBox(height: 16),
//               // ListView.builder(
//               //   shrinkWrap: true,
//               //   physics: NeverScrollableScrollPhysics(),
//               //   itemCount: 20,
//               //   itemBuilder: (context, index) {
//               //     return Padding(
//               //       padding: const EdgeInsets.symmetric(
//               //           horizontal: 16.0, vertical: 8.0),
//               //       child: singleVoiceRoomCard(context),
//               //     );
//               //   },
//               // ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//                 itemCount: popularRoomDetails.length,
//                 itemBuilder: (context, index) {
//                   return singleVoiceRoomCard(
//                       context, popularRoomDetails[index]);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildDiscoverTabContent(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             //  const SizedBox(height: 16),
//             // const Padding(
//             //   padding: EdgeInsets.all(8.0),
//             //   child: Text('Discover Content'),
//             // ),
//
//             Padding(
//               padding: const EdgeInsets.all(4.0),
//               child: Column(
//                 children: [
//                   buildImageCarousel(context),
//                   const SizedBox(height: 10),
//                   TextField(
//                     controller: _inputSearchController,
//                     onChanged: (searchText) {
//                       if (searchText.isEmpty) {
//                         setState(() {
//                           searchRoomDetails.clear();
//                         });
//                       }
//                       searchRoomById(searchText);
//                     },
//                     decoration: const InputDecoration(
//                       hintText: 'Search by Id...',
//                       border: OutlineInputBorder(),
//                     ),
//                     inputFormatters: <TextInputFormatter>[
//                       FilteringTextInputFormatter
//                           .digitsOnly // Allow only digits
//                     ],
//                     keyboardType: TextInputType.number,
//                   ),
//                   if (searchRoomDetails.isEmpty)
//                     Center(child: Container(child: const Text("No Result")))
//                   else
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: searchRoomDetails.length,
//                       itemBuilder: (context, index) {
//                         return singleVoiceRoomCard(
//                           context,
//                           searchRoomDetails[index],
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ),
//             // Add more widgets here as needed
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildImageCard(String imageUrl) {
//     return Container(
//       width: 150,
//       margin: EdgeInsets.symmetric(horizontal: 8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.5),
//             spreadRadius: 2,
//             blurRadius: 5,
//             offset: Offset(0, 2),
//           ),
//         ],
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(8.0),
//         child: Image.network(
//           imageUrl,
//           fit: BoxFit.cover,
//         ),
//       ),
//     );
//   }
//
//   Widget blueBoxContainer(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 7,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade300, Colors.blue.shade700],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: const Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Create My Room',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Text(
//               'Enjoy the wonderful journey with Leo Chat',
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget blueBoxContainer2(BuildContext context) {
//     return Container(
//       height: MediaQuery.of(context).size.height / 10,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue.shade300, Colors.blue.shade700],
//           begin: Alignment.centerLeft,
//           end: Alignment.centerRight,
//         ),
//         borderRadius: BorderRadius.circular(12.0),
//       ),
//       child: Row(
//         children: [
//           // Left Section: Text
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     'Create a Voice Room',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                   Text(
//                     'Enjoy the wonderful journey with Leo Chat',
//                     textAlign: TextAlign.left,
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//
//           // Right Section: Icon
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: IconButton(
//               icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
//               onPressed: () {
//                 // Handle button press if needed
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget singleVoiceRoomCard(
//       BuildContext context, Map<String, dynamic> roomDetail) {
//     return GestureDetector(
//       onTap: () {
//         _navigateToVoiceRoomPage(
//           context,
//           roomDetail['roomId'].toString(),
//           widget.userId,
//           widget.user_name,
//           widget.user_avatar,
//           roomDetail['backgroundImageUrl'].toString(),
//           roomDetail['roomOwnerId'].toString() == widget.userId ? true : false,
//         );
//       },
//       child: Container(
//         padding: const EdgeInsets.all(12.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Left Section: Image (You can use a placeholder image or load dynamically if available)
//             CircleAvatar(
//               radius: 28.0,
//               backgroundImage: NetworkImage(
//                 roomDetail['backgroundImageUrl'],
//               ),
//             ),
//             const SizedBox(width: 12.0), // Spacer between image and text
//
//             // Middle Section: Name, ID, Country
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text("${roomDetail['roomName']}",
//                     style: const TextStyle(fontWeight: FontWeight.bold)),
//                 Text("ID: ${roomDetail['roomId']}"),
//                 Text("${roomDetail['country']}"),
//                 // Text(roomDetail['isFollowing'] ? "Following" : "Not Following"),
//               ],
//             ),
//
//             // Expanded Spacer
//             Expanded(child: Container()),
//
//             // Right Section: Analytics Icon (Placeholder for now)
//             Icon(Icons.analytics),
//           ],
//         ),
//       ),
//     );
//   }
// }
