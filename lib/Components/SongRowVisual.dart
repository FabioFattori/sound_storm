import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Song.dart';

class SongRowVisual extends StatefulWidget {
  SongRowVisual({super.key, required this.song});

  late Song song;
  File? image;
  @override
  State<SongRowVisual> createState() => _SongRowVisualState();
}

class _SongRowVisualState extends State<SongRowVisual> {
  void getImage() async {
    File appoggio = await widget.song.getImageFile();
    setState(() {
      widget.image = appoggio;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
        child: Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        widget.image != null
            ? Image.file(
                widget.image!,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              )
            : const Image(
                image: AssetImage(
                  "images/default.jpg",
                ),
                width: 100,
                height: 100,
              ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            widget.song.title,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        )
      ],
    ));
  }
}
