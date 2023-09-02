import 'dart:io';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Song {
  String baseUrl = "https://understated-throttl.000webhostapp.com";

  String localUrl = "http://192.168.77.1/AudioSaver/";
  String title;
  String urlToMp3;
  String urlToImage;

  Song({required this.title, required this.urlToMp3, required this.urlToImage});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
        title: json['title'], urlToMp3: json['song'], urlToImage: json['img']);
  }

  Future<File> getMp3File()async {
    String url = '$localUrl$urlToMp3';
    final file = await DefaultCacheManager().getSingleFile(url);

    return file;
  }

   getImageFile() async {
    String url = '$localUrl$urlToImage';
    final file = await DefaultCacheManager().getSingleFile(url);

    return file;
  }
}
