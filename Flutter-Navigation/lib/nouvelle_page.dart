import 'package:flutter/material.dart';

class NouvellePage extends StatelessWidget {
  String title;

  NouvellePage(String title){
    this.title = title;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text("Je suis  la nouvelle page"),
      ),
    );


  }
}