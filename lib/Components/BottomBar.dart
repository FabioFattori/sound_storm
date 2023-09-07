import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Song.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
      {super.key,
      required this.playSong,
      required this.pauseSong,
      required this.isPlaying,
      required this.currentSong,
      required this.getDuration,
      required this.setDurationSong});
  late bool isPlaying;
  Function getDuration;
  late Function playSong;
  late Function pauseSong;
  late Song currentSong;
  late double currentDuration = 0;
  late double totalDuration = 0;
  late Function setDurationSong;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Future<double> setDuration() async {
    Duration? dur =
        await widget.getDuration(widget.currentSong.urlToMp3) ??
            const Duration(seconds: 200);
    setState(() {
      widget.totalDuration = dur!.inSeconds.toDouble() / 60;
    });
    return dur!.inSeconds.toDouble() / 60;
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.currentSong.title != "" &&
          widget.currentSong.urlToMp3 != " " &&
          widget.currentSong.urlToImage != "") {
        setState(() {
          if (widget.isPlaying &&
              widget.currentDuration < widget.totalDuration) {
            widget.currentDuration += 0.01;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: const Color.fromRGBO(25, 20, 20, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  // Image radius
                  child: widget.currentSong.image != null
                      ? Image.file(
                          widget.currentSong.image!,
                          width: 75,
                          height: 75,
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage(
                            "images/default.jpg",
                          ),
                          width: 75,
                          height: 75,
                        ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        widget.currentSong.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  FutureBuilder(
                      future: setDuration(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Slider(
                            label: widget.currentDuration.toString(),
                            min: 0,
                            max: snapshot.data as double == 0
                                ? 1
                                : snapshot.data as double,
                            value: widget.currentDuration,
                            onChanged: (double value) {
                              setState(() {
                                widget.currentDuration = value;
                              });
                              widget.setDurationSong(Duration(
                                  minutes: value.toInt(),
                                  seconds:
                                      ((value - value.toInt()) * 60).toInt()));
                            },
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          );
                        } else {
                          return Slider(
                            min: 0,
                            max: 0,
                            value: 0,
                            onChanged: (double value) {},
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          );
                        }
                      }),
                ],
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                if (widget.currentSong != Song.noSong()) {
                  if (widget.isPlaying) {
                    widget.pauseSong();
                  } else {
                    widget.playSong();
                  }
                }
              },
              icon: widget.isPlaying
                  ? const Icon(Icons.pause, color: Colors.white)
                  : const Icon(Icons.play_arrow, color: Colors.white)),
        ],
      ),
    );
  }
}
