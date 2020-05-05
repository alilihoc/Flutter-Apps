import 'package:flutter/material.dart';
import 'package:rss/models/parser.dart';
import 'package:rss/widgets/chargement.dart';
import 'package:rss/widgets/grille.dart';
import 'package:rss/widgets/liste.dart';
import 'package:webfeed/webfeed.dart';

class Home extends StatefulWidget {

  final String title;
  Home({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }

}

class _HomeState extends State<Home> {
  RssFeed feed;

  @override
  void initState() {
    super.initState();
    parse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: (){
              setState(() {
                feed = null;
                parse();
              });
            },
          )
        ],
      ),
      body: choixDuBody(),
    );
  }



  Widget choixDuBody(){
    if(feed == null){
      return Chargement();
    }else{
      Orientation orientation = MediaQuery.of(context).orientation;
      if(orientation == Orientation.portrait){
        return Liste(feed);
      }else{
        return Grille(feed);
      }
    }
  }

  Future<Null> parse() async {
    RssFeed recu = await Parser().chargerRss();
    if(recu != null){
      setState(() {
        feed = recu;
      });
      print(feed.items.length);
      RssItem item = feed.items[2];
      print(item.title);
    }
  }


}