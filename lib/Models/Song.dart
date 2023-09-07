// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';

class Song {
  String baseUrl = "https://understated-throttl.000webhostapp.com/";

  String localUrl = "http://192.168.77.1/AudioSaver/";
  String title;
  String urlToMp3;
  String urlToImage;
  late File? image = null;
  late AudioSource? urlToMp3Local=null;

  Song(
      {required this.title, required this.urlToMp3, required this.urlToImage}) {
    if (title == "" && urlToMp3 == "" && urlToImage == "") {
      image = null;
    } else {
      getImageFile();
    }
  }

  factory Song.noSong() {
    return Song(title: "", urlToMp3: "", urlToImage: "");
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        title: json['title'], urlToMp3: json['song'], urlToImage: json['img']);
  }

  Future<AudioSource> getMp3File() async {
    if (urlToMp3Local == null) {
      String url = '$baseUrl$urlToMp3';
      final audioSource = LockCachingAudioSource(Uri.parse(url));
      
      urlToMp3Local = audioSource;
      return audioSource;
    } else {
      return urlToMp3Local!;
    }
  }

  getImageFile() async {
    if (image == null) {
      String url = '$baseUrl$urlToImage';
      final file = await DefaultCacheManager().getSingleFile(url);
      image = file;

      return file;
    } else {
      return image;
    }
  }
}
