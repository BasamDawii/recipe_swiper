import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';


class CarouselSliderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: double.infinity,
        viewportFraction: 1.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.easeInOut,
        aspectRatio: MediaQuery.of(context).size.aspectRatio,
        enlargeCenterPage: false,
        scrollDirection: Axis.horizontal,
      ),
      items: [
        'assets/images/food1.jpg',
        'assets/images/food2.jpg',
        'assets/images/food3.jpg',
        'assets/images/food4.jpg'
      ].map((imagePath) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
            ),
          ),
        );
      }).toList(),
    );
  }
}

