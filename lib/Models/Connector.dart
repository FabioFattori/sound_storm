// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/Song.dart';

String baseUrl = "https://understated-throttl.000webhostapp.com";

String localUrl = "http://192.168.77.1/AudioSaver";

class Connector {
  static Future<List<Song>> getSongList() async {
    try {
      var response = await http.get(
          Uri.parse(
            '$baseUrl/getFiles.php',
          ),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Song> songs = [];
        for (var element in json) {
          songs.add(Song.fromStrangeJson(element));
        }
        return songs;
      } else {
        return [];
      }
    } catch (e) {
      print(e);
      getSongList();
      return [];
    }
  }

  static Future<String?> uploadFile(
      PlatformFile audio, PlatformFile? image, String titolo) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        '$baseUrl/uploadAudio.php?Titolo=$titolo',
      ),
    );

    request.headers.addAll({
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });

    if (image != null) {
      File imageFile = File(image!.path!);
      var imageType = lookupMimeType(imageFile.path);

      var imageToSend = http.MultipartFile(
        'Image',
        File(imageFile.path).readAsBytes().asStream(),
        File(imageFile.path).lengthSync(),
        //get the name of the file
        filename: image.name,
        contentType: MediaType.parse(imageType!),
      );

      request.files.add(imageToSend);
    }

    File file = File(audio.path!);

    var mimeType = lookupMimeType(file.path);

    if (mimeType == 'audio/mpeg' || mimeType == 'audio/mp3') {
      var multipartFile = http.MultipartFile(
        'Audio',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        //get the name of the file
        filename: audio.name,
        contentType: MediaType.parse(mimeType!),
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return 'Errore di connessione , controlla la connessione e riprova';
      }
    }

    return "error";
  }

  static Future<Song> getSongFromId(int id) async {
    try {
      var response = await http.get(
          Uri.parse(
            '$baseUrl/getSongFromID.php?id=$id',
          ),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return Song.fromJson(json);
      } else {
        return Song.noSong();
      }
    } catch (e) {
      print(e);
      return Song.noSong();
    }
  }

  static Future<List<Playlist>> getPlaylists() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/getPlaylist.php'), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Playlist> playlists = [];
        for (var element in json) {
          print(element);
          playlists.add(Playlist.fromJson(element));
        }
        return playlists;
      } else {
        print("porcodio");
        return [];
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  static Future<int> addSongToPlaylist(List<int> toAdd, int idPlaylist) async {
    try {
      var response = await http.post(
          Uri.parse(
              '$baseUrl/AddSongToPlaylist.php?toAdd=${toAdd.toString()}&idPlaylist=${idPlaylist.toString()}'),
          headers: {
            "Access-Control-Allow-Origin": "*",
            'Content-Type': 'application/json',
            'Accept': '*/*'
          });
      if (response.statusCode == 200) {
        return 0;
      } else {
        return response.statusCode;
      }
    } catch (e) {
      print(e);
      return 2;
    }
  }

  static Future<Playlist> createPlaylist(String name) async {
    try {
      var response = await http
          .post(Uri.parse('$baseUrl/CreatePlaylist.php?name=$name'), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        return Playlist.fromJson(json);
      } else {
        return Playlist.noPlaylist();
      }
    } catch (e) {
      print(e);
      return Playlist.noPlaylist();
    }
  }

  static Future<Playlist> getFavoritesSongs() async {
    try {
      var response =
          await http.get(Uri.parse('$baseUrl/getFavoritesSongs.php'), headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Accept': '*/*'
      });
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);
        List<Song> favoritesSongs = List<Song>.empty(growable: true);

        for (var element in json) {
          favoritesSongs.add(Song.fromJson(element));
        }

        Playlist toRet =
            Playlist(songs: favoritesSongs, titolo: "Liked Songs", id: 0);

        return toRet;
      } else {
        return Playlist.noPlaylist();
      }
    } catch (e) {
      print(e);
      return Playlist.noPlaylist();
    }
  }

  static void changeFavoriteListFromId(int id) {
    http.post(Uri.parse('$baseUrl/changeFavoriteListFromId.php?id=$id'),
        headers: {
          "Access-Control-Allow-Origin": "*",
          'Content-Type': 'application/json',
          'Accept': '*/*'
        });
  }

  static void deletePlaylist(int id) {
    http.post(Uri.parse('$baseUrl/deletePlaylist.php?id=$id'), headers: {
      "Access-Control-Allow-Origin": "*",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    });
  }
}
