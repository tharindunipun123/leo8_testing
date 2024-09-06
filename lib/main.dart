// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       home: Scaffold(
//         body: Center(
//           child: Text('Hello World!'),
//         ),
//       ),
//     );
//   }
// }

// // Flutter imports:
// import 'package:flutter/material.dart';

// import 'package:zego_uikit/zego_uikit.dart';

// // Package imports:
// import 'home_page.dart';
// import 'gift/gift.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();

//   ZegoGiftManager().cache.cache(giftItemList);

//   ZegoUIKit().initLog().then((value) {
//     runApp(const MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'Flutter Demo', home: HomePage());
//   }
// }

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/database_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:flutter_application_1/models/database_data.dart';
import 'package:flutter_application_1/pages/achievement/achievement_screen.dart';
import 'package:flutter_application_1/pages/achievement/active_achievements_page.dart';
import 'package:flutter_application_1/pages/achievement/all_achievements_page.dart';
import 'package:flutter_application_1/pages/achievement/charm_achievements_page.dart';
import 'package:flutter_application_1/pages/achievement/consumption_achievements_page.dart';
import 'package:flutter_application_1/pages/achievement/recharge_achievements_page.dart';
import 'package:flutter_application_1/pages/feedback/feedback_screen.dart';
import 'package:flutter_application_1/pages/invite%20friends/invite_screen.dart';
import 'package:flutter_application_1/pages/language/language_screen.dart';
import 'package:flutter_application_1/pages/level/level_screen.dart';
import 'package:flutter_application_1/pages/nobel/profilepage.dart';
import 'package:flutter_application_1/pages/settings/settings_screen.dart';
import 'package:flutter_application_1/pages/svip/svip_screen.dart';
//import 'package:flutter_application_1/pages/wallet/wallet_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
//import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
//import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
//import 'package:zego_zimkit/zego_zimkit.dart';
// import 'gift/gift_data.dart';
// import 'gift/gift_manager/gift_manager.dart';
import 'pages/home page/bloc/home_page_bloc.dart';
import 'pages/home page/home_page.dart';
import 'pages/welcome page/welcome_page.dart';
import 'zego files/initial.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Stripe.publishableKey =
  //     'pk_test_51PE7q0CnvMccepGGN5R6sUUcTetLKAD8cWEi56rzgh2KqOuB6t1JIr7Eh65dh4hO34mwy6UOtE8QYGS0dRZij3CO00Gdh0xyva';

  // await ZIMKit().init(
  //   appID: Initial.id,
  //   appSign: Initial.signIn,
  // );
  // ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  // ZegoGiftManager().cache.cache(giftItemList);
  // ZegoUIKit().initLog().then((value) {
  //   ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
  //     [ZegoUIKitSignalingPlugin()],
  //   );

  runApp(MyApp(navigatorKey: navigatorKey));
}

