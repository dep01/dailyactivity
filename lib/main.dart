import 'package:flutter/material.dart';
import 'package:flutter_batch/pages/home.dart';
import './pages/form.dart';
import './pages/login.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: Homepage(),
      initialRoute: "/",
      routes: {
        "/":(_)=>Login(),
        "/home":(_)=>Homepage(),
        "/form":(_)=>FormPage(),
      },
    );
  }
}

