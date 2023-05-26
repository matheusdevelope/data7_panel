import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomIncrease extends StatefulWidget {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final Function(double) onChange;
  final double? fontSize;
  CustomIncrease({
    super.key,
    this.label = '',
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChange,
    this.fontSize,
  });

  @override
  State<CustomIncrease> createState() => _CustomIncreaseState();
}

class _CustomIncreaseState extends State<CustomIncrease> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.label.isNotEmpty)
          Text(
            widget.label,
            style: TextStyle(
                fontSize: widget.fontSize, fontWeight: FontWeight.bold),
          ),
        Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey,
              style: BorderStyle.solid,
              width: 0.5,
            ),
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onLongPress: () => setState(() {
                  timer =
                      Timer.periodic(const Duration(milliseconds: 60), (timer) {
                    setState(() {
                      if (widget.value - 1 >= widget.minValue) {
                        widget.onChange(widget.value - 1);
                      }
                    });
                  });
                }),
                onLongPressEnd: (_) => setState(() {
                  timer?.cancel();
                }),
                child: IconButton(
                  padding: const EdgeInsets.only(right: 4),
                  constraints: const BoxConstraints(),
                  iconSize: widget.fontSize,
                  onPressed: () {
                    if (widget.value - 1 >= widget.minValue) {
                      widget.onChange(widget.value - 1);
                    }
                  },
                  icon: const Icon(Icons.remove, color: Colors.black),
                ),
              ),
              Text(
                widget.value.toString(),
                style: TextStyle(fontSize: widget.fontSize),
              ),
              GestureDetector(
                onLongPress: () => setState(() {
                  timer =
                      Timer.periodic(const Duration(milliseconds: 60), (timer) {
                    setState(() {
                      if (widget.value + 1 <= widget.maxValue) {
                        widget.onChange(widget.value + 1);
                      }
                    });
                  });
                }),
                onLongPressEnd: (_) => setState(() {
                  timer?.cancel();
                }),
                child: IconButton(
                  padding: const EdgeInsets.only(
                    left: 4,
                  ),
                  constraints: const BoxConstraints(),
                  iconSize: widget.fontSize,
                  onPressed: () {
                    if (widget.value + 1 <= widget.maxValue) {
                      widget.onChange(widget.value + 1);
                    }
                  },
                  icon: const Icon(Icons.add, color: Colors.black),
                ),
              ),
            ],
          ),
        )
      ],
    ));
  }
}

class NumberInputCarousel extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int? initialValue;
  final Function(int) onChange;
  final bool useCarousel;
  final bool? enabled;
  NumberInputCarousel(
      {required this.minValue,
      required this.maxValue,
      this.initialValue,
      required this.onChange,
      this.useCarousel = true,
      this.enabled});

  @override
  _NumberInputCarouselState createState() => _NumberInputCarouselState();
}

class _NumberInputCarouselState extends State<NumberInputCarousel> {
  CarouselController controller = CarouselController();
  late int _value;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue ?? widget.minValue;
  }

  void _onCarouselChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      _value = index + widget.minValue;
      widget.onChange(_value);
    });
  }

  void _onLongPress(bool nextPage) {
    if (widget.enabled ?? true) {
      setState(
        () {
          timer = Timer.periodic(
            const Duration(milliseconds: 50),
            (timer) {
              _value = nextPage ? _value + 1 : _value - 1;
            },
          );
        },
      );
    }
  }

  void _onLongPressEnd(LongPressEndDetails _) {
    if (widget.enabled ?? true) {
      setState(
        () {
          timer!.cancel();
        },
      );
      controller.jumpToPage(_value);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.useCarousel) {
      return CustomIncrease(
        value: _value.toDouble(),
        minValue: widget.minValue.toDouble(),
        maxValue: widget.maxValue.toDouble(),
        onChange: (value) {
          setState(() {
            _value = value.toInt();
          });
        },
      );
    }
    return SizedBox(
      width: (Theme.of(context).iconTheme.size ?? 24) * 3,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CarouselSlider.builder(
            itemCount: widget.maxValue - widget.minValue + 1,
            carouselController: controller,
            options: CarouselOptions(
                height: Theme.of(context).iconTheme.size,
                enableInfiniteScroll: false,
                scrollPhysics: (widget.enabled ?? true) == false
                    ? const NeverScrollableScrollPhysics()
                    : null,
                initialPage: _value - widget.minValue,
                viewportFraction: 0.3,
                onPageChanged: _onCarouselChange,
                enlargeCenterPage: true),
            itemBuilder: (context, index, realIndex) {
              final number = index + widget.minValue;
              final isSelected = number == _value;
              final textStyle = isSelected
                  ? const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    )
                  : const TextStyle(
                      color: Colors.grey,
                    );

              return Container(
                padding: EdgeInsets.zero,
                child: Text(
                  number.toString(),
                  style: textStyle,
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.enabled ?? true) {
                      controller.previousPage();
                    }
                  },
                  onLongPress: () => _onLongPress(false),
                  onLongPressEnd: _onLongPressEnd,
                  child: Icon(
                    Icons.remove_circle_outline,
                    color: (widget.enabled ?? true) == false
                        ? Colors.grey
                        : Theme.of(context).iconTheme.color,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (widget.enabled ?? true) {
                      controller.nextPage();
                    }
                  },
                  onLongPress: () => _onLongPress(true),
                  onLongPressEnd: _onLongPressEnd,
                  child: Icon(
                    Icons.add_circle_outline,
                    color: (widget.enabled ?? true) == false
                        ? Colors.grey
                        : Theme.of(context).iconTheme.color,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
