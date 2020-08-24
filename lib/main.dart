import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:locer/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Location tracker',
      theme: ThemeData(
        primaryColor: Colors.cyan,
      ),
      home: Home(),
    );
  }
}
