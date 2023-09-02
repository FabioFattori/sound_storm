import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
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
    PlatformFile Audio, PlatformFile Image, String Titolo) async {
    File file = File(Audio.path!);
    File Imagefile = File(Image.path!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadAudio.php?Titolo=$Titolo'),
    );

    var mimeType = lookupMimeType(file.path);
    var ImageType = lookupMimeType(Imagefile.path);

    if (mimeType == 'audio/mpeg' || mimeType == 'audio/mp3') {
      var multipartFile = http.MultipartFile(
        'Audio',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        //get the name of the file
        filename: Audio.name,
        contentType: MediaType.parse(mimeType!),
      );

      var ImageToSend = http.MultipartFile(
        'Image',
        File(Imagefile.path!).readAsBytes().asStream(),
        File(Imagefile.path!).lengthSync(),
        //get the name of the file
        filename: Image.name,
        contentType: MediaType.parse(ImageType!),
      );

      request.files.add(multipartFile);
      request.files.add(ImageToSend);

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
