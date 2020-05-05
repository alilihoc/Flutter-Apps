import 'package:flutter/material.dart';

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
      child: new Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: setColor() ,
        ),
        body: new SingleChildScrollView(
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
                        new Switch(
                            value: genre,
                            inactiveTrackColor: Colors.pink,
                            activeTrackColor: Colors.blue,
                            onChanged: (bool b){
                              setState(() {
                                genre = b;
                              });
                            }),
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
                    new Slider(
                        value: taille,
                        activeColor: setColor(),
                        onChanged: (double d){
                          setState(() {
                            taille = d;
                          });
                        },
                      max: 215.0,
                      min: 100.0,
                    ),
                    padding(),
                    new TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (String value) {
                        setState(() {
                          poids = double.tryParse(value);
                        });
                      },
                      decoration: new InputDecoration(
                        labelText: "Entrez votre poids en Kilos."
                      ),
                    ),
                    padding(),
                    texteAvecStyle("Quelle est votre activité sportive ?", color: setColor()),
                    padding(),
                    rowRadio(),
                    padding(),
                  ],
                ),
              ),
              padding(),
              new RaisedButton(
                color: setColor(),
                child: texteAvecStyle("Calculer", color: Colors.white),
                  onPressed: calculerNombreDeCalories)
            ],
          ),
        ),
      ),
    ) ;

  }

  Padding padding(){
    return  new Padding(padding: EdgeInsets.only(top: 20.0));
  }

  //Affiche datePicker. En mode Futur Async car le composant n'est peut être pas pret coté Device
  //Un Await pour forcer à attendre le choix de la date pour faire le reste
  Future<Null> montrerPicker() async {
    DateTime choix = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime.now(),
      initialDatePickerMode: DatePickerMode.year
    );

    //Grace au await précédent, tant que je n'ai pas choisi une date ici ça ne se lancera pas
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
    //Genre est à true alors homme sinon femme
    if(genre) {
      return Colors.blue;
    }else{
      return  Colors.pink;
    }
  }

  //Fonction pour générer un champ Text plus facilement
  Text texteAvecStyle(String data, {color: Colors.black, fontSize: 15.0}){
    return new Text(
      data,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: color,
        fontSize: fontSize
      ),
    );

  }

  Row rowRadio(){
    //On pourrait faire la liste à la main mais on va utiliser une boucle
    List<Widget> l = [] ;

    //Je créer plusieurs colonne dans ma ROW
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
    //Vérification des champs
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
              texteAvecStyle("Votre besoin avec activité sportive est de  : ${calorieAvecActivite}"),
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
    );
  }
}
