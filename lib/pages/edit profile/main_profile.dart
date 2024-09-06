import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_application_1/constants.dart';
import 'package:flutter_application_1/pages/badges/badges_screen.dart';
import 'package:flutter_application_1/pages/edit%20profile/edit_bio.dart';
import 'package:flutter_application_1/pages/edit%20profile/edit_motto.dart';
import 'package:flutter_application_1/pages/edit%20profile/edit_name_screen.dart';
import 'package:flutter_application_1/pages/edit%20profile/profile_edit_screen.dart';
import 'package:flutter_application_1/pages/edit%20profile/profile_screen.dart';
import 'package:flutter_application_1/pages/gifts/gifts_screen.dart';
import 'package:flutter_application_1/pages/rooms/voice_rooms_screen.dart';
import 'package:flutter_application_1/theme.dart';

class MainProfile extends StatelessWidget {
  final String userId;
  final String name;
  final String profileImgUrl;
  const MainProfile(
      {super.key,
      required this.name,
      required this.userId,
      required this.profileImgUrl});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        title: 'Leo',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
        darkTheme: darkTheme,
        routes: {
          'profile': (context) => ProfileScreen(
                name: name,
                userId: userId,
                profileImgUrl: profileImgUrl,
              ),
          'gifts': (context) => const GiftsScreen(),
          'badges': (context) => BadgesScreen(
                name: name,
                userId: userId,
                profileImgUrl: profileImgUrl,
              ),
          'rooms': (context) => const VoiceRoomsScreen(),
          'edit-profile': (context) =>
              EditProfileScreen(name: name, userId: userId),
          'edit-name': (context) => EditNameScreen(userId: userId),
          'edit-bio': (context) => EditBio(
                userId: userId,
              ),
          'edit-motto': (context) => EditMotto(userId: userId),
        },
        initialRoute: 'profile',
      ),
    );
  }
}
