import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:virtual_gift_demo/constants.dart';
import 'package:virtual_gift_demo/entry-effect/entry_manager/defines.dart';
import 'package:virtual_gift_demo/entry-effect/entry_manager/entry_manager.dart';
import 'package:virtual_gift_demo/entry-effect/gift.dart';
import 'package:virtual_gift_demo/gift/components/gift_list_sheet.dart';
import 'package:virtual_gift_demo/gift/components/mp4_player_widget.dart';
import 'package:virtual_gift_demo/gift/components/svga_player_widget.dart';
import 'package:virtual_gift_demo/gift/gift_data.dart';
import 'package:virtual_gift_demo/gift/gift_manager/defines.dart';
import 'package:virtual_gift_demo/gift/gift_manager/gift_manager.dart';
import 'package:virtual_gift_demo/media.dart';
import 'package:virtual_gift_demo/zego%20files/initial.dart';
import 'package:zego_express_engine/zego_express_engine.dart';
import 'package:zego_uikit_prebuilt_live_audio_room/zego_uikit_prebuilt_live_audio_room.dart';

class LivePage2 extends StatefulWidget {
  final String roomID;
  final bool isHost;
  final String userId;
  final String user_name;
  final String user_avatar;
  final String bgImg;

  final LayoutMode layoutMode;

  const LivePage2({
    Key? key,
    required this.roomID,
    this.isHost = false,
    required this.userId,
    required this.user_name,
    required this.user_avatar,
    this.bgImg =
        "https://th.bing.com/th/id/R.9578f43da9e766c51b8c42e3acef449d?rik=YdBbPAZC4GFjlg&riu=http%3a%2f%2fwww.pixelstalk.net%2fwp-content%2fuploads%2f2016%2f03%2fBlue-abstract-background.jpg&ehk=EEk%2f6tl4tFBKdMj6GeXhUHalxlKJnzgN%2fNTkMwt3%2fXw%3d&risl=&pid=ImgRaw&r=0",
    this.layoutMode = LayoutMode.defaultLayout,
  }) : super(key: key);

  @override
  State<LivePage2> createState() => _LivePage2State();
}

class _LivePage2State extends State<LivePage2> {
  List<String> selectedNames = ['Alex']; // Initialize with default value

  final List<String> names = ['Alex', 'John', 'Emma', 'Olivia', 'Liam'];
  final List<ZegoUIKitUser> users = [];
  int? selectedGiftIndex;

