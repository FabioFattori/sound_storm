import 'package:flutter/material.dart';
import 'package:sound_storm/Components/Mp3FilePicker.dart';
import 'package:sound_storm/Models/Connector.dart';

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
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:Scaffold(
        appBar: AppBar(
          title: Text('Sound Storm'),
        ),
        body: Center(
          child: Mp3FilePicker(),
        ),
      )
      );
    
  }
}