class MyApp extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;

  const MyApp({Key? key, required this.navigatorKey}) : super(key: key);

  // Future<Map<String, dynamic>?> _checkUserLoggedIn() async {
  //   final directory = await getApplicationDocumentsDirectory();
  //   final file = File('${directory.path}/user.json');
  //   if (await file.exists()) {
  //     final userJson = await file.readAsString();
  //     final userData = jsonDecode(userJson) as Map<String, dynamic>;
  //     return userData;
  //   }
  //   return null;
  // }

  @override
  Widget build(BuildContext context) {
    // return ChangeNotifierProvider(
    //   create: (context) => databasedata(),
    //   child: FutureBuilder<Map<String, dynamic>?>(
    //     future: _checkUserLoggedIn(),
    //     builder: (context, snapshot) {
    //       if (snapshot.connectionState == ConnectionState.waiting) {
    //         return const MaterialApp(
    //           home: Scaffold(
    //             body: Center(child: CircularProgressIndicator()),
    //           ),
    //         );
    //       } else if (snapshot.hasData && snapshot.data != null) {
    //         final userData = snapshot.data!;
    //         final userId = userData['id'].toString();
    //         final name = userData['name'] ?? 'Unknown';
    //         final about = userData['about'] ?? 'Unknown';
    //         final avatar = userData['avatar'] ?? 'assets/avatar.jpg';
    //         return BlocProvider(
    //           create: (context) => HomePageBloc(),
    //           child: ScreenUtilInit(
    //             builder: (context, child) => MaterialApp(
    //               navigatorKey: navigatorKey,
    //               debugShowCheckedModeBanner: false,
    //               title: 'Flutter Demo',
    //               theme: ThemeData.light().copyWith(
    //                 primaryColor: Colors.blue,
    //               ),
    //               home: MyHomePage(
    //                 userId: userId,
    //                 about: about,
    //                 name: name,
    //                 userAvatar: avatar,
    //               ),
    //               // routes: {
    //               //   '/wallet': (context) => WalletScreen(userId: userId),
    //               //   '/achievement': (context) => const AchievementPage(),
    //               //   '/invite': (context) => const InviteFriendsPage(),
    //               //   '/nobel': (context) => const profilepage(),
    //               //   '/svip': (context) => const SvipScreen(),
    //               //   '/level': (context) => const LevelScreen(),
    //               //   '/language': (context) => const LanguageScreen(),
    //               //   '/feedback': (context) => const FeedbackScreen(),
    //               //   '/settings': (context) => const SettingsScreen(),
    //               //   '/all': (context) => AllAchievementsPage(),
    //               //   '/active': (context) => ActiveAchievementsPage(),
    //               //   '/charm': (context) => CharmAchievementsPage(),
    //               //   '/recharge': (context) => RechargeAchievementsPage(),
    //               //   '/consumption': (context) =>
    //               //       ConsumptionAchievementsPage(),
    //               // }
    //             ),
    //           ),
    //         );

    //       } else {
    //         return BlocProvider(
    //           create: (context) => HomePageBloc(),
    //           child: ScreenUtilInit(
    //             builder: (context, child) => MaterialApp(
    //               debugShowCheckedModeBanner: false,
    //               title: 'Flutter Demo',
    //               theme: ThemeData.light().copyWith(
    //                 primaryColor: Colors.blue,
    //               ),
    //               home: const WelcomePage(),
    //             ),
    //           ),
    //         );
    //       }
    //     },
    //   ),
    // );
    final Map<String, dynamic> userData = {
      "id": 1,
      "name": "Akash",
      // "about": "Some about text", // Uncomment if you have this key
      // "avatar": "assets/avatar.jpg", // Uncomment if you have this key
    };
    final userId = userData['id'].toString();
    final name = userData['name'] ?? 'Unknown';
    final about = userData['about'] ?? 'Unknown';
    final avatar = userData['avatar'] ?? 'assets/avatar.jpg';
    return BlocProvider(
      create: (context) => HomePageBloc(),
      child: ScreenUtilInit(
        builder: (context, child) => MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.light().copyWith(
            primaryColor: Colors.blue,
          ),
          home: WelcomePage(),
          // home: MyHomePage(
          //   userId: userId,
          //   about: about,
          //   name: name,
          //   userAvatar: avatar,
          // ),
          routes: {
           // '/wallet': (context) => WalletScreen(userId: userId),
            '/achievement': (context) => const AchievementPage(),
            '/invite': (context) => const InviteFriendsPage(),
            '/nobel': (context) => const profilepage(),
            '/svip': (context) => const SvipScreen(),
            '/level': (context) => const LevelScreen(),
            '/language': (context) => const LanguageScreen(),
            '/feedback': (context) => const FeedbackScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/all': (context) => AllAchievementsPage(),
            '/active': (context) => ActiveAchievementsPage(),
            '/charm': (context) => CharmAchievementsPage(),
            '/recharge': (context) => RechargeAchievementsPage(),
            '/consumption': (context) =>
                ConsumptionAchievementsPage(),
          }
        ),
      ),
    );
  }
}
