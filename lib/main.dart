import 'package:flutter/material.dart';
import 'package:sound_storm/RouteGenerator.dart';
import 'package:sound_storm/Screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Storm',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home:Home(),
      onGenerateRoute: RouteGenerator.generateRoute,
      );
    
  }
}

