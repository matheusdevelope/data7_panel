import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final bool isConnected;
  final List<Icon> dynamicIcons;
  final String updateTime;

  CustomBottomNavigationBar(
      {required this.isConnected,
      required this.dynamicIcons,
      required this.updateTime});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  bool _isExpanded = false;
  double _fontSize = 16.0;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: _isExpanded ? 120.0 : 56.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Wrap(
              children: widget.dynamicIcons
                  .map((icon) => IconButton(
                        onPressed: () {},
                        icon: icon,
                      ))
                  .toList(),
            ),
            GestureDetector(
              onTap: _toggleExpanded,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.isConnected ? Colors.green : Colors.red,
                ),
                child: const Icon(Icons.network_check),
                padding: const EdgeInsets.all(16.0),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Last updated:',
                  style: TextStyle(fontSize: _fontSize),
                ),
                Text(
                  widget.updateTime,
                  style: TextStyle(fontSize: _fontSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
