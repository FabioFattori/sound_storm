import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Components/Mp3FilePicker.dart';

class Upload extends StatefulWidget {
  Upload({super.key});
  late File? image = null;
  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Crea Una Nuova Canzone",
          style:
              TextStyle(fontSize: 25, color: Color.fromRGBO(50, 123, 234, 1)),
        ),
        backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      ),
      backgroundColor: const Color.fromRGBO(25, 20, 20, 1),
      body: CustomContainer(
          child: Padding(
              padding:
                  const EdgeInsets.only(top: 24, left: 12, right: 12, bottom: 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Anteprima Copertina",
                        style: TextStyle(
                            fontSize: 25,
                            color: Color.fromRGBO(50, 123, 234, 1)),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(100), // Image radius
                          child: widget.image != null
                              ? Image.file(
                                  widget.image!,
                                  fit: BoxFit.cover,
                                )
                              : const Image(
                                  image: AssetImage("images/default.jpg"),
                                ),
                        ),
                      ),
                      IconButton(
                          onPressed: () async {
                            FilePickerResult? result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png'],
                            );
                            if (result != null) {
                              setState(() {
                                widget.image = File(result.files.single.path!);
                              });
                            } else {
                              // User canceled the picker
                            }
                          },
                          icon: const Icon(
                            Icons.add_a_photo,
                            color: Color.fromRGBO(50, 123, 234, 1),
                          )),
                      Mp3FilePicker(),
                    ],
                  ),
                ],
              ))),
    );
  }
}
