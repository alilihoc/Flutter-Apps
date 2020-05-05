import 'package:flutter/material.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Les widgets basiques',
      theme: ThemeData(
        primarySwatch: Colors.red
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  bool oui = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return new Scaffold(
      appBar: AppBar(
        title: Text('Salut'),
        leading: Icon(Icons.account_circle),
        actions: <Widget> [
            Icon(Icons.tag_faces),
          ],
        elevation: 10,
        centerTitle: true,

      ),
      backgroundColor: Colors.teal,
      body: Container(
        color: Colors.blue,
        margin: EdgeInsets.only(top: 20, bottom: 15),
        child: Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             children: <Widget>[
             Text('Apprentissage des widgets ',
               textAlign:TextAlign.center,
               textScaleFactor: 2,
               style: TextStyle(
                 color: (oui) ? Colors.white:Colors.red,
                 fontSize: 20,
                 fontStyle: FontStyle.italic,
               ),
             ),
             Card(
               elevation: 10,
               child: Container(
                 width: MediaQuery.of(context).size.width / 1.5,
                 height: 200,
                 child: Image.asset("assets/article_flutter_mobizel@2x.png"),
               ),
             ),
               Container(
                 height: 75,
                 color: Colors.red,
                 margin: EdgeInsets.only(left: 20, right: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     Container(height: width / 8,width: width / 8, color: Colors.blue),
                     Container(height: width / 8,width: width / 8, color: Colors.white),
                     Container(height: width / 8,width: width / 8, color: Colors.green),
                     Container(height: width / 8,width: width / 8, color: Colors.deepOrangeAccent),
                     Container(height: width / 8,width: width / 8, color: Colors.amber),
                   ],
                 ),
               ),
               Text(oui.toString()),
               FlatButton(
                 child: Text('Changer oui'),
                 onPressed: changerOui,
               ),
               RaisedButton(
                 onPressed: changerOui,
                 color: Colors.red,
                 textColor: Colors.white,
                 child: Text("Changer oui"),
               ),
               Container(
                 height: 75,
                 color: Colors.red,
                 margin: EdgeInsets.only(left: 20, right: 20),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children: <Widget>[
                     IconButton(
                       icon: Icon(Icons.delete),
                       onPressed: (){
                         changerOui();
                       },
                       color: Colors.white,
                     ),
                     IconButton(
                       icon: Icon(Icons.table_chart),
                       onPressed: (){
                         print('test');
                       },
                       color: Colors.white,
                     ),
                     IconButton(
                       icon: Icon(Icons.data_usage),
                       onPressed: (){
                         print('test');
                       },
                       color: Colors.white,
                     ),
                     IconButton(
                       icon: Icon(Icons.fast_rewind),
                       onPressed: (){
                         print('test');
                       },
                       color: Colors.white,
                     ),
                     IconButton(
                       icon: Icon(Icons.get_app),
                       onPressed: (){
                         print('test');
                       },
                       color: Colors.white,
                     ),
                   ],
                 ),
               ),
           ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          print('floating');
          changerOui();
        },
        elevation: 8,
        tooltip: 'Changer Oui',
        child: Icon(Icons.add),
        backgroundColor: Colors.teal,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void changerOui() {
    setState(() {
      oui = !oui;
    });
  }
}