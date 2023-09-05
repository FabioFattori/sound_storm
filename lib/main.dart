import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';
import 'package:sound_storm/RouteGenerator.dart';
import 'package:sound_storm/Screens/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  var player;
  List<Song> songs = [];
  bool isPlaying = false;
  Song currentSong = Song.noSong();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void playSong(UrlSource url) async {
    await widget.player.play(url);

    setState(() {
      widget.isPlaying = true;
    });
  }

  void setSong(Song song) {
    setState(() {
      widget.currentSong = song;
    });
  }

  void resumeSong() async {
    await widget.player.resume();
    setState(() {
      widget.isPlaying = true;
    });
  }

  void pauseSong() async {
    await widget.player.pause();
    setState(() {
      widget.isPlaying = false;
    });
  }

  Future<Duration?> getDuration(UrlSource url) async {
    return widget.player.getDuration();
  }

  void getSongs() async {
    dynamic appoggio = await Connector.getSongList();
    setState(() {
      widget.songs = appoggio;
    });
  }

  @override
  void initState() {
    super.initState();
    getSongs();
    widget.player = AudioPlayer();
    
    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Storm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Home(
        playSong: (value) => playSong(value),
        pauseSong: () => pauseSong(),
        resumeSong: () => resumeSong(),
        isPlaying: widget.isPlaying,
        setSong: (value) => setSong(value),
        currentSong: widget.currentSong,
        songs: widget.songs,
        getDuration: (value) => getDuration(value),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
