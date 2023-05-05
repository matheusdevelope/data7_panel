import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/components/table.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transform_data.dart';
import 'carroussel.dart';

class RenderPanels extends StatefulWidget {
  List<List<TableComponentData>> dataList = [];
  bool? isHorizontal = false;
  final CarouselController controller;
  RenderPanels(
      {super.key,
      required this.dataList,
      required this.controller,
      this.isHorizontal});

  @override
  State<RenderPanels> createState() => _RenderPanels();
}

class _RenderPanels extends State<RenderPanels> {
  @override
  Widget build(BuildContext context) {
    final items = widget.dataList.map((data) {
      return widget.isHorizontal == true
          ? RenderPanelsHorizontal(dataList: data)
          : RenderPanelsVertical(
              dataList: data,
            );
    }).toList();
    return Carousel(items: items, controller: widget.controller);
  }
}

class RenderPanelsVertical extends StatelessWidget {
  List<TableComponentData> dataList = [];
  RenderPanelsVertical({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    List<Widget> list = [];
    dataList.toList().forEach((table) {
      list = [...list, ..._generateTable(table, context)];
      if (counter < dataList.length - 1) {
        list.add(const Divider(
          height: 1,
          thickness: 1,
        ));
      }
      counter++;
    });
    return Column(children: [...list]);
  }
}

_generateTable(TableComponentData data, BuildContext context) {
  return [
    Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      return Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            data.title,
            style: TextStyle(
                color: getColor("#4A5568"),
                fontSize: theme.fontSizeTitlePanel,
                fontWeight: FontWeight.bold),
          ),
        ),
      );
    }),
    Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      child: const Divider(
        height: 1,
        thickness: 1,
      ),
    ),
    Expanded(
        child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width),
                            child: TableComponent(data: data),
                          )),
                    ),
                  ],
                )))),
  ];
}

class RenderPanelsHorizontal extends StatelessWidget {
  List<TableComponentData> dataList = [];
  RenderPanelsHorizontal({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    List<Widget> list = [];
    dataList.toList().forEach((table) {
      list.add(DataTablePanelHorizontal(
        data: table,
      ));
      if (counter < dataList.length - 1) {
        list.add(const VerticalDivider(
          width: 1,
          thickness: 0.6,
        ));
      }
      counter++;
    });
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start, children: [...list]);
  }
}

class DataTablePanelHorizontal extends StatelessWidget {
  final TableComponentData data;
  double fontSizeProvider = 0;
  DataTablePanelHorizontal({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModel>(builder: (context, ThemeModel theme, child) {
      fontSizeProvider = theme.fontSizeTitlePanel;
      return Expanded(
          child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Text(
              data.title,
              style: TextStyle(
                  color: getColor("#4A5568"),
                  fontSize: fontSizeProvider,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Divider(
            height: 2,
            thickness: 1,
            color: getColor("#4A5568"),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: ConstrainedBox(
                            constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width),
                            child: TableComponent(data: data)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ));
    });
  }
}
