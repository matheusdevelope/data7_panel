import 'package:data7_panel/old/components/custom_increase.dart';
import 'package:data7_panel/old/components/settings/icon_style.dart';
import 'package:flutter/material.dart';

class SettingRowNumber extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final Function(int) onChange;
  final int? initialValue;
  final int minValue;
  final int maxValue;
  final bool useCarousel;
  final bool? enabled;

  SettingRowNumber(
      {required this.title,
      this.subtitle,
      this.icon,
      this.iconStyle,
      required this.onChange,
      this.initialValue,
      required this.minValue,
      required this.maxValue,
      this.useCarousel = true,
      this.enabled});

  @override
  _SettingRowNumberState createState() => _SettingRowNumberState();
}

class _SettingRowNumberState extends State<SettingRowNumber> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.subtitle != null)
                      Text(
                        widget.subtitle!,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            // overflow: TextOverflow.ellipsis,
                            color: Colors.grey,
                            fontSize: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.fontSize),
                      ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  NumberInputCarousel(
                      useCarousel: widget.useCarousel,
                      initialValue: widget.initialValue,
                      minValue: widget.minValue,
                      maxValue: widget.maxValue,
                      onChange: widget.onChange,
                      enabled: widget.enabled),
                ],
              )
            ],
          ),
          leading: widget.icon != null
              ? (widget.iconStyle != null && widget.iconStyle!.withBackground!)
                  ? Container(
                      decoration: BoxDecoration(
                        color: widget.iconStyle!.backgroundColor,
                        borderRadius: BorderRadius.circular(
                          widget.iconStyle!.borderRadius!,
                        ),
                      ),
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        widget.icon,
                        color: widget.iconStyle!.iconsColor,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(5),
                      child: Icon(
                        widget.icon,
                      ),
                    )
              : null,
        ),
      ],
    );
  }
}
