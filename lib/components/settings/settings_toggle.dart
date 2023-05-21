import 'package:data7_panel/components/settings/icon_style.dart';
import 'package:flutter/material.dart';

class SettingRowToggle extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final bool initialValue;
  final Function(bool) onChange;

  SettingRowToggle(
      {required this.title,
      this.subtitle,
      this.icon,
      this.iconStyle,
      required this.initialValue,
      required this.onChange});

  @override
  _SettingRowToggleState createState() => _SettingRowToggleState();
}

class _SettingRowToggleState extends State<SettingRowToggle> {
  bool checked = true;
  bool inicialized = false;
  void _setInitialValue() {
    if (!inicialized) {
      setState(() {
        checked = widget.initialValue;
        inicialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _setInitialValue();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(4),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              // fontSize: 16,
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
          subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
          trailing: Material(
            color: Colors.white,
            child: IconButton(
              padding: const EdgeInsets.all(4),
              constraints: const BoxConstraints(),
              onPressed: () {
                setState(() {
                  checked = !checked;
                });
                widget.onChange(checked);
              },
              color: checked ? Colors.blue : Colors.black,
              tooltip: checked ? "Desativar" : "Ativar",
              icon: Icon(
                checked ? Icons.toggle_on : Icons.toggle_off,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
