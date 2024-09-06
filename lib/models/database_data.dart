import 'package:flutter/foundation.dart';
import 'package:flutter_application_1/Service/database_services.dart';
import 'package:flutter_application_1/models/database.dart';

class databasedata extends ChangeNotifier {
  List<databases> Databases = [];

  void adddata(String datatitle) async {
    databases database = await DatabaseServices.adddata(datatitle, title: '');
    Databases.add(database);
    notifyListeners();
  }
}
