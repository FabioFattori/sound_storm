// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';

class CreatePlaylist extends StatefulWidget {
  CreatePlaylist({super.key});
  late TextEditingController playlistNameController = TextEditingController();

  @override
  State<CreatePlaylist> createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Create Playlist",
              style: TextStyle(color: Colors.white)),
              leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),          backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        body: CustomContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: widget.playlistNameController,
                decoration: const InputDecoration
                (
                  labelStyle: TextStyle(color: Colors.white),
                  border: OutlineInputBorder(),
                  focusColor: Color.fromRGBO(50, 123, 234, 1),
                  labelText: 'Playlist Name',
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(50, 123, 234, 1)),
              onPressed: () async {
                Playlist newPlaylist = await Connector.createPlaylist(
                    widget.playlistNameController.text);
                //pop this page and go to add song to playlist page
                Navigator.pop(context);
                Navigator.pushNamed(context, "/AddSongToPlaylist",
                    arguments: newPlaylist);
              },
              child:
                  const Text("Create", style: TextStyle(color: Colors.white)),
            ),
          ],
        )));
  }
}
