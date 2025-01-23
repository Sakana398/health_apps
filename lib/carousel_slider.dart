import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:health_apps/model/banner_model.dart';

class Carouselslider extends StatelessWidget {
  const Carouselslider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: MediaQuery.of(context).size.width,
      child: CarouselSlider.builder(
        itemCount: bannerCards.length,
        itemBuilder: (context, index, realIndex) {
          return Container(
            height: 140,
            margin: const EdgeInsets.only(left: 0, right: 0, bottom: 20),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                stops: const [0.3, 0.7],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: bannerCards[index].cardBackground,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Image.asset(
                    bannerCards[index].image,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        bannerCards[index].text,
                        style: GoogleFonts.lato(
                          color: Colors.lightBlue[900],
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        softWrap: true,
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: Colors.lightBlue[900],
                      size: 25,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          enableInfiniteScroll: false,
          scrollPhysics: const ClampingScrollPhysics(),
        ),
      ),
    );
  }
}
