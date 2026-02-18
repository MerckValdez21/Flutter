
import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'listOfUsers.dart';

class Homepage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePageHome(),
    );
  }
}

class HomePageHome extends StatefulWidget{
  @override
  State<HomePageHome> createState() => _HomePageHomeState();
}

class _HomePageHomeState extends State<HomePageHome> {
  var selectedIndex = 0;
  var screens = [Dashboard(), ListOfUsers()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (int index){
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Users'
            )
          ]
      ),
    );
  }
}
