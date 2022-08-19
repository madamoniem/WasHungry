import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intro_screen_onboarding_flutter/intro_app.dart';
import 'package:washungrystable/customwidgets.dart';
import 'package:washungrystable/userdashboard.dart';

class CongratsScreen extends StatelessWidget {
  final List<Introduction> list = [
    Introduction(
      title: 'Congrats',
      subTitle:
          'Congratulations on posting your donation. Keep an eye on your notifications and the donations tab.',
      imageUrl: 'assets/images/d6.png',
      titleTextStyle: const TextStyle(
        fontFamily: "cextrabold",
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
      subTitleTextStyle: const TextStyle(
        fontFamily: "cthin",
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
  ];

  CongratsScreen({Key? key}) : super(key: key);

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
