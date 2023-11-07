import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sound_storm/Models/Song.dart';

class ImageFromPhp extends StatelessWidget {
  ImageFromPhp({super.key, required this.song});
  final Song song;

  @override
  Widget build(BuildContext context) {
    String phpEndpoint = song.baseUrl;

    return song.id == -1 ?
        const Image(
              image: AssetImage(
                "images/default.jpg",
              ),
              width: 100,
              height: 100,
            )
      :
      song.image == null ?
      FutureBuilder<http.Response>(
      future: http.get(Uri.parse(
          "$phpEndpoint/getImage.php?titleOfImage=" + song.urlToImage)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Image(
              image: AssetImage(
                "images/default.jpg",
              ),
              width: 100,
              height: 100,
            );
          }
          if (snapshot.hasData && snapshot.data != null) {

              List<int> fileBytes = snapshot.data!.bodyBytes;
              // Now you have the file bytes in the 'fileBytes' variable.
              // You can save the file locally or process it as needed.
            
            
            song.setImageFile(new File(fileBytes, song.title),fileBytes);
            // Display the image fetched from PHP.
            return Image.memory(
              Uint8List.fromList(fileBytes),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              );
          }
        }
        return const Image(
              image: AssetImage(
                "images/default.jpg",
              ),
              width: 100,
              height: 100,
            ); // Show a loading indicator while fetching the image.
      },
    )
    : Image.memory(
              Uint8List.fromList(song.imageBytes),
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              );
  }
}
