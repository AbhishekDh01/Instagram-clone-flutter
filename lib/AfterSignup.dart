import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

import 'package:my_insta/methods.dart';

class AfterSignup extends StatefulWidget {
  @override
  _AfterSignupState createState() => _AfterSignupState();
}

class _AfterSignupState extends State<AfterSignup> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String _profileUrl;
  File _file;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ))
          : SingleChildScrollView(
              child: Form(
                key: _key,
                child: Column(
                  children: [
                    profileImg(),
                    SizedBox(
                      height: 40,
                    ),
                    myField(size, 'Username', _username, errText: 'Required'),
                    myField(size, 'First Name', _fname, errText: 'Required'),
                    myField(size, 'Last Name', _lname, errText: 'Required'),
                    myField(size, 'Bio', _bio),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: SizedBox(
                          width: size.width / 1.6,
                          height: 34,
                          child: ElevatedButton(
                            child: Text("Done"),
                            onPressed: () {
                              _key.currentState.validate();
                              if (_username.text.isNotEmpty &&
                                  _fname.text.isNotEmpty &&
                                  _lname.text.isNotEmpty) {
                                setState(() {
                                  isLoading = true;
                                });

                                addUserData(_username.text, _fname.text,
                                        _lname.text, _bio.text, _profileUrl)
                                    .then((value) {
                                  if (value) {
                                    setState(() {
                                      showSnackBar(context,
                                          "Account Successfully created");
                                      isLoading = false;
                                      Navigator.of(context).pushNamed('signIn');
                                    });
                                  } else {
                                    setState(() {
                                      isLoading = false;
                                    });

                                    Navigator.of(context)
                                        .pushNamed('/AfterSignup');
                                    showSnackBar(context,
                                        "Something went wrong try again");
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget myField(Size size, String text, TextEditingController _cont,
      {String errText = null, int maxline = 1}) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 12, left: 12, right: 12),
          // height: 52,
          width: size.width / 1.1,
          alignment: Alignment.center,
          child: TextFormField(
            minLines: 1,
            maxLines: 3,
            keyboardType: TextInputType.multiline,
            validator: (value) {
              if (value.isEmpty)
                return errText;
              else
                return null;
            },
            controller: _cont,
            decoration: InputDecoration(
              labelText: text,
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }

  Widget profileImg() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: 60),
      child: Stack(
        children: [
          Container(
            height: 90,
            width: 90,
            child: CircleAvatar(
              backgroundImage: (_file == null)
                  ? AssetImage('images/dp1.png')
                  : FileImage(_file),
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 10, left: 8),
            height: 75,
            width: 75,
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

  Widget button(Size size, String text, {GlobalKey<FormState> formkey}) {
    return Container(
      padding: EdgeInsets.only(top: 20.0),
      child: Center(
        child: SizedBox(
          width: size.width / 1.6,
          height: 34,
          child: ElevatedButton(
            child: Text(text),
            onPressed: () {
              formkey.currentState.validate();
            },
          ),
        ),
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
        _profileUrl = value;
      });
    });
  }

  Future<String> getFuture() async {
    if (_file == null) return " ";
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
