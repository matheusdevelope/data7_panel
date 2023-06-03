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
  final bool? required;
  final List<String? Function(String)>? validations;

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
      this.enabled,
      this.required,
      this.validations});

  @override
  _SettingRowTextFieldState createState() => _SettingRowTextFieldState();
}

class _SettingRowTextFieldState extends State<SettingRowTextField> {
  late TextEditingController textController;
  bool inicialized = false;
  String? errorText;
  void _setInitialValue() {
    if (!inicialized) {
      setState(() {
        textController = TextEditingController(text: widget.initialValue);
        errorText = _errorText;
        if (widget.initialValue.isNotEmpty) {
          inicialized = true;
        }
      });
    }
  }

  String? get _errorText {
    final text = textController.value.text;
    if (widget.required == true && text.trim().isEmpty) {
      return 'Esse campo é obrigatório, verifique.';
    }
    if (widget.validations != null) {
      for (var i = 0; i < widget.validations!.length; i++) {
        String? ret = widget.validations![i](text.trim());
        if (ret != null) return ret;
      }
    }

    return null;
  }

  _onChange(String value) {
    widget.onChange(value);
    setState(() {
      errorText = _errorText;
    });
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
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
                ? (widget.iconStyle != null &&
                        widget.iconStyle!.withBackground!)
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
            subtitle:

                // ValueListenableBuilder(
                //   valueListenable: textController,
                //   builder: (context, TextEditingValue value, __) {
                //     if (value.text != widget.initialValue && value.text.isNotEmpty) {
                //       widget.onChange(value.text);
                //     }
                //     return

                TextField(
              controller: textController,
              onChanged: _onChange,
              enabled: widget.enabled,
              textInputAction: TextInputAction.next,
              obscureText: widget.isPassword,
              keyboardType: widget.inputType,
              maxLines: widget.isPassword ? 1 : widget.maxLines,
              inputFormatters: [
                if (widget.inputType == TextInputType.number)
                  FilteringTextInputFormatter.digitsOnly
              ],
              style: TextStyle(
                  color: widget.enabled == false ? Colors.grey : null),
              decoration: InputDecoration(
                labelText: widget.placeholder,
                errorText: errorText,
                enabled: widget.enabled ?? true,
              ),
            ) //;
            //   },
            // ),
            ),
      ],
    );
  }
}
