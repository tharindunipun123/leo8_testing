import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_application_1/pages/edit%20profile/profile_screen.dart';
import 'package:flutter_application_1/pages/nobel/nobelcart.dart';
import 'package:flutter_application_1/pages/nobel/questionmark.dart';
import 'package:flutter_application_1/pages/nobel/rankingpage.dart';
import 'package:flutter_application_1/pages/profile/profile.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/Service/database_services.dart';
import 'package:flutter_application_1/Service/globals.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:flutter_application_1/models/database_data.dart';
// import 'package:flutter_application_1/nobelcart.dart';
// import 'package:flutter_application_1/questionmark.dart';
// import 'package:flutter_application_1/rankingpage.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:provider/provider.dart';

class profilepage extends StatefulWidget {
  const profilepage({super.key});

  @override
  State<profilepage> createState() => _profilepageState();
}

class _profilepageState extends State<profilepage> {
  List<databases>? Databases;
  String profile = '';
  String profilepic = '';
  double nobelcount = 00;
  int limit = 0;
  String counted = "";
  double x = 0;
  int endcount = 999;
  int nextcount = 0;
  String frame = "assets/nononbel.json";
  double precentage = 0;
  String nobelcon = "assets/Resizers/nonbarcon.png";
  String nobelback = "assets/Resizers/nonback.jpg";
  Color barcolor = Colors.white;
  String downbar = "assets/Resizers/nonbar.png";
  String nobelbatch = "assets/Resizers/pawnbatch.png";
  String nobelpriveledge = "assets/Resizers/nonprevelege.png";
  String limitline = "";
  int limitvalue = 0;
  String nobelname = "Non nobel";

  getdata() async {
    Databases = await DatabaseServices.getdata();
    Provider.of<databasedata>(context, listen: false).Databases = Databases!;
    setState(() {});
  }

  Future<double> getNobelCount() async {
    List<databases>? Databases = await DatabaseServices.getdata();
    if (Databases != null && Databases.isNotEmpty && Databases.length >= 2) {
      return Databases[1].count.toDouble();
    } else {
      // Handle the case where databases is null or empty
      return 0.0; // Or any default value you prefer
    }
  }

  Future<String> getname() async {
    List<databases>? Databases = await DatabaseServices.getdata();
    if (Databases != null && Databases.isNotEmpty && Databases.length >= 2) {
      return Databases[1].name.toString();
    } else {
      // Handle the case where databases is null or empty
      return ''; // Or any default value you prefer
    }
  }

  Future<String> getaddress() async {
    List<databases>? Databases = await DatabaseServices.getdata();
    if (Databases != null && Databases.isNotEmpty && Databases.length >= 2) {
      return Databases[1].address.toString();
    } else {
      // Handle the case where databases is null or empty
      return ''; // Or any default value you prefer
    }
  }

  @override
  void initState() {
    super.initState();
    getdata();
    updateCounted();
    initializeNobelCount();
    getname();
    getaddress();
  }

  void initializeNobelCount() async {
    double count = await getNobelCount();
    String name = await getname();
    String address = await getaddress();
    setState(() {
      nobelcount = count;
      profile = name;
      profilepic = address;
    });
  }

