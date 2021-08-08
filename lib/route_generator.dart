import 'package:flutter/material.dart';
import 'package:my_insta/AfterSignup.dart';
import 'package:my_insta/Search.dart';
import 'package:my_insta/dynamicProfile.dart';
import 'FirstPage.dart';
import 'signUp.dart';
import 'SignIn.dart';
import 'Home.dart';
import 'Search.dart';
import 'Profile.dart';
import 'DM.dart';
import 'forgetPassword.dart';
import 'updatePass.dart';
import 'EditProfile.dart';
import 'AfterSignup.dart';
import 'addPost.dart';
import 'dynamicProfile.dart';

class RouteGenertor {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => FirstPage());
      case './signUp':
        return MaterialPageRoute(builder: (_) => SignUp());
      case './forget':
        return MaterialPageRoute(builder: (_) => ForgetPass());
      case 'signIn':
        return MaterialPageRoute(builder: (_) => SignIn());
      case '/update':
        return MaterialPageRoute(builder: (_) => UpdatePass());
      case '/AfterSignup':
        return MaterialPageRoute(builder: (_) => AfterSignup());
      case 'EditProfile':
        return MaterialPageRoute(builder: (_) => EditProfile());
      case 'addPost':
        return MaterialPageRoute(builder: (_) => AddPost());
      case 'Home':
        return MaterialPageRoute(builder: (_) => Home());

      case '/.Search':
        return MaterialPageRoute(builder: (_) => Search());

      case '/.add':
        return MaterialPageRoute(builder: (_) => AddPage());
      case '/.Profile':
        return MaterialPageRoute(builder: (_) => Profile());

      case 'DM':
        return MaterialPageRoute(builder: (_) => DM());
      case 'dynamic':
        if (args is String) {
          return MaterialPageRoute(builder: (_) => DynamicProfile(data: args));
        }
        return _errorRoute();
      // case './second':
      //   if (args is String) {
      //     return MaterialPageRoute(
      //       builder: (_) => SecondPage(
      //         data: args,
      //       ),
      //     );
      //   }
      //   return _errorRoute();
      default:
        return _errorRoute();
      // return _errorRoute(); // or can use error page
    }
  }
}

Route<dynamic> _errorRoute() {
  return MaterialPageRoute(builder: (_) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error Page"),
      ),
      body: Center(
        child: Text(
          "Error",
          style: TextStyle(
            fontSize: 40,
            color: Colors.blue,
          ),
        ),
      ),
    );
  });
}

class AddPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feature page"),
      ),
      body: Column(
        children: [
          Center(
              child: Text(
            "Would apply later +_+",
            style: TextStyle(
              fontSize: 40,
              color: Colors.blue,
            ),
          )),
          Container(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: SizedBox(
                width: 338.0,
                height: 34.0,
                child: ElevatedButton(
                  style: ButtonStyle(),
                  child: Text("Go to Home Page"),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/');
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
