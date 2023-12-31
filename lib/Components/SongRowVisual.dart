// ignore_for_file: file_names

import 'dart:html';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Components/ImageFromPhp.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';
import 'package:flutter/foundation.dart';

// ignore: must_be_immutable
class SongRowVisual extends StatefulWidget {
  SongRowVisual(
      {super.key,
      required this.song,
      required this.playSong,
      required this.pauseSong,
      required this.setSong,
      File? this.image = null});
  Function playSong;
  Function pauseSong;
  Function setSong;
  bool clicked = false;
  late Song song;
  File? image;
  @override
  State<SongRowVisual> createState() => _SongRowVisualState();
}

class _SongRowVisualState extends State<SongRowVisual> {
  void getImage() async {
    File? appoggio = await widget.song.getImageFile();
    if (mounted) {
      setState(() {
        widget.image = appoggio;
      });
    }
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
            child:  ImageFromPhp(song: widget.song)
                
          ),
        ),
        SizedBox(
          width: 125,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              widget.song.title,
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 30),
          child: IconButton(
              onPressed: () async {
                if (widget.clicked) {
                  widget.pauseSong();
                } else {
                  await widget.song.getMp3File().then((value) => {
                        widget.playSong(value),
                        widget.setSong(widget.song),
                      });
                }
                if (mounted) {
                  setState(() {
                    widget.clicked = !widget.clicked;
                  });
                }
              },
              icon: widget.clicked
                  ? const Icon(
                      Icons.pause,
                      color: Colors.white,
                      size: 35,
                    )
                  : const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 35,
                    )),
        ),
        IconButton(
            onPressed: () => {
                  setState(() {
                    widget.song.isLiked = !widget.song.isLiked;
                  }),
                  Connector.changeFavoriteListFromId(widget.song.id)
                },
            icon: Icon(
              widget.song.isLiked ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
              size: 35,
            ))
      ],
    ));
  }
}
