import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';

class Playlist {
  late int id;
  late List<Song> songs;
  late String titolo;
  late File? image;

  Playlist({required this.songs, required this.titolo, required this.id}) {
    
      image = null;
    

    
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

  getImage() async {
    if (songs.isNotEmpty) {
      Random random = Random();
      int index = random.nextInt(songs.length);
      image = await songs[index].getImageFile();
    }
    return image;
  }

  List<Song> getSongs() {
    return songs;
  }
}
