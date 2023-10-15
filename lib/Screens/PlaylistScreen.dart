import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';
import 'package:sound_storm/Models/argsToPass.dart';

class PlaylistScreen extends StatefulWidget {
  PlaylistScreen({super.key, required this.playPlaylist});

  final Function playPlaylist;
  late Future<List<Playlist>> playlists = Future<List<Playlist>>.value([]);

  @override
  State<PlaylistScreen> createState() => _PlaylistState();
}

class _PlaylistState extends State<PlaylistScreen> {
  Future<List<Playlist>> getPlaylists() async {
    setState(() {
      widget.playlists = Connector.getPlaylists();
    });
    return Connector.getPlaylists();
  }

  @override
  void initState() {
    super.initState();
    widget.playlists = Connector.getPlaylists();

    Future.delayed(const Duration(seconds: 3), () {
      dynamic x = widget.playlists;
        setState(() {
          widget.playlists = new Future<List<Playlist>>.value([]);
        });

        setState(() {
          widget.playlists = x;
        });
    });
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
            RefreshIndicator(
                child: FutureBuilder<List<Playlist>>(
                  future: widget.playlists,
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
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              20), // Image border
                                          child: SizedBox.fromSize(
                                            // Image radius
                                            child:
                                                snapshot.data![index].image !=
                                                        null
                                                    ? kIsWeb ?
                                                    Image.network(
                                                        snapshot
                                                            .data![index]
                                                            .getImageWeb(),
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.file(
                                                        snapshot
                                                            .data![index]
                                                            .image!,
                                                        width: 50,
                                                        height: 50,
                                                        fit: BoxFit.cover,
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
                                      SizedBox(
                                        width: 235,
                                        child: Text(
                                          snapshot.data![index].getTitolo(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20),
                                        ),
                                      ),
                                      IconButton(
                                          tooltip: "Elimina Playlist",
                                          onPressed: () => {
                                                Connector.deletePlaylist(
                                                    snapshot.data![index].id),
                                                setState(() {
                                                  widget.playlists =
                                                      Connector.getPlaylists();
                                                })
                                              },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                                    ],
                                  ),
                                  onTap: () => {
                                    args.arg1 = snapshot.data![index],
                                    Navigator.pushNamed(
                                        context, '/SinglePlaylist',
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
                onRefresh: () => getPlaylists())
          ],
        ));
  }
}
