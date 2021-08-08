import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  final String data;
  Profile({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  _ProfileState createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<Profile> {
  Map<String, dynamic> user;
  User currentUser = FirebaseAuth.instance.currentUser;
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
    return Scaffold(
      body: isLoading
          ? Center(
              child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ))
          : ListView(
              physics: AlwaysScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 248,
                  child: Column(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  WidgetSpan(child: Icon(Icons.lock, size: 16)),
                                  TextSpan(
                                    text: " ${user['displayName']} ",
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black),
                                  ),
                                  WidgetSpan(
                                    child:
                                        Icon(Icons.arrow_drop_down, size: 16),
                                  )
                                ],
                              ),
                            ),
                          )),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(left: 5, top: 10),
                            height: 90,
                            width: 90,
                            child: CircleAvatar(
                              backgroundImage: (user['profileUrl'] == " ")
                                  ? AssetImage('images/dp1.png')
                                  : NetworkImage(user['profileUrl']),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                user['postNo'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Text('Posts')
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                user['followers'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Text('Followers')
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Text(
                                user['following'],
                                style: TextStyle(fontSize: 16),
                              ),
                              Text('Followings')
                            ],
                          ),
                        ],
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 12, top: 5),
                          alignment: Alignment.centerLeft,
                          child:
                              Text("${user['firstName']} ${user['lastName']}")),
                      Container(
                        padding: EdgeInsets.only(left: 12, top: 3),
                        alignment: Alignment.centerLeft,
                        child: Text(user['bio']),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Center(
                          child: SizedBox(
                            width: 338.0,
                            height: 28.0,
                            // ignore: deprecated_member_use
                            child: RaisedButton(
                              colorBrightness: Brightness.light,
                              color: Colors.white70,
                              textColor: Colors.black,
                              child: Text("Edit Profile"),
                              onPressed: () {
                                Navigator.of(context).pushNamed('EditProfile');
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Divider(
                        height: 10,
                        thickness: 2,
                      )
                    ],
                  ),
                ),
                Insta(),
              ],
            ),
      bottomNavigationBar: BNav(),
    );
  }

  Future<Map<String, dynamic>> getFromFuture() async {
    return await getUserData();
  }
}

class Insta extends StatelessWidget {
  @override
  User currentUser = FirebaseAuth.instance.currentUser;
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .collection("posts")
            .orderBy('time')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
                child: Text(
              "Error",
              style: TextStyle(fontSize: 30.0),
            ));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(),
            ));
          }
          return StaggeredGridView.countBuilder(
            physics: NeverScrollableScrollPhysics(), // coz parent is scrollable
            shrinkWrap: true,
            crossAxisCount: 3,
            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              final data = snapshot.data.docs[snapshot.data.size - index - 1];
              return Container(
                padding: EdgeInsets.all(1),
                width: 100,
                height: 100,
                child: Image(
                  image: (data['postUrl'] != null)
                      ? NetworkImage(data['postUrl'])
                      : AssetImage('images/16.jpeg'),
                  fit: BoxFit.fill,
                ),
              );
            },
            staggeredTileBuilder: (index) => StaggeredTile.count(1, 1),
          );
        });
  }
}
