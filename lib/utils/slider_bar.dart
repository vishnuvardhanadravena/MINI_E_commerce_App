import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class BannerSliderWidget extends StatefulWidget {
  final List<String> banners;

  const BannerSliderWidget({super.key, required this.banners});

  @override
  State<BannerSliderWidget> createState() => _BannerSliderWidgetState();
}

class _BannerSliderWidgetState extends State<BannerSliderWidget> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider(
          items: widget.banners
              .map(
                (img) => ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(img, fit: BoxFit.contain, width: 1000),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: 160,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 1,
            onPageChanged: (i, _) => setState(() => index = i),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: index == i ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: index == i ? Colors.orange : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
