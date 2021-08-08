import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'NavBar.dart';
import 'methods.dart';

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  File _file;
  String _postUrl;
  final TextEditingController _location = TextEditingController();
  final TextEditingController _caption = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white54,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Add Post',
          style: TextStyle(
            fontFamily: "Mine",
            fontSize: 34,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 30.0,
            onPressed: () {
              if (_file != null) {
                if (_location.text.isEmpty) _location.text = ' ';
                if (_caption.text.isEmpty) _caption.text = ' ';
                addUserPost(_location.text, _caption.text, _postUrl).then((_) {
                  showSnackBar(context, "Post Uploaded Successfully");
                  updateCurrentUserPostNum();
                  Navigator.of(context).pushNamed('/.Profile');
                });
              } else
                showSnackBar(context, "Please Select Image");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BoxImg(size),
            SizedBox(
              height: 12,
            ),
            myField(size, "Add location", _location),
            myField(size, "Caption", _caption, maxline: 2, h: 88),
          ],
        ),
      ),
      bottomNavigationBar: BNav(),
    );
  }

  Widget BoxImg(Size size) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 10),
      child: Stack(
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.grey),
              ),
              height: 360,
              width: size.width / 1.05,
              child: Image(
                image: (_file == null)
                    ? AssetImage('images/select3.jpeg')
                    : FileImage(_file),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 8),
            height: 360,
            width: size.width / 1.05,
            child: InkWell(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: SingleChildScrollView(
                          child: Row(
                            children: [
                              TextButton.icon(
                                  onPressed: () {
                                    galleryImg(ImageSource.camera);
                                  },
                                  icon: Icon(
                                    Icons.camera_alt_outlined,
                                  ),
                                  label: Text(
                                    "Camera",
                                  )),
                              TextButton.icon(
                                  onPressed: () {
                                    galleryImg(ImageSource.gallery);
                                  },
                                  icon: Icon(Icons.image),
                                  label: Text("Gallery")),
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ),
        ],
      ),
    );
  }

  void galleryImg(ImageSource choice) async {
    final ImagePicker _picker = ImagePicker();

    final image = await _picker.pickImage(source: choice);
    File _temp = File(image.path);

    setState(() {
      _file = _temp;
      getFuture().then((value) {
        _postUrl = value;
      });
    });
  }

  Widget myField(Size size, String text, TextEditingController _cont,
      {int maxline = 1, String initial = null, double h = 52}) {
    return Container(
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      width: size.width / 1.02,
      height: h,
      alignment: Alignment.center,
      child: TextFormField(
        minLines: 1,
        maxLines: maxline,
        keyboardType: TextInputType.multiline,
        controller: _cont..text = initial,
        decoration: InputDecoration(
          labelText: text,
          //  contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Future<String> getFuture() async {
    if (_file == null) return null;
    return await uploadImg(_file);
  }
}

void showSnackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    content: Text(msg,
        style: TextStyle(
          color: Colors.blue,
        )),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
