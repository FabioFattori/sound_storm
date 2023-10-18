// ignore_for_file: file_names

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class Song {
  String baseUrl = "https://understated-throttl.000webhostapp.com/";
  int id;
  String localUrl = "http://192.168.77.1/AudioSaver/";
  String title;
  String urlToMp3;
  String urlToImage;
  bool isLiked;
  late File? image = null;
  late AudioSource? urlToMp3Local = null;

  Song(
      {required this.title,
      required this.urlToMp3,
      required this.urlToImage,
      required this.id,required this.isLiked}) {
    if (title == "" && urlToMp3 == "" && urlToImage == "") {
      image = null;
    } else {
      getImageFile();
    }
  }

  factory Song.noSong() {
    return Song(title: "", urlToMp3: "", urlToImage: "", id: -1,isLiked: false);
  }

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        id: json['id'],
        title: json['Titolo'],
        urlToMp3: json['urlToMp3'],
        urlToImage: json['urlToImage'],isLiked: json['liked'] == 1 ? true : false);
  }

  factory Song.fromStrangeJson(Map<String, dynamic> json) {
    return Song(
        title: json['title'],
        urlToMp3: json['song'],
        urlToImage: json['img'],
        id: json['id'],
        isLiked: json['liked'] == 1 ? true : false);
  }

  String getUrlToImage(){
    return '$baseUrl$urlToImage';
  }

  String getUrlToMp3(){
    return '$baseUrl$urlToMp3';
  }

  Future<AudioSource> getMp3FileWithPlaylist(String playlist) async {
    if (urlToMp3Local == null) {
      String url = '$baseUrl$urlToMp3';
      final audioSource = LockCachingAudioSource(Uri.parse(url),
          tag: MediaItem(
              id: '1',
              title: title,
              album: playlist,
              artUri: Uri.parse((await getImageFile()).path)));

      urlToMp3Local = audioSource;
      return audioSource;
    } else {
      return urlToMp3Local!;
    }
  }

  Future<AudioSource> getMp3File() async {
    if (urlToMp3Local == null) {
      String url = '$baseUrl$urlToMp3';
      Uri uri = Uri.parse('$baseUrl$urlToImage');
      if(kIsWeb){
        urlToMp3Local = AudioSource.uri(Uri.parse(url),
            tag: MediaItem(id: '1', title: title, artUri: uri));
        return urlToMp3Local!;
      }

      final audioSource = LockCachingAudioSource(Uri.parse(url),
          tag: MediaItem(id: '1', title: title, artUri: uri));
      urlToMp3Local = audioSource;
      return audioSource;
    } else {
      return urlToMp3Local!;
    }
  }

  Future<AudioSource> getMp3FileWithAlbum(String album) async {
    if (urlToMp3Local == null) {
      String url = '$baseUrl$urlToMp3';
      Uri uri = Uri.parse('$baseUrl$urlToImage');

      if(kIsWeb){
        urlToMp3Local = AudioSource.uri(Uri.parse(url),
            tag: MediaItem(id: '1', title: title, artUri: uri));
        return urlToMp3Local!;
      }

      final audioSource = LockCachingAudioSource(Uri.parse(url),
          tag: MediaItem(id: '1', title: title, album: album, artUri: uri));

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


  @override
  String toString() {
    return "Song: $title";
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'Titolo': title,
        'urlToMp3': urlToMp3,
        'urlToImage': urlToImage,
        'liked': isLiked ? 1 : 0
      };
  getObject() {
    return toJson();
  }
}
