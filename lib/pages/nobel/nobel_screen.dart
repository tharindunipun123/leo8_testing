import 'package:flutter/material.dart';

class NobelScreen extends StatelessWidget {
  const NobelScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nobel'),
      ),
      body: Center(
        child: Text('Nobel Prize Winners'),
      ),
    );
  }
}
