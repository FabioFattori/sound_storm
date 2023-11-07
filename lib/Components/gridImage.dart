import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sound_storm/Components/ImageFromPhp.dart';
import 'package:sound_storm/Models/Song.dart';

class gridImage extends StatefulWidget {
  gridImage(
      {super.key,
      required this.song,
      required this.playSong,
      required this.pauseSong,
      required this.setSong});
  late Function playSong;
  late Function pauseSong;
  late Function setSong;
  bool clicked = false;
  late Song song;
  @override
  State<gridImage> createState() => _gridImageState();
}

class _gridImageState extends State<gridImage> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        widget.setSong(widget.song);
        widget.playSong(await widget.song.getMp3File());
      },
      icon: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Image border
        child: SizedBox.fromSize(
          // Image radius
          child: widget.song.image != null
              ? ImageFromPhp(song: widget.song)
              : const Image(
                  image: AssetImage(
                    "images/default.jpg",
                  ),
                  width: 100,
                  height: 100,
                ),
        ),
      ),
    );
  }
}
