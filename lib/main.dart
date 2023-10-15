import 'dart:collection';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:sound_storm/Components/BottomBar.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/Song.dart';
import 'package:sound_storm/RouteGenerator.dart';
import 'package:sound_storm/Screens/Home.dart';

void main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});
  var player;
  List<Song> songs = [];
  bool isPlaying = false;
  bool loop = true;
  bool playlist = false;
  Song currentSong = Song.noSong();
  late var duration = const Duration(seconds: 200);
  Playlist? currentPlaylist;
  List<Song> recentSongs = [];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void playSong(dynamic risorsaAudio) async {
    try {
      dynamic duration;
      
        duration = await widget.player.setAudioSource(risorsaAudio);
        await widget.player.play();
      
      setState(() {
        widget.duration = duration;
      });
    } catch (e) {
      if (e is PlayerInterruptedException) {
        playSong(risorsaAudio);
      }
    }
  }

  List<Song> reverseList(List<Song> lst, Song toAdd) {
    lst.insertAll(0, [toAdd]);
    return lst;
  }

  void setSong(Song song) {
    setState(() {
      widget.currentSong = song;
      if (!widget.recentSongs.contains(song)) {
        widget.recentSongs = reverseList(widget.recentSongs, song);
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      print("recent Songs=>${widget.recentSongs}");
    });
  }

  void setTimeSong(Duration duration) async {
    await widget.player.seek(duration);
  }

  void resumeSong() async {
    await widget.player.play();
  }

  void pauseSong() async {
    await widget.player.pause();
  }

  Future<Duration?> getDuration(String url) async {
    return widget.duration;
  }

  void getSongs() async {
    dynamic appoggio = await Connector.getSongList();
    setState(() {
      widget.songs = appoggio;
    });
  }

  void setAndPlayPlaylist(Playlist p) async {
    setState(() {
      widget.currentPlaylist = p;
      widget.currentSong = p.getSongs()[0];
      widget.playlist = true;
      widget.loop = false;
    });

    List<AudioSource> appoggio = [];

    for (Song song in p.getSongs()) {
      appoggio.add(await song.getMp3FileWithAlbum(p.titolo));
    }

    playSong(ConcatenatingAudioSource(
      children: appoggio,
      shuffleOrder: DefaultShuffleOrder(random: Random()),
    ));

    if (widget.loop) await widget.player.setLoopMode(LoopMode.all);

    // Set playlist to loop (off|all|one)
    await widget.player
        .setShuffleModeEnabled(true); // Shuffle playlist order (true|false)
  }

  void skipPrevious() async {
    if (widget.playlist) {
      int currentIndex = widget.player.currentIndex;

      await widget.player.seekToPrevious();

      if (currentIndex == widget.player.currentIndex) {
        widget.player.seek(const Duration(seconds: 0),
            index: widget.currentPlaylist!.songs.length - 1);
      }
    }
  }

  void skipNext() async {
    if (widget.playlist) {
      int currentIndex = widget.player.currentIndex;

      await widget.player.seekToNext();

      if (currentIndex == widget.player.currentIndex) {
        widget.player.seek(const Duration(seconds: 0), index: 0);
      }
    }
  }

  List<Song> getRecentSongs() {
    return widget.recentSongs;
  }

  @override
  void initState() {
    super.initState();
    getSongs();
    widget.player = AudioPlayer();

    widget.player.processingStateStream.listen((state) {
      switch (state) {
        case ProcessingState.idle:
          print("idle playlist");
        case ProcessingState.loading:
          print("loading file");
        case ProcessingState.buffering:
          print("buffering  playlist");
        case ProcessingState.ready:
          print("ready  playlist");
        case ProcessingState.loading:
          print("loading  playlist");
        case ProcessingState.completed:
          if (widget.currentPlaylist != null) {
            if (widget.loop) {
              widget.player.seek(const Duration(seconds: 0), index: 0);
              widget.player.play();
            } else {
              setState(() {
                widget.isPlaying = false;
              });
            }
          }
      }
    });

    // widget.player.durationStream.listen((duration) {
    //   print("duration playlist=>$duration");
    // });

    widget.player.currentIndexStream.listen((index) {
      if (index != null && widget.currentPlaylist != null) {
        setState(() {
          widget.currentSong = widget.currentPlaylist!.getSongs()[index];
        });
      }
    });

    widget.player.playerStateStream.listen((state) {
      if (state.playing) {
        setState(() {
          widget.isPlaying = true;
        });
      } else {
        setState(() {
          widget.isPlaying = false;
        });
      }
      switch (state.processingState) {
        case ProcessingState.idle:
          print("idle");
        case ProcessingState.loading:
          print("loading file");
        case ProcessingState.buffering:
          print("buffering");
        case ProcessingState.ready:
          print("ready");
        case ProcessingState.loading:
          print("loading");
        case ProcessingState.completed:
          print("completed");
          if (widget.loop) {
            widget.player.seek(const Duration(seconds: 0));
            widget.player.play();
          } else {
            setState(() {
              widget.isPlaying = false;
            });
          }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Storm',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: Home(
        playSong: (value) => playSong(value),
        pauseSong: () => pauseSong(),
        resumeSong: () => resumeSong(),
        isPlaying: widget.isPlaying,
        setSong: (value) => setSong(value),
        currentSong: widget.currentSong,
        songs: widget.songs,
        getDuration: (value) => getDuration(value),
        setDurationSong: (value) => setTimeSong(value),
        player: widget.player,
        plaPlaylist: (value) => setAndPlayPlaylist(value),
        skipNext: () => skipNext(),
        skipPrevious: () => skipPrevious(),
        recentSongs: getRecentSongs(),
      ),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
