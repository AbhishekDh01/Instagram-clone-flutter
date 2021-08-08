import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'NavBar.dart';
import 'dart:math';

Widget getListView() {
  final names = [
    'IGTV',
    'Shop',
    'Style',
    'Sports',
    'Auto',
    'Game',
    'Songs',
    'Music',
    'Flutter'
  ];
  var listView = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        index = index % 9;
        return Column(
          children: <Widget>[
            Container(
              // ignore: deprecated_member_use
              child: FlatButton(
                onPressed: () {},
                child: Text(
                  names[index],
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              margin: EdgeInsets.all(8.0),
              width: 74,
              height: 23,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black45,
                    offset: Offset(0, 2),
                    blurRadius: 2.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
            ),
          ],
        );
      });
  return listView;
}

class Search extends StatefulWidget {
  final String data;
  Search({
    Key key,
    this.data,
  }) : super(key: key);
  @override
  _SearchState createState() {
    return _SearchState();
  }
}

class _SearchState extends State<Search> {
  bool newPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 6, left: 6),
                width: 300,
                height: 42,
                child: TextField(
                    onTap: () {
                      setState(() {
                        newPage = true;
                      });
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: "Search",
                    ),
                    onSubmitted: (String str) {
                      print(str);
                    }),
              ),
              Container(
                child: IconButton(
                  icon: Icon(Icons.add_box_outlined),
                  onPressed: () {},
                  iconSize: 36,
                  color: Colors.black54,
                ),
              )
            ],
          ),
          Container(
            width: double.infinity,
            height: 40.0,
            child: getListView(),
          ),
          (newPage) ? search() : Insta(),
        ],
      ),
      bottomNavigationBar: BNav(),
    );
  }

  Widget search() {
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
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: snapshot.data.size,
            itemBuilder: (context, index) {
              final data = snapshot.data.docs[snapshot.data.size - index - 1];
              return ListTile(
                onTap: () {
                  Navigator.of(context)
                      .pushNamed('dynamic', arguments: data.id);
                },
                leading: Container(
                  height: 44,
                  width: 44,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(data['profileUrl']),
                  ),
                ),
                title: Text(
                  data['displayName'],
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  data['firstName'],
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              );
            },
          );
        });
  }
}

class Insta extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Posts").snapshots(),
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
            staggeredTileBuilder: (index) => StaggeredTile.count(
                (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
          );
        });
  }
}

int myNum() {
  var random = Random();
  int luckyNum = random.nextInt(14); // 15 is boundary
  return luckyNum +
      1; // or your string to return " your lucky num is $luckynum";
}
