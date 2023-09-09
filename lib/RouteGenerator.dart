// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Song.dart';
import 'package:sound_storm/Screens/Home.dart';
import 'package:sound_storm/Screens/PlaylistScreen.dart';
import 'package:sound_storm/Screens/Upload.dart';

class RouteGenerator {
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // ignore: unused_local_variable
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        
          return MaterialPageRoute(builder: (_) => Home(playSong: ()=>{
            print("play")
          },pauseSong: ()=>{
            print("pause")
          },resumeSong: ()=>{
            print("resume")
          },isPlaying: false,
          setSong: (song)=>{
            print("song to set ${song.title}")
          },currentSong: Song.noSong(),getDuration: ()=>{print("get duration")},setDurationSong: ()=>print("set duration"),songs: [],));
        


      case '/Upload':
        return MaterialPageRoute(builder: (_) => Upload());
      case '/Playlist':
        return MaterialPageRoute(builder: (_) => PlaylistScreen());


     

      default:
        return _errorRoute();
    }
  }
}