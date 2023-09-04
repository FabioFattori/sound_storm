// ignore_for_file: file_names

import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Song.dart';

// ignore: must_be_immutable
class SongRowVisual extends StatefulWidget {
  SongRowVisual(
      {super.key,
      required this.song,
      required this.playSong,
      required this.pauseSong,required this.setSong});
  Function playSong;
  Function pauseSong;
  Function setSong;
  var player = AudioPlayer();
  bool clicked = false;
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
        ClipRRect(
          borderRadius: BorderRadius.circular(20), // Image border
          child: SizedBox.fromSize(
            // Image radius
            child: widget.image != null
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
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            widget.song.title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 120),
          child: IconButton(
              onPressed: () async {
                if (widget.clicked) {
                  widget.pauseSong();
                } else {
                  await widget.song
                      .getMp3File()
                      .then((value) => widget.playSong(UrlSource(value)));
                      widget.setSong(widget.song);
                }
                setState(() {
                  widget.clicked = !widget.clicked;
                });
              },
              icon: widget.clicked
                  ? const Icon(
                      Icons.pause,
                      color: Colors.white,
                    )
                  : const Icon(Icons.play_arrow, color: Colors.white)),
        )
      ],
    ));
  }
}
