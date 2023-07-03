import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movie_show/common/constants.dart';
import 'package:movie_show/presentation/pages/dashboard_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kRichBlack,
      body: Center(
        child: Image.asset('assets/movie-show-bg.png'),
      ),
    );
  }
}
