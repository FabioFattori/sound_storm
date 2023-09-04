import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Song.dart';

class BottomBar extends StatefulWidget {
  BottomBar(
      {super.key,
      required this.playSong,
      required this.pauseSong,
      required this.isPlaying,required this.currentSong});
  late bool isPlaying;
  late Function playSong;
  late Function pauseSong;
  late Song currentSong;
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20), // Image border
            child: SizedBox.fromSize(
              // Image radius
              child: widget.currentSong.image != null
                  ? Image.file(
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
          IconButton(
              onPressed: () {
                if(widget.isPlaying){
                  widget.pauseSong();
                }else{
                  widget.playSong();
                }
              },
              icon: widget.isPlaying
                  ? const Icon(Icons.pause)
                  : const Icon(Icons.play_arrow)),
        ],
      ),
    );
  }
}
