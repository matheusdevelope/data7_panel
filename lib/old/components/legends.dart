import 'package:flutter/material.dart';

class Legends extends StatelessWidget {
  const Legends({super.key, required this.legends, required this.fontSize});
  final String legends;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final listLegends = legends.split(',');

    return Wrap(
      children: List<Row>.generate(
        listLegends.length,
        (index) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (listLegends[index].toString().contains(":"))
              Icon(Icons.circle,
                  size: fontSize,
                  color: Color(int.parse(listLegends[index]
                      .split(":")[0]
                      .replaceAll("#", "0xFF")))),
            if (listLegends[index].toString().contains(':'))
              Text(listLegends[index].split(":")[1].toString(),
                  style: TextStyle(fontSize: fontSize)),
            const SizedBox(
              width: 4.0,
            )
          ],
        ),
      ),
    );
  }
}
