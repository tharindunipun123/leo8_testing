// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:virtual_gift_demo/gift/components/gift_list_sheet.dart';
// import 'package:virtual_gift_demo/gift/components/svga_player_widget.dart';
// import 'package:virtual_gift_demo/gift/gift_data.dart';
// import 'package:virtual_gift_demo/gift/gift_manager/defines.dart';
// import 'package:virtual_gift_demo/gift/gift_manager/gift_manager.dart';
// import 'package:virtual_gift_demo/pages/audio-room/live_page.dart';
// import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../constants.dart';
// import '../../media.dart';
// import '../../zego files/initial.dart';

// class LivePage extends StatefulWidget {
//   final String roomID;
//   final bool isHost;
//   final String userId;
//   final String user_name;
//   final String user_avatar;
//   final LayoutMode layoutMode;

//   const LivePage({
//     Key? key,
//     required this.roomID,
//     this.isHost = false,
//     required this.userId,
//     required this.user_name,
//     required this.user_avatar,
//     this.layoutMode = LayoutMode.defaultLayout,
//   }) : super(key: key);

//   @override
//   State<LivePage> createState() => _LivePageState();
// }

// class _LivePageState extends State<LivePage> {
//   List<String> selectedNames = ['Alex']; // Initialize with default value

//   final List<String> names = ['Alex', 'John', 'Emma', 'Olivia', 'Liam'];
//   int? selectedGiftIndex;

//   bool showDropdown = false;

//   @override
//   void initState() {
//     super.initState();

//     ZegoGiftManager().cache.cacheAllFiles(giftItemList);

