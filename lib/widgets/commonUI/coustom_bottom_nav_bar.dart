import 'package:bidding_app/utils/constants.dart';
import 'package:bidding_app/utils/routing/RoutingUtils.dart';
import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.index,
  }) : super(key: key);
  final int index;

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  @override
  void initState() {
    _currentIndex = widget.index;
    super.initState();
  }

  void onTabTapped(int index) {
    if (_currentIndex != index) {
      setState(() {
        _currentIndex = index;
      });
      Navigator.pushReplacementNamed(
          context, Routes.bottomNavBarRoutes[_currentIndex]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: onTabTapped,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Color(0xFFB6B6B6),
      elevation: 10.0,
      showSelectedLabels: false,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: "Shop"),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded), label: "Favorites"),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded), label: "Account"),
      ],
    );
  }
}
