import 'package:data7_panel/old/components/dropdown.dart';
import 'package:data7_panel/old/components/settings/icon_style.dart';
import 'package:flutter/material.dart';

class SettingRowDropDown extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final Function(String) onChange;
  final Map<String, String> items;
  final List<String>? itemsDefault;
  final String selectedValue;
  final Function(String)? onLeftButtonPress;
  final Function(String)? onLeftLongButtonPress;
  final Function(String)? onRightButtonPress;
  final Function(String)? onRightLongButtonPress;
  final Future<Map<String, String>> Function()? onAdd;
  final bool? enabled;

  SettingRowDropDown(
      {required this.title,
      this.subtitle,
      this.icon,
      this.iconStyle,
      required this.onChange,
      required this.items,
      this.itemsDefault,
      required this.selectedValue,
      this.onLeftButtonPress,
      this.onLeftLongButtonPress,
      this.onRightButtonPress,
      this.onRightLongButtonPress,
      this.onAdd,
      this.enabled});

  @override
  _SettingRowDropDownState createState() => _SettingRowDropDownState();
}

class _SettingRowDropDownState extends State<SettingRowDropDown> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
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
          subtitle: CustomDropdown(
            enabled: widget.enabled,
            items: widget.items,
            itemsDefault: widget.itemsDefault,
            selectedValue: widget.selectedValue,
            onChange: widget.onChange,
            onLeftButtonPress: widget.onLeftButtonPress,
            onLeftLongButtonPress: widget.onLeftLongButtonPress,
            onRightButtonPress: widget.onRightButtonPress,
            onRightLongButtonPress: widget.onLeftLongButtonPress,
            onAdd: widget.onAdd,
          ),
        ),
      ],
    );
  }
}
