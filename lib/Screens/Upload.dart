// ignore_for_file: file_names

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:sound_storm/Components/CustonContainer.dart';
import 'package:sound_storm/Components/Mp3FilePicker.dart';

// ignore: must_be_immutable
class Upload extends StatefulWidget {
  Upload({super.key});
  late PlatformFile? image;
  bool show = true;
  TextEditingController controller = TextEditingController();
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
              padding: const EdgeInsets.only(
                  top: 24, left: 12, right: 12, bottom: 24),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        child: TextField(
                          controller: widget.controller,
                          onTap: () => {
                            setState(() {
                              widget.show = false;
                            })
                          },
                          onSubmitted: (value) => {
                            setState(() {
                              widget.show = true;
                            })
                          },
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Titolo',
                            hintStyle: TextStyle(color: Colors.white),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Padding(
                        padding: widget.show
                            ? const EdgeInsets.only(bottom: 20)
                            : const EdgeInsets.only(bottom: 0),
                        child: const Text(
                          "Anteprima Copertina",
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromRGBO(50, 123, 234, 1)),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(100), // Image radius
                          child: widget.image != null
                              ? Image.file(
                                  File(widget.image!.path!),
                                  fit: BoxFit.cover,
                                )
                              : const Image(
                                  image: AssetImage("images/default.jpg"),
                                ),
                        ),
                      ),
                      widget.show
                          ? IconButton(
                              onPressed: () async {
                                FilePickerResult? result =
                                    await FilePicker.platform.pickFiles(
                                  type: FileType.custom,
                                  allowedExtensions: ['jpg', 'png'],
                                );
                                if (result != null) {
                                  setState(() {
                                    widget.image = result.files.single;
                                  });
                                } else {
                                  // User canceled the picker
                                }
                              },
                              icon: const Icon(
                                Icons.add_a_photo,
                                color: Color.fromRGBO(50, 123, 234, 1),
                              ))
                          : const Text(""),
                      widget.show
                          ? widget.image != null
                              ? Mp3FilePicker(
                                  image: widget.image!,
                                  titolo: widget.controller.text,
                                )
                              : Mp3FilePicker(
                                  image: null,
                                  titolo: widget.controller.text,
                                )
                          : const Text("")
                    ],
                  ),
                ],
              ))),
    );
  }
}
