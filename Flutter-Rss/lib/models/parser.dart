import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';



class Parser {

  final url = "https://www.france24.com/fr/rss";

  Future chargerRss() async {
    final reponse = await get(url);
    if(reponse.statusCode == 200){
      final feed = RssFeed.parse(reponse.body);
      return feed;
    }else{
      print("Erreur ${reponse.statusCode}");
    }

  }

}