import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Activite> mesActivites = [
    new Activite("Velo", Icons.directions_bike),
    new Activite("Peinture", Icons.palette),
    new Activite("Golf", Icons.golf_course),
    new Activite("Arcade", Icons.gamepad),
    new Activite("Bricolage", Icons.build),
    new Activite("Velo", Icons.directions_bike),
    new Activite("Peinture", Icons.palette),
    new Activite("Golf", Icons.golf_course),
    new Activite("Arcade", Icons.gamepad),
    new Activite("Bricolage", Icons.build),
    new Activite("Velo", Icons.directions_bike),
    new Activite("Peinture", Icons.palette),
    new Activite("Golf", Icons.golf_course),
    new Activite("Arcade", Icons.gamepad),
    new Activite("Bricolage", Icons.build),
    new Activite("Velo", Icons.directions_bike),
    new Activite("Peinture", Icons.palette),
    new Activite("Golf", Icons.golf_course),
    new Activite("Arcade", Icons.gamepad),
    new Activite("Bricolage", Icons.build),
    new Activite("Velo", Icons.directions_bike),
    new Activite("Peinture", Icons.palette),
    new Activite("Golf", Icons.golf_course),
    new Activite("Arcade", Icons.gamepad),
    new Activite("Bricolage", Icons.build),
  ];

  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    print(orientation);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: mesActivites.length,
            itemBuilder: (context, i){
              return Container(
                margin: EdgeInsets.all(2.5),
                child: Card(
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text("Activité",style: TextStyle(color: Colors.teal, fontSize: 15),),
                      Icon(mesActivites[i].icone, color: Colors.teal,size: 40,),
                      Text(mesActivites[i].nom,style: TextStyle(color: Colors.teal[800], fontSize: 20),),
                    ],
                  ),
                ),
              );
            }

        )

      ),
    );
  }
}




class Activite {
  String nom;
  IconData icone;

  Activite(String nom, IconData icone){
    this.nom = nom;
    this.icone = icone;
  }
  
  Widget myTile(){
    return Container(
      height: 125,
      padding: EdgeInsets.all(5),
      child: Card(
        elevation: 7.5,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Icon(this.icone, color: Colors.teal,size: 75),
              Text(this.nom, style: TextStyle(fontSize: 30, color: Colors.teal),)
            ],
          ),
          onTap: (){
            print(this.nom);
          },
          onLongPress: () async {
            await Future.delayed(Duration(seconds: 3));
            print('Press Long sur : ${this.nom}');
          },
        )
        

      ),
    );
  }



}
