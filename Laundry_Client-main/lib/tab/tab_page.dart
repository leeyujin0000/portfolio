import 'package:flutter/material.dart';
import 'package:laundry/tab/home/home_page.dart';
import 'package:laundry/tab/matching/matching_page.dart';
import 'package:laundry/tab/mypost/myposts_page.dart';

class TabPage extends StatefulWidget {
  static int currentIndex = 0;

  const TabPage({super.key});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> {

  final pages = [
    const HomePage(),
    const MyPostsPage(),
    const MatchingPage()
  ];

  @override
  void initState() {
    super.initState();
    // getUserDeviceToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[TabPage.currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 1.0))
        ),
        child: BottomNavigationBar(
          currentIndex: TabPage.currentIndex,
          onTap: (index) {
            setState(() {
              TabPage.currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0,
          selectedItemColor: Colors.orangeAccent,
          selectedFontSize: 12.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2_outlined),
              label: '내 구인글'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline),
              label: '매칭'
            ),
          ],
        ),
      ),
    );
  }
}
