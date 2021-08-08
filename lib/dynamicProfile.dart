import 'package:flutter/material.dart';
import 'NavBar.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'methods.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class DynamicProfile extends StatefulWidget {
  final String data;
  DynamicProfile({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  _DynamicProfileState createState() {
    return _DynamicProfileState();
  }
}

class _DynamicProfileState extends State<DynamicProfile> {
  Map<String, dynamic> user;
  bool isLoading = true;
  String msg = "";
  int cnt = 0;
  @override
  void initState() {
    super.initState();
    test().then((val) {
      setState(() {
        msg = (val) ? "Unfollow" : "Follow";
      });
    });
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
                  height: 220,
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
                              backgroundImage: NetworkImage(user['profileUrl']),
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
                                (int.parse(user['followers']) + cnt).toString(),
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 150.0,
                                height: 28.0,
                                child: ElevatedButton(
                                  child: Text(msg),
                                  onPressed: () {
                                    test().then((value) {
                                      if (value == true) {
                                        removeUserFollower(widget.data);
                                        removeCurrentUserFollowings(
                                            widget.data);
                                        updateDynamicUserFollowersNum(
                                            widget.data, -1);
                                        updateCurrentUserFollowingNum(
                                            widget.data, -1);
                                        setState(() {
                                          msg = "Follow";
                                          cnt = -1;
                                        });
                                      } else {
                                        addUserFollowers(widget.data);
                                        addCurrentUserFollowings(widget.data);
                                        updateDynamicUserFollowersNum(
                                            widget.data, 1);
                                        updateCurrentUserFollowingNum(
                                            widget.data, 1);
                                        setState(() {
                                          msg = "Unfollow";
                                          cnt = 1;
                                        });
                                      }
                                    });
                                  },
                                ),
                              ),
                              SizedBox(
                                width: 150.0,
                                height: 28.0,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white60),
                                  ),
                                  child: Text('Message',
                                      style: TextStyle(color: Colors.black87)),
                                  onPressed: () {},
                                ),
                              ),
                            ],
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
                post(),
              ],
            ),
      bottomNavigationBar: BNav(),
    );
  }

  Future<bool> test() async {
    return await isCurrentUserFollower(widget.data);
  }

  Future<Map<String, dynamic>> getFromFuture() async {
    return await getUserDataDynamic(widget.data);
  }

  Widget post() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(widget.data)
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
