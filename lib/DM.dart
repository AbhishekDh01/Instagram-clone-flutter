import 'package:flutter/material.dart';

import 'NavBar.dart';

class DM extends StatefulWidget {
  DM({
    Key key,
  }) : super(key: key);
  @override
  _DMState createState() {
    return _DMState();
  }
}

class _DMState extends State<DM> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Later",
          style: TextStyle(
            fontSize: 17,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {},
            iconSize: 28,
          ),
        ],
      ),
      body: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 6, left: 6, right: 6),
            child: SizedBox(
              width: 296,
              height: 42,
              child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                  ),
                  onSubmitted: (String str) {
                    print(str);
                  }),
            ),
          ),
          Chats(),
        ],
      ),
      bottomNavigationBar: BNav(),
    );
  }
}

class Chats extends StatelessWidget {
  final names = [
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
    'Right'
  ];
  final phrases = [
    'Hi there man',
    'ohh God this is so funny yr..',
    'see ya',
    'Ok Gud nyt',
    'thanks yrr for doing ..',
    'i don\'t  know what to say ..',
    'hi man how are you doing',
    'it is so boring when you don\'t know ..',
    'ya I\'m saying what to write',
    'ohh God this is so ..',
    'why only english ',
    'aur bhai kya haal chaal',
    'sab bhadiya?',
    'bas bas rahne de..'
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: 50,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (context, index) {
          index = index % 14;
          return ListTile(
            leading: Container(
              height: 44,
              width: 44,
              child: CircleAvatar(
                backgroundImage: AssetImage('./images/${index + 16}.jpeg'),
              ),
            ),
            title: Text(
              names[index],
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            subtitle: Text(
              phrases[index],
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {},
            ),
          );
        });
  }
}
