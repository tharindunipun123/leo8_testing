import 'package:flutter/material.dart';

class LevelScreen extends StatelessWidget {
  const LevelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level'),
      ),
      body: Center(
        child: Text('Level Screen'),
      ),
    );
  }
}
