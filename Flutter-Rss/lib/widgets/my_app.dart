import 'package:flutter/material.dart';
import 'package:rss/widgets/home.dart';

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "My News",
      theme: ThemeData(
        primarySwatch: Colors.indigo
      ),
      home: Home(title: "News",),
      debugShowCheckedModeBanner: false,
    );
  }

}