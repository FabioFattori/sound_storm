// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/Song.dart';
import 'package:sound_storm/Screens/AddSongToPlaylist.dart';
import 'package:sound_storm/Screens/CreatePlaylist.dart';
import 'package:sound_storm/Screens/Favorite.dart';
import 'package:sound_storm/Screens/Home.dart';
import 'package:sound_storm/Screens/PlaylistScreen.dart';
import 'package:sound_storm/Screens/SinglePlaylist.dart';
import 'package:sound_storm/Screens/Upload.dart';
import 'Models/argsToPass.dart';

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
        return MaterialPageRoute(
            builder: (_) => Home(
                  playSong: () => {print("play")},
                  pauseSong: () => {print("pause")},
                  resumeSong: () => {print("resume")},
                  isPlaying: false,
                  setSong: (song) => {print("song to set ${song.title}")},
                  plaPlaylist: () => print("playPlaylist"),
                  currentSong: Song.noSong(),
                  getDuration: () => {print("get duration")},
                  setDurationSong: () => print("set duration"),
                  songs: [],
                  player: AudioPlayer(),
                ));

      case '/Upload':
        return MaterialPageRoute(builder: (_) => Upload());
      case '/Playlist':
        return MaterialPageRoute(
            builder: (_) => PlaylistScreen(
                  playPlaylist:
                      args is Function ? args : () => print("no method"),
                ));
      case '/SinglePlaylist':
        if (args is argsToPass) {
          return MaterialPageRoute(
              builder: (_) => SinglePlaylist(
                    playPlaylist: args.arg2,
                    playlist: args.arg1,
                  ));
        }
        return _errorRoute();
      case '/AddSongToPlaylist':
        return MaterialPageRoute(
            builder: (_) => AddSongToPlaylist(
                playlist: args is Playlist ? args : Playlist.noPlaylist()));
      case '/CreatePlaylist':
        return MaterialPageRoute(builder: (_) => CreatePlaylist());

      case '/Favourite':
        try{
          return MaterialPageRoute(
            builder: (_) => Favourite(
              playPlaylist: args is Function ? args : ()=>{print("no method")},
            ),
          );
        
        }catch(e){
          print(e);
          return _errorRoute();
        }


      default:
        return _errorRoute();
    }
  }
}
