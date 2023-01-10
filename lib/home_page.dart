import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imgPermanent = await saveImgPermanently(image.path);
      setState(() {
        this.image = imgPermanent;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  Future<File> saveImgPermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 5"),
      ),
      body: Container(
        margin: const EdgeInsets.all(50),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: Border.all(width: 8, color: Colors.white70),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ]),
              child: image != null
                  ? Image.file(
                      image!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : const Image(
                      image: AssetImage('assets/chishiya.jpg'),
                      fit: BoxFit.cover,
                      width: 300,
                      height: 300,
                    ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 50,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      elevation: 10, shadowColor: Colors.white,
                    ),
                    onPressed: () async {
                      PermissionStatus cameraStatus =
                          await Permission.camera.request();
                      if (cameraStatus == PermissionStatus.granted) {
                        pickImage(ImageSource.camera);
                      } else if (cameraStatus == PermissionStatus.denied) {
                        return;
                      }
                    },
                    child: Column(
                      children: const [
                        SizedBox(
                          height: 5,
                        ),
                        Icon(Icons.camera_alt),
                        Text('Camera'),
                        SizedBox(
                          height: 5,
                        ),
                      ],
                    )),
                const SizedBox(
                  width: 25,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    elevation: 10, shadowColor: Colors.white,
                  ),
                  onPressed: () async {
                    PermissionStatus galleryStatus =
                        await Permission.storage.request();
                    if (galleryStatus == PermissionStatus.granted) {
                      pickImage(ImageSource.gallery);
                    } else if (galleryStatus == PermissionStatus.denied) {
                      return;
                    }
                  },
                  child: Column(
                    children: const [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(Icons.image),
                      Text('Gallery'),
                      SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
