import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';

class Playlist {
  late int id;
  late List<Song> songs;
  late String titolo;
  File? image;

  Playlist({required this.songs, required this.titolo, required this.id}) {
    image = null;
    //getImage(); after 10 seconds
    Future.delayed(new Duration(seconds: 2), () {
      getImage();
    });
  }

  Playlist.noPlaylist() {
    id = -1;
    songs = [];
    titolo = "";
    image = null;
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<dynamic> ids = jsonDecode(json['Songs_id']);
    List<Song> songs = [];

    for (dynamic id in ids) {
      Connector.getSongFromId(id).then((value) => songs.add(value));
    }

    return Playlist(
      id: json['id'],
      songs: songs,
      titolo: json['Titolo'],
    );
  }

  String getTitolo() {
    return titolo;
  }

  getImage() {
    if (songs.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(songs.length);

      image = songs[index].image;
    }
    return image;
  }

  getImageWeb() {
    if (songs.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(songs.length);

      return songs[index].getUrlToImage();
    }
  }

  List<Song> getSongs() {
    return songs;
  }
}
