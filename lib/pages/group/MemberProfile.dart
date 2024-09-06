import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/theme.dart';

import '../../constants.dart';
import '../../widgets/body_container.dart';
import '../../widgets/gift_item.dart';
import '../../widgets/outline_button.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/profile_info.dart';
import '../../widgets/stats_box.dart';
import '../../widgets/voice_room_item.dart';

class MemberProfile extends StatefulWidget {
  final String userId;
  final String myId;

  const MemberProfile({
    Key? key,
    required this.userId,
    required this.myId,
  }) : super(key: key);

  @override
  State<MemberProfile> createState() => _MemberProfileState();
}

class _MemberProfileState extends State<MemberProfile> {
  late Future<Map<String, dynamic>> userDataFuture;
  late Future<Map<String, dynamic>> followDataFuture;
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData();
    followDataFuture = fetchFollowFollwingData();
    isFollow();
  }

  Future<Map<String, dynamic>> fetchUserData() async {
    final response = await http.get(
      Uri.parse('http://45.126.125.172:8080/api/v1/user/${widget.userId}'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to fetch user data');
    }
  }

  Future<Map<String, dynamic>> fetchFollowFollwingData() async {
    final response = await http.get(
      Uri.parse(
          'http://45.126.125.172:8080/api/v1/getFollowersFollowingCount?userId=${widget.userId}'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      followerCount = data['followerCount'] ?? 0;
      followingCount = data['followingCount'] ?? 0;
      return data;
    } else {
      throw Exception('Failed to fetch follow/following data');
    }
  }

  Future<void> followUser() async {
    final response = await http.post(
      Uri.parse('http://45.126.125.172:8080/api/v1/follow'),
      body: json.encode({
        "followerId": widget.myId,
        "followingId": widget.userId,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isFollowing = true;
        followingCount += 1;
      });
    } else {
      throw Exception('Failed to follow user');
    }
  }

  Future<void> unfollowUser() async {
    final response = await http.post(
      Uri.parse('http://45.126.125.172:8080/api/v1/unfollow'),
      body: json.encode({
        "followerId": widget.myId,
        "followingId": widget.userId,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        isFollowing = false;
        followingCount--;
      });
    } else {
      throw Exception('Failed to unfollow user');
    }
  }

  Future<void> isFollow() async {
    final response = await http.post(
      Uri.parse('http://45.126.125.172:8080/api/v1/isFollowing'),
      body: json.encode({
        "followerId": widget.myId,
        "followingId": widget.userId,
      }),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
      },
    );

    if (response.statusCode == 200) {
      dynamic responseData = json.decode(response.body);
      bool isFollowingResponse = responseData[
          'isFollowing']; // Assuming 'isFollowing' is a boolean field in your response
      setState(() {
        isFollowing = isFollowingResponse;
      });
    } else {
      throw Exception('Failed to fetch following status');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        width: double.infinity,
        color: darkModeEnabled ? kDarkBoxColor : kLightBlueColor,
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: OutlineButton(
                onTap: () {
                  // Define the share functionality
                },
                text: 'Share',
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            if (widget.userId !=
                widget.myId) // Check if userId is not equal to myId
              Expanded(
                child: isFollowing
                    ? PrimaryButton(
                        onTap: unfollowUser,
                        text: 'Unfollow',
                      )
                    : PrimaryButton(
                        onTap: followUser,
                        text: 'Follow',
                      ),
              ),
          ],
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          final userData = snapshot.data!;
          return FutureBuilder<Map<String, dynamic>>(
            future: followDataFuture,
            builder: (context, followSnapshot) {
              if (followSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (followSnapshot.hasError) {
                return Center(child: Text('Error: ${followSnapshot.error}'));
              } else if (!followSnapshot.hasData) {
                return Center(
                    child: Text('No follow/following data available'));
              }

              final followData = followSnapshot.data!;
              followerCount = followData['followerCount'] ?? 0;
              followingCount = followData['followingCount'] ?? 0;

              return BodyContainer(
                enableScroll: true,
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/coverpic.png',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProfileInfo(
                            name: userData['name'],
                            userId: widget.userId,
                            profileImgUrl: userData['profilePicUrl'] ??
                                'https://img.freepik.com/free-vector/portrait-boy-with-brown-hair-brown-eyes_1308-146018.jpg',
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Text(
                            userData['bio'] ?? 'No Bio',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: darkModeEnabled
                                  ? kDarkTextColor
                                  : kAltTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: darkModeEnabled
                                  ? kDarkBoxColor
                                  : kLightBlueColor,
                              borderRadius: BorderRadius.circular(12.w),
                            ),
                            padding: const EdgeInsets.all(20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StatsBox(
                                  text: 'Followers',
                                  value: followerCount,
                                ),
                                StatsBox(
                                  text: 'Following',
                                  value: followingCount,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Text(
                            'Lorem ipsum dolor sit amet, consectetur adipiscing. Lorem ipsum dolor sit amet, consectetur adipiscing. Lorem ipsum dolor sit amet, consectetur adipiscing.  Lorem ipsum dolor sit amet, consectetur adipiscing.  Lorem ipsum dolor sit amet, consectetur adipiscing.',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: darkModeEnabled
                                  ? kDarkTextColor
                                  : kAltTextColor,
                            ),
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Gifts',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'gifts');
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/ic-arrow-right.svg',
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          SizedBox(
                            height: 75.w,
                            width: double.infinity,
                            child: ListView.separated(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 20.w,
                                );
                              },
                              itemBuilder: (context, index) {
                                return const GiftItem(
                                  icon: 'assets/icons/ic-gifticon.svg',
                                  text: 'x263',
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Badges',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'badges');
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/ic-arrow-right.svg',
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          SizedBox(
                            height: 75.w,
                            width: double.infinity,
                            child: ListView.separated(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 20.w,
                                );
                              },
                              itemBuilder: (context, index) {
                                return const GiftItem(
                                  icon: 'assets/icons/ic-gifticon.svg',
                                  text: 'x263',
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            height: 10.w,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Voice Rooms',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, 'rooms');
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/ic-arrow-right.svg',
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 106.w,
                            width: double.infinity,
                            child: ListView.separated(
                              itemCount: 5,
                              scrollDirection: Axis.horizontal,
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  width: 20.w,
                                );
                              },
                              itemBuilder: (context, index) {
                                return const VoiceRoomItem(
                                  image: 'assets/images/room.png',
                                  text: 'My Voice Room',
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
