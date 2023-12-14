import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/components/carousel.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'legends.dart';

class CustomBottomAppBar extends StatelessWidget {
  const CustomBottomAppBar(
      {super.key,
      required this.legends,
      required this.lastTimeSync,
      required this.controller});
  final String legends;
  final String lastTimeSync;
  final CarouselController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel theme, c) {
        return BottomAppBar(
          padding: const EdgeInsets.only(top: 8),
          shape: const CircularNotchedRectangle(),
          child: Container(
              padding:
                  const EdgeInsets.only(top: 2, bottom: 2, left: 8, right: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (MediaQuery.of(context).size.width <= 450)
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: ListenableBuilder(
                            listenable: settings.carousel,
                            builder: (BuildContext context, Widget? child) {
                              return ControlsCarousel(
                                controller: controller,
                                activeIndex: settings.carousel.currentIndex,
                                autoplay: settings.carousel.autoplay,
                                items: settings.carousel.itensCount,
                                fontSize: theme.fontSizeMenuPanel,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Legends(
                          legends: legends,
                          fontSize: theme.fontSizeMenuPanel,
                        ),
                      ),
                      if (MediaQuery.of(context).size.width > 450)
                        Expanded(
                          flex: 1,
                          child: ListenableBuilder(
                            listenable: settings.carousel,
                            builder: (BuildContext context, Widget? child) {
                              return ControlsCarousel(
                                controller: controller,
                                activeIndex: settings.carousel.currentIndex,
                                autoplay: settings.carousel.autoplay,
                                items: settings.carousel.itensCount,
                                fontSize: theme.fontSizeMenuPanel,
                              );
                            },
                          ),
                        ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          lastTimeSync,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: theme.fontSizeMenuPanel),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}
