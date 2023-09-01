import 'package:flutter/material.dart';
import 'package:sound_storm/Screens/Home.dart';
import 'package:sound_storm/Screens/Upload.dart';

class RouteGenerator {
  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        
          return MaterialPageRoute(builder: (_) => Home());
        


      case '/Upload':
        return MaterialPageRoute(builder: (_) => Upload());



     

      default:
        return _errorRoute();
    }
  }
}