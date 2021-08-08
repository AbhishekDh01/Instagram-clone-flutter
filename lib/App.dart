import 'package:flutter/material.dart';
import 'route_generator.dart';
import 'package:firebase_core/firebase_core.dart';

class App extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _fbApp,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("you have an error! ${snapshot.error.toString()}");
            return Center(
              child: Text(
                "Please turn you data on",
                style: TextStyle(
                  fontSize: 40,
                  color: Colors.black,
                ),
              ),
            );
          } else if (snapshot.hasData) {
            print("firebase intialize successfully");
            return MaterialApp(
              title: "Insta by Abhi",
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              initialRoute: '/',
              onGenerateRoute: RouteGenertor.generateRoute,
              // home: FirstPage(),
            );
          } else {
            print("waiting");
            return Center(
                child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ));
          }
        });
  }
}
