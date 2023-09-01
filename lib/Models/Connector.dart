import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

String baseUrl = "https://understated-throttl.000webhostapp.com";

class Connector {
  static Future<String?> uploadFile(PlatformFile platformFile) async {
    File file = File(platformFile.path!);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/uploadAudio.php'),
    );

    var mimeType = lookupMimeType(file.path);

    if (mimeType == 'audio/mpeg' || mimeType == 'audio/mp3') {
      var multipartFile = http.MultipartFile(
        'file',
        File(file.path).readAsBytes().asStream(),
        File(file.path).lengthSync(),
        //get the name of the file
        filename: platformFile.name,
        contentType: MediaType.parse(mimeType!),
      );

      request.files.add(multipartFile);

      var response = await request.send();

      if (response.statusCode == 200) {
        return await response.stream.bytesToString();
      } else {
        return'Errore di connessione , controlla la connessione e riprova';
      }
    } 
  }


}