//     ZegoGiftManager().service.recvNotifier.addListener(onGiftReceived);

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       ZegoGiftManager().service.init(
//           appID: Initial.id,
//           liveID: widget.roomID,
//           localUserID: widget.userId,
//           localUserName: widget.user_name);
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();

//     ZegoGiftManager().service.recvNotifier.removeListener(onGiftReceived);
//     ZegoGiftManager().service.uninit();
//   }

//   @override
//   Widget build(BuildContext context) {
//     void sendGift() {
//       // Send a virtual gift.
//     }
//     return SafeArea(
//       child: ZegoUIKitPrebuiltLiveAudioRoom(
//         appID: Initial.id /*input your AppID*/,
//         appSign: Initial.signIn /*input your AppSign*/,
//         userID: widget.userId,
//         userName: widget.user_name,
//         roomID: widget.roomID,
//         events: events,
//         config: config,
//       ),
//     );
//   }

//   void onGiftReceived() {
//     final receivedGift = ZegoGiftManager().service.recvNotifier.value ??
//         ZegoGiftProtocolItem.empty();
//     final giftData = queryGiftInItemList(receivedGift.name);
//     if (giftData == null) {
//       debugPrint('not ${receivedGift.name} exist');
//       return;
//     }

//     ZegoGiftManager().playList.add(PlayData(
//           giftItem: giftData,
//           count: receivedGift.count,
//         ));
//   }

//   ZegoUIKitPrebuiltLiveAudioRoomConfig get config {
//     ZegoUIKitPrebuiltLiveAudioRoomConfig config = widget.isHost
//         ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
//         : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();

//     config.seat = getSeatConfig()
//       ..takeIndexWhenJoining = widget.isHost ? getHostSeatIndex() : -1
//       ..hostIndexes = [0]

//       // ..hostIndexes = [0]
//       ..layout = getLayoutConfig();
//     //  ..backgroundBuilder = backgroundBuilder;

//     config.background = background();

//     final giftButton = ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         shape: const CircleBorder(),
//         padding: EdgeInsets.all(15), // Adjust padding as needed
//         //primary: Colors.blue, // Background color of the button
//         minimumSize: Size(50, 50), // Width and height of the button
//       ),
//       onPressed: () {
//         // Send a virtual gift.
//       },
//       child: const Icon(Icons.blender),
//     );
//     final giftButton2 = ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         shape: const CircleBorder(),
//         padding: EdgeInsets.all(15), // Adjust padding as needed
//         //primary: Colors.blue, // Background color of the button
//         minimumSize: Size(50, 50), // Width and height of the button
//       ),
//       onPressed: () {
//         // Send a virtual gift.
//       },
//       child: const Icon(Icons.blender),
//     );
//     final giftButton3 = ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         shape: const CircleBorder(),
//         padding: EdgeInsets.all(15), // Adjust padding as needed
//         //primary: Colors.blue, // Background color of the button
//         minimumSize: Size(50, 50), // Width and height of the button
//       ),
//       onPressed: () {
//         // Send a virtual gift.
//       },
//       child: const Icon(Icons.blender),
//     );

//     config.bottomMenuBar.audienceExtendButtons = [
//       giftButton,
//       giftButton2,
//       giftButton3
//     ];

//     // config.foreground = Builder(
//     //   builder: (BuildContext context) {
//     //     Size size = MediaQuery.of(context).size;
//     //     ZegoUIKitUser? user = getCurrentUser();
//     //     Map extraInfo = getExtraInfo();
//     //     return foregroundBuilder(context, size, user, extraInfo);
//     //   },
//     // );

//     // config.emptyAreaBuilder = mediaPlayer;
//     // config.bottomMenuBar = ZegoLiveAudioRoomBottomMenuBarConfig(

//     // )

//     config.topMenuBar.buttons = [
//       // ZegoLiveAudioRoomMenuBarButtonName.minimizingButton
//     ];
//     config.foreground = giftForeground();

//     config.userAvatarUrl = 'https://robohash.org/localUserID.png';

//     return config;
//   }

//   Widget giftForeground() {
//     return ValueListenableBuilder<PlayData?>(
//       valueListenable: ZegoGiftManager().playList.playingDataNotifier,
//       builder: (context, playData, _) {
//         if (playData == null) {
//           return const SizedBox.shrink();
//         }

//         return Positioned(
//           bottom: 200,
//           left: 10,
//           child: ZegoLottiePlayerWidget(
//             key: UniqueKey(),
//             size: const Size(100, 100),
//             playData: playData,
//             onPlayEnd: () {
//               ZegoGiftManager().playList.next();
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget backgroundBuilder(
//       BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
//     // if (!isAttributeHost(user?.inRoomAttributes)) {
//     //   return Container();
//     // }

//     return Positioned(
//       top: -8,
//       left: 0,
//       child: Container(
//         width: size.width,
//         height: size.height,
//         decoration: const BoxDecoration(
//             image: DecorationImage(image: AssetImage('assets/backAvatar.jpg'))),
//       ),
//     );
//   }

//   Size getSize(BuildContext context) {
//     return MediaQuery.of(context).size;
//   }

//   ZegoUIKitUser? getCurrentUser() {
//     // Replace with actual logic to get the current user
//     return ZegoUIKitUser(id: 'userID', name: 'UserName');
//   }

//   Map getExtraInfo() {
//     // Replace with actual logic to get extra info
//     return {'key': 'value'};
//   }

//   ZegoUIKitPrebuiltLiveAudioRoomEvents get events {
//     return ZegoUIKitPrebuiltLiveAudioRoomEvents(
//       user: ZegoLiveAudioRoomUserEvents(
//         onCountOrPropertyChanged: (List<ZegoUIKitUser> users) {
//           debugPrint(
//             'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}',
//           );
//         },
//       ),
//       seat: ZegoLiveAudioRoomSeatEvents(
//         onClosed: () {
//           debugPrint('on seat closed');
//         },
//         onOpened: () {
//           debugPrint('on seat opened');
//         },
//         onChanged: (
//           Map<int, ZegoUIKitUser> takenSeats,
//           List<int> untakenSeats,
//         ) {
//           debugPrint(
//             'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats',
//           );
//         },

//         /// WARNING: will override prebuilt logic
//         // onClicked:(int index, ZegoUIKitUser? user) {
//         //   debugPrint(
//         //       'on seat clicked, index:$index, user:${user.toString()}');
//         // },
//         host: ZegoLiveAudioRoomSeatHostEvents(
//           onTakingRequested: (ZegoUIKitUser audience) {
//             debugPrint('on seat taking requested, audience:$audience');
//           },
//           onTakingRequestCanceled: (ZegoUIKitUser audience) {
//             debugPrint('on seat taking request canceled, audience:$audience');
//           },
//           onTakingInvitationFailed: () {
//             debugPrint('on invite audience to take seat failed');
//           },
//           onTakingInvitationRejected: (ZegoUIKitUser audience) {
//             debugPrint('on seat taking invite rejected');
//           },
//         ),
//         audience: ZegoLiveAudioRoomSeatAudienceEvents(
//           onTakingRequestFailed: () {
//             debugPrint('on seat taking request failed');
//           },
//           onTakingRequestRejected: () {
//             debugPrint('on seat taking request rejected');
//           },
//           onTakingInvitationReceived: () {
//             debugPrint('on host seat taking invite sent');
//           },
//         ),
//       ),

//       /// WARNING: will override prebuilt logic
//       memberList: ZegoLiveAudioRoomMemberListEvents(
//         onMoreButtonPressed: onMemberListMoreButtonPressed,
//       ),
//     );
//   }

//   Widget mediaPlayer(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         //   return Container();

//         // return simpleMediaPlayer(
//         //   canControl: widget.isHost,
//         // );

//         return advanceMediaPlayer(
//           constraints: constraints,
//           canControl: widget.isHost,
//         );
//       },
//     );
//   }

//   Widget background() {
//     /// how to replace background view
//     return Stack(
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               fit: BoxFit.fill,
//               image:
//                   Image.asset('assets/images/voice-room-background.jpg').image,
//             ),
//           ),
//         ),
//         Positioned(
//           top: 5,
//           left: 5,
//           child: ClipOval(
//             child: Image.asset(
//               'assets/images/robot.jpg',
//               width: 60,
//               height: 60,
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         // Positioned(
//         //     top: 5,
//         //     left: 5 + 10,
//         //     child: ElevatedButton(onPressed: () {}, child: Text('get users'))),
//         const Positioned(
//             top: 10,
//             left: 60 + 10,
//             child: Column(
//               children: [
//                 Text(
//                   'Hello Nuwan',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 Text(
//                   'Memebers : 2.5k',
//                   style: TextStyle(
//                     color: Colors.grey,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w400,
//                   ),
//                 ),
//               ],
//             )),
//         Positioned(
//           bottom: 80,
//           left: 20,
//           child: Container(
//             width: 250, // Adjust the width as needed
//             height: 100, // Fixed height
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.yellow, width: 2.0),
//               borderRadius: BorderRadius.circular(12.0),
//             ),
//             child: const SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(10.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.announcement_rounded, color: Colors.white),
//                     SizedBox(height: 10),
//                     SizedBox(
//                       width: 250,
//                       child: Text(
//                         'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Positioned(
//           top: 100,
//           right: 10,
//           child: Container(
//             height: 40,
//             width: 120, // Adjusted width to fit three images
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(25),
//             ),
//             child: Row(
//               mainAxisAlignment:
//                   MainAxisAlignment.spaceEvenly, // Adjusted alignment
//               children: [
//                 Image.asset(
//                   'assets/images/avatar.png',
//                   width: 30,
//                   height: 30,
//                 ),
//                 Image.asset(
//                   'assets/images/avatar.png',
//                   width: 30,
//                   height: 30,
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       width: 30,
//                       height: 30,
//                       decoration: BoxDecoration(
//                         color: Colors.grey.shade800,
//                         borderRadius: BorderRadius.circular(50),
//                         border: Border.all(color: Colors.white, width: 1.0),
//                       ),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text(
//                             '2',
//                             style: TextStyle(color: Colors.white),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//         Positioned(
//           top: 70,
//           left: 10,
//           child: Container(
//             height: 50,
//             decoration: BoxDecoration(
//               // border: Border.all(color: Colors.black, width: 1.0),
//               borderRadius: BorderRadius.circular(50),
//             ),
//             child: const Row(
//               children: [
//                 SizedBox(width: 10),
//                 Icon(
//                   Icons.announcement,
//                   color: Colors.blue,
//                 ),
//                 SizedBox(width: 10),
//                 Text(
//                   'this is the announcement ...',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         // if (!showDropdown)
//         //   Positioned(
//         //     top: 70,
//         //     right: 10,
//         //     child: Container(
//         //       margin: EdgeInsets.only(top: 5),
//         //       padding: EdgeInsets.symmetric(horizontal: 10),
//         //       decoration: BoxDecoration(
//         //         borderRadius: BorderRadius.circular(8.0),
//         //         color: Colors.grey.shade800,
//         //       ),
//         //       child: DropdownButton<String>(
//         //         onChanged: (String? newValue) {
//         //           setState(() {
//         //             if (newValue != null) {
//         //               if (selectedNames.contains(newValue)) {
//         //                 selectedNames.remove(newValue);
//         //               } else {
//         //                 selectedNames.add(newValue);
//         //               }
//         //             }
//         //           });
//         //         },
//         //         items: names.map<DropdownMenuItem<String>>((String value) {
//         //           return DropdownMenuItem<String>(
//         //             value: value,
//         //             child: Row(
//         //               children: [
//         //                 Checkbox(
//         //                   value: selectedNames.contains(value),
//         //                   onChanged: (bool? checked) {
//         //                     setState(() {
//         //                       if (checked != null && checked) {
//         //                         selectedNames.add(value);
//         //                       } else {
//         //                         selectedNames.remove(value);
//         //                       }
//         //                     });
//         //                   },
//         //                 ),
//         //                 SizedBox(width: 8),
//         //                 Text(
//         //                   value,
//         //                   style: TextStyle(color: Colors.white),
//         //                 ),
//         //               ],
//         //             ),
//         //           );
//         //         }).toList(),
//         //       ),
//         //     ),
//         //   ),
//         if (widget.isHost)
//           Positioned(
//             top: 10,
//             right: 10,
//             child: GestureDetector(
//                 onTap: () {},
//                 child: const Icon(
//                   Icons.more_vert,
//                   color: Colors.white,
//                   size: Checkbox.width,
//                   weight: 100,
//                 )),
//           ),
//         Positioned(
//           bottom: 60,
//           right: 20,
//           child: GestureDetector(
//             onTap: () {
//               showModalBottomSheet(
//                 context: context,
//                 builder: (BuildContext context) {
//                   return StatefulBuilder(
//                       builder: (BuildContext context, StateSetter setState) {
//                     return Container(
//                       decoration: const BoxDecoration(
//                         borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(20.0),
//                           topRight: Radius.circular(20.0),
//                         ),
//                         color: Color(0xFF161c1c),
//                       ),
//                       height: 400,
//                       padding: const EdgeInsets.all(10.0),
//                       child: DefaultTabController(
//                         length: 3,
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             // const Center(
//                             //   child: Text(
//                             //     'Send Gift',
//                             //     style: TextStyle(
//                             //         fontSize: 24.0,
//                             //         fontWeight: FontWeight.bold,
//                             //         color: Colors.white),
//                             //   ),
//                             // ),
//                             const SizedBox(height: 20.0),
//                             const TabBar(
//                               isScrollable: true,
//                               tabAlignment: TabAlignment.start,
//                               tabs: [
//                                 Tab(text: 'Gifts'),
//                                 Tab(text: 'Entry Effects'),
//                                 Tab(
//                                   text: 'Avatar Frames',
//                                 )
//                               ],
//                               // indicatorColor: Colors.white,
//                               // labelColor: Colors.white,
//                               // unselectedLabelColor: Colors.grey,
//                               dividerColor: Colors.transparent,
//                               indicatorColor: Color(0xFF0078ff),
//                               labelColor: Colors.white,
//                             ),
//                             Expanded(
//                               child: TabBarView(
//                                 children: [
//                                   GridView.count(
//                                     crossAxisCount: 4,
//                                     children: List.generate(8, (index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           // Navigator.pop(context);
//                                           setState(() {
//                                             selectedGiftIndex = index;
//                                           });
//                                         },
//                                         child: Container(
//                                           decoration: BoxDecoration(
//                                             border: Border.all(
//                                               color: selectedGiftIndex == index
//                                                   ? const Color(0xFF0078ff)
//                                                   : Colors.transparent,
//                                               width: 2.0,
//                                             ),
//                                             borderRadius:
//                                                 BorderRadius.circular(10.0),
//                                           ),
//                                           child: Center(
//                                             child: Column(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.center,
//                                               children: <Widget>[
//                                                 Image.asset(
//                                                   'assets/gifts/gift${index + 1}.png',
//                                                   height: 45,
//                                                   width: 45,
//                                                 ),
//                                                 const SizedBox(height: 5.0),
//                                                 Column(
//                                                   children: [
//                                                     Text(
//                                                       'Gift ${index + 1}',
//                                                       style: const TextStyle(
//                                                           color: Colors.white,
//                                                           fontWeight:
//                                                               FontWeight.bold),
//                                                     ),
//                                                     const Row(
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         Icon(Icons.diamond,
//                                                             color:
//                                                                 Colors.yellow,
//                                                             size: 15),
//                                                         Text(
//                                                           '100',
//                                                           style: TextStyle(
//                                                               color:
//                                                                   Colors.grey),
//                                                         ),
//                                                       ],
//                                                     )
//                                                   ],
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }),
//                                   ),
//                                   const Center(
//                                     child: Text(
//                                       'Favorites Content',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                   const Center()
//                                 ],
//                               ),
//                             ),
//                             const SizedBox(height: 10.0),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Image.asset(
//                                       'assets/coin.png',
//                                       width: 40,
//                                       height: 40,
//                                     ),
//                                     const SizedBox(width: 10.0),
//                                     const Text(
//                                       '453',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     const SizedBox(
//                                       width: 10,
//                                     ),
//                                     const Text(
//                                       'Recharge>',
//                                       style:
//                                           TextStyle(color: Color(0xFF0078ff)),
//                                     ),
//                                   ],
//                                 ),
//                                 // ElevatedButton(
//                                 //   style: ButtonStyle(
//                                 //     backgroundColor: MaterialStateProperty.all<
//                                 //             Color>(
//                                 //         const Color.fromARGB(255, 77, 3, 238)),
//                                 //     shape: MaterialStateProperty.all<
//                                 //         RoundedRectangleBorder>(
//                                 //       RoundedRectangleBorder(
//                                 //         borderRadius:
//                                 //             BorderRadius.circular(12.0),
//                                 //       ),
//                                 //     ),
//                                 //   ),
//                                 //   onPressed: () {
//                                 //     if (selectedGiftIndex != null) {
//                                 //       Navigator.pop(context, selectedGiftIndex);
//                                 //     }
//                                 //   },
//                                 //   child: const Text(
//                                 //     'Send Gift',
//                                 //     style: TextStyle(color: Colors.white),
//                                 //   ),
//                                 // )
//                                 Container(
//                                   height: 40,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                     color: Colors.grey.shade800,
//                                   ),
//                                   padding: EdgeInsets.only(
//                                       left: 10, top: 0, bottom: 0),

