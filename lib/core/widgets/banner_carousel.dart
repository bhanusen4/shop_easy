import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  int _currentIndex = 0;

  final List<String> banners = [
    'assets/banners/banner1.png',
    'assets/banners/banner1.png',
    'assets/banners/banner1.png',

  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            viewportFraction: 1,
            autoPlayInterval: const Duration(seconds: 3),
            onPageChanged: (index, _) {
              setState(() => _currentIndex = index);
            },
          ),
          items: banners.map((image) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 8,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          }).toList(),

        ),

       // const SizedBox(height: 10),

        /// Indicators
        Positioned(
          bottom: 10,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: banners.asMap().entries.map((entry) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentIndex == entry.key ? 10 : 5,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: _currentIndex == entry.key
                      ? AppColors.blackColor
                      : Colors.grey.shade500,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
