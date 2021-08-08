import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgetPass extends StatefulWidget {
  @override
  _ForgetPassState createState() => _ForgetPassState();
}

class _ForgetPassState extends State<ForgetPass> {
  @override
  String _email, _password;
  final auth = FirebaseAuth.instance;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Reset Password",
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
                      _email = value.trim();
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
                      labelText: "New Password",
                    ),
                    onChanged: (value) {
                      _password = value.trim();
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
                    onChanged: (value) {},
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
                      if (_email != null && _password != null) {
                        auth
                            .signInWithEmailAndPassword(
                                email: _email, password: _password)
                            .then((_) {
                          print("signed in");
                          Navigator.of(context)
                              .pushNamed('/update', arguments: _email);
                        });
                      } else {
                        print("not good");
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
