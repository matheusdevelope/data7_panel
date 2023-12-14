import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/components/render_panel.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<CarouselData> data;
  final CarouselController controller;
  Carousel({super.key, required this.data, required this.controller});
  late int _interval = 0;
  @override
  Widget build(BuildContext context) {
    final items = data.map((data) {
      return data.panels[0].isHorizontal
          ? RenderPanelsHorizontal(dataList: data.panels)
          : RenderPanelsVertical(
              dataList: data.panels,
            );
    }).toList();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return ListenableBuilder(
                listenable: settings.carousel,
                builder: (BuildContext context, Widget? child) {
                  int currentIndex =
                      settings.carousel.currentIndex + 1 >= data.length
                          ? data.length - 1
                          : settings.carousel.currentIndex;

                  int time = currentIndex == data.length - 1
                      ? data[0].duration
                      : currentIndex + 1 >= data.length
                          ? data[currentIndex].duration
                          : data[currentIndex + 1].duration;
                  time = time == 0 ? settings.carousel.autoPlayDuration : time;
                  if (_interval > 0 && _interval != time) {
                    controller.stopAutoPlay();
                    controller.startAutoPlay();
                  }
                  _interval = time;

                  return CarouselSlider(
                    carouselController: controller,
                    options: CarouselOptions(
                      height: height,
                      viewportFraction: 1.0,
                      enlargeCenterPage: false,
                      autoPlay: settings.carousel.autoplay &&
                          (settings.carousel.itensCount > 1 || data.length > 1),
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayInterval: Duration(seconds: _interval),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 500),
                      onPageChanged:
                          (int index, CarouselPageChangedReason reason) {
                        settings.carousel.currentIndex = index;
                        // settings.carousel.itensCount = data.length;
                        // if (data.length == 1) {
                        //   caroussel.autoplay = false;
                        // }
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
  late double? fontSize;
  ControlsCarousel(
      {super.key,
      required this.autoplay,
      required this.items,
      required this.activeIndex,
      required this.controller,
      this.onLeftArrow,
      this.onRightArrow,
      this.onIndicatorClick,
      this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: items <= 1
          ? []
          : [
              IconButton(
                iconSize: fontSize,
                color: Colors.black,
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
                  (index) => SizedBox(
                    width: (fontSize ?? 14),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      tooltip: (index + 1).toString(),
                      onPressed: () {
                        controller.jumpToPage(index);
                        if (onLeftArrow != null) onLeftArrow!();
                      },
                      iconSize: (fontSize ?? 24) - 4,
                      icon: Icon(
                        Icons.circle,
                        color: activeIndex == index ? null : Colors.grey[200],
                      ),
                    ),
                  ),
                ),
              ),
              IconButton(
                iconSize: fontSize,
                color: Colors.black,
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
