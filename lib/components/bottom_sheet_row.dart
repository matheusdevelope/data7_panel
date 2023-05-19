import 'package:data7_panel/providers/caroussel_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_model.dart';

class BottomSheetRow extends StatelessWidget {
  final Text? label;
  final List<Widget> child;
  final bool divider;
  const BottomSheetRow(
      {super.key, this.label, required this.child, this.divider = true});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 6, right: 6),
      child: Consumer<CarousselModel>(
        builder: (context, CarousselModel caroussel, c) {
          return Consumer<ThemeModel>(
            builder: (ctx, ThemeModel theme, c) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        if (label != null)
                          Container(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            child: label!,
                          ),
                        ...child
                      ],
                    ),
                  ),
                  if (divider) const Divider(),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
