import 'package:data7_panel/components/settings/settings.dart';
import 'package:flutter/material.dart';
import 'options_from_url.dart';
import 'tableComponentData.dart';

class Table {
  String title;
  int order;
  TableComponentData data;
  Table({required this.title, required this.order, required this.data});
}

class TransformData {
  double configFontSize = 0;
  String configOrderDefault = "ASC";
  String configOrderFieldDefault = "ID";
  String consfigTitlePanel = "Painel";
  String configOrientationPanel = 'VERTICAL';
  String configLegendColors = "";
  int configColumnPanelOrder = 0;

  Map<String, double> configWidthColummns = {};
  List<String> configHideColumns = [];
  List<Columns> columns = [];
  List<Columns> columnsHide = [];
  List<Rows> rows = [];

  List<TableComponentData> tables = [];
  List<List<TableComponentData>> carousels = [];
  late List<CarouselData> carouselsData = [];

  List<TableComponentData> parseData(List<Map<String, dynamic>> pdata) {
    tables = [];
    List<Map<String, dynamic>> data =
        Settings.panel.colsOptions.filters.isNotEmpty
            ? filterList(list: pdata, colOptions: Settings.panel.colsOptions)
            : pdata;

    List<List<Map<String, dynamic>>> separatedData = [];
    _separatePanelsData(data).forEach((key, value) {
      separatedData.add(value);
    });

    separatedData
        .sort((a, b) => a[0]["Config_Painel"].compareTo(b[0]["Config_Painel"]));

    for (var value in separatedData) {
      configFontSize = 0;
      configOrderDefault = "ASC";
      configOrderFieldDefault = "ID";
      consfigTitlePanel = "Painel";
      configOrientationPanel = 'VERTICAL';
      configLegendColors = "";
      configColumnPanelOrder = 0;
      configWidthColummns = {};
      configHideColumns = [];
      columns = [];
      columnsHide = [];
      rows = [];

      if (value.isNotEmpty) {
        _gererateGeneralInfo(value[0]);
        _gererateColumns(value[0]);
        _gererateRows(value);
        _sortRows(rows);
      }
      tables.add(
        TableComponentData(
            title: consfigTitlePanel,
            columns: columns,
            rows: rows,
            columnsHide: columnsHide,
            legendColors: configLegendColors,
            isHorizontal: configOrientationPanel.toUpperCase() == 'HORIZONTAL'),
      );
    }
    return tables;
  }

  List<CarouselData> parseDataCarousel(List<Map<String, dynamic>> pdata) {
    List<Map<String, dynamic>> data =
        Settings.panel.colsOptions.filters.isNotEmpty
            ? filterList(list: pdata, colOptions: Settings.panel.colsOptions)
            : pdata;
    String keyToSort = "Config_Carrossel";
    data.sort((a, b) => a.containsKey(keyToSort) && b.containsKey(keyToSort)
        ? a[keyToSort].compareTo(b[keyToSort])
        : 0);
    _separatePanelsCarousel(data).forEach(
      (key, data) {
        List<List<Map<String, dynamic>>> separatedData = [];
        _separatePanelsData(data).forEach((key, value) {
          separatedData.add(value);
        });

        separatedData.sort(
            (a, b) => a[0]["Config_Painel"].compareTo(b[0]["Config_Painel"]));

        for (var value in separatedData) {
          configFontSize = 0;
          configOrderDefault = "ASC";
          configOrderFieldDefault = "ID";
          consfigTitlePanel = "Painel";
          configOrientationPanel = 'VERTICAL';
          configLegendColors = "";
          configColumnPanelOrder = 0;
          configWidthColummns = {};
          configHideColumns = [];
          columns = [];
          columnsHide = [];
          rows = [];

          if (value.isNotEmpty) {
            _gererateGeneralInfo(value[0]);
            _gererateColumns(value[0]);
            _gererateRows(value);
            _sortRows(rows);
          }
          tables.add(
            TableComponentData(
                title: consfigTitlePanel,
                columns: columns,
                rows: rows,
                columnsHide: columnsHide,
                legendColors: configLegendColors,
                isHorizontal:
                    configOrientationPanel.toUpperCase() == 'HORIZONTAL'),
          );
        }
        carousels.add(tables);
        carouselsData.add(
          CarouselData(
              id: key.toString(),
              duration: separatedData[0][0]['Config_DuracaoCarrossel'] ?? 0,
              panels: tables),
        );
        tables = [];
      },
    );
    return carouselsData;
  }

  List<Map<String, dynamic>> filterList(
      {required List<Map<String, dynamic>> list,
      required ColumnsOptions colOptions}) {
    return list.where((objeto) {
      bool filterPass = true;
      for (var filter in colOptions.filters) {
        filterPass = filter.filter?.test(objeto) ?? true;
      }
      return filterPass;
    }).toList();
  }

  Map<int, List<Map<String, dynamic>>> _separatePanelsCarousel(
      List<Map<String, dynamic>> data) {
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    for (var element in data) {
      int configCarousel = element['Config_Carrossel'] ?? 1;
      if (groupedData.containsKey(configCarousel)) {
        groupedData[configCarousel]!.add(element);
      } else {
        groupedData[configCarousel] = [element];
      }
    }
    return groupedData;
  }

