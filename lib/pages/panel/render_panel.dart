import 'package:carousel_slider/carousel_slider.dart';
import 'package:data7_panel/models/tableComponentData.dart';
import 'package:data7_panel/pages/panel/table.dart';
import 'package:data7_panel/providers/theme_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'transform_data.dart';

class RenderPanels extends StatefulWidget {
  List<TableComponentData> dataList = [];

  bool? isHorizontal = false;
  RenderPanels({super.key, required this.dataList, this.isHorizontal});

  @override
  State<RenderPanels> createState() => _RenderPanels();
}

class _RenderPanels extends State<RenderPanels> {
  final CarouselController _controller = CarouselController();

  int _currentIndex = 0;
  bool _autoplay = true;

  void _onCarouselChanged(int index, CarouselPageChangedReason reason) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onArrowPressed(bool forward) {
    if (forward) {
      _controller.nextPage();
    } else {
      _controller.previousPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: widget.isHorizontal == true
                ? RenderPanelsHorizontal(dataList: widget.dataList)
                : RenderPanelsVertical(
                    dataList: widget.dataList,
                  )));
    final items = [
      widget.isHorizontal == true
          ? RenderPanelsHorizontal(dataList: widget.dataList)
          : RenderPanelsVertical(
              dataList: widget.dataList,
            ),
      widget.isHorizontal == true
          ? RenderPanelsHorizontal(dataList: widget.dataList)
          : RenderPanelsVertical(
              dataList: widget.dataList,
            )
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Builder(builder: (context) {
              final double height = MediaQuery.of(context).size.height;

              return CarouselSlider(
                carouselController: _controller,
                options: CarouselOptions(
                  height: height,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  autoPlay: _autoplay,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 500),
                  onPageChanged: _onCarouselChanged,
                ),
                items: items,
              );
            })),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: items.map((item) {
                int index = items.indexOf(item);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Colors.blueAccent
                        : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _onArrowPressed(false),
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _autoplay = !_autoplay;
                      });
                    },
                    icon: Icon(_autoplay ? Icons.toggle_on : Icons.toggle_off)),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _autoplay = !_autoplay;
                      });
                    },
                    icon:
                        Icon(!_autoplay ? Icons.toggle_on : Icons.toggle_off)),
                IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () => _onArrowPressed(true),
                ),
              ],
            ),
          ],
        ),

        // return CarouselSlider(
        //   options: CarouselOptions(
        //     height: height,
        //     viewportFraction: 1.0,
        //     enlargeCenterPage: false,
        //     autoPlay: true,
        //     autoPlayCurve: Curves.fastOutSlowIn,
        //     enableInfiniteScroll: true,
        //     autoPlayAnimationDuration: Duration(milliseconds: 800),
        //     // viewportFraction: 0.8,
        //   ),
        //   items: [
        //     isHorizontal == true
        //         ? RenderPanelsHorizontal(dataList: dataList)
        //         : RenderPanelsVertical(
        //             dataList: dataList,
        //           ),
        //     isHorizontal == true
        //         ? RenderPanelsHorizontal(dataList: dataList)
        //         : RenderPanelsVertical(
        //             dataList: dataList,
        //           )
        //   ],
        // );
      ),
    );
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
