import 'package:flutter/material.dart';

import '../pages/latest_movies.dart';
import '../pages/categories.dart';
import '../pages/downloads.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentPageIndex = 0; //which page are we displaying

  Widget displayPage(int index) {
    //select which content to display
    if (index == 0) {
      return const LatestMovies();
    } else if (index == 1) {
      return const Categories();
    } else if (index == 2) {
      return const Downloads();
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,

          backgroundColor: Colors.transparent,
          // leading: const Icon(Icons.menu),
          actions: const [
            // IconButton(onPressed: null, icon: Icon(Icons.search)),
            IconButton(
                onPressed: null, icon: Icon(Icons.notifications_outlined))
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          currentIndex: currentPageIndex,
          selectedLabelStyle: const TextStyle(fontSize: 0),
          unselectedLabelStyle: const TextStyle(fontSize: 0),
          items: [
            BottomNavigationBarItem(
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF155672),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.home),
                ),
                icon: const Icon(Icons.home),
                label: ""),
            BottomNavigationBarItem(
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF155672),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.category),
                ),
                icon: const Icon(Icons.category),
                label: ""),
            BottomNavigationBarItem(
                activeIcon: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      color: const Color(0xFF155672),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.favorite),
                ),
                icon: const Icon(Icons.favorite),
                label: ""),
            // BottomNavigationBarItem(
            //     activeIcon: Container(
            //       width: 40,
            //       height: 40,
            //       decoration: BoxDecoration(
            //           color: const Color(0xFF155672),
            //           borderRadius: BorderRadius.circular(8)),
            //       child: const Icon(Icons.person),
            //     ),
            //     icon: const Icon(Icons.person),
            //     label: ""),
          ],
        ),
        body: displayPage(currentPageIndex));
  }
}
