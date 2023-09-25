import 'dart:convert';
import 'dart:math';

import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';

class Playlist {
  late List<Song> songs;
  late String titolo;
  late String image;

  Playlist({required this.songs, required this.titolo}) {
    if (songs.isNotEmpty) {
      image = songs[0].urlToImage;
    } else {
      image = "";
    }
  }

  Playlist.noPlaylist() {
    songs = [];
    titolo = "";
    image = "";
  }

  factory Playlist.fromJson(Map<String, dynamic> json) {
    List<dynamic> ids = jsonDecode(json['Songs_id']);
    List<Song> songs = [];

    for (dynamic id in ids) {
      Connector.getSongFromId(id).then((value) => songs.add(value));
    }

    return Playlist(
      songs: songs,
      titolo: json['Titolo'],
    );
  }

  String getTitolo() {
    return titolo;
  }

  String getImage() {
    return image;
  }

  List<Song> getSongs() {
    return songs;
  }
}
