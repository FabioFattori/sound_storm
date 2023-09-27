// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/Song.dart';

class AddSongToPlaylist extends StatefulWidget {
  AddSongToPlaylist({super.key, required this.playlist});
  late Playlist playlist;
  List<int> songToAdd = [];
  late int oldLength = 0;
  @override
  State<AddSongToPlaylist> createState() => _AddSongToPlaylistState();
}

class _AddSongToPlaylistState extends State<AddSongToPlaylist> {
  @override
  void initState() {
    super.initState();
    widget.playlist.getSongs().forEach((element) {
      setState(() {
        widget.songToAdd.add(element.id);
      });
    });

    setState(() {
      widget.oldLength = widget.songToAdd.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Add song to playlist",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      ),
      backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      body: Column(
        children: [
          Text(
            widget.playlist.getTitolo(),
            style: const TextStyle(color: Colors.white, fontSize: 30),
          ),
          CustomContainer(
            child: FutureBuilder<List<Song>>(
                future: Connector.getSongList(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    snapshot.data![index].title,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ),
                                Checkbox(
                                    value: widget.songToAdd
                                        .contains(snapshot.data![index].id),
                                    onChanged: (value) => {
                                          if (widget.songToAdd.contains(
                                              snapshot.data![index].id))
                                            {
                                              setState(() {
                                                widget.songToAdd.remove(
                                                    snapshot.data![index].id);
                                              })
                                            }
                                          else
                                            {
                                              setState(() {
                                                widget.songToAdd.add(
                                                    snapshot.data![index].id);
                                              })
                                            }
                                        })
                              ],
                            ),
                          );
                        });
                  }
                  return const Center(child: CircularProgressIndicator());
                }),
          ),
          ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith((states) =>
                    widget.oldLength <= widget.songToAdd.length
                        ? const Color.fromRGBO(50, 123, 234, 1)
                        : const Color.fromARGB(255, 196, 40, 40)),
                elevation: MaterialStateProperty.resolveWith((states) => 0),
                shape: MaterialStateProperty.resolveWith((states) =>
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(61))),
                padding: MaterialStateProperty.resolveWith(
                    (states) => const EdgeInsets.all(10)),
              ),
              onPressed: () async {
                int i=await Connector.addSongToPlaylist(
                    widget.songToAdd, widget.playlist.id);
                if(i==0) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error Code $i")));
                }
              },
              icon: const Icon(
                Icons.add_circle_outlined,
                color: Colors.white,
              ),
              label: Text(
                  widget.oldLength <= widget.songToAdd.length
                      ? "Add ${widget.songToAdd.length} song/s to playlist"
                      : "Remove ${widget.oldLength - widget.songToAdd.length} song/s to playlist",
                  style: const TextStyle(color: Colors.white)))
        ],
      ),
    );
  }
}
