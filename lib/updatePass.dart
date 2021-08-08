import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UpdatePass extends StatefulWidget {
  @override
  _UpdatePassState createState() => _UpdatePassState();
}

class _UpdatePassState extends State<UpdatePass> {
  String newPass;
  String _confirmPass;
  String email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white70,
        title: Text(
          "Update Password",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 150, left: 12, right: 12),
              child: Center(
                child: SizedBox(
                  width: 460,
                  height: 46,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email-Id",
                    ),
                    onChanged: (value) {
                      email = value.trim();
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
              child: Center(
                child: SizedBox(
                  width: 460,
                  height: 46,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "New Password",
                    ),
                    onChanged: (value) {
                      newPass = value.trim();
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
              child: Center(
                child: SizedBox(
                  width: 460,
                  height: 46,
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Confirm Password",
                    ),
                    onChanged: (value) {
                      _confirmPass = value.trim();
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 38.0),
              child: SizedBox(
                width: 300.0,
                height: 34.0,
                child: ElevatedButton(
                  child: Text("Continue"),
                  onPressed: () {
                    if (newPass.isNotEmpty &&
                        _confirmPass.isNotEmpty &&
                        email.isNotEmpty) {
                      _changePassword(newPass);
                      print("yes");
                      Navigator.of(context).pushNamed('/');
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _changePassword(String newPass) async {
  User user = await FirebaseAuth.instance.currentUser;
  user.updatePassword(newPass).then((_) {
    print("password changed");
  }).catchError((onError) {
    print("error $onError");
  });
}
