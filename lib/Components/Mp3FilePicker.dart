import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'dart:io';

class Mp3FilePicker extends StatefulWidget {
  @override
  _Mp3FilePickerState createState() => _Mp3FilePickerState();
}

class _Mp3FilePickerState extends State<Mp3FilePicker> {
  PlatformFile file = PlatformFile(name: '', path: '', size: 0);
  String? result;

  Future<void> _pickMp3File() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      setState(() {
        file = result.files.single;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ElevatedButton(
          onPressed: _pickMp3File,
          child: Text('Seleziona file .mp3'),
        ),
        SizedBox(height: 10),
        file.name == '' ? Text('Nessun file selezionato') : Text(file.name),
        ElevatedButton(
            onPressed: () async {
              var res=await Connector.uploadFile(file);
              setState(() {
                result = "${res!.split(".")[0]}.";
              });
            },
            child: Text('Upload')),
            result==null?Text(''):Text(result!),
      ],
    );
  }
}
