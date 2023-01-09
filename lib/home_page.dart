import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
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

      final imgTemporary = File(image.path);
      setState(() {
        this.image = imgTemporary;
      });
    } on PlatformException catch (e) {
      print("Failed to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity 5"),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(50),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black54.withOpacity(0.5),
                  spreadRadius: 10,
                  blurRadius: 10,
                )
              ],
              border: Border.all(width: 5, color: Colors.white70),
            ),
            child: image != null
                ? CircleAvatar(
                    radius: 150,
                    child: Image.file(
                      image!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ):
                const Image(
                      image: AssetImage('assets/chishiya.jpg'),
                      fit: BoxFit.cover,
                      width: 300,
                      height: 300,
                    ),
                ),
          Container(
            padding: const EdgeInsets.only(left: 50, right: 50),
            child: const Text(
              "Robel qt",
              style: TextStyle(
                fontSize: 45,
                color: Colors.yellow,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Text(
            ": Grabi jud ka gwapo",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white54,
            ),
          ),
          const Text(
            ": Kaayo Jud",
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: Colors.white54,
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Gallery'),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        onTap: (int index) async {
          if(index == _selectedIndex) {
            PermissionStatus cameraStatus = await Permission.camera.request();
            if (cameraStatus == PermissionStatus.granted) {
                pickImage(ImageSource.camera);
            } else if (cameraStatus == PermissionStatus.denied) {
              return;
            }
          }else{
            PermissionStatus galleryStatus = await Permission.storage.request();
            if (galleryStatus == PermissionStatus.granted) {
                pickImage(ImageSource.gallery);
            } else if (galleryStatus == PermissionStatus.denied) {
              return;
            }
          }
        },
      ),
    );
  }
}