  bool showDropdown = false;
  @override
  void initState() {
    super.initState();
    printLiveAudioRoomMembers();
    ZegoGiftManager().cache.cacheAllFiles(giftItemList);

    ZegoGiftManager().service.recvNotifier.addListener(onGiftReceived);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ZegoGiftManager().service.init(
          appID: Initial.id,
          liveID: widget.roomID,
          localUserID: widget.userId,
          localUserName: widget.user_name);
    });
  }

  @override
  void dispose() {
    super.dispose();

    ZegoGiftManager().service.recvNotifier.removeListener(onGiftReceived);
    ZegoGiftManager().service.uninit();
  }

  @override
  Widget build(BuildContext context) {
    final hostConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.host();

    final audienceConfig = ZegoUIKitPrebuiltLiveAudioRoomConfig.audience()
      ..bottomMenuBar.audienceExtendButtons = [giftButton];

    return SafeArea(
      child: Stack(
        children: [
          ZegoUIKitPrebuiltLiveAudioRoom(
              appID: Initial.id /*input your AppID*/,
              appSign: Initial.signIn /*input your AppSign*/,
              userID: widget.userId,
              userName: widget.user_name,
              roomID: widget.roomID,
              events: events,
              config: config
                ..mediaPlayer.supportTransparent = true
                ..foreground = giftForeground()
                ..emptyAreaBuilder = mediaPlayer
              //  ..foreground = entryForeGround()
              ),
          Positioned(
            bottom: 60,
            right: 0,
            child: giftButton,
          ),
          if (widget.isHost)
            Positioned(
              top: 5,
              right: 0,
              child: backGroundChangeButton,
            ),

          // Positioned(
          //   bottom: 90,
          //   right: 0,
          //   child: ElevatedButton(
          //     onPressed: () {
          //       printLiveAudioRoomMembers();
          //     },
          //     child: Text('get users'),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget mediaPlayer(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // return Container();

        return simpleMediaPlayer(
          canControl: widget.isHost,
        );

        // return advanceMediaPlayer(
        //   constraints: constraints,
        //   canControl: widget.isHost,
        // );
      },
    );
  }

  ZegoUIKitPrebuiltLiveAudioRoomEvents get events {
    return ZegoUIKitPrebuiltLiveAudioRoomEvents(
      user: ZegoLiveAudioRoomUserEvents(
          onCountOrPropertyChanged: (List<ZegoUIKitUser> users) {
        debugPrint(
          'onUserCountOrPropertyChanged:${users.map((e) => e.toString())}',
        );
        printLiveAudioRoomMembers();

        // ZegoEntryItem entryItem = ZegoEntryItem(
        //   name: 'Kasun',
        //   sourceURL:
        //       'https://storage.zego.im/sdk-doc/Pics/zegocloud/gift/music_box.mp4',
        //   source: ZegoGiftSourceEntry.url,
        //   type: ZegoGiftTypeEntry.mp4,
        // );

        // ZegoEntryManager()
        //     .playListEntry
        //     .add(PlayDataEntry(entryItem: entryItem));
        // ZegoEntryManager().Entryservice.sendEntry(
        //       name: entryItem.name,
        //     );
      }, onEnter: (ZegoUIKitUser users) {
        printLiveAudioRoomMembers();

        ZegoGiftItem giftItem = ZegoGiftItem(
            sourceURL: 'assets/gift/crown.svga', weight: 100, price: 0);
        ZegoGiftManager().playList.add(PlayData(giftItem: giftItem, count: 1));
        ZegoGiftManager().service.sendGift(name: giftItem.name, count: 1);
      }),
      seat: ZegoLiveAudioRoomSeatEvents(
        onClosed: () {
          debugPrint('on seat closed');
        },
        onOpened: () {
          debugPrint('on seat opened');
        },
        onChanged: (
          Map<int, ZegoUIKitUser> takenSeats,
          List<int> untakenSeats,
        ) {
          debugPrint(
            'on seats changed, taken seats:$takenSeats, untaken seats:$untakenSeats',
          );
        },

        /// WARNING: will override prebuilt logic
        // onClicked:(int index, ZegoUIKitUser? user) {
        //   debugPrint(
        //       'on seat clicked, index:$index, user:${user.toString()}');
        // },
        host: ZegoLiveAudioRoomSeatHostEvents(
          onTakingRequested: (ZegoUIKitUser audience) {
            debugPrint('on seat taking requested, audience:$audience');
          },
          onTakingRequestCanceled: (ZegoUIKitUser audience) {
            debugPrint('on seat taking request canceled, audience:$audience');
          },
          onTakingInvitationFailed: () {
            debugPrint('on invite audience to take seat failed');
          },
          onTakingInvitationRejected: (ZegoUIKitUser audience) {
            debugPrint('on seat taking invite rejected');
          },
        ),
        audience: ZegoLiveAudioRoomSeatAudienceEvents(
          onTakingRequestFailed: () {
            debugPrint('on seat taking request failed');
          },
          onTakingRequestRejected: () {
            debugPrint('on seat taking request rejected');
          },
          onTakingInvitationReceived: () {
            debugPrint('on host seat taking invite sent');
          },
        ),
      ),

      /// WARNING: will override prebuilt logic
    );
  }

  ZegoUIKitPrebuiltLiveAudioRoomConfig get config {
    ZegoUIKitPrebuiltLiveAudioRoomConfig config = widget.isHost
        ? ZegoUIKitPrebuiltLiveAudioRoomConfig.host()
        : ZegoUIKitPrebuiltLiveAudioRoomConfig.audience();

    config.seat = getSeatConfig()
      ..takeIndexWhenJoining = widget.isHost ? getHostSeatIndex() : -1
      ..hostIndexes = [0]
      ..backgroundBuilder = backgroundBuilder

      // ..hostIndexes = [0]
      ..layout = getLayoutConfig();
    //  ..backgroundBuilder = backgroundBuilder;

    config.background = background();

    final giftButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: EdgeInsets.all(15), // Adjust padding as needed
        //primary: Colors.blue, // Background color of the button
        minimumSize: Size(50, 50), // Width and height of the button
      ),
      onPressed: () {
        // Send a virtual gift.
      },
      child: const Icon(Icons.blender),
    );

    // config.foreground = Builder(
    //   builder: (BuildContext context) {
    //     Size size = MediaQuery.of(context).size;
    //     ZegoUIKitUser? user = getCurrentUser();
    //     Map extraInfo = getExtraInfo();
    //     return foregroundBuilder(context, size, user, extraInfo);
    //   },
    // );

    // config.emptyAreaBuilder = mediaPlayer;
    // config.bottomMenuBar = ZegoLiveAudioRoomBottomMenuBarConfig(

    // )

    config.topMenuBar.buttons = [
      // ZegoLiveAudioRoomMenuBarButtonName.minimizingButton
    ];
    config.foreground = giftForeground();

    config.userAvatarUrl = 'https://robohash.org/localUserID.png';

    return config;
  }

  Widget backgroundBuilder(
      BuildContext context, Size size, ZegoUIKitUser? user, Map extraInfo) {
    return Positioned(
      top: -8,
      left: 0,
      child: Container(
        width: size.width,
        height: size.height,
        child: Lottie.asset('assets/animations/9.json'),
      ),
    );
  }

  ZegoLiveAudioRoomSeatConfig getSeatConfig() {
    if (widget.layoutMode == LayoutMode.hostTopCenter) {
      // return ZegoLiveAudioRoomSeatConfig(
      //   backgroundBuilder: (
      //     BuildContext context,
      //     Size size,
      //     ZegoUIKitUser? user,
      //     Map<String, dynamic> extraInfo,
      //   ) {
      //     return Container(color: Colors.blue);
      //   },
      // );
    }
    return ZegoLiveAudioRoomSeatConfig(
      backgroundBuilder: (
        BuildContext context,
        Size size,
        ZegoUIKitUser? user,
        Map<String, dynamic> extraInfo,
      ) {
        return Container();
      },
    );

    // return ZegoLiveAudioRoomSeatConfig(
    //     // avatarBuilder: avatarBuilder,
    //     );
  }

  ZegoLiveAudioRoomLayoutConfig getLayoutConfig() {
    final config = ZegoLiveAudioRoomLayoutConfig();
    config.rowSpacing = 5;
    config.rowConfigs = [
      ZegoLiveAudioRoomLayoutRowConfig(
          alignment: ZegoLiveAudioRoomLayoutAlignment.center, count: 1),
      ZegoLiveAudioRoomLayoutRowConfig(
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween, count: 4),
      ZegoLiveAudioRoomLayoutRowConfig(
          alignment: ZegoLiveAudioRoomLayoutAlignment.spaceBetween, count: 4)
    ];
    return config;
  }

  int getHostSeatIndex() {
    if (widget.layoutMode == LayoutMode.hostCenter) {
      return 4;
    }

    return 0;
  }

  List<int> getLockSeatIndex() {
    // if (widget.layoutMode == LayoutMode.hostCenter) {
    //   print('host 4');
    //   return [4];
    // }
    print('host 3');
    return [0];
  }

  Widget giftForeground() {
    return ValueListenableBuilder<PlayData?>(
      valueListenable: ZegoGiftManager().playList.playingDataNotifier,
      builder: (context, playData, _) {
        if (null == playData) {
          return const SizedBox.shrink();
        }

        if (playData.giftItem.type == ZegoGiftType.svga) {
          return svgaWidget(playData);
        } else {
          return mp4Widget(playData);
        }
      },
    );
  }

  Widget entryForeGround() {
    return ValueListenableBuilder<PlayDataEntry?>(
      valueListenable:
          ZegoEntryManager().playListEntry.playingDataNotifierEntry,
      builder: (context, playDataEntry, _) {
        if (null == playDataEntry) {
          return const SizedBox.shrink();
        }

        if (playDataEntry.entryItem.type == ZegoGiftTypeEntry.svga) {
          //return svgaWidget(playDataEntry);
          return svgaWidgetEntry(playDataEntry);
        } else {
          //return mp4Widget(playDataEntry);
          return mp4WidgetEntry(playDataEntry);
        }
      },
    );
  }

  Widget svgaWidget(PlayData playData) {
    if (playData.giftItem.type != ZegoGiftType.svga) {
      return const SizedBox.shrink();
    }

    /// you can define the area and size for displaying your own
    /// animations here
    int level = 1;
    if (playData.giftItem.weight < 10) {
      level = 1;
    } else if (playData.giftItem.weight < 100) {
      level = 2;
    } else {
      level = 3;
    }
    switch (level) {
      case 2:
        return Positioned(
          top: 100,
          bottom: 100,
          left: 10,
          right: 10,
          child: ZegoSvgaPlayerWidget(
            key: UniqueKey(),
            playData: playData,
            onPlayEnd: () {
              ZegoGiftManager().playList.next();
            },
          ),
        );
      case 3:
        return ZegoSvgaPlayerWidget(
          key: UniqueKey(),
          playData: playData,
          onPlayEnd: () {
            ZegoGiftManager().playList.next();
          },
        );
    }
    // level 1
    return Positioned(
      bottom: 200,
      left: 10,
      child: ZegoSvgaPlayerWidget(
        key: UniqueKey(),
        size: const Size(100, 100),
        playData: playData,
        onPlayEnd: () {
          /// if there is another gift animation, then play
          ZegoGiftManager().playList.next();
        },
      ),
    );
  }

  Widget mp4Widget(PlayData playData) {
    if (playData.giftItem.type != ZegoGiftType.mp4) {
      return const SizedBox.shrink();
    }

    /// you can define the area and size for displaying your own
    /// animations here
    int level = 1;
    if (playData.giftItem.weight < 10) {
      level = 1;
    } else if (playData.giftItem.weight < 100) {
      level = 2;
    } else {
      level = 3;
    }
    switch (level) {
      case 2:
        return Positioned(
          top: 100,
          bottom: 100,
          left: 10,
          right: 10,
          child: ZegoMp4PlayerWidget(
            key: UniqueKey(),
            playData: playData,
            onPlayEnd: () {
              ZegoGiftManager().playList.next();
            },
          ),
        );
      case 3:
        return ZegoMp4PlayerWidget(
          key: UniqueKey(),
          playData: playData,
          onPlayEnd: () {
            ZegoGiftManager().playList.next();
          },
        );
    }
    // level 1
    return Positioned(
      bottom: 200,
      left: 10,
      child: ZegoMp4PlayerWidget(
        key: UniqueKey(),
        size: const Size(100, 100),
        playData: playData,
        onPlayEnd: () {
          /// if there is another gift animation, then play
          ZegoGiftManager().playList.next();
        },
      ),
    );
  }

  Widget svgaWidgetEntry(PlayDataEntry playData) {
    if (playData.entryItem.type != ZegoGiftType.svga) {
      return const SizedBox.shrink();
    }

    /// you can define the area and size for displaying your own
    /// animations here
    int level = 1;

    // switch (level) {
    //   case 2:
    //     return Positioned(
    //       top: 100,
    //       bottom: 100,
    //       left: 10,
    //       right: 10,
    //       child: ZegoSvgaPlayerWidget(
    //         key: UniqueKey(),
    //         playData: playData,
    //         onPlayEnd: () {
    //           ZegoGiftManager().playList.next();
    //         },
    //       ),
    //     );
    //   case 3:
    //     return ZegoSvgaPlayerWidget(
    //       key: UniqueKey(),
    //       playData: playData,
    //       onPlayEnd: () {
    //         ZegoGiftManager().playList.next();
    //       },
    //     );
    // }
    // // level 1
    return Positioned(
      bottom: 200,
      left: 10,
      child: ZegoSvgaPlayerWidgetEntry(
        key: UniqueKey(),
        size: const Size(100, 100),
        playData: playData,
        onPlayEnd: () {
          /// if there is another gift animation, then play
          ZegoEntryManager().playListEntry.next();
        },
      ),
    );
  }

  Widget mp4WidgetEntry(PlayDataEntry playData) {
    if (playData.entryItem.type != ZegoGiftType.mp4) {
      return const SizedBox.shrink();
    }

    /// you can define the area and size for displaying your own
    /// animations here
    int level = 1;

    // switch (level) {
    //   case 2:
    //     return Positioned(
    //       top: 100,
    //       bottom: 100,
    //       left: 10,
    //       right: 10,
    //       child: ZegoMp4PlayerWidgetEntry(
    //         key: UniqueKey(),
    //         playData: playData,
    //         onPlayEnd: () {
    //           ZegoEntryManager().playListEntry.next();
    //         },
    //       ),
    //     );
    //   case 3:
    //     return ZegoMp4PlayerWidgetEntry(
    //       key: UniqueKey(),
    //       playData: playData,
    //       onPlayEnd: () {
    //         ZegoEntryManager().playListEntry.next();
    //       },
    //     );
    // }
    // level 1
    return Positioned(
      bottom: 200,
      left: 10,
      child: ZegoMp4PlayerWidgetEntry(
        key: UniqueKey(),
        size: const Size(100, 100),
        playData: playData,
        onPlayEnd: () {
          /// if there is another gift animation, then play
          ZegoGiftManager().playList.next();
        },
      ),
    );
  }

  Widget get giftButton => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          // Assuming `users` is a List<ZegoUIKitUser>
          List<Map<String, dynamic>> userDataList = users
              .map((user) => {
                    'id': user.id,
                    'name': user.name,
                    'in-room attributes': {
                      'role': user.inRoomAttributes
                          .value['role'], // Access role directly if available
                      'avatar': user.inRoomAttributes.value[
                          'avatar'], // Access avatar URL directly if available
                    },
                    'camera': user
                        .camera, // Access camera status directly if available
                    'microphone': user
                        .microphone, // Access microphone status directly if available
                    'microphone mute mode': user
                        .microphoneMuteMode, // Access mute mode directly if available
                  })
              .toList();
          print(users);
          print(userDataList);
          showGiftListSheet(context, userDataList, widget.userId);
        },
        child: Image.asset('assets/images/gift.png', height: 50, width: 50),
      );

  Widget get backGroundChangeButton => ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: Colors.transparent,
        ),
        onPressed: () {
          showChangeBackgroundBottomModal(context);
        },
        child: Icon(
          Icons.more_vert,
          color: Colors.white,
        ),
      );

  void onGiftReceived() {
    final receivedGift = ZegoGiftManager().service.recvNotifier.value ??
        ZegoGiftProtocolItem.empty();
    final giftData = queryGiftInItemList(receivedGift.name);
    if (null == giftData) {
      debugPrint('not ${receivedGift.name} exist');
      return;
    }

    ZegoGiftManager().playList.add(PlayData(
          giftItem: giftData,
          count: receivedGift.count,
        ));
  }

  void showChangeBackgroundBottomModal(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          // title: Text("Change Background"),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                // Add your action logic here
                Navigator.pop(context); // Close the action sheet
              },
              child: Text("Change Background"),
            ),
            // CupertinoActionSheetAction(
            //   onPressed: () {
            //     // Add your action logic here
            //     Navigator.pop(context); // Close the action sheet
            //   },
            //   child: Text("Option 2"),
            // ),
            // Add more actions as needed
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // Close the action sheet
            },
            child: Text("Cancel"),
          ),
        );
      },
    );
  }

  Widget background() {
    /// how to replace background view
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: Image.network(widget.bgImg).image,
            ),
          ),
        ),
        Positioned(
          top: 5,
          left: 5,
          child: ClipOval(
            child: Image.asset(
              'assets/images/robot.jpg',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
        ),
        // Positioned(
        //     top: 5,
        //     left: 5 + 10,
        //     child: ElevatedButton(onPressed: () {}, child: Text('get users'))),
        const Positioned(
            top: 10,
            left: 60 + 10,
            child: Column(
              children: [
                Text(
                  'Hello Nuwan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Memebers : 2.5k',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )),
        Positioned(
          bottom: 80,
          left: 20,
          child: Container(
            width: 250, // Adjust the width as needed
            height: 100, // Fixed height
            decoration: BoxDecoration(
              border: Border.all(color: Colors.yellow, width: 2.0),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: const SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.announcement_rounded, color: Colors.white),
                    SizedBox(height: 10),
                    SizedBox(
                      width: 250,
                      child: Text(
                        'Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 100,
          right: 10,
          child: Container(
            height: 40,
            width: 120, // Adjusted width to fit three images
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceEvenly, // Adjusted alignment
              children: [
                Image.asset(
                  'assets/images/avatar.png',
                  width: 30,
                  height: 30,
                ),
                Image.asset(
                  'assets/images/avatar.png',
                  width: 30,
                  height: 30,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade800,
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.white, width: 1.0),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '2',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 70,
          left: 10,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              // border: Border.all(color: Colors.black, width: 1.0),
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Row(
              children: [
                SizedBox(width: 10),
                Icon(
                  Icons.announcement,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text(
                  'this is the announcement ...',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void printLiveAudioRoomMembers() {
    // Assuming you have a method to get the list of members in the room
    List<ZegoUIKitUser> members = ZegoUIKit().getAllUsers();
    // Print each member's name and ID
    if (mounted) {
      setState(() {
        users.clear();
        users.addAll(members);
      });
    }
    // for (var member in members) {
    //   print(
    //       'kil Name: ${member.name}, ID: ${member.id}, Profile photo: ${member}');
    // }
    print('kil Name ${users}');
  }
}
