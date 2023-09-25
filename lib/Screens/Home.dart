// ignore_for_file: file_names

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/BottomBar.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Components/RouteButton.dart';
import 'package:sound_storm/Components/Skeleton.dart';
import 'package:sound_storm/Components/SongRowVisual.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Song.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  Home(
      {super.key,
      required this.playSong,
      required this.setDurationSong,
      required this.getDuration,
      required this.pauseSong,
      required this.resumeSong,
      required this.isPlaying,
      required this.setSong,
      required this.currentSong,
      required this.plaPlaylist,
      this.songs = const [],required this.player,this.skipPrevious,this.skipNext});
  late bool isPlaying;
  late Function playSong;
  late Function pauseSong;
  late Function? skipPrevious;
  late Function? skipNext;
  late Function resumeSong;
  late Function setSong;
  late Function getDuration;
  late Song currentSong;
  late Function setDurationSong;
  late dynamic player;
  late Function plaPlaylist;

  final TextEditingController _controller = TextEditingController();
  List<Song> get filteredSongs {
    if (_controller.text == "" || _controller.text == " ") {
      return songs;
    } else {
      return songs
          .where((element) => element.title
              .toLowerCase()
              .contains(_controller.text.toLowerCase()))
          .toList();
    }
  }

  bool isSearching = false;
  List<Song> songs;
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Text chooseWhatToSay() {
    if (DateTime.now().hour < 11) {
      return const Text(
        'Buongiorno!',
        style: TextStyle(fontSize: 30, color: Color.fromRGBO(50, 123, 234, 1)),
      );
    } else if (DateTime.now().hour < 18) {
      return const Text('Buon pomeriggio!',
          style:
              TextStyle(fontSize: 30, color: Color.fromRGBO(50, 123, 234, 1)));
    } else {
      return const Text('Buonasera!',
          style:
              TextStyle(fontSize: 30, color: Color.fromRGBO(50, 123, 234, 1)));
    }
  }

  void getSongs() async {
    dynamic appoggio = await Connector.getSongList();
    setState(() {
      widget.songs = appoggio;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      appBar: AppBar(
        title: chooseWhatToSay(),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: TextField(
                controller: widget._controller,
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => {
                  setState(() {
                    widget._controller.text = value;
                  })
                },
                onTap: () => {
                  setState(() {
                    widget.isSearching = true;
                  })
                },
                onSubmitted: (value) => {
                  if (widget._controller.text == "" ||
                      widget._controller.text == " ")
                    {
                      setState(() {
                        widget.isSearching = false;
                      })
                    }
                },
                decoration: const InputDecoration(
                  hintText: 'Cerca...',
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )),
          widget.isSearching
              ? Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widget.songs.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: widget.filteredSongs.length,
                              itemBuilder: (context, index) {
                                return SongRowVisual(
                                  playSong: widget.playSong,
                                  pauseSong: widget.pauseSong,
                                  song: widget.filteredSongs[index],
                                  setSong: widget.setSong,
                                );
                              })
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return const Skeleton();
                              }),
                    ],
                  ))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RouteButton(
                          title: "Playlist",
                          icon: Icons.my_library_music,
                          Route: "/Playlist",
                          argsToPass: widget.plaPlaylist,
                        ),
                        RouteButton(
                          title: "Importa",
                          icon: Icons.download,
                          Route: "/Upload",
                        ),
                        RouteButton(
                            title: "Canzoni Preferite", icon: Icons.favorite),
                      ],
                    )),
                    const Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Canzoni Ascoltate di recente:",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    )
                  ],
                )
        ],
      ),
      bottomNavigationBar: BottomBar(
        playSong: widget.resumeSong,
        pauseSong: widget.pauseSong,
        isPlaying: widget.isPlaying,
        currentSong: widget.currentSong,
        getDuration: widget.getDuration,
        setDurationSong: widget.setDurationSong,player: widget.player,
        skipNext: widget.skipNext,
        skipPrevious: widget.skipPrevious,
      ),
    );
  }
}
