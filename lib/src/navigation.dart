import 'package:flutter/material.dart';
import 'package:subscriba/src/home/home_view.dart';

class Navigation extends StatefulWidget {
  const Navigation({super.key});

  @override
  State<StatefulWidget> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.toc),
            icon: Icon(Icons.toc_outlined),
            label: 'Subsctiptions',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.info),
            icon: Icon(Icons.info_outline),
            label: 'About',
          )
        ],
        selectedIndex: currentIndex,
        onDestinationSelected: setCurrentIndex,
      ),
      body: [const HomeView(), Container(), Container()][currentIndex],
    );
  }
}
