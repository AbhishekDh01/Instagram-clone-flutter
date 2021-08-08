import 'package:flutter/material.dart';

class BNav extends StatefulWidget {
  @override
  _BNavState createState() {
    return _BNavState();
  }
}

class _BNavState extends State<BNav> {
  int _currentIndex = 0;
  List<String> temp;
  final route = ['Home', '/.Search', 'addPost', '/.add', '/.Profile'];
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex, // which item to to selected default
      selectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed, // if not want howered //
      unselectedItemColor: Colors.black54,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home, size: 28),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search, size: 28),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_rounded, size: 28),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_rounded, size: 28),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person, size: 28),
          label: "",
        ),
      ],
      onTap: (index) {
        // onTap fn which take one parameter
        setState(() {
          // to scroll on bottom navigation bar
          _currentIndex = index;
          Navigator.of(context).pushNamed(route[index]);
        });
      },
    );
  }
}
