import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:my_insta/methods.dart';
import 'gradient_ring_widget.dart';

import 'NavBar.dart';
import 'dart:math';

Widget getListView() {
  final names = [
    'Your Story',
    'Chirag',
    'Abhi',
    'Ashu',
    'Musan',
    'kieron',
    'Escanor',
    'Gon',
    'Rengoku',
    'Killua',
    'Monster',
    'Tenma',
    'Hanma',
    'Baki',
    'Right',
  ];

  var listView = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        index = index % 15;
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(8.0),
              width: 60,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black45,
                      offset: Offset(0, 2),
                      blurRadius: 6.0)
                ],
              ),
              child: WGradientRing(
                child: CircleAvatar(
                  backgroundImage: AssetImage('./images/${index + 16}.jpeg'),
                ),
              ),
            ),
            Container(
              child: Text(names[index]),
            ),
          ],
        );
      });
  return listView;
}

Widget getListViewer() {
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection("Users").snapshots(),
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
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: snapshot.data.size,
          itemBuilder: (context, index) {
            final data = snapshot.data.docs[snapshot.data.size - index - 1];
            return Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(8.0),
                  width: 60,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 6.0)
                    ],
                  ),
                  child: WGradientRing(
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(data['profileUrl']),
                    ),
                  ),
                ),
                Container(
                  child: Text(data['firstName']),
                ),
              ],
            );
          },
        );
      });
}

class Home extends StatefulWidget {
  final String data;
  Home({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Instagram',
          style: TextStyle(
            fontFamily: "Mine",
            fontSize: 34,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        leading: Container(
          padding: EdgeInsets.only(left: 5),
          child: IconButton(
            icon: Icon(Icons.camera_alt_outlined),
            iconSize: 30.0,
            onPressed: () {},
          ),
        ),
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.live_tv),
                    iconSize: 30.0,
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    iconSize: 30.0,
                    onPressed: () {
                      Navigator.of(context).pushNamed('DM');
                    },
                  ),
                ],
              )
            ],
          ),
        ],
      ),
      body: ListView(
        //  padding: EdgeInsets.symmetric(),
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            width: double.infinity,
            height: 100.0,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 6.0)
              ],
              color: Colors.white,
            ),
            child: getListViewer(),
          ),

          postGenerate(),
          // Post(
          //     userName: names[myNum()],
          //     userImg: "${myNum15()}",
          //     post: "${myNum()}",
          //     add: 'UP, India',
          //     likerImg: "${myNum15()}",
          //     likerName: names[myNum()],
          //     likesNum: '2222',
          //     quote: phrases[myNum()]),
        ],
      ),
      bottomNavigationBar: BNav(),
    );
  }

  Widget postGenerate() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Posts")
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
          return ListView.builder(
            physics: NeverScrollableScrollPhysics(), // coz parent is scrollable
            shrinkWrap: true,

            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              final data = snapshot.data.docs[snapshot.data.size - index - 1];
              return Post(
                  postId: data.id,
                  userName: "${data['firstName']} ${data['lastName']}",
                  userImg: data['profileUrl'],
                  post: data['postUrl'],
                  add: data['location'],
                  // likerImg: "${myNum15()}",
                  // likerName: names[myNum()],
                  likesNum: data['likes'],
                  quote: data['caption']);
            },
          );
        });
  }
}

class Post extends StatefulWidget {
  final String userImg;
  final String userName;
  final String add;
  final String post;
  final String likerImg;
  final String likerName;
  final String likesNum;
  final String quote;
  final String postId;

  Post(
      {Key key,
      @required this.userImg,
      @required this.userName,
      @required this.postId,
      this.add,
      @required this.post,
      this.likerImg,
      this.likerName,
      this.likesNum,
      this.quote})
      : super(key: key);
  @override
  _PostState createState() {
    return _PostState();
  }
}

class _PostState extends State<Post> {
  int cnt = 0;
  bool isliked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(top: 10),
          // width: size.width,
          // height: size.height / 1.14,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 4),
                blurRadius: 8.0,
              ),
            ],
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 5, left: 5),
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.userImg),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 5),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.userName, // here
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.add,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  //  width: size.width,
                  height: size.height / 1.4,
                  child: Image(
                      fit: BoxFit.fill, image: NetworkImage(widget.post) // here
                      ),
                ),
                Container(
                    child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.favorite),
                      iconSize: 28.0,
                      color: (isliked) ? Colors.red : Colors.grey,
                      onPressed: () {
                        onLikeButtonTapped();
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.chat_bubble_outline),
                      iconSize: 26.0,
                      onPressed: () {
                        showSnackBar(
                            context, "Would apply comments feature later");
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.send),
                      iconSize: 26.0,
                      onPressed: () {
                        showSnackBar(context, "Would apply this feature later");
                      },
                    ),
                  ],
                )),
                Container(
                  child: Row(
                    children: <Widget>[
                      (widget.likerImg != null)
                          ? Container(
                              padding: EdgeInsets.only(left: 10),
                              child: CircleAvatar(
                                radius: 12,
                                backgroundImage: AssetImage(
                                    (widget.likerImg != null)
                                        ? './images/${widget.likerImg}.jpeg'
                                        : ""),
                              ),
                            )
                          : Container(),
                      Container(
                          padding: EdgeInsets.only(left: 6),
                          child: Text((widget.likesNum != null)
                              ? " Liked by ${(int.parse(widget.likesNum) + cnt).toString()} "
                              : " "))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 13, top: 4),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.quote,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> onLikeButtonTapped() async {
    if (isliked == false) {
      await updatePostLikeNum(widget.postId, 1);
      setState(() {
        cnt = 0;
        isliked = !isliked;
      });
      showSnackBar(context, "You liked this Post");
    } else {
      updatePostLikeNum(widget.postId, -1);
      setState(() {
        cnt = 0;
        isliked = !isliked;
      });
    }
  }
}

int myNum() {
  var random = Random();
  int luckyNum = random.nextInt(14); // 13 is boundary
  return luckyNum +
      1; // or your string to return " your lucky num is $luckynum";
}

int myNum15() {
  var random = Random();
  int luckyNum = random.nextInt(14); // 13 is boundary
  return luckyNum +
      15; // or your string to return " your lucky num is $luckynum";
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