  Map<int, List<Map<String, dynamic>>> _separatePanelsData(
      List<Map<String, dynamic>> data) {
    Map<int, List<Map<String, dynamic>>> groupedData = {};
    for (var element in data) {
      int configPainel = element['Config_Painel'] ?? 1;
      if (groupedData.containsKey(configPainel)) {
        groupedData[configPainel]!.add(element);
      } else {
        groupedData[configPainel] = [element];
      }
    }
    return groupedData;
  }

  _gererateGeneralInfo(Map<String, dynamic> objData) {
    if (objData['Config_TituloPainel'] != null) {
      consfigTitlePanel = objData['Config_TituloPainel'].toString();
    }
    if (objData['Config_LegendaCores'] != null) {
      configLegendColors = objData['Config_LegendaCores'].toString();
      if (objData['Config_OrientacaoPainel'] != null) {
        configOrientationPanel =
            objData['Config_OrientacaoPainel'].toString().toUpperCase() ==
                    "HORIZONTAL"
                ? "HORIZONTAL"
                : configOrientationPanel;
      }
    }
    if (objData['Config_OrdenacaoPainel'] != null) {
      configOrderDefault =
          objData['Config_OrdenacaoPainel'].toString().toUpperCase() == 'DESC'
              ? "DESC"
              : configOrderDefault;
    }
    if (objData['Config_CampoOrdenacaoPainel'] != null) {
      configOrderFieldDefault =
          objData['Config_CampoOrdenacaoPainel'].toString();
    }
    if (objData['Config_OcultarColunas'] != null) {
      configHideColumns =
          objData['Config_OcultarColunas'].toString().split(',');
    }
    if (objData['Config_TamanhoFonte'] != null) {
      configFontSize = getFontSize(objData['Config_TamanhoFonte'].toString());
    }

    if (objData['Config_LarguraColunas'].toString().contains(',') &&
        objData['Config_LarguraColunas'].toString().contains(":")) {
      objData['Config_LarguraColunas'].toString().split(',').forEach((element) {
        configWidthColummns[element.split(':')[0].toString().trim()] =
            removeNonDigitAndParseToDouble(element.split(':')[1]);
      });
    }
  }

  _gererateColumns(Map<String, dynamic> objData) {
    List<String> keys = objData.keys.toList();
    keys.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    for (var key in keys) {
      final String label =
          key.substring(key.indexOf('_') > 0 ? key.indexOf('_') + 1 : 0);
      final hide = configHideColumns.contains(key) || key.startsWith('Config_');

      final col = Columns(
          name: key,
          label: label,
          toolTip: label,
          fontSize: configFontSize,
          width: configWidthColummns[key] ?? 0,
          hide: hide,
          isOrderColumn: configOrderFieldDefault == key);
      hide ? columnsHide.add(col) : columns.add(col);
    }
  }

  _gererateRows(List<Map<String, dynamic>> data) {
    for (var row in data) {
      List<Data> list = [];
      List<Data> listHide = [];
      List<String> keys = row.keys.toList();
      keys.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
      for (var key in keys) {
        final hide =
            configHideColumns.contains(key) || key.startsWith('Config_');
        final cell = Data(field: key, value: row[key].toString());
        hide ? listHide.add(cell) : list.add(cell);
      }

      rows.add(Rows(
          data: list,
          options: Options(
              backgroundColor:
                  getColorString(row['Config_CorFundo'].toString()),
              color: getColorString(row['Config_CorFonte'].toString()),
              fontSize: getFontSize(row['Config_TamanhoFonte'].toString()))));
    }
  }

  _sortRows(List<Rows> rows) {
    if (rows.isNotEmpty) {
      rows.sort((rowA, rowB) {
        var idxA = rowA.data
            ?.indexWhere((element) => element.field == configOrderFieldDefault);
        idxA ??= 0;
        if (idxA < 0) {
          idxA = 0;
        }

        var valueA = rowA.data?[idxA].value.toString().toLowerCase();

        valueA ??= "";
        var idxB = rowB.data
            ?.indexWhere((element) => element.field == configOrderFieldDefault);
        idxB ??= 0;
        if (idxB < 0) {
          idxB = 0;
        }
        var valueB = rowB.data?[idxB].value.toString().toLowerCase();
        valueB ??= "";
        if (configOrderDefault == "ASC") {
          return valueA.compareTo(valueB);
        }
        return valueB.compareTo(valueA);
      });
    }
  }
}

getColor(String value) {
  String stringColor = value;
  RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
  if (hexColor.hasMatch(stringColor)) {
    return Color(
        int.parse(stringColor.trim().split(":")[0].replaceAll("#", "0xFF")));
  }

  return null;
}

getColorString(String value) {
  String stringColor = value;
  RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');
  if (hexColor.hasMatch(stringColor)) {
    return value.trim().replaceAll('#', "");
    //Color(int.parse(stringColor.split(":")[0].replaceAll("#", "0xFF")));
  }

  return "#000";
}

getFontSize(String value) {
  final String tempFontSize = value.toString().replaceAll('\\D', "");
  if (tempFontSize.isNotEmpty && double.tryParse(tempFontSize) != null) {
    return double.parse(tempFontSize);
  }
  return 0.0;
}

double removeNonDigitAndParseToDouble(String input) {
  String cleaned = input.replaceAll(RegExp(r'[^0-9]'), '');

  try {
    double result = double.parse(cleaned);
    return result;
  } catch (e) {
    return 0.0;
  }
}
