import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> items;
  const Carousel({super.key, required this.items});
  @override
  State<Carousel> createState() => _Carousel();
}

class _Carousel extends State<Carousel> {
  final CarouselController _controller = CarouselController();

  int _currentIndex = 0;
  bool _autoplay = true;

  void _onCarouselChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onArrowPressed(bool forward) {
    if (forward) {
      _controller.nextPage();
    } else {
      _controller.previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Builder(
            builder: (context) {
              final double height = MediaQuery.of(context).size.height;
              return CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: _autoplay,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 500),
                  onPageChanged: _onCarouselChanged,
                ),
                items: widget.items,
              );
            },
          ),
        ),
        const SizedBox(height: 60, child: Text("Teste")),
        ControlsCarousel(
          activeIndex: _currentIndex,
          autoplay: _autoplay,
          items: widget.items.length,
          onLeftArrow: () {
            _controller.previousPage();
          },
          onRightArrow: () {
            _controller.nextPage();
          },
          onToggleButton: () {
            setState(() {
              _autoplay = !_autoplay;
            });
          },
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
}

class ControlsCarousel extends StatelessWidget {
  final bool autoplay;
  final int items;
  final int activeIndex;
  final Function onLeftArrow;
  final Function onRightArrow;
  final Function onToggleButton;
  const ControlsCarousel(
      {super.key,
      required this.autoplay,
      required this.items,
      required this.activeIndex,
      required this.onLeftArrow,
      required this.onRightArrow,
      required this.onToggleButton});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => onLeftArrow(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List<Container>.generate(
            items,
            (index) => Container(
              width: 8.0,
              height: 8.0,
              margin:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: activeIndex == index ? Colors.blueAccent : Colors.grey,
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              onToggleButton();
            },
            icon: Icon(autoplay ? Icons.toggle_on : Icons.toggle_off)),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => onRightArrow(),
        ),
      ],
    );
  }
}
