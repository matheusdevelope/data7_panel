import 'package:flutter/material.dart';

class FontSizeSelector extends StatefulWidget {
  final List<FontSizeSelectorData> selectorDataList;
  final double fontSize;

  FontSizeSelector({required this.selectorDataList, required this.fontSize});

  @override
  _FontSizeSelectorState createState() => _FontSizeSelectorState();
}

class _FontSizeSelectorState extends State<FontSizeSelector> {
  List<double> _fontSizeList = [];

  void _updateFontSize(int index, double value) {
    print(value);
    setState(() {
      _fontSizeList[index] = value;
    });
    widget.selectorDataList[index].onChangeValue(value);
  }

  @override
  void initState() {
    super.initState();
    _fontSizeList = List.filled(widget.selectorDataList.length, 15);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
        // mainAxisSize: MainAxisSize.min,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          ...widget.selectorDataList
              .asMap()
              .map((index, selectorData) {
                return MapEntry(
                    index,
                    SizedBox(
                      height: 30,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // width: 100,
                            flex: 1,
                            child: Text(
                              selectorData.label,
                              textAlign: TextAlign.end,
                              style: const TextStyle(fontSize: null),
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Slider(
                              value: _fontSizeList[index],
                              min: selectorData.minValue,
                              max: selectorData.maxValue,
                              divisions: (selectorData.maxValue -
                                      selectorData.minValue)
                                  .toInt(),
                              onChanged: (value) =>
                                  _updateFontSize(index, value),
                            ),
                          )
                        ],
                      ),
                    ));
              })
              .values
              .toList(),
        ]);
  }
}

class FontSizeSelectorData {
  final String label;
  final double value;
  final double minValue;
  final double maxValue;
  final Function(double) onChangeValue;

  FontSizeSelectorData({
    required this.label,
    required this.value,
    required this.minValue,
    required this.maxValue,
    required this.onChangeValue,
  });
}
