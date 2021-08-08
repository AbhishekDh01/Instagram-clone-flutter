import 'dart:io';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/material.dart';

import 'package:my_insta/methods.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _fname = TextEditingController();
  final TextEditingController _lname = TextEditingController();
  final TextEditingController _bio = TextEditingController();

  Map<String, dynamic> user;
  String _profileUrl;
  File _file;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    getFromFuture().then((value) {
      setState(() {
        user = value;
        isLoading = false;
      });
    });
  }

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
              child: Column(
                children: [
                  profileImg(),
                  SizedBox(
                    height: 40,
                  ),
                  myField(size, 'Username', _username,
                      initial: user['displayName']),
                  myField(size, 'First Name', _fname,
                      initial: user['firstName']),
                  myField(size, 'Last Name', _lname, initial: user['lastName']),
                  myField(size, 'Bio', _bio, initial: user['bio']),
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
                            setState(() {
                              isLoading = true;
                            });
                            setState(() {
                              if (_username.text.isNotEmpty) {
                                updateUserData(
                                    data: _username.text, choice: '1');
                              }
                              if (_fname.text.isNotEmpty) {
                                updateUserData(data: _fname.text, choice: '2');
                              }
                              if (_lname.text.isNotEmpty) {
                                updateUserData(data: _lname.text, choice: '3');
                              }
                              if (_bio.text.isNotEmpty) {
                                updateUserData(data: _bio.text, choice: '4');
                              }
                              if (_profileUrl != null) {
                                updateUserData(data: _profileUrl, choice: '5');
                              }
                              Navigator.of(context).pushNamed('/.Profile');
                            });
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(
                      child: SizedBox(
                        width: size.width / 1.6,
                        height: 34,
                        child: ElevatedButton(
                            child: Text(" Or Update Password"),
                            onPressed: () {
                              Navigator.of(context).pushNamed('/update');
                            }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget myField(Size size, String text, TextEditingController _cont,
      {int maxline = 1, String initial = null}) {
    return Container(
      padding: EdgeInsets.only(top: 12, left: 12, right: 12),
      width: size.width / 1.1,
      height: 52,
      alignment: Alignment.center,
      child: TextFormField(
        minLines: 1,
        maxLines: 2,
        keyboardType: TextInputType.multiline,
        controller: _cont..text = initial,
        decoration: InputDecoration(
          labelText: text,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
          border: OutlineInputBorder(),
        ),
      ),
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
                  ? NetworkImage(user['profileUrl'])
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
    if (_file == null) return null;
    return await uploadImg(_file);
  }

  Future<Map<String, dynamic>> getFromFuture() async {
    return await getUserData();
  }
}

void showSnackBar(BuildContext context, String msg) {
  var snackBar = SnackBar(
    backgroundColor: Colors.grey,
    content: Text(msg,
        style: TextStyle(
          color: Colors.blue,
        )),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
