import 'package:data7_panel/components/settings/icon_style.dart';
import 'package:flutter/material.dart';

class SettingsCategory extends StatefulWidget {
  final String? title;
  final List<Widget> child;
  final String? subtitle;
  final IconData? icon;
  final IconStyle? iconStyle;
  final bool? expansible;
  Function(bool expanded)? onChangeExpansion;

  SettingsCategory(
      {super.key,
      this.title,
      required this.child,
      this.subtitle,
      this.icon,
      this.iconStyle,
      this.expansible = true,
      this.onChangeExpansion});

  @override
  State<SettingsCategory> createState() => _SettingsCategoryState();
}

class _SettingsCategoryState extends State<SettingsCategory> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(width: 0.5, color: Colors.grey.shade300)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title != null)
            ListTile(
              contentPadding: const EdgeInsets.all(2),
              onTap: () {
                if (widget.expansible!) {
                  if (widget.onChangeExpansion != null) {
                    widget.onChangeExpansion!(!_isExpanded);
                  }
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                }
              },
              title: Padding(
                padding: EdgeInsets.only(left: widget.icon != null ? 0 : 8),
                child: Text(
                  widget.title!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontSize: 16,
                  ),
                ),
              ),
              leading: widget.icon != null
                  ? Padding(
                      padding: const EdgeInsets.all(4),
                      child: (widget.iconStyle != null &&
                              widget.iconStyle!.withBackground!)
                          ? Container(
                              decoration: BoxDecoration(
                                color: widget.iconStyle!.backgroundColor,
                                borderRadius: BorderRadius.circular(
                                    widget.iconStyle!.borderRadius!),
                              ),
                              padding: const EdgeInsets.all(4),
                              child: Icon(
                                widget.icon,
                                // size: widget.iconStyle.size,
                                color: widget.iconStyle!.iconsColor,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(5),
                              child: Icon(
                                widget.icon,
                                // size: SettingsScreenUtils.settingsGroupIconSize,
                              ),
                            ))
                  : null,
              subtitle: widget.subtitle != null ? Text(widget.subtitle!) : null,
              trailing: widget.expansible != null && widget.expansible!
                  ? Material(
                      color: Colors.white,
                      child: IconButton(
                        icon: Icon(
                          _isExpanded ? Icons.expand_less : Icons.expand_more,
                        ),
                        onPressed: () {
                          if (widget.onChangeExpansion != null) {
                            widget.onChangeExpansion!(!_isExpanded);
                          }
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                      ),
                    )
                  : null,
            ),
          if (_isExpanded || !widget.expansible! || widget.title == null)
            ...List<Widget>.generate(
              widget.child.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: widget.child[index],
              ),
            ).toList(),
          if (_isExpanded || !widget.expansible! || widget.title == null)
            const SizedBox(
              height: 4,
            )
          //
        ],
      ),
    );
  }
}
