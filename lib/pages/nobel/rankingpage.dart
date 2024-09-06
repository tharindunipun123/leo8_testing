import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Service/database_services.dart';
import 'package:flutter_application_1/models/database.dart';
import 'package:flutter_application_1/pages/nobel/countdown.dart';
import 'package:flutter_application_1/pages/nobel/rankincontainer.dart';

class RankingPage extends StatefulWidget {
  const RankingPage({super.key});

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  final StreamController<List<databases>> _streamController =
      StreamController.broadcast();
  List<databases> _databasesList = [];
  String? topItemName;
  int? topItemCount;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchDataPeriodically();
  }

  void _fetchDataPeriodically() {
    // Fetch data initially
    _fetchData();

    // Fetch data every 5 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      _fetchData();
    });
  }

  void _fetchData() async {
    List<databases> data = await DatabaseServices.getdata();
    data.sort((a, b) => b.count.compareTo(a.count)); // Sort by count
    setState(() {
      _databasesList = data;
    });
    _streamController.add(_databasesList);
  }

  void _handleCountdownEnd() {
    if (_databasesList.isNotEmpty) {
      setState(() {
        topItemName = _databasesList[0].name;
        topItemCount = _databasesList[0].count;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: StreamBuilder<List<databases>>(
        stream: _streamController.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            List<databases> databasesList = snapshot.data!;
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: height / 4,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/Resizers/Noble Interface 2 copy.png"),
                                fit: BoxFit.fill)),
                      ),
                      Container(
                        height: height / 1.4,
                        width: double.infinity,
                        color: const Color.fromARGB(255, 255, 255, 255),
                      )
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 4.3),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            child: CountdownScreen(
                                onCountdownEnd: _handleCountdownEnd),
                            width: double.infinity,
                            height: height / 10,
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 240, 240, 240),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                          ),
                          if (topItemName != null && topItemCount != null) ...[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Top Item: $topItemName, Count: $topItemCount',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          Container(
                            width: double.infinity,
                            height: height / 1.5,
                            child: ListView.builder(
                              itemCount: databasesList.length,
                              itemBuilder: (context, index) {
                                String address = databasesList[index].address;
                                bool validUrl =
                                    Uri.tryParse(address)?.hasAbsolutePath ??
                                        false;
                                Widget leadingWidget;

                                if (index == 0) {
                                  leadingWidget = Image.asset(
                                    'assets/Resizers/firstplace.png',
                                    scale: width / 50,
                                  );
                                } else if (index == 1) {
                                  leadingWidget = Image.asset(
                                    'assets/Resizers/secondplace.png',
                                    scale: width / 50,
                                  );
                                } else if (index == 2) {
                                  leadingWidget = Image.asset(
                                    'assets/Resizers/thirdplace.png',
                                    scale: width / 50,
                                  );
                                } else {
                                  leadingWidget = Padding(
                                    padding: EdgeInsets.only(
                                        left: width / 25, right: width / 25),
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                          fontSize: width / 20,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  );
                                }

                                return Padding(
                                  padding:
                                      EdgeInsets.only(bottom: height / 140),
                                  child: rankingcontainer(
                                    name: databasesList[index].name,
                                    nobelcount:
                                        databasesList[index].count.toString(),
                                    leadingget: leadingWidget,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