  void updateCounted() {
    setState(() {
      if (nobelcount < 500) {
        limit = 0;
        x = nobelcount - limit;
        nobelname = "Non Nobel";
        endcount = 500;
        precentage = nobelcount / endcount;
        barcolor = const Color.fromARGB(255, 61, 61, 61);
        nobelcon = "assets/Resizers/nonbarcon.png";
        downbar = "assets/Resizers/nonbar.png";
        nobelbatch = "assets/Resizers/nonbatch.png";
        nobelpriveledge = "assets/Resizers/nonprevelege.png";
        frame = 'assets/bishop.json';
        nobelback = "assets/Resizers/nonback.jpg";
        limitvalue = 0;
        limitline = '';
      }

      //Pawn
      else if (500 <= nobelcount && nobelcount <= 1499) {
        counted = "assets/pawnbatch.png";
        limit = 500;
        x = nobelcount - limit;
        endcount = 1499;
        nextcount = 3999;
        frame = 'assets/Resizers/pawn2.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/pawnback.jpg";
        barcolor = const Color.fromARGB(255, 25, 121, 29);
        nobelcon = "assets/Resizers/barcon.png";
        downbar = "assets/Resizers/bar.png";
        nobelbatch = "assets/Resizers/pawnbatch.png";
        nobelpriveledge = "assets/Resizers/pawnprevelege.png";
        limitline = "749";
        limitvalue = 749;
        nobelname = "Pawan";
      }
      //Rook
      else if (1500 <= nobelcount && nobelcount <= 3999) {
        counted = "assets/nonnobel.jpg";
        limit = 1500;
        endcount = 3999;
        nextcount = 11999;
        frame = "assets/Resizers/rook.json";
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/rookback.jpg";
        barcolor = const Color.fromARGB(255, 3, 103, 186);
        nobelcon = "assets/Resizers/rookbarcon.png";
        downbar = "assets/Resizers/rookbar.png";
        nobelbatch = "assets/Resizers/rookbatch.png";
        nobelpriveledge = "assets/Resizers/rookprevelege.png";
        limitline = "2.499K";
        limitvalue = 2499;
        nobelname = "Rook";
      }
      //Knight
      else if (4000 <= nobelcount && nobelcount <= 11999) {
        counted = "assets/baronbatch.png";
        limit = 4000;
        endcount = 11999;
        endcount = 11999;
        nextcount = 29999;
        frame = 'assets/Resizers/knight.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/knightback.jpg";
        barcolor = const Color.fromARGB(255, 153, 0, 180);
        nobelcon = "assets/Resizers/knightbarcon.png";
        downbar = "assets/Resizers/knightbar.png";
        nobelbatch = "assets/Resizers/knightbatch.png";
        nobelpriveledge = "assets/Resizers/knightprevelege.png";
        limitline = "6.999k";
        limitvalue = 6999;
        nobelname = "Knight";
      }
      //Bishop
      else if (12000 <= nobelcount && nobelcount <= 29999) {
        counted = "assets/baronbatch.png";
        limit = 12000;
        endcount = 29999;
        endcount = 29999;
        nextcount = 59999;
        frame = 'assets/Resizers/bishop2.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/bishopback.jpg";
        barcolor = Color.fromARGB(255, 101, 11, 68);
        nobelcon = "assets/Resizers/bishopbarcon.png";
        downbar = "assets/Resizers/bishopbar.png";
        nobelbatch = "assets/Resizers/bishopbatch.png";
        nobelpriveledge = "assets/Resizers/bishopprevelege.png";
        limitline = "16.99k";
        limitvalue = 16999;
        nobelname = "Bishop";
      }
      //Queen
      else if (30000 <= nobelcount && nobelcount <= 59999) {
        counted = "assets/baronbatch.png";
        limit = 30000;
        endcount = 59999;
        endcount = 59999;
        nextcount = 149999;
        frame = 'assets/Resizers/queen.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/queenback.jpg";
        barcolor = Color.fromARGB(255, 177, 114, 6);
        nobelcon = "assets/Resizers/queenbarcon.png";
        downbar = "assets/Resizers/queenbar.png";
        nobelbatch = "assets/Resizers/queenbatch.png";
        nobelpriveledge = "assets/Resizers/queenprevelege.png";
        limitline = "36.99k";
        limitvalue = 36999;
        nobelname = "Queen";
      }
      //Duke
      else if (60000 <= nobelcount && nobelcount <= 149999) {
        counted = "assets/baronbatch.png";
        limit = 60000;
        endcount = 149999;
        endcount = 149999;
        nextcount = 299999;
        frame = 'assets/Resizers/duke2.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/dukeback.jpg";
        barcolor = Color.fromARGB(255, 170, 173, 2);
        nobelcon = "assets/Resizers/dukebarcon.png";
        downbar = "assets/Resizers/dukebar.png";
        nobelbatch = "assets/Resizers/dukebatch.png";
        nobelpriveledge = "assets/Resizers/dukeprevelege.png";
        limitline = "69.99k";
        limitvalue = 69999;
        nobelname = "Duke";
      }
      //King
      else if (150000 <= nobelcount && nobelcount <= 299999) {
        counted = "assets/baronbatch.png";
        limit = 150000;
        endcount = 299999;
        endcount = 299999;
        nextcount = 499999;
        frame = 'assets/Resizers/king.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/kingback.jpg";
        barcolor = Color.fromARGB(255, 110, 19, 5);
        nobelcon = "assets/Resizers/kingbarcon.png";
        downbar = "assets/Resizers/kingbar.png";
        nobelbatch = "assets/Resizers/kingbatch.png";
        nobelpriveledge = "assets/Resizers/kingprevelege.png";
        limitline = "174.9k";
        limitvalue = 174999;
        nobelname = "King";
      }
      //Sking
      else if (300000 <= nobelcount && nobelcount <= 499999) {
        counted = "assets/baronbatch.png";
        limit = 300000;
        endcount = 499999;
        endcount = 499999;
        nextcount = 1000000;
        frame = 'assets/Resizers/sking.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/skingback.jpg";
        barcolor = Color.fromARGB(255, 80, 3, 76);
        nobelcon = "assets/Resizers/skingbarcon.png";
        downbar = "assets/Resizers/skingbar.png";
        nobelbatch = "assets/Resizers/skingbatch.png";
        nobelpriveledge = "assets/Resizers/skingprevelege.png";
        limitline = "369.9k";
        limitvalue = 369999;
        nobelname = "SKing";
      }
      //SSking
      else if (500000 <= nobelcount && nobelcount <= 1000000) {
        counted = "assets/baronbatch.png";
        limit = 500000;
        endcount = 1000000;
        endcount = 1000000;
        nextcount = 12000000;
        frame = 'assets/Resizers/ssking.json';
        precentage = nobelcount / endcount;
        nobelback = "assets/Resizers/sskingback.jpg";
        barcolor = Color.fromARGB(255, 111, 88, 4);
        nobelcon = "assets/Resizers/sskingbarcon.png";
        downbar = "assets/Resizers/sskingbar.png";
        nobelbatch = "assets/Resizers/sskingbatch.png";
        nobelpriveledge = "assets/Resizers/sskingprevelege.png";
        limitline = "699.9k";
        limitvalue = 699999;
        nobelname = "SSKing";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    getdata();
    updateCounted();
    initializeNobelCount();
    getname();
//nobelcount=(Provider.of<databasedata>(context,listen: false).Databases[0].count).toDouble();
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(nobelback), fit: BoxFit.cover)),
          child:
              Consumer<databasedata>(builder: (context, databasedata, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,
                                  color: Colors.black,
                                  size: width / 18,
                                  shadows: [
                                    BoxShadow(
                                        blurRadius: 30,
                                        blurStyle: BlurStyle.outer,
                                        color: const Color.fromARGB(
                                            255, 68, 68, 68))
                                  ],
                                )),
                            Text(
                              "MY NOBEL",
                              style: TextStyle(
                                  color: Colors.white,
                                  shadows: [
                                    BoxShadow(
                                        blurRadius: 30,
                                        color: Colors.black,
                                        blurStyle: BlurStyle.outer)
                                  ],
                                  fontSize: width / 22,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 2),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (context) {
                                        return RankingPage();
                                      },
                                    ));
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.trophy,
                                    color: Color.fromARGB(255, 255, 200, 0),
                                    size: width / 15,
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 4),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) {
                                      return question();
                                    },
                                  ));
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Center(
                                      child: Icon(
                                        Icons.question_mark,
                                        size: width / 25,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: width / 20,
                          right: width / 20,
                          bottom: height / 40),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(nobelcon), fit: BoxFit.fill)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      profile,
                                      style: TextStyle(
                                          color: Colors.white,
                                          shadows: [
                                            BoxShadow(
                                                blurRadius: 20,
                                                color: Colors.black,
                                                blurStyle: BlurStyle.outer)
                                          ],
                                          fontSize: width / 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                //profile image section
                                if (nobelcount >= 500) ...[
                                  SizedBox(
                                    width: width / 3,
                                    child: LottieBuilder.asset(
                                      frame,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                ],

                                if (nobelcount < 500) ...[
                                  SizedBox(
                                    width: width / 3,
                                    height: height / 7,
                                  )
                                ]
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: height / 76, bottom: height / 60),
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 30),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.money,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            size: width / 25),
                                        Text(
                                          "$limit",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: width / 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width / 100,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: height / 170,
                                            ),
                                            Container(
                                              width: width / 3,
                                              child: LinearPercentIndicator(
                                                center: Container(
                                                    height: height / 72,
                                                    width: 2,
                                                    color: const Color.fromARGB(
                                                        255, 155, 155, 155)),
                                                lineHeight: height / 70,
                                                animation: true,
                                                progressColor: barcolor,
                                                percent: precentage,
                                                barRadius: Radius.circular(55),
                                                backgroundColor: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                            Center(
                                                child: Text(
                                              limitline,
                                              style: TextStyle(
                                                  fontSize: width / 36,
                                                  color: Color.fromARGB(
                                                      255, 252, 252, 252)),
                                            ))
                                          ],
                                        ),
                                        SizedBox(
                                          width: width / 100,
                                        ),
                                        Text(
                                          "$endcount",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 255, 255, 255),
                                              fontSize: width / 25,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (limitvalue - nobelcount >= 0 && nobelcount >= 500) ...[
                      Text(
                          "Need ${(limitvalue - nobelcount).toString()} to secure your current"
                          "\n"
                          "nobel level $nobelname",
                          style: TextStyle(
                              fontSize: width / 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [BoxShadow(blurRadius: 2)]),
                          textAlign: TextAlign.center),
                    ],
                    if (nobelcount - limitvalue >= 0 && nobelcount >= 500) ...[
                      Text(
                          "You'll secure your current nobel level $nobelname after validity period"
                          "\n"
                          "To uppgrade to next nobel you need ${(endcount - nobelcount).toString()}",
                          style: TextStyle(
                              fontSize: width / 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [BoxShadow(blurRadius: 2)]),
                          textAlign: TextAlign.center)
                    ],
                  ]),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          left: width / 40,
                          right: width / 40,
                        ),
                        child: Container(
                          child: SingleChildScrollView(
                            physics: ScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                if ((nobelcount < 500)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Frame.png",
                                      "assets/Resizers/Name-Plate.png",
                                    ],
                                    name: 'Non-Nobel',
                                    fcolor: Color.fromARGB(166, 35, 97, 37),
                                    lcolor:
                                        const Color.fromARGB(166, 17, 48, 18),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: ["Frame", "NamePlate"],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 1499)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Pawn Frame.png",
                                      "assets/Resizers/Pawn Noble Name Plate.PNG",
                                    ],
                                    name: 'Pawn',
                                    fcolor: Color.fromARGB(166, 35, 97, 37),
                                    lcolor:
                                        const Color.fromARGB(166, 17, 48, 18),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Frame",
                                      "NamePlate",
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 3999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Rook Noble Badge.PNG",
                                      "assets/Resizers/Rook Frame.png",
                                      "assets/baron.png",
                                    ],
                                    name: 'Rook',
                                    fcolor: Color.fromARGB(166, 21, 100, 165),
                                    lcolor: Color.fromARGB(166, 13, 64, 105),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 11999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Knight Noble Badge.PNG",
                                      "assets/Resizers/Knight Frame.png",
                                      "assets/Resizers/Knight Noble Badge Name.PNG",
                                      "assets/Resizers/KnightFancyPlate.png",
                                      "assets/Resizers/Knightcard.png"
                                    ],
                                    name: 'Knight',
                                    fcolor: Color.fromARGB(166, 116, 29, 132),
                                    lcolor: Color.fromARGB(166, 74, 18, 84),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 29999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Bishop Noble Badge.PNG",
                                      "assets/Resizers/Bishop Frame.png",
                                      "assets/Resizers/Bishop Noble Badge Name.PNG",
                                      "assets/Resizers/BishopFancyPlate.png",
                                      "assets/Resizers/Bishopcard.png"
                                    ],
                                    name: 'Bishop',
                                    fcolor: Color.fromARGB(166, 158, 19, 65),
                                    lcolor: Color.fromARGB(166, 83, 10, 34),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 59999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Queen-Noble-Badge.PNG",
                                      "assets/Resizers/Queen Frame.png",
                                      "assets/Resizers/Queen Noble Badge Name.PNG",
                                      "assets/Resizers/QueenFancyPlate.png",
                                      "assets/Resizers/Queencard.png"
                                    ],
                                    name: 'Queen',
                                    fcolor: Color.fromARGB(166, 110, 66, 1),
                                    lcolor: Color.fromARGB(166, 55, 33, 0),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 149999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/Duke Noble Badge.PNG",
                                      "assets/Resizers/Duke Frame.png",
                                      "assets/Resizers/Duke Noble Badge Name.PNG",
                                      "assets/Resizers/DukeFancyPlate.png",
                                      "assets/Resizers/Dukecard.png"
                                    ],
                                    name: 'Duke',
                                    fcolor: Color.fromARGB(166, 207, 186, 0),
                                    lcolor: Color.fromARGB(166, 125, 113, 0),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 299999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/King Noble Badge.PNG",
                                      "assets/Resizers/King Frame.png",
                                      "assets/Resizers/King Noble Badge Name.PNG",
                                      "assets/Resizers/KingFancyPlate.png",
                                      "assets/Resizers/Kingcard.png"
                                    ],
                                    name: 'King',
                                    fcolor: Color.fromARGB(166, 170, 46, 37),
                                    lcolor: Color.fromARGB(166, 83, 22, 17),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 449999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/SKing Noble Badge.PNG",
                                      "assets/Resizers/SKing Frame.png",
                                      "assets/Resizers/SKing Noble Badge Name.PNG",
                                      "assets/Resizers/SKingFancyPlate.png",
                                      "assets/Resizers/SKingcard.png"
                                    ],
                                    name: 'SKing',
                                    fcolor: Color.fromARGB(166, 65, 1, 61),
                                    lcolor: Color.fromARGB(166, 23, 0, 21),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                  SizedBox(
                                    width: width / 40,
                                  ),
                                ],
                                if ((nobelcount <= 1009999)) ...[
                                  nobelcart(
                                    img: [
                                      "assets/Resizers/SSKing Noble Badge.PNG",
                                      "assets/Resizers/SSKing Frame.png",
                                      "assets/Resizers/SSKing Noble Badge Name.PNG",
                                      "assets/Resizers/SSKingFancyPlate.png",
                                      "assets/Resizers/SSKingcard.png"
                                    ],
                                    name: 'SSKing',
                                    fcolor: Color.fromARGB(166, 73, 60, 10),
                                    lcolor: Color.fromARGB(166, 36, 30, 5),
                                    nobelpreve: nobelpriveledge,
                                    nobelbatch: nobelbatch,
                                    imgname: [
                                      "Badge",
                                      "Frame",
                                      "NamePlate",
                                      "Entry Effect",
                                      "Profile Card"
                                    ],
                                  ),
                                ]
                              ],
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: height / 12,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(downbar), fit: BoxFit.fill),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
