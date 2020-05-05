import 'package:flutter/material.dart';
import 'package:navigation/nouvelle_page.dart';

class Body extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _BodyState();
  }
}

class _BodyState extends State<Body> {

  @override
  Widget build(BuildContext context) {
    return(
      Center(
        child: RaisedButton(
          color: Colors.teal,
          textColor: Colors.white,
          child: Text(
            "Appuyez moi",
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontSize: 20
            ),
          ),
          onPressed: (){
            versNouvellePage();

          },
        ),
      )
    );
  }

  // Accès à la nouvelle page
  void versNouvellePage(){
    Navigator.push(
        context,
        MaterialPageRoute (
            builder: (BuildContext context) {
    return NouvellePage("La seconde page");
    }
        )
    );
  }


  //AlertDialog
  Future<Null> alerte() async{
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Ceci est une alert", textScaleFactor: 1.5,),
          content: Text("Nous avons un problème"),
          contentPadding: EdgeInsets.all(5),
          actions: <Widget>[
            FlatButton(
              child: Text("Annuler", style: TextStyle(color: Colors.red),),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text("Continuer", style: TextStyle(color: Colors.blue),),
              onPressed: (){
                print("Code qui exécute");
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );

  }


  // SnackBar
  void snack() {
    SnackBar snackbar = new SnackBar(
      content: Text("Je suis un SnackBar"),
      duration: Duration(microseconds: 500),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

}