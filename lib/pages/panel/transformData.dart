import 'package:flutter/material.dart';

import '../../models/tableComponentData.dart';

class TransformData {
  double configFontSize = 14;
  String configOrderDefault = "ASC";
  String configOrderFieldDefault = "ID";
  int configColumnPanelOrder = 0;
  List<String> configHideColumns = [];
  List<Columns> columns = [];
  List<Columns> columnsHide = [];
  List<Rows> rows = [];

// {01_ID: 370631, 02_OP.: 1, 03_Cliente: 2325 - A C B ACIOLE COM PECAS E SERVICOS EIRELI - ME, 04_Vendedor: DOUGLAS, 05_Municipio: ITAITUBA - PA, 06_Data/Hora: 2023-02-21 15:05, CodFilial: 1,
//Config_Painel: 2, Config_TituloPainel: Expedicao Externa, Config_OrientacaoPainel: Vertical, Config_CampoOrdenacaoPainel: 06_Data/Hora,
// Config_OrdenacaoPainel: ASC, Config_CorFundo: #FFF, Config_CorFonte: #000, Config_TamanhoFonte: 15, Config_LegendaCores: #FF0000:1h, #FFFF00:0h30m, #00FF00:0h15m, Config_OcultarColunas: CodFilial}

  parseData(List<Map<String, dynamic>> data) {
    if (data.isEmpty == false) {
      _gererateGeneralInfo(data[0]);
      _gererateColumns(data[0]);
      _gererateRows(data);
      _sortRows(rows);
    }
    return TableComponentData(columns: columns, rows: rows);
  }

  _gererateGeneralInfo(Map<String, dynamic> objData) {
    configOrderDefault =
        objData['Config_OrdenacaoPainel'].toString().toUpperCase() == 'DESC'
            ? "DESC"
            : "ASC";
    configOrderFieldDefault = objData['Config_CampoOrdenacaoPainel'].toString();
    configHideColumns = objData['Config_OcultarColunas'].toString().split(',');
    configFontSize = _getFontSize(objData['Config_TamanhoFonte'].toString());
  }

  _gererateColumns(Map<String, dynamic> objData) {
    List<String> keys = objData.keys.toList();
    keys.sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    keys.forEach((key) {
      final String label =
          key.substring(key.indexOf('_') > 0 ? key.indexOf('_') + 1 : 0);
      final hide = configHideColumns.contains(key) || key.startsWith('Config_');
      final col = Columns(
          name: key,
          label: label,
          toolTip: label,
          fontSize: configFontSize,
          hide: hide,
          isOrderColumn: configOrderFieldDefault == key);
      hide ? columnsHide.add(col) : columns.add(col);
    });
  }

  _gererateRows(List<Map<String, dynamic>> data) {
    data.forEach((row) {
      List<Data> list = [];
      List<Data> listHide = [];
      row.keys.toList().forEach((key) {
        final hide =
            configHideColumns.contains(key) || key.startsWith('Config_');
        final cell = Data(field: key, value: row[key].toString());
        hide ? listHide.add(cell) : list.add(cell);
      });

      rows.add(Rows(
          data: list,
          options: Options(
              backgroundColor: _getColor(row['Config_CorFundo'].toString()),
              color: _getColor(row['Config_CorFonte'].toString()),
              fontSize: _getFontSize(row['Config_TamanhoFonte'].toString()))));
    });
  }

  _sortRows(List<Rows> rows) {
    rows.sort((rowA, rowB) {
      var idxA = rowA.data
          ?.indexWhere((element) => element.field == configOrderFieldDefault);
      idxA ??= 0;
      var valueA = rowA.data?[idxA].value.toString().toLowerCase();
      valueA ??= "";
      var idxB = rowB.data
          ?.indexWhere((element) => element.field == configOrderFieldDefault);
      idxB ??= 0;
      var valueB = rowB.data?[idxB].value.toString().toLowerCase();
      valueB ??= "";
      if (configOrderDefault == "ASC") {
        return valueB.compareTo(valueA);
      }
      return valueA.compareTo(valueB);
    });
  }
}

_getColor(String value) {
  final String stringColor = value;
  RegExp hexColor = RegExp(r'^#?([0-9a-fA-F]{3}|[0-9a-fA-F]{6})$');

  if (hexColor.hasMatch(stringColor) && stringColor.toLowerCase() != "#fff") {
    return Color(int.parse(stringColor.split(":")[0].replaceAll("#", "0xFF")));
  }
  return null;
}

_getFontSize(String value) {
  final String tempFontSize = value.toString().replaceAll('\\D', "");
  if (tempFontSize.isNotEmpty && double.tryParse(tempFontSize) != null) {
    return double.parse(tempFontSize);
  }
  return 14.0;
}

//  "columns": [
//         {
//             "name": "Name",
//             "label": "Label",
//             "toolTip": "ToolTip",
//             "isOrderColumn": false,
//             "hide": false,
//             "fontSize": 14
//         }
//     ],
