import 'package:flutter/material.dart';

class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents(
      {required this.title, required this.image, required this.desc});
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Created by Group 5",
    image: "assets/images/group.png",
    desc:
        "Putra Pradana Ardi Mahensa\nAfiyani Ma'rifah\nRahmah Nurfadilah\nMuhammad Fikri\nRendy Priyadi",
  ),
  OnboardingContents(
    title: "Let's make what's todos 📙",
    image: "assets/images/image1.png",
    desc: "Note, Work on and Done!",
  )
];

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenW;
  static double? screenH;
  static double? blockH;
  static double? blockV;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenW = _mediaQueryData!.size.width;
    screenH = _mediaQueryData!.size.height;
    blockH = screenW! / 100;
    blockV = screenH! / 100;
  }
}
