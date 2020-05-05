import 'package:flutter/material.dart';
import 'package:rss/widgets/text_perso.dart';
import 'package:webfeed/webfeed.dart';

class PageDetail extends StatelessWidget {
  RssItem item;
  PageDetail(RssItem item){
    this.item = item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Détail de l'article"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextPerso(item.title, fontSize: 30.0,),
            Card(
              elevation: 7.5,
              child: Container(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.network(item.enclosure.url, fit : BoxFit.fill),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextPerso(item.author),
                TextPerso(item.pubDate, color: Colors.red,)
              ],
            ),
            TextPerso(item.description)
          ],
        ),
      ),
    );
  }
}