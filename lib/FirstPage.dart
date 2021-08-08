import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 200),
              child: Center(
                child: Text(
                  "Instagram",
                  style: TextStyle(
                    fontFamily: 'Mine',
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                    fontSize: 56.0,
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 180),
              child: SizedBox(
                width: 300.0,
                height: 34.0,
                child: ElevatedButton(
                  child: Text("Log in"),
                  onPressed: () {
                    Navigator.of(context).pushNamed('signIn');
                  },
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 38.0),
              child: SizedBox(
                width: 300.0,
                height: 34.0,
                child: ElevatedButton(
                  child: Text("Sign up"),
                  onPressed: () {
                    // color:
                    // Colors.black;
                    Navigator.of(context).pushNamed('./signUp');
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
