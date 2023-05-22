import 'package:data7_panel/components/settings/icon_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingRowTextField extends StatefulWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final Function(String) onChange;
  final String initialValue;
  final String placeholder;
  final bool isPassword;
  final TextInputType? inputType;
  final int? maxLines;
  final bool? enabled;
  SettingRowTextField(
      {required this.title,
      this.subtitle,
      this.icon,
      this.iconStyle,
      required this.onChange,
      this.initialValue = '',
      this.placeholder = '',
      this.isPassword = false,
      this.inputType,
      this.maxLines = 1,
      this.enabled});

  @override
  _SettingRowTextFieldState createState() => _SettingRowTextFieldState();
}

class _SettingRowTextFieldState extends State<SettingRowTextField> {
  late TextEditingController textController;
  bool inicialized = false;
  void _setInitialValue() {
    if (!inicialized) {
      setState(() {
        textController = TextEditingController(text: widget.initialValue);
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
          subtitle: TextField(
            enabled: widget.enabled,
            controller: textController,
            onChanged: widget.onChange,
            textInputAction: TextInputAction.next,
            obscureText: widget.isPassword,
            keyboardType: widget.inputType,
            maxLines: widget.isPassword ? 1 : widget.maxLines,
            inputFormatters: [
              if (widget.inputType == TextInputType.number)
                FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: widget.placeholder,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 0)),
          ),
          // widget.subtitle != null ? Text(widget.subtitle!) : null,
        ),
      ],
    );
  }
}
