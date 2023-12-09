import 'package:flutter/material.dart';

class CustomDropdown extends StatefulWidget {
  final Map<String, String> items;
  final List<String>? itemsDefault;
  final String selectedValue;
  final Function(String) onChange;
  final Function(String)? onLeftButtonPress;
  final Function(String)? onLeftLongButtonPress;
  final Function(String)? onRightButtonPress;
  final Function(String)? onRightLongButtonPress;
  final Future<Map<String, String>> Function()? onAdd;
  final bool? enabled;

  const CustomDropdown(
      {super.key,
      required this.items,
      this.itemsDefault,
      required this.selectedValue,
      required this.onChange,
      this.onLeftButtonPress,
      this.onLeftLongButtonPress,
      this.onRightButtonPress,
      this.onRightLongButtonPress,
      this.onAdd,
      this.enabled});

  @override
  CustomDropdownState createState() => CustomDropdownState();
}

class CustomDropdownState extends State<CustomDropdown> {
  bool inicialized = false;
  String selectedValue = '';
  Map<String, String> items = {};
  void _setInitialValue() {
    if (!inicialized) {
      setState(() {
        items = widget.items;
        selectedValue = widget.selectedValue;
        if (selectedValue.isEmpty) {
          selectedValue = widget.items.keys.first;
          widget.onChange(selectedValue);
        }
        inicialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _setInitialValue();

    return Container(
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 0.2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: DropdownButton(
        value: selectedValue,
        underline: const Divider(
          color: Colors.transparent,
        ),
        menuMaxHeight: 300,
        isExpanded: true,
        onChanged: (value) {
          setState(() {
            selectedValue = value;
          });
          widget.onChange(value);
        },
        items: [
          for (var entry in widget.items.entries)
            DropdownMenuItem(
              enabled: widget.enabled ?? true,
              value: entry.key,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        if (widget.onLeftButtonPress != null ||
                            widget.onLeftLongButtonPress != null)
                          InkWell(
                            onTap: () => widget.onLeftButtonPress!(entry.key),
                            onLongPress: () =>
                                widget.onLeftLongButtonPress!(entry.key),
                            child: const Icon(
                              Icons.play_circle_outline,
                              // color: Colors.blue,
                            ),
                          ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 4),
                            child: Text(
                              entry.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if ((widget.onRightButtonPress != null ||
                          widget.onRightLongButtonPress != null) &&
                      (entry.key != selectedValue &&
                          (!widget.itemsDefault!.contains(entry.key))))
                    InkWell(
                      onTap: () {
                        widget.onRightButtonPress!(entry.key);
                        setState(() {
                          items.remove(entry.key);
                        });
                      },
                      onLongPress: () {
                        widget.onRightLongButtonPress!(entry.key);
                        setState(() {
                          items.remove(entry.key);
                        });
                      },
                      child:
                          const Icon(Icons.delete_forever, color: Colors.red),
                    ),
                ],
              ),
            ),
          if (widget.onAdd != null)
            DropdownMenuItem(
              enabled: false,
              alignment: Alignment.center,
              child: IconButton(
                icon: const Icon(Icons.add_box_outlined),
                onPressed: () async {
                  Map<String, String> obj = await widget.onAdd!();
                  setState(() {
                    items.addAll(obj);
                  });
                },
              ),
            ),
        ],
      ),
    );
  }
}
