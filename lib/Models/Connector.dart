
// ignore_for_file: file_names

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:sound_storm/Models/Song.dart';

String baseUrl = "https://understated-throttl.000webhostapp.com";

String localUrl = "http://192.168.77.1/AudioSaver";

class Connector {
  static Future<List<Song>> getSongList() async {
    var response = await http.get(Uri.parse('$baseUrl/getFiles.php'));
    if (response.statusCode == 200) {
      var json = jsonDecode(response.body);
      List<Song> songs = [];
      for (var element in json) {
        songs.add(Song.fromJson(element));
      }
      return songs;
    } else {
      return [];
    }
  }

  static Future<String?> uploadFile(
    PlatformFile audio, PlatformFile? image, String titolo) async {
      var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadAudio.php?Titolo=$titolo'),
    );

    
    if(image!=null){
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
    }else{
      request.files.add(http.MultipartFile.fromString('Image',
        ''
      
      ));
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
}
