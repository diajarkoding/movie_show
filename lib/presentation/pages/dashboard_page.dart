import 'package:flutter/material.dart';
import 'package:movie_show/common/constants.dart';
import 'package:movie_show/presentation/pages/about_page.dart';
import 'package:movie_show/presentation/pages/movie/movie_page.dart';
import 'package:movie_show/presentation/pages/watchlist_page.dart';
import 'package:movie_show/presentation/pages/series/series_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  DashboardPageState createState() => DashboardPageState();
}

class DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MoviePage(),
    SeriesPage(),
    WatchlistPage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: kRichBlack,
        type: BottomNavigationBarType.fixed,
        iconSize: 20,
        selectedItemColor: kPrussianBlue,
        unselectedItemColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movie',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.tv),
            label: 'Series',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Watchlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
