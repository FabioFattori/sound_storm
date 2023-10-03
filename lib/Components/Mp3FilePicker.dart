// ignore_for_file: must_be_immutable, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sound_storm/Models/Connector.dart';
import 'package:sound_storm/functions/showOverlay.dart';

class Mp3FilePicker extends StatefulWidget {
  Mp3FilePicker({super.key, required this.image, required this.titolo});

  final PlatformFile? image;
  late String titolo;
  @override
  _Mp3FilePickerState createState() => _Mp3FilePickerState();
}

class _Mp3FilePickerState extends State<Mp3FilePicker> {
  PlatformFile file = PlatformFile(name: '', path: '', size: 0);
  String? result = "";

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
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith(
                (states) => const Color.fromRGBO(50, 123, 234, 1)),
          ),
          onPressed: _pickMp3File,
          child: const Text('Seleziona file .mp3',
              style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(height: 10),
        file.name == ''
            ? const Text(
                'Nessun file selezionato',
                style: TextStyle(color: Colors.white),
              )
            : SizedBox(
                width: 200,
                child: Text(
                  file.name,
                  style: const TextStyle(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
        Padding(
          padding: const EdgeInsets.only(top:16),
          child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => const Color.fromRGBO(50, 123, 234, 1)),
              ),
              onPressed: () async {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showOverlay(context);
                });
                Connector.uploadFile(file, widget.image, widget.titolo)
                    .then((value) => {
                          setState(() {
                            result = "${value!.split(".")[0]}.";
                          }),
                          hideOverlay(),
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(result!),
                              duration: const Duration(seconds: 2),
                            ),
                          )
                        });
              },
              child: const Text('Crea Canzone',
                  style: TextStyle(color: Colors.white))),
        )
      ],
    );
  }
}
