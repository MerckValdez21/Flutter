import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'ListOfUsers.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePageHome();
  }
}

class HomePageHome extends StatefulWidget {
  const HomePageHome({super.key});

  @override
  State<HomePageHome> createState() => _HomePageHomeState();
}

class _HomePageHomeState extends State<HomePageHome> {
  int selectedIndex = 0;

  // Use const constructors to avoid recreating widgets on every rebuild
  static const screens = [DashboardHome(), ListOfUsersScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 12,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() => selectedIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people_rounded),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}