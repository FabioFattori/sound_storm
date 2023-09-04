// ignore_for_file: file_names

import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Song {
  String baseUrl = "https://understated-throttl.000webhostapp.com/";

  String localUrl = "http://192.168.77.1/AudioSaver/";
  String title;
  String urlToMp3;
  String urlToImage;
  late File? image;

  Song({required this.title, required this.urlToMp3, required this.urlToImage}){
    if(title==""&&urlToMp3==""&&urlToImage==""){
      image=null;
    }else{
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

  Future<String> getMp3File() async {
    String url = '$baseUrl$urlToMp3';
    final file = await DefaultCacheManager().getSingleFile(url);

    return file.path;
  }

  getImageFile() async {
    String url = '$baseUrl$urlToImage';
    final file = await DefaultCacheManager().getSingleFile(url);
    image = file;

    return file;
  }
}
