// import 'dart:io';

import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AlbumPageAccess(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AlbumPageAccess extends StatefulWidget {
  const AlbumPageAccess({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AlbumPageAccessState();
  }
}


class AlbumPageAccessState extends State<AlbumPageAccess> {
  var _galleryFile;
  // var _cameraFile;
  final ImagePicker _picker = ImagePicker();

  List<String> _images = [];

  @override
  Widget build(BuildContext context) {

    //display image selected from gallery
    imageSelectorGallery() async {
      _galleryFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      setState(() {
        _galleryFile = File(_galleryFile.path);
        _images.add(_galleryFile.path);
      });
    }


    //display image captured from camera
    imageSelectorFromCamera() async{
      _galleryFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      setState(() {
        _galleryFile = File(_galleryFile.path);
        _images.add(_galleryFile.path);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Album 571'),
        backgroundColor: Colors.blue,
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            // child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded( child: Container(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.count(
                    crossAxisCount: 3,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,

                    children : <Widget>[
                      for (var img in _images)
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => NewScreen(
                              image: File(img),
                            )));
                          },
                          child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: img != null
                              ? Image.file(
                            File(img),
                            fit: BoxFit.cover,
                          ) : null,
                      ),
                        ),
                    ],
                  ),
                ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // const SizedBox(width: 20,),
                        ElevatedButton.icon(
                          onPressed: imageSelectorGallery,
                          icon: const Icon(
                            Icons.add_photo_alternate,
                            size: 24.0,
                          ),
                          label: const Text('Add from Gallery'),
                        ),
                        const SizedBox(width: 20,),
                        ElevatedButton.icon(
                          label: const Text('Use Camera'),
                          icon: const Icon(
                            Icons.camera_alt,
                            size: 24.0,
                          ),
                          onPressed: imageSelectorFromCamera,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          // );
        },
      ),
    );
  }
}


class NewScreen extends StatelessWidget {
  final File image;
  const NewScreen({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Image img = Image.file(image);
    Completer<ui.Image> completer = Completer<ui.Image>();
    img.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
            (ImageInfo info, bool synchronousCall) => completer.complete(info.image)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full screen Image'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          // Expanded(child: Center(child: img)),
          Expanded(child: Center(child: img)),
          const SizedBox(height: 8,),
          FutureBuilder<ui.Image>(
            future: completer.future,
            builder: (BuildContext context, AsyncSnapshot<ui.Image> snapshot) {
              if (snapshot.hasData) {
                return Text(
                  'Image width: ${snapshot.data!.width}\n'
                  'Image height: ${snapshot.data!.height}',
                  style: const TextStyle(fontSize: 20,),
                );
              } else {
                return const Text('Loading...');
              }
            },
          ),
        ],
      ),
    );
  }

}





/**
class ImageFromGalleryEx extends StatefulWidget {
  final type;
  ImageFromGalleryEx(this.type);

  @override
  State<ImageFromGalleryEx> createState() => ImageFromGalleryExState(this.type);
}

class ImageFromGalleryExState extends State<ImageFromGalleryEx> {
  var _image;
  var imagePicker;
  var type;

  ImageFromGalleryExState(this.type);

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(type == ImageSourceType.camera
              ? "Image from Camera"
              : "Image from Gallery")),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 52,),
          Center(
            child: GestureDetector(
              onTap: () async {
                var source = type == ImageSourceType.camera
                    ? ImageSource.camera
                    : ImageSource.gallery;
                XFile image = await imagePicker.pickImage(
                    source: source, imageQuality: 50, preferredCameraDevice: CameraDevice.front);
                setState(() {
                  _image = File(image.path);
                });
              },
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.red[200]),
                child: _image != null
                    ? Image.file(
                  _image,
                  width: 200.0,
                  height: 200.0,
                  fit: BoxFit.fitHeight,
                )
                    : Container(
                  decoration: BoxDecoration(
                      color: Colors.red[200]),
                  width: 200,
                  height: 200,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

**/