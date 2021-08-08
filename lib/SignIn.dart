import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'methods.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool isLoading = false;
  final auth = FirebaseAuth.instance;
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
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Center(
                      child: Text(
                        "Instagram",
                        style: TextStyle(
                          fontFamily: 'Mine',
                          fontSize: 51.0,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Column(
                      children: <Widget>[
                        field(size, "Email", _email),
                        field(size, "Password", _password, obsure: true),
                        Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 9, top: 12),
                          child: RichText(
                            text: TextSpan(
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Forget password?',
                                      style: TextStyle(color: Colors.blue),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Navigator.of(context)
                                              .pushNamed('./forget');
                                        })
                                ]),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: SizedBox(
                              width: size.width / 1.6,
                              height: 34,
                              child: ElevatedButton(
                                child: Text("Log in"),
                                onPressed: () {
                                  if (_email.text.isNotEmpty &&
                                      _password.text.isNotEmpty) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    login(_email.text, _password.text)
                                        .then((user) {
                                      if (user != null) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showSnackBar(
                                            context, "Login Successfully");
                                        Navigator.of(context).pushNamed('Home');
                                      } else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showSnackBar(context,
                                            "Inavlid Username or Password");
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
                  Container(
                    padding: EdgeInsets.only(top: 80),
                    child: Divider(
                      height: 10,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                            children: <TextSpan>[
                              TextSpan(text: "Or Don't Have an account?"),
                              TextSpan(
                                  text: 'Sign up',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushNamed('./signUp');
                                    })
                            ]),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 72),
                    child: Divider(
                      height: 10,
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 5),
                      child: Center(
                          child: Text(
                        "Instagram oT Facebook",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 12,
                        ),
                      ))),
                ],
              ),
            ),
    );
  }
}

Widget field(Size size, String text, TextEditingController cont,
    {bool obsure = false, String errText, String check}) {
  return Container(
    padding: EdgeInsets.only(top: 12, left: 12, right: 12),
    height: 50,
    width: size.width / 1.1,
    alignment: Alignment.center,
    child: TextField(
      controller: cont,
      obscureText: obsure,
      decoration: InputDecoration(
        errorText: (cont.text != check) ? errText : null,
        labelText: text,
        border: OutlineInputBorder(),
      ),
    ),
  );
}

void myAlert(BuildContext context) {
  var alertDialog = AlertDialog(
    title: Text("Invalid Username"),
    content: Text("Username length should be 8 to 16"),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
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