//                                   // Background color of the container
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: <Widget>[
//                                       SizedBox(
//                                           width:
//                                               8.0), // Spacing between Text and Button
//                                       Text(
//                                         '1',
//                                         style: TextStyle(
//                                             fontSize: 16, color: Colors.white),
//                                       ),
//                                       Icon(
//                                         Icons.keyboard_arrow_up,
//                                         color: Colors.white,
//                                         size: 20,
//                                       ),
//                                       SizedBox(
//                                           width:
//                                               20.0), // Spacing between Text and Button
//                                       ElevatedButton(
//                                         onPressed: () {},
//                                         child: Text(
//                                           'Send',
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         // style: ButtonStyle(
//                                         //   backgroundColor: WidgetStateProperty
//                                         //       .resolveWith<Color>(
//                                         //     (Set<WidgetState> states) {
//                                         //       if (states.contains(
//                                         //           WidgetState.pressed))
//                                         //         return Color(0xFF59B49D);
//                                         //       return Color(
//                                         //           0xFF59B49D); // Use the component's default.
//                                         //     },
//                                         //   ),
//                                         // ),
//                                         style: ButtonStyle(
//                                           backgroundColor:
//                                               MaterialStateProperty.all<Color>(
//                                                   Color(0xFF0078ff)),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),

//                             // Row(
//                             //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             //   children: [
//                             //     Row(
//                             //       children: [
//                             //         Container(
//                             //           child: ElevatedButton(
//                             //             // style: ButtonStyle(
//                             //             //   // backgroundColor:
//                             //             //   //     WidgetStateProperty.all<Color>(
//                             //             //   //         const Color.fromARGB(
//                             //             //   //             255, 48, 48, 48)),
//                             //             //   // shape: WidgetStateProperty.all<
//                             //             //   //     RoundedRectangleBorder>(
//                             //             //   //   RoundedRectangleBorder(
//                             //             //   //     borderRadius:
//                             //             //   //         BorderRadius.circular(30.0),
//                             //             //   //   ),
//                             //             //   // ),
//                             //             // ),
//                             //             onPressed: () {
//                             //               // Add your logic here
//                             //             },
//                             //             child: Row(
//                             //               children: [
//                             //                 GestureDetector(
//                             //                   onTap: () {},
//                             //                   child: Container(
//                             //                     height: 40,
//                             //                     decoration: BoxDecoration(
//                             //                       borderRadius:
//                             //                           BorderRadius.circular(
//                             //                               30.0),
//                             //                       color: Colors.transparent,
//                             //                     ),
//                             //                     child: Row(
//                             //                       children: [
//                             //                         Image.asset(
//                             //                           'assets/coin.png',
//                             //                           width: 40,
//                             //                           height: 40,
//                             //                         ),
//                             //                         const SizedBox(width: 10.0),
//                             //                         const Text(
//                             //                           'Alex',
//                             //                           style: TextStyle(
//                             //                               color: Colors.white),
//                             //                         )
//                             //                       ],
//                             //                     ),
//                             //                     //   Row(
//                             //                     //     children: [
//                             //                     //       Image.asset(
//                             //                     //         'assets/images/avatar.png',
//                             //                     //         width: 30,
//                             //                     //         height: 30,
//                             //                     //       ),
//                             //                     //       const SizedBox(width: 10.0),
//                             //                     //       const Text(
//                             //                     //         'Alex',
//                             //                     //         style: TextStyle(
//                             //                     //             color: Colors.white),
//                             //                     //       ),
//                             //                     //       const SizedBox(width: 20.0),
//                             //                     //       Container(
//                             //                     //         padding:
//                             //                     //             const EdgeInsets.symmetric(
//                             //                     //                 horizontal: 4),
//                             //                     //         decoration: BoxDecoration(
//                             //                     //           borderRadius:
//                             //                     //               BorderRadius
//                             //                     //                   .circular(30.0),
//                             //                     //           color:
//                             //                     //               Colors.red.shade50,
//                             //                     //         ),
//                             //                     //         child: const Row(
//                             //                     //           children: [
//                             //                     //             Icon(Icons.favorite,
//                             //                     //                 color: Colors.red,
//                             //                     //                 size: 14),
//                             //                     //             SizedBox(width: 2),
//                             //                     //             Text(
//                             //                     //               '+10',
//                             //                     //               style: TextStyle(
//                             //                     //                   fontSize: 12,
//                             //                     //                   color:
//                             //                     //                       Colors.red),
//                             //                     //             ),
//                             //                     //           ],
//                             //                     //         ),
//                             //                     //       ),
//                             //                     //       const Icon(
//                             //                     //         Icons.keyboard_arrow_up,
//                             //                     //         color: Colors.white,
//                             //                     //         size: 20,
//                             //                     //       ),
//                             //                     //     ],
//                             //                     //   ),
//                             //                     //
//                             //                   ),
//                             //                 ),
//                             //               ],
//                             //             ),
//                             //           ),
//                             //         ),
//                             //         const SizedBox(width: 18),
//                             //         Container(
//                             //           height: 40,
//                             //           decoration: BoxDecoration(
//                             //             borderRadius:
//                             //                 BorderRadius.circular(30.0),
//                             //             color: Colors.grey.shade800,
//                             //           ),
//                             //           padding: const EdgeInsets.only(
//                             //               left: 10, top: 0, bottom: 0),
//                             //           child: Row(
//                             //             mainAxisSize: MainAxisSize.min,
//                             //             children: <Widget>[
//                             //               const SizedBox(width: 8.0),
//                             //               const Text(
//                             //                 '1',
//                             //                 style: TextStyle(
//                             //                     fontSize: 16,
//                             //                     color: Colors.white),
//                             //               ),
//                             //               const Icon(
//                             //                 Icons.keyboard_arrow_up,
//                             //                 color: Colors.white,
//                             //                 size: 20,
//                             //               ),
//                             //               const SizedBox(width: 20.0),
//                             //               ElevatedButton(
//                             //                 onPressed: () {},
//                             //                 style: ButtonStyle(
//                             //                   backgroundColor:
//                             //                       MaterialStateProperty
//                             //                           .resolveWith<Color>(
//                             //                     (Set<MaterialState> states) {
//                             //                       if (states.contains(
//                             //                           MaterialState.pressed)) {
//                             //                         return Colors.blue.shade200;
//                             //                       }
//                             //                       return Colors.blue;
//                             //                     },
//                             //                   ),
//                             //                 ),
//                             //                 child: const Text(
//                             //                   'Send',
//                             //                   style: TextStyle(
//                             //                       color: Colors.white),
//                             //                 ),
//                             //               ),
//                             //             ],
//                             //           ),
//                             //         ),
//                             //       ],
//                             //     ),
//                             //   ],
//                             // ),
//                           ],
//                         ),
//                       ),
//                     );
//                   });
//                 },
//               );
//             },
//             child: Image.asset(
//               'assets/images/gift.png',
//               height: 50,
//               width: 50,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   ZegoLiveAudioRoomSeatConfig getSeatConfig() {
//     if (widget.layoutMode == LayoutMode.hostTopCenter) {
//       // return ZegoLiveAudioRoomSeatConfig(
//       //   backgroundBuilder: (
//       //     BuildContext context,
//       //     Size size,
//       //     ZegoUIKitUser? user,
//       //     Map<String, dynamic> extraInfo,
//       //   ) {
//       //     return Container(color: Colors.blue);
//       //   },
//       // );
//     }
//     return ZegoLiveAudioRoomSeatConfig(
//       backgroundBuilder: (
//         BuildContext context,
//         Size size,
//         ZegoUIKitUser? user,
//         Map<String, dynamic> extraInfo,
//       ) {
//         return Container();
//       },
//     );

//     // return ZegoLiveAudioRoomSeatConfig(
//     //     // avatarBuilder: avatarBuilder,
//     //     );
//   }

//   Widget avatarBuilder(
//     BuildContext context,
//     Size size,
//     ZegoUIKitUser? user,
//     Map<String, dynamic> extraInfo,
//   ) {
//     return CircleAvatar(
//       maxRadius: size.width,
//       backgroundImage: Image.asset(
//               "assets/avatars/avatar_${((int.tryParse(user?.id ?? "") ?? 0) % 6)}.png")
//           .image,
//     );
//   }

//   //  bool isAttributeHost(Map<String, String>? userInRoomAttributes) {
//   //   return (userInRoomAttributes?[attributeKeyRole] ?? "") ==
//   //       ZegoLiveAudioRoomRole.host.index.toString();
//   // }
//   Widget foregroundBuilder(
//       BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
//     var userName = user?.name.isEmpty ?? true
//         ? Container()
//         : Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Text(
//               user?.name ?? "",
//               overflow: TextOverflow.ellipsis,
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 backgroundColor:
//                     const Color.fromARGB(255, 255, 0, 0).withOpacity(0.1),
//                 fontSize: 10,
//                 fontWeight: FontWeight.w600,
//                 decoration: TextDecoration.none,
//               ),
//             ),
//           );

//     // if (!isAttributeHost(user?.inRoomAttributes)) {
//     //   return userName;
//     // }

//     // var hostIconSize = Size(size.width / 3, size.height / 3);
//     // var hostIcon = Positioned(
//     //   bottom: 3,
//     //   right: 0,
//     //   child: Container(
//     //     width: hostIconSize.width,
//     //     height: hostIconSize.height,
//     //     decoration: const BoxDecoration(
//     //       image: DecorationImage(image: '',fit: BoxFit.cover),
//     //     ),
//     //   ),
//     // );
//     var hostIconSize = Size(size.width / 3, size.height / 3);
//     var hostIcon = Positioned(
//       bottom: 3,
//       right: 0,
//       child: Container(
//         width: hostIconSize.width,
//         height: hostIconSize.height,
//         decoration: const BoxDecoration(
//           image: DecorationImage(
//             image: NetworkImage(
//                 'https://img.freepik.com/free-vector/businessman-character-avatar-isolated_24877-60111.jpg'), // Replace with your image path
//             fit: BoxFit.cover,
//           ),
//         ),
//       ),
//     );

//     return Stack(children: [userName, hostIcon]);
//   }

//   int getHostSeatIndex() {
//     if (widget.layoutMode == LayoutMode.hostCenter) {
//       return 4;
//     }

//     return 0;
//   }

//   List<int> getLockSeatIndex() {
//     // if (widget.layoutMode == LayoutMode.hostCenter) {
//     //   print('host 4');
//     //   return [4];
//     // }
//     print('host 3');
//     return [0];
//   }

//   // ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
//   //   final config = ZegoLiveAudioRoomLayoutConfig();
//   //   switch (widget.layoutMode) {
//   //     case LayoutMode.defaultLayout:
//   //       print('defult layout me');
//   //       config.rowSpacing = 5;
//   //       config.rowConfigs = [
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 1,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.center,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 4,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 4,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       ];
//   //       config.rowConfigs = List.generate(
//   //         2,
//   //         (index) => ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 4,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       );
//   //       break;
//   //     case LayoutMode.full:
//   //       config.rowSpacing = 5;
//   //       config.rowConfigs = List.generate(
//   //         4,
//   //         (index) => ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 4,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       );
//   //       break;
//   //     case LayoutMode.horizontal:
//   //       config.rowSpacing = 5;
//   //       config.rowConfigs = [
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 10,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       ];
//   //       break;
//   //     case LayoutMode.vertical:
//   //       config.rowSpacing = 5;
//   //       config.rowConfigs = List.generate(
//   //         8,
//   //         (index) => ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 1,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       );
//   //       break;
//   //     case LayoutMode.hostTopCenter:
//   //       config.rowConfigs = [
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 1,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.center,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 3,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 3,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 2,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceEvenly,
//   //         ),
//   //       ];
//   //       break;
//   //     case LayoutMode.hostCenter:
//   //       config.rowSpacing = 5;
//   //       config.rowConfigs = [
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 3,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 3,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 3,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       ];
//   //       break;
//   //     case LayoutMode.fourPeoples:
//   //       config.rowConfigs = [
//   //         ZegoLiveAudioRoomLayoutRowConfig(
//   //           count: 4,
//   //           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween,
//   //         ),
//   //       ];
//   //       break;
//   //   }
//   //   return config;
//   // }
//   ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
//     final config = ZegoLiveAudioRoomLayoutConfig();
//     config.rowSpacing = 5;
//     config.rowConfigs = [
//       ZegoLiveAudioRoomLayoutRowConfig(
//           alignment: ZegoLiveAudioRoomLayoutAlignment.center, count: 1),
//       ZegoLiveAudioRoomLayoutRowConfig(
//           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween, count: 4),
//       ZegoLiveAudioRoomLayoutRowConfig(
//           alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween, count: 4)
//     ];
//     return config;
//   }

