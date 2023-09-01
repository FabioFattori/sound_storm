import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Components/RouteButton.dart';
import 'package:sound_storm/Components/Skeleton.dart';

class Home extends StatefulWidget {
  Home({super.key});

  final TextEditingController _controller = TextEditingController();
  bool isSearching = false;
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

  @override
  void initState() {
    super.initState();
    
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
                onTap: () => {
                  setState(() {
                    widget.isSearching = true;
                  })
                },
                onSubmitted: (value) => {
                  setState(() {
                    widget.isSearching = false;
                  })
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
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return const Skeleton();
                      }),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomContainer(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RouteButton(
                                  title: "Playlist",
                                  icon: Icons.my_library_music),
                              RouteButton(
                                  title: "Importa", icon: Icons.download,Route: "/Upload",),
                              RouteButton(
                                  title: "Canzoni Preferite",
                                  icon: Icons.favorite),
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
    );
  }
}
