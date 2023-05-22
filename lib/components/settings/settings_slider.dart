import 'package:data7_panel/components/settings/icon_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingRowSlider extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final Function(double) onChange;
  final double from;
  final double to;
  final double initialValue;
  final bool justIntValues;
  final String unit;

  SettingRowSlider(
      {required this.title,
      this.subtitle,
      this.icon,
      this.iconStyle,
      required this.onChange,
      required this.from,
      required this.to,
      required this.initialValue,
      this.justIntValues = false,
      this.unit = ""});

  @override
  _SettingRowSliderState createState() => _SettingRowSliderState();
}

class _SettingRowSliderState extends State<SettingRowSlider> {
  double valueToUse = 0;
  bool inicialized = false;
  void onSliderChange(double newVal) {
    setState(() {
      valueToUse = newVal;
    });
  }

  void onSliderChangeEnd(double newVal) {
    setState(() {
      valueToUse = newVal;
    });
    widget.onChange(valueToUse);
  }

  void _setInitialValue() {
    if (!inicialized) {
      setState(() {
        valueToUse = widget.initialValue;
        inicialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _setInitialValue();
    String resultText = widget.justIntValues
        ? valueToUse.round().toString() + widget.unit
        : valueToUse.toString() + widget.unit;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Column(
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
                      fontSize:
                          Theme.of(context).textTheme.bodyMedium?.fontSize),
                ),
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
          subtitle: Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(resultText),
              Expanded(
                child: CupertinoSlider(
                  activeColor: Colors.blue,
                  min: widget.from,
                  max: widget.to,
                  value: valueToUse >= widget.from && valueToUse <= widget.to
                      ? valueToUse
                      : valueToUse > widget.to
                          ? widget.to
                          : widget.from,
                  // activeColor: widget.style.activeColor,
                  onChanged: onSliderChange,
                  onChangeEnd: onSliderChangeEnd,
                  divisions: widget.justIntValues
                      ? (widget.to - widget.from).round()
                      : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
