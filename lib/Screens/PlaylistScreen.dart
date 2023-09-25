import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/argsToPass.dart';

class PlaylistScreen extends StatefulWidget {
  PlaylistScreen({super.key,required this.playPlaylist});

  final Function playPlaylist;
  late List<Playlist> playlists;

  @override
  State<PlaylistScreen> createState() => _PlaylistState();
}

class _PlaylistState extends State<PlaylistScreen> {
  Future<List<Playlist>> getPlaylists() async {
    return Connector.getPlaylists();
  }

  

  @override
  Widget build(BuildContext context) {
    argsToPass args = argsToPass(arg1: null, arg2: widget.playPlaylist);


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
          title: const Text(
            "Le Mie Playlist",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.all(10),
                child: Card(
                  color: const Color.fromARGB(255, 78, 72, 72),
                  child: ListTile(
                    title: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(20), // Image border
                            child: SizedBox.fromSize(
                              // Image radius
                              child: const Icon(
                                Icons.add_circle,
                                color: Colors.white,
                                size: 50,
                              ),
                            ),
                          ),
                        ),
                        const Text(
                          "crea una nuova playlist",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                    onTap: () =>
                        {Navigator.pushNamed(context, '/CreatePlaylist')},
                  ),
                )),
            FutureBuilder<List<Playlist>>(
              future: getPlaylists(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(10),
                          child: Card(
                            color: const Color.fromARGB(255, 78, 72, 72),
                            child: ListTile(
                              title: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          20), // Image border
                                      child: SizedBox.fromSize(
                                        // Image radius
                                        child:
                                            snapshot.data![index].getImage() !=
                                                    ""
                                                ? Image.network(
                                                    snapshot.data![index]
                                                        .getImage(),
                                                    width: 50,
                                                    height: 50,
                                                  )
                                                : const Image(
                                                    image: AssetImage(
                                                      "images/default.jpg",
                                                    ),
                                                    width: 50,
                                                    height: 50,
                                                  ),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    snapshot.data![index].getTitolo(),
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              ),
                              onTap: () => {
                                args.arg1 = snapshot.data![index],
                                Navigator.pushNamed(context, '/SinglePlaylist',
                                    arguments: args)
                              },
                            ),
                          ));
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ));
  }
}
