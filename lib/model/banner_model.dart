import 'package:flutter/material.dart';

class BannerModel {
  String text;
  List<Color> cardBackground;
  String image;

  BannerModel(this.text, this.cardBackground, this.image);
}

List<BannerModel> bannerCards = [
  BannerModel(
      "Nothing can dim the light that shines from within",
      [
        const Color(0xffa1d4ed),
        const Color(0xffc0eaff),
      ],
      "assets/414-bg.png"),
  BannerModel(
      "Happiness is not something ready-made",
      [
        const Color(0xffb6d4fa),
        const Color(0xffcfe3fc),
      ],
      "assets/covid-bg.png"),
];
