import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Playlist.dart';

class SinglePlaylist extends StatelessWidget {
  const SinglePlaylist(
      {super.key, required this.playlist, required this.playPlaylist});

  final Function playPlaylist;
  final Playlist playlist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            playlist.getTitolo(),
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100), // Image radius
                  child: playlist.image.isNotEmpty
                      ? Image.file(
                          File(playlist.image),
                          fit: BoxFit.cover,
                        )
                      : const Image(
                          image: AssetImage("images/default.jpg"),
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () => playPlaylist(playlist),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => const Color.fromRGBO(50, 123, 234, 1)),
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 0),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(61))),
                      padding: MaterialStateProperty.resolveWith(
                          (states) => const EdgeInsets.all(15)),
                    ),
                    child: 
                       const Icon(Icons.play_arrow,
                          color: Color.fromRGBO(25, 20, 20, 1), size: 35),
                    
                  ),
                ),

                Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, "/AddSongToPlaylist",arguments: playlist),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => const Color.fromRGBO(50, 123, 234, 1)),
                      elevation:
                          MaterialStateProperty.resolveWith((states) => 0),
                      shape: MaterialStateProperty.resolveWith((states) =>
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(61))),
                      padding: MaterialStateProperty.resolveWith(
                          (states) => const EdgeInsets.all(15)),
                    ),
                    child:  const Icon(Icons.add,
                          color: Color.fromRGBO(25, 20, 20, 1), size: 35),
                    ),
                  ),
                
              ],
            ),
            CustomContainer(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: playlist.getSongs().length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${index + 1}_  ${playlist.getSongs()[index].title}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ));
  }
}
