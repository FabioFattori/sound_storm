import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/Models/Playlist.dart';



class Favourite extends StatefulWidget {
  Favourite({super.key, required this.playPlaylist});
  final Function playPlaylist;
  late Future<Playlist> Favorite = Future<Playlist>.value(Playlist.noPlaylist());
  @override
  State<Favourite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favourite> {
  void getFavorites() async {
    setState(() {
      widget.Favorite = Connector.getFavoritesSongs();
      
    });
  }

  @override
  void initState() {
    super.initState();
    getFavorites();
  }

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
          title: const Text("Favorite", style: TextStyle(color: Colors.white)),
          backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
        body: FutureBuilder<Playlist>(future: widget.Favorite, builder: ((context, snapshot) {
          if(snapshot.hasData){
            return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(100), // Image radius
                  child:  const Image(
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
                    onPressed: ()async => {
                        widget.playPlaylist(await widget.Favorite),
                        Navigator.pop(context),
                      },
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

                
                
              ],
            ),
            CustomContainer(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.getSongs().length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        "${index + 1}_  ${snapshot.data!.getSongs()[index].title}",
                        style: const TextStyle(color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        );
          }
          else{
            return const Center(child: CircularProgressIndicator());
          }
        })) 
        );
  }
}