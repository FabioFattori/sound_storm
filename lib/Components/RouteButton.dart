import 'package:flutter/material.dart';

class RouteButton extends StatelessWidget {
  RouteButton({super.key, required this.title, required this.icon,this.Route=""});

  late String title;
  late IconData icon;
  late String Route;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton.icon(
          onPressed: () => {
            Navigator.pushNamed(context, Route),
          },
          icon: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
          label: Text(
            title,
            style:const TextStyle(color: Colors.white, fontSize: 25),
            selectionColor: const Color.fromRGBO(50, 123, 234, 1),
          ),
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateColor.resolveWith(
              (states) => const Color.fromRGBO(61, 61, 61, 1),
            ),
            elevation: MaterialStateProperty.resolveWith((states) => 0),
            shape: MaterialStateProperty.resolveWith((states) =>
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(31))),
            padding: MaterialStateProperty.resolveWith(
                (states) => const EdgeInsets.all(20)),
          ),
        ),
      ],
    );
  }
}
