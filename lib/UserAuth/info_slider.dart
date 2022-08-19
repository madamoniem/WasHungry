import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart';

class TestScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Become a donor',
      subTitle: 'Quickly donate leftover food to those in need.',
      imageUrl: 'assets/images/d2.png',
      titleTextStyle: const TextStyle(
        fontFamily: "cextrabold",
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),
      subTitleTextStyle: const TextStyle(
        fontFamily: "cthin",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Introduction(
      title: 'Find a donor',
      subTitle:
          'Browse for nearby items and choose between delivery and pickup options.',
      imageUrl: 'assets/images/d3.png',
      titleTextStyle: const TextStyle(
        fontFamily: "cextrabold",
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),
      subTitleTextStyle: const TextStyle(
        fontFamily: "cthin",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Introduction(
      title: 'Volunteer',
      subTitle: 'Help process food and ensure the safety of your community.',
      imageUrl: 'assets/images/d4.png',
      titleTextStyle: const TextStyle(
        fontFamily: "cextrabold",
        fontWeight: FontWeight.bold,
        fontSize: 35,
      ),
      subTitleTextStyle: const TextStyle(
        fontFamily: "cthin",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    Introduction(
      title: 'Keep Track',
      subTitle: 'Compete with others for volunteer hours and donations.',
      imageUrl: 'assets/images/d5.png',
      titleTextStyle: const TextStyle(
        fontFamily: "cextrabold",
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
      subTitleTextStyle: const TextStyle(
        fontFamily: "cthin",
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  ];

  TestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: IntroScreenOnboarding(
        skipTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        backgroudColor: CustomColors.secondary,
        introductionList: list,
        onTapSkipButton: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserDashboard(),
            ), //MaterialPageRoute
          );
        },
      ),
    );
  }
}
