import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_insta/methods.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confirm = TextEditingController();
  //final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
                        field(size, "Email-id", _email),
                        field(size, "Password", _password, obsure: true),
                        field(
                          size,
                          "Confirm Password",
                          _confirm,
                        ),
                        Container(
                          padding: EdgeInsets.only(top: 14.0),
                          child: SizedBox(
                            width: size.width / 1.5,
                            height: 38,
                            child: ElevatedButton(
                              child: Text("Sign up"),
                              onPressed: () {
                                if (_email.text.isNotEmpty &&
                                    _password.text.isNotEmpty &&
                                    _confirm.text.isNotEmpty &&
                                    _password.text == _confirm.text) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  createAccount(_email.text, _password.text)
                                      .then((user) {
                                    if (user != null) {
                                      setState(() {
                                        isLoading = false;
                                      });

                                      Navigator.of(context)
                                          .pushNamed('/AfterSignup');
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      showSnackBar(
                                          context, "Some error Occured");
                                    }
                                  });
                                }
                                if (_password.text != _confirm.text) {
                                  showSnackBar(
                                      context, "Passwords don't match");
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 40),
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
                              TextSpan(text: 'Or Have an account?'),
                              TextSpan(
                                  text: 'Log in',
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamed('signIn');
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
    {bool obsure = false}) {
  return Container(
    padding: EdgeInsets.only(top: 12, left: 12, right: 12),
    height: 50,
    width: size.width / 1.1,
    alignment: Alignment.center,
    child: TextFormField(
      controller: cont,
      obscureText: obsure,
      decoration: InputDecoration(
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
