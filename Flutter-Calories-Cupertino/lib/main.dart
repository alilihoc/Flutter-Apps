import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Calculateur de Calories'),
      debugShowCheckedModeBanner: false,
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


  double poids;
  bool genre = false;
  double age;
  double taille = 170.0;
  int radioSelectionnee;
  Map mapActivite = {
    0: "Faible",
    1: "Modere",
    2: "Forte"
  };

  int calorieBase;
  int calorieAvecActivite;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (()=> FocusScope.of(context).requestFocus(new FocusNode())),
      child: (Platform.isAndroid)
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              backgroundColor: setColor(),
              middle: texteAvecStyle(widget.title),
            ),
        child: body(),
          )
        : new Scaffold(
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: setColor() ,
          ),
          body: body()
      ),

    ) ;

  }

  Widget body(){
    return new SingleChildScrollView(
      padding: EdgeInsets.all(15.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          padding(),
          texteAvecStyle("Remplissez tous les champs pour obtenir votre besoin journalier en calories"),
          padding(),
          new Card(
            elevation: 10.0,
            child: new Column(
              children: <Widget>[
                padding(),
                new Row (
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    texteAvecStyle("Femme", color: Colors.pink),
                    switchSelonPlateforme(),
                    texteAvecStyle("Homme", color: Colors.blue)
                  ],
                ),
                padding(),
                new RaisedButton(
                    color: setColor(),
                    child: texteAvecStyle((age == null)? "Appuyez pour entrer un ": "Votre age est de : ${age.toInt()} ans",
                        color: Colors.white
                    ),
                    onPressed: (){
                      montrerPicker();
                    }
                ),
                padding(),
                texteAvecStyle("Votre taille est de : ${taille.toInt()} cm.", color: setColor()),
                padding(),
                sliderSelonPlateforme(),
                padding(),
                textFieldSelonPlateforme(),
                padding(),
                texteAvecStyle("Quelle est votre activit� sportive ?", color: setColor()),
                padding(),
                rowRadio(),
                padding(),
              ],
            ),
          ),
          padding(),
         calcButton()
        ],
      ),
    );
  }

  Padding padding(){
    return  new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  //Affiche datePicker. En mode Futur Async car le composant n'est peut �tre pas pret cot� Device
  //Un Await pour forcer � attendre le choix de la date pour faire le reste
  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
        initialDatePickerMode: DatePickerMode.year
    );

    //Grace au await pr�c�dent, tant que je n'ai pas choisi une date ici �a ne se lancera pas
    if(choix != null){
      var difference = new DateTime.now().difference(choix);
      var jours = difference.inDays;
      var ans = (jours / 365);
      setState(() {
        age = ans;
      });
    }
  }

  Color setColor(){
    //Genre est � true alors homme sinon femme
    if(genre) {
      return Colors.blue;
    }else{
      return  Colors.pink;
    }
  }

  Widget switchSelonPlateforme(){
    if(Platform.isAndroid){
      return CupertinoSwitch(
        value: genre,
        activeColor: Colors.blue,
        onChanged: (bool b){
          setState(() {
            genre = b;
          });
        },
      );
    }else{
      return new Switch(
          value: genre,
          inactiveTrackColor: Colors.pink,
          activeTrackColor: Colors.blue,
          onChanged: (bool b){
            setState(() {
              genre = b;
            });
          });
    }
  }

  Widget sliderSelonPlateforme(){
    if(Platform.isAndroid){
      return CupertinoSlider(
        value: taille,
        activeColor: setColor(),
        onChanged: (double d){
          setState(() {
            taille = d;
          });
        },
        min: 100,
        max: 215
      );
    }else{
      return new Slider(
        value: taille,
        activeColor: setColor(),
        onChanged: (double d){
          setState(() {
            taille = d;
          });
        },
        max: 215.0,
        min: 100.0,
      );
    }
  }

  Widget calcButton(){
    if(Platform.isAndroid) {
      return CupertinoButton(
        color: setColor(),
        child: texteAvecStyle("Calculer", color: Colors.white),
          onPressed: calculerNombreDeCalories
      );
    }else{
      return new RaisedButton(
          color: setColor(),
          child: texteAvecStyle("Calculer", color: Colors.white),
          onPressed: calculerNombreDeCalories);
    }

  }

  //Fonction pour g�n�rer un champ Text plus facilement
  Widget texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}){
    if(Platform.isAndroid){
      return new DefaultTextStyle(
          style: TextStyle(
            color: color,
            fontSize: fontSize
          ),
          child: Text(
            data,
            textAlign: TextAlign.center,
          )
      );
    }else{
      return new Text(
        data,
        textAlign: TextAlign.center,
        style: new TextStyle(
            color: color,
            fontSize: fontSize
        ),
      );
    }
  }

  Row rowRadio(){
    //On pourrait faire la liste � la main mais on va utiliser une boucle
    List<Widget> l = [] ;

    //Je cr�er plusieurs colonne dans ma ROW
    mapActivite.forEach((key,value){
      Column colonne = new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Radio(
              activeColor: setColor(),
              value: key,
              groupValue: radioSelectionnee,
              onChanged: (Object i){
                setState(() {
                  radioSelectionnee = i;
                });
              }),
          texteAvecStyle(value, color: setColor())
        ],
      );
      l.add(colonne);
    });


    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: l, // Contient la liste des Colonnes de la boucle ci dessus
    );
  }

  void calculerNombreDeCalories(){
    //V�rification des champs
    if(age != null && poids != null && radioSelectionnee != null){
      if(genre){
        calorieBase = (66.4730 + (13.7516 * poids) + (5.0033 * taille) - (6.7550 * age)).toInt();
      }else{
        calorieBase = (655.0955 + (9.5634 * poids) + (1.8496 * taille) - (4.6756 * age)).toInt();
      }
      switch(radioSelectionnee){
        case 0:
          calorieAvecActivite = (calorieBase * 1.2).toInt();
          break;
        case 1:
          calorieAvecActivite = (calorieBase * 1.5).toInt();
          break;
        case 2:
          calorieAvecActivite = (calorieBase * 1.8).toInt();
          break;
        default:
          calorieAvecActivite = calorieBase;
          break;
      }
      setState(() {
        dialogue();
      });
    }else{
      //Alerte erreur
      alerte();
    }
  }

  // Fonction qui affiche la boite de dialogue finale
  Future<Null> dialogue() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          return SimpleDialog(
            title: texteAvecStyle("Votre besoin en calories", color: setColor()),
            contentPadding: EdgeInsets.all(15.0),
            children: <Widget>[
              padding(),
              texteAvecStyle("Votre besoin de base est de : ${calorieBase}"),
              padding(),
              texteAvecStyle("Votre besoin avec activit� sportive est de  : ${calorieAvecActivite}"),
              new RaisedButton(
                onPressed: (){
                  Navigator.pop(buildContext);
                },
                child: texteAvecStyle("OK", color: Colors.white),
                color: setColor(),
              )
            ],
          );
        }
    );
  }

  // Fonction qui affiche la boite de dialogue erreur
  Future<Null> alerte() async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          if(Platform.isAndroid){
            return CupertinoAlertDialog(
              title: texteAvecStyle("Erreur"),
              content: texteAvecStyle("Tous les champs ne sont pas remplis"),
              actions: <Widget>[
                CupertinoButton(
                  color: Colors.white,
                  onPressed: (){
                    Navigator.pop(buildContext);
                  },
                  child: texteAvecStyle("OK", color: Colors.red),
                )
              ],
            );
          }else{
            return new AlertDialog(
              title: texteAvecStyle("Erreur"),
              content: texteAvecStyle("Tous les champs ne sont pas remplis"),
              actions: <Widget>[
                new FlatButton(
                    onPressed: (){
                      Navigator.pop(buildContext);
                    },
                    child: texteAvecStyle("OK", color: Colors.red))
              ],
            );
          }
        }
    );
  }


  Widget textFieldSelonPlateforme(){
      if(Platform.isAndroid){
        return CupertinoTextField(
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              poids = double.tryParse(value);
            });
          },
          placeholder: "Entrez votre poids en Kilos.",
        );
      }else{
        return new TextField(
          keyboardType: TextInputType.number,
          onChanged: (String value) {
            setState(() {
              poids = double.tryParse(value);
            });
          },
          decoration: new InputDecoration(
              labelText: "Entrez votre poids en Kilos."
          ),
        );
      }
  }




}