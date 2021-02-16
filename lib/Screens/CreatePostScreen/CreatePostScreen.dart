import 'dart:io';

import 'package:Hooked/Screens/BasicUI/ImageViewModal.dart';
import 'package:Hooked/models/post.dart';
import 'package:exif/exif.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_material_pickers/flutter_material_pickers.dart';
import 'package:image_picker/image_picker.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';

class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final TextEditingController _contentController = TextEditingController();

  File _image;
  bool _keyBoardisOpenned = false;
  String _currentFish;

  List<String> selectedFish = [
    "Bass",
    "Peacock Bass"
  ];



  @override
  void initState() {
    super.initState();
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyBoardisOpenned = visible;
        });
      },
    );
  }

  getImageByGallery() async {
    var image = await ImagePicker().getImage(source: ImageSource.gallery);
    var fixedImage = await rotateAndCompressAndSaveImage(File(image.path));

    setState(() {
      _image = fixedImage;
    });
  }

  getImageByCamera() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);
    var fixedImage = await rotateAndCompressAndSaveImage(File(image.path));

    setState(() {
      _image = fixedImage;
    });
  }

  _submitCatch(BuildContext context) async {
    final pic = _image;
    final createdTime = DateTime.now().toUtc();
    final id = FirebaseAuth.instance.currentUser.uid + createdTime.toString();
    final imageRef = "postPics/$id";
    String uploadurl;

    try {
      await FirebaseStorage.instance.ref(imageRef).putFile(pic);
      uploadurl = await FirebaseStorage.instance.ref(imageRef).getDownloadURL();
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Failed to upload Image"),
          actions: [FlatButton(onPressed: null, child: Text("Close"))],
        ),
      );
    }

    final post = Post(FirebaseAuth.instance.currentUser.uid,
        _contentController.text, uploadurl, _currentFish, createdTime);
    Post.createPost(post);
  }

  Widget addButtonWithChecker(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          child: Icon(Icons.add_a_photo),
          onPressed: () {
            showModalBottomSheet(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(10),
                      topLeft: Radius.circular(10))),
              context: context,
              builder: (context) => imageChooser(context),
            );
          },
        ),
      ),
    );
  }

  Container imageChooser(BuildContext context) {
    return Container(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),
          FloatingActionButton(
              heroTag: 1,
              child: Icon(Icons.camera_alt),
              onPressed: () {
                getImageByCamera();
                Navigator.of(context).pop();
              }),
          Spacer(),
          FloatingActionButton(
              heroTag: 2,
              child: Icon(Icons.source),
              onPressed: () {
                getImageByGallery();
                Navigator.of(context).pop();
              }),
          Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: Text("New Catch"),
        ),
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus.unfocus(),
          child: Stack(children: [
            SingleChildScrollView(
              child: _image != null ? postForm(context) : Container(),
            ),
            _image == null
                ? Center(
                    child: Text(
                    "Please Submit A Picture Of Your Catch",
                    overflow: TextOverflow.visible,
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center,
                  ))
                : Container(),
            !_keyBoardisOpenned ? addButtonWithChecker(context) : Container(),
            !_keyBoardisOpenned &&
                    (_image != null && _contentController.text != "")
                ? addPhotobutton(context)
                : Container()
          ]),
        ),
      ),
    );
  }

  Align addPhotobutton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RaisedButton(
          onPressed: () {
            _submitCatch(context);
            Navigator.of(context).pop();
          },
          child: Text("Post Catch"),
          color: Colors.green,
        ),
      ),
    );
  }

  Column postForm(BuildContext context) {
    var selectedItem = "Bass";
    return Column(
      children: [
        TextField(
          controller: _contentController,
          enabled: _image != null,
          minLines: 2,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            hintText: 'description',
            hintStyle: TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(0)),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              _currentFish == null ? Text("Please Select a Fish type") : Text("Selected Fish: " + _currentFish), 
              Spacer(),
              RaisedButton(child: Text("Select") ,onPressed: (){
                showMaterialScrollPicker(
                  context: context,
                  title: "Select a fish",
                  items: selectedFish,
                  selectedItem: selectedItem,
                  onChanged: (value) => setState(() => selectedItem = value),
                  onConfirmed: (){
                    _currentFish = selectedItem;
                  }
                );
              })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              GestureDetector(
                  child: Image.file(_image),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ImageViewModal(Image.file(_image)),
                        fullscreenDialog: true));
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                    heroTag: 3,
                    backgroundColor: Colors.red,
                    child: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    }),
              )
            ],
          ),
        )
      ],
    );
  }

  Future<File> rotateAndCompressAndSaveImage(File image) async {
    int rotate = 0;
    List<int> imageBytes = await image.readAsBytes();
    Map<String, IfdTag> exifData = await readExifFromBytes(imageBytes);

    if (exifData != null &&
        exifData.isNotEmpty &&
        exifData.containsKey("Image Orientation")) {
      IfdTag orientation = exifData["Image Orientation"];
      int orientationValue = orientation.values[0];

      if (orientationValue == 3) {
        rotate = 180;
      }

      if (orientationValue == 6) {
        rotate = -90;
      }

      if (orientationValue == 8) {
        rotate = 90;
      }
    }

    List<int> result = await FlutterImageCompress.compressWithList(imageBytes,
        quality: 100, rotate: rotate);

    await image.writeAsBytes(result);

    return image;
  }
}
