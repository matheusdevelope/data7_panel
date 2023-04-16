import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/table.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transform_data.dart';

class RenderPanels extends StatelessWidget {
  List<TableComponentData> dataList = [];
  bool? isHorizontal = false;

  RenderPanels({Key? key, required this.dataList, this.isHorizontal})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: RenderPanelsHorizontal(
        dataList: dataList,
      )),
    );
  }
}

class RenderPanelsHorizontal extends StatelessWidget {
  List<TableComponentData> dataList = [];
  RenderPanelsHorizontal({Key? key, required this.dataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int counter = 0;
    List<Widget> _list = [];
    dataList.take(2).toList().forEach((table) {
      _list.add(DataTablePanelHorizontal(
        data: table,
      ));
      // if (!dataList.length.isEven && counter.isEven) {
      if (counter < dataList.take(2).toList().length - 1) {
        _list.add(const VerticalDivider(
          width: 3,
        ));
      }
      counter++;
    });
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start, children: [..._list]);
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
