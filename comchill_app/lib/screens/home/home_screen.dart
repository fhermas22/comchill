import 'package:flutter/material.dart';
import 'package:comchill_app/screens/home/tabs/contacts_tab.dart';
import 'package:comchill_app/screens/home/tabs/discussions_tab.dart';
import 'package:comchill_app/screens/home/tabs/ia_tab.dart';
import 'package:comchill_app/screens/home/tabs/archive_screen.dart';
import 'package:comchill_app/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;


  // Initialisation de la liste avec vos classes externes
  final List<Widget> _screens = const [
    DiscussionTabScreen(),
    ArchivedChatsScreen(),
    ContactsTabScreen(),
    IaTabScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: primaryColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.add, color: surfaceColor, size: 30),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryTextColor,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Discussion',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive_outlined),
            activeIcon: Icon(Icons.chat_bubble),
            label: '  Archives',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts_outlined),
            activeIcon: Icon(Icons.contacts),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.smart_toy_outlined),
            activeIcon: Icon(Icons.smart_toy),
            label: 'ChatBot',
          ),
        ],
      ),
    );
  }
}
