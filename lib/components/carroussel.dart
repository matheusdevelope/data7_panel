import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/providers/caroussel_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Carousel extends StatelessWidget {
  final List<Widget> items;
  final CarouselController controller;
  Carousel({super.key, required this.items, required this.controller});
  late int _interval = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return Consumer<CarousselModel>(
                builder: (context, CarousselModel caroussel, c) {
                  if (_interval > 0 &&
                      _interval != caroussel.autoPlayDuration) {
                    controller.stopAutoPlay();
                    controller.startAutoPlay();
                  }
                  _interval = caroussel.autoPlayDuration;
                  return CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      height: height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: caroussel.autoplay,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayInterval:
                          Duration(milliseconds: caroussel.autoPlayDuration),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 500),
                      onPageChanged:
                          (int index, CarouselPageChangedReason reason) {
                        caroussel.currentIndex = index;
                        caroussel.itensCount = items.length;
                      },
                    ),
                    items: items,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class ControlsCarousel extends StatelessWidget {
  final bool autoplay;
  final int items;
  final int activeIndex;
  final CarouselController controller;
  late Function? onLeftArrow;
  late Function? onRightArrow;
  late Function? onIndicatorClick;
  ControlsCarousel({
    super.key,
    required this.autoplay,
    required this.items,
    required this.activeIndex,
    required this.controller,
    this.onLeftArrow,
    this.onRightArrow,
    this.onIndicatorClick,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items == 0
          ? []
          : [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  controller.previousPage();
                  if (onIndicatorClick != null) onIndicatorClick!();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  items,
                  (index) => IconButton(
                    tooltip: (index + 1).toString(),
                    onPressed: () {
                      controller.stopAutoPlay();
                      controller.jumpToPage(index);
                      if (onLeftArrow != null) onLeftArrow!();
                      controller.startAutoPlay();
                    },
                    iconSize: 12,
                    icon: Icon(
                      Icons.circle,
                      color: activeIndex == index
                          ? Colors.blueAccent
                          : Colors.grey,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  controller.nextPage();
                  if (onRightArrow != null) onRightArrow!();
                },
              ),
            ],
    );
  }
}
