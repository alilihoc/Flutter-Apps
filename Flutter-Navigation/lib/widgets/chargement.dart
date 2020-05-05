import 'package:flutter/material.dart';
import 'package:rss/widgets/text_perso.dart';

class Chargement extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TextPerso(
        "Chargement en cours ....",
        fontSize: 30.0,
        fontStyle: FontStyle.italic,
      ),
    );
  }

}