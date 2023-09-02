import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

var overlay;
OverlayEntry? entry;
void showOverlay(dynamic context) {
  final overlay = Overlay.of(context);
  

  entry = OverlayEntry(
    builder: (context) =>  Container(
                width: double.maxFinite,
                height: 500,
                color: const Color.fromRGBO(25, 20, 20, 1),
                child: const Center(
                  child: SpinKitSpinningLines(
                    color:  Color.fromRGBO(50, 123, 234, 1),
                    size: 100.0,
                  ),
                ))
  );
  overlay.insert(entry!);
  
}

void hideOverlay() {
  entry!.remove();
}
