import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:rss/widgets/text_perso.dart';
import 'package:webfeed/webfeed.dart';

class Grille extends StatefulWidget {
  RssFeed feed;

  Grille(RssFeed feed){
    this.feed = feed;
  }

  @override
    State<StatefulWidget> createState() {
      return _GrilleState();
    }
}

class _GrilleState extends State<Grille> {

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.feed.items.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, i){
        RssItem item = widget.feed.items[i];
          return Card(
            child: InkWell(
              onTap: (){

              },
              child: Card(
                elevation: 10,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextPerso(item.author),
                        TextPerso(item.pubDate)
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Image.network(item.enclosure.url, fit: BoxFit.fitWidth),
                    )
                  ],
                ),
              ),
            ),
          );
        }
    );
  }
}