import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:meteo/temps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  var userLocation;
  var location = new Location();

  try{
    userLocation = await location.getLocation();
  }on PlatformException catch(e){
    if(e.code == 'PERMISSION_DENIED'){
      print('PERMISSION_DENIED');
    }else{
      print(e);
    }
  }

  if(userLocation != null){
    final latitude = userLocation.latitude;
    final longitude = userLocation.longitude;
    final Coordinates coordinates = Coordinates(latitude, longitude);
    final ville = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    if(ville != null){
      runApp(MyApp(ville.first.locality));
    }
  }
}

class MyApp extends StatelessWidget {
  String ville;
  MyApp(String ville){
    this.ville = ville;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(ville,title: 'Météo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  String villeDuDevice;
  final String title;

  MyHomePage(String ville, {Key key, this.title}) : super(key: key){
    this.villeDuDevice = ville;
  }


  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<String> villes = [];
  String villechoisie;
  Temps tempsActuel;

  @override
  void initState() {
    super.initState();
    obtenir();
    appelApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      drawer: SizedBox(
        width: MediaQuery.of(context).size.width / 2,
        child: Drawer(
          child: Container(
            color: Colors.blue,
            child: ListView.builder(
                itemCount: villes.length + 2,
                itemBuilder: (context, i){
                  if(i == 0){
                    return DrawerHeader(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          texteAvecStyle("Mes villes", fontSize: 22.0),
                          RaisedButton(
                            color: Colors.white,
                            elevation: 8.0,
                            child: texteAvecStyle("Ajouter une ville", color: Colors.blue),
                            onPressed: (){
                              ajoutVille();
                            },
                          )
                        ],
                      ),
                    );
                  }else if(i == 1){
                    return ListTile(
                      title: texteAvecStyle(widget.villeDuDevice),
                      onTap: (){
                        setState(() {
                          villechoisie = null;
                          appelApi();
                          Navigator.pop(context);
                        });
                      },
                    );
                  }else{
                    int indexVille = i - 2;
                    return ListTile(
                      onTap: (){
                        setState(() {
                          villechoisie = villes[indexVille];
                          appelApi();
                          Navigator.pop(context);
                        });
                      },
                      title: texteAvecStyle(villes[indexVille]),
                      trailing: new IconButton(
                          icon: Icon(Icons.delete, color: Colors.white,),
                          onPressed: (){
                            supprimer(villes[indexVille]);
                          }
                      ),
                    );
                  }

                }
            ),
          ),
        ),
      ) ,
      body: (tempsActuel == null)
        ? Center(
        child: Text((villechoisie==null)?widget.villeDuDevice:villechoisie),
          )
        : Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(assetName()),
              fit: BoxFit.cover
          )
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            texteAvecStyle(tempsActuel.name, fontSize: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                texteAvecStyle("${tempsActuel.temp.toInt()}°C", fontSize: 60.0),
                Image.asset(tempsActuel.icon.replaceAll("d", "").replaceAll("n.", "."))
              ],
            ),
            texteAvecStyle(tempsActuel.main, fontSize: 30.0),
            texteAvecStyle(tempsActuel.description, fontSize: 25.0)
          ],
        ),
      ),
    );
  }


  Text texteAvecStyle(String data, {color: Colors.white, fontSize: 18.0, fontStyle: FontStyle.italic, textAlign: TextAlign.center}){
    return new Text(
      data,
      textAlign: textAlign,
      style: TextStyle(
        color: color,
        fontStyle: fontStyle,
        fontSize: fontSize
      ),
    );

  }

  Future<Null> ajoutVille() async{
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext builContext){
        return SimpleDialog(
          contentPadding: EdgeInsets.all(20.0),
          title: texteAvecStyle("Ajoutez une ville", fontSize: 20.0, color: Colors.blue),
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: "Ville:"),
              onSubmitted: (String value){
                print("onSubmitted");
                ajouter(value);
                Navigator.pop(builContext);
              },
            ),
          ],
        );
      }
    );
  }

  Future<Null> obtenir() async{
    print("Obtenir");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<String> liste = await sharedPreferences.getStringList("villes");
    if(liste != null){
      setState(() {
        villes = liste;
      });
    }
  }

  Future<Null> ajouter(String value) async{
    print("Ajouter $value");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.add(value);
    await sharedPreferences.setStringList("villes", villes);
    obtenir();
  }

  Future<Null> supprimer(String value) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    villes.remove(value);
    await sharedPreferences.setStringList("villes", villes);
    obtenir();
  }

  void appelApi() async{
    String adresse;
    if(villechoisie == null){
      adresse = widget.villeDuDevice;
    }else{
      adresse = villechoisie;
    }
    List<Address> coord = await Geocoder.local.findAddressesFromQuery(adresse);
    if(coord != null){
      final lat = coord.first.coordinates.latitude;
      final lon = coord.first.coordinates.longitude;
      String lang = Localizations.localeOf(context).languageCode;
      final key = "959d1296a89c3365a20b001a440c4eb3";

      String urlApi = "http://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$key&lang=$lang&units=metric";
      final reponse = await http.get(urlApi);
      if(reponse.statusCode == 200){
        Temps temps = new Temps();
        Map map = jsonDecode(reponse.body);
        temps.fromJSON(map);
        setState(() {
          tempsActuel = temps;
          print(tempsActuel.icon);
        });
      }
    }
  }

  String assetName(){
    if(tempsActuel.icon.contains("n.")){
      // Nuit
      return "assets/n.jpg";
    }else if(tempsActuel.icon.contains("/01")
        || tempsActuel.icon.contains("/02")
        || tempsActuel.icon.contains("/03")){
      // Beau
      return "assets/d1.jpg";
    }else{
      // Mauvais temps
      return "assets/d2.jpg";
    }
  }

}
