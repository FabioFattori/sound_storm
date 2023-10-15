import 'dart:async';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_storm/Models/PositionData.dart';
import 'package:sound_storm/Models/Song.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
      {super.key,
      required this.playSong,
      required this.pauseSong,
      required this.isPlaying,
      required this.currentSong,
      required this.getDuration,
      required this.setDurationSong,
      required this.player, this.skipNext,this.skipPrevious});
  late bool isPlaying;
  late Function? skipPrevious;
  late Function? skipNext;
  Function getDuration;
  late Function playSong;
  late Function pauseSong;
  late Song currentSong;
  late double totalDuration = 0;
  late Function setDurationSong;
  double currentDuration = 0;
  late dynamic player;

  Stream<PositionData> get durationStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        player.positionStream,
        player.bufferedPositionStream,
        player.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position: position,
          BufferedPosition: bufferedPosition,
          duration: duration ?? const Duration(seconds: 0),
        ),
      );

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  Future<double> setDuration() async {
    Duration? dur = await widget.getDuration(widget.currentSong.urlToMp3) ??
        const Duration(seconds: 200);
    setState(() {
      widget.totalDuration = dur!.inSeconds.toDouble() / 60;
    });
    return dur!.inSeconds.toDouble() / 60;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 175,
      width: MediaQuery.of(context).size.width,
      color: const Color.fromRGBO(25, 20, 20, 1),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          
              Center(
                child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  // Image radius
                  child: widget.currentSong.image != null
                      ? kIsWeb
                    ? Image.network(
                        widget.currentSong.getUrlToImage(),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        widget.currentSong.image!,
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
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                   Text(
                        widget.currentSong.title,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                  Row(
                    children: [
                      IconButton(onPressed: ()=>widget.skipPrevious!(), icon: const Icon(Icons.skip_previous,color: Colors.white,size: 30,)),
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
                              ? const Icon(Icons.pause, color: Colors.white,size: 30)
                              : const Icon(Icons.play_arrow,
                                  color: Colors.white,size: 30)),
                      IconButton(onPressed: ()=>widget.skipNext!(), icon: const Icon(Icons.skip_next,color: Colors.white,size: 30)),
                    ],
                  ),
                  StreamBuilder<PositionData>(
                      stream: widget.durationStream,
                      builder: (context, snapshot) {
                        final positionData = snapshot.data;
                        return SizedBox(
                          width: 275,
                          child: ProgressBar(
                            baseBarColor: Colors.white,
                            bufferedBarColor:
                                const Color.fromRGBO(61, 61, 61, 1),
                            progressBarColor:
                                const Color.fromRGBO(50, 123, 234, 1),
                            thumbColor: const Color.fromRGBO(50, 123, 234, 1),
                            thumbGlowColor:
                                const Color.fromRGBO(50, 124, 234, 0.521),
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            progress: positionData?.position ?? Duration.zero,
                            buffered:
                                positionData?.BufferedPosition ?? Duration.zero,
                            total: positionData?.duration ?? Duration.zero,
                            onSeek: widget.player.seek,
                          ),
                        );
                      })
                ],
              ),
            ],
          ),
        
      
    );
  }
}