//   void onMemberListMoreButtonPressed(ZegoUIKitUser user) {
//     showModalBottomSheet(
//       backgroundColor: const Color(0xff111014),
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(32.0),
//           topRight: Radius.circular(32.0),
//         ),
//       ),
//       isDismissible: true,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         const textStyle = TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         );
//         final listMenu = ZegoUIKitPrebuiltLiveAudioRoomController()
//                 .seat
//                 .localHasHostPermissions
//             ? [
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();

//                     ZegoUIKit().removeUserFromRoom(
//                       [user.id],
//                     ).then((result) {
//                       debugPrint('kick out result:$result');
//                     });
//                   },
//                   child: Text(
//                     'Kick Out ${user.name}',
//                     style: textStyle,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();

//                     ZegoUIKitPrebuiltLiveAudioRoomController()
//                         .seat
//                         .host
//                         .inviteToTake(user.id)
//                         .then((result) {
//                       debugPrint('invite audience to take seat result:$result');
//                     });
//                   },
//                   child: Text(
//                     'Invite ${user.name} to take seat',
//                     style: textStyle,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     'Cancel',
//                     style: textStyle,
//                   ),
//                 ),
//               ]
//             : [];
//         print('list menu -');
//         print(listMenu);
//         return AnimatedPadding(
//           padding: MediaQuery.of(context).viewInsets,
//           duration: const Duration(milliseconds: 50),
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 0,
//               horizontal: 10,
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: listMenu.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return SizedBox(
//                   height: 60,
//                   child: Center(child: listMenu[index]),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void onMemberListMoreButtonPressed2(ZegoUIKitUser user) {
//     showModalBottomSheet(
//       backgroundColor: const Color(0xff111014),
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(32.0),
//           topRight: Radius.circular(32.0),
//         ),
//       ),
//       isDismissible: true,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         const textStyle = TextStyle(
//           color: Colors.white,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         );
//         final listMenu = ZegoUIKitPrebuiltLiveAudioRoomController()
//                 .seat
//                 .localHasHostPermissions
//             ? [
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();

//                     ZegoUIKit().removeUserFromRoom(
//                       [user.id],
//                     ).then((result) {
//                       debugPrint('kick out result:$result');
//                     });
//                   },
//                   child: Text(
//                     'Kick Out ${user.name}',
//                     style: textStyle,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();

//                     ZegoUIKitPrebuiltLiveAudioRoomController()
//                         .seat
//                         .host
//                         .inviteToTake(user.id)
//                         .then((result) {
//                       debugPrint('invite audience to take seat result:$result');
//                     });
//                   },
//                   child: Text(
//                     'Invite ${user.name} to take seat',
//                     style: textStyle,
//                   ),
//                 ),
//                 GestureDetector(
//                   onTap: () async {
//                     Navigator.of(context).pop();
//                   },
//                   child: const Text(
//                     'Cancel',
//                     style: textStyle,
//                   ),
//                 ),
//               ]
//             : [];
//         return AnimatedPadding(
//           padding: MediaQuery.of(context).viewInsets,
//           duration: const Duration(milliseconds: 50),
//           child: Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 0,
//               horizontal: 10,
//             ),
//             child: ListView.builder(
//               shrinkWrap: true,
//               itemCount: listMenu.length,
//               itemBuilder: (BuildContext context, int index) {
//                 return SizedBox(
//                   height: 60,
//                   child: Center(child: listMenu[index]),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
