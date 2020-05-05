import 'package:flutter/material.dart';
import 'package:rss/widgets/page_detail.dart';
import 'package:rss/widgets/text_perso.dart';
import 'package:webfeed/webfeed.dart';

class Liste extends StatefulWidget {
  RssFeed feed;
  
  Liste(RssFeed feed){
    this.feed = feed;
  }
  
  @override
  State<StatefulWidget> createState() {
    return _ListeState();
  }
}

class _ListeState extends State<Liste> {
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.feed.items.length, 
        itemBuilder: (context, i){
          RssItem item = widget.feed.items[i];
          return Container(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 10,
              child: InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (BuildContext context){
                        return new PageDetail(item);
                      })
                  );
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        TextPerso("France 24"),
                        TextPerso(item.pubDate, color: Colors.red,)
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    Row(
                      children: <Widget>[
                        Image.network(item.enclosure.url),
                        Container(
                            width: 200,
                            child: TextPerso(item.title)
                        )

                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                  ],
                ),
              )

            ),
          );
        }
    );
  }
}