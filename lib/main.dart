import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sound_storm/Components/BottomBar.dart';
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
  late var duration=const Duration(seconds: 200);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  void playSong(AudioSource risorsaAudio) async {
    
    dynamic appoggio=await widget.player.setAudioSource(risorsaAudio);
    await widget.player.play();
    
    setState(() {
      widget.duration=appoggio;
      widget.isPlaying = true;
    });
  }

  void setSong(Song song) {
    setState(() {
      widget.currentSong = song;
    });
  }

  void setTimeSong(Duration duration) async {
    await widget.player.seek(duration);
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

  Future<Duration?> getDuration(String url) async {
    return widget.duration;
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
        setDurationSong: (value) => setTimeSong(value),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
