import 'package:flutter/material.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';


class PlaylistScreen extends StatefulWidget {
  PlaylistScreen({super.key});
  
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Playlist", style: TextStyle(color: Colors.white),),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      ),
      backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      body: FutureBuilder<List<Playlist>>(
        future: getPlaylists(),
        builder: (context, snapshot) {
          print(snapshot.data);
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  color: Color.fromARGB(255, 78, 72, 72),
                  child: ListTile(
                    title: Text(snapshot.data![index].getTitolo(), style: const TextStyle(color: Colors.white),),
                    onTap: () => {
                      Navigator.pushNamed(context, '/playlist',
                          arguments: snapshot.data![index])
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}