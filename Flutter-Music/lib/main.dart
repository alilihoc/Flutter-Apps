import 'dart:async';

import 'package:flutter/material.dart';
import 'musique.dart';
import 'package:audioplayer/audioplayer.dart';

void main(){
  runApp(new MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Coda Music',
      theme: new ThemeData(
        primarySwatch: Colors.blue //ici il faut des couleurs primaires
      ),
      home: new MyHomePage(title: 'Coda Music'),
      debugShowCheckedModeBanner: false,
    );
  }

}

class MyHomePage extends StatefulWidget {
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new _MyHomePageState();
  }

}

class _MyHomePageState extends State<MyHomePage>{
  List<Musique> maListeDeMusiques = [
    new Musique('Theme Swift', 'Fabien', 'assets/corbeau.jpg', 'https://codabee.com/wp-content/uploads/2018/06/un.mp3'),
    new Musique('Theme Flutter', 'Fabien', 'assets/magicien.jpg', 'https://codabee.com/wp-content/uploads/2018/06/deux.mp3'),
  ];

  AudioPlayer audioPlayer;
  StreamSubscription positionSub; // Nécessite classe dart:async. Subscripion de la position
  StreamSubscription stateSubscription;
  Musique maMusiqueActuelle;
  Duration position = new Duration(seconds: 0);
  Duration duree = new Duration(seconds: 10); // durée de la musique
  PlayerState statut = PlayerState.stopped; // mon énum
  int index = 0;
  // On surcharge l'initial State, au démarrage on veut que la musique à écouter soit celle de l'index "0"
  // Attention le HotReload ne passe pas par l'initState il faudra recharger totalement
  @override
  void initState(){
    super.initState();
    maMusiqueActuelle = maListeDeMusiques[index];
    configurationAudioPlayer();
  }
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title),
        backgroundColor: Colors.grey[900],
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new Card(
              elevation: 9.0,
              child: new Container(
                //pas direcement une image. On passe par container pour avoir une taille fixe
                width: MediaQuery.of(context).size.width / 2.5, //image un petit peu moins de la moitié
                child: new Image.asset(maMusiqueActuelle.imagePath),
              ),
            ),
            textAvecStyle(maMusiqueActuelle.titre, 1.5),
            textAvecStyle(maMusiqueActuelle.artiste, 1.0),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                bouton(Icons.fast_rewind, 30.0, ActionMusic.rewind),
                bouton((statut == PlayerState.playing) ? Icons.pause: Icons.play_arrow, 45.0, (statut == PlayerState.playing) ? ActionMusic.pause: ActionMusic.play),
                bouton(Icons.fast_forward, 30.0, ActionMusic.forward),
              ],
            ),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                textAvecStyle(fromDuration(position), 0.8),
                textAvecStyle(fromDuration(duree), 0.8),
              ],
            ),
            new Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duree.inSeconds.toDouble(), // La durée max du slider doit correspondre
                inactiveColor: Colors.white,
                activeColor: Colors.blueAccent,
                onChanged: (double d) {
                  setState(() {
                    audioPlayer.seek(d); // comme on est mappé à l'audio player plus besoin de mettre à jour le slider
                  });
                }
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[800],
    );
  }

  // dans la classe, création d'une fonction qui retourne un IconButton
  IconButton bouton(IconData icone, double taille, ActionMusic action){
    return new IconButton(
      iconSize: taille,
        color: Colors.white,
        icon: new Icon(icone),
        onPressed: (){
          switch (action){
            case ActionMusic.play:
              play();
              break;
            case ActionMusic.pause:
              pause();
              break;
            case ActionMusic.rewind:
              rewind();
              break;
            case ActionMusic.forward:
              forward();
              break;
          }
        }
    );
  }

  // une fonction qui se charge de retourner un type Text dans laquelle on met juste du texte et une tille
  Text textAvecStyle(String data, double scale){
    return new Text (
      data,
      textScaleFactor: scale,
      textAlign: TextAlign.center,
      style: new TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontStyle: FontStyle.italic
      )
    );
  }

  void configurationAudioPlayer(){
    audioPlayer = new AudioPlayer();
    positionSub = audioPlayer.onAudioPositionChanged.listen(
        (pos) => setState(() => position = pos)
    );
    stateSubscription = audioPlayer.onPlayerStateChanged.listen((state){
      if(state == AudioPlayerState.PLAYING){
        setState(() {
          duree = audioPlayer.duration;
        });
      }else if (state == AudioPlayerState.STOPPED){
        statut = PlayerState.stopped;
      }
    },onError: (message){
      print('Erreur : $message');
      setState(() {
        statut = PlayerState.stopped;
        duree = new Duration(seconds: 0);
        position = new Duration(seconds: 0);
      });
    }
    );
  }

  Future play() async {
    await audioPlayer.play(maMusiqueActuelle.urlSong);
    setState(() {
      statut = PlayerState.playing;
    });
  }

  Future pause() async {
    await audioPlayer.pause();
    setState(() {
      statut = PlayerState.paused;
    });
  }

  void forward() {
    if(index == maListeDeMusiques.length -1){
      //Si c'est la dernière musique de la liste on retourne au début
      index = 0;
    }else{
      index = index +1;
    }
    maMusiqueActuelle = maListeDeMusiques[index];
    audioPlayer.stop(); //J'arrête mon audio Player
    configurationAudioPlayer(); // Je le reconfigure
    play(); // Je joue la musique
  }

  void rewind(){
    if(position > Duration(seconds: 3)){
      // si on a joué plus de 3 secondes de musique alors retour au début de la musique
      audioPlayer.seek(0.0);
    }else{
      if(index == 0){
        // si j'étais sur la première musique de la liste, je m'en vais à la dernière
        index = maListeDeMusiques.length -1;
      }else{
        index = index - 1;
      }
      maMusiqueActuelle = maListeDeMusiques[index];
      audioPlayer.stop(); //J'arrête mon audio Player
      configurationAudioPlayer(); // Je le reconfigure
      play(); // Je joue la musique
    }
  }

  String fromDuration(Duration duree){
    return duree.toString().split('.').first;
  }
}
//En dehors de toute classe, création d'un énumérateur (liste de possibilité des boutons)
enum ActionMusic {
  play,
  pause,
  rewind,
  forward
}

//En dehors de toute classe,énum du player (liste de possibilité du player)
enum PlayerState {
  playing,
  stopped,
  paused
}