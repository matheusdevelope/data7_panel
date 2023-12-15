// ignore_for_file: use_build_context_synchronously

import 'package:data7_panel/components/dialogAlert.dart';
import 'package:data7_panel/components/modal.dart';
import 'package:data7_panel/components/panel_box.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
import 'package:data7_panel/main.dart';
import 'package:data7_panel/models/panel.dart';
import 'package:data7_panel/repository/create_panel.dart';
import 'package:data7_panel/repository/delete_panel.dart';
import 'package:data7_panel/repository/get_panels.dart';
import 'package:flutter/material.dart';

class Panels extends StatefulWidget {
  const Panels({super.key});

  @override
  State<Panels> createState() => _PanelsState();
}

class _PanelsState extends State<Panels> {
  List<Panel> panels = [];
  late Modal formPanel;
  bool loading = true;

  void _showFormPanel() {
    formPanel.show(context);
  }

  void _onSavePanel() async {
    try {
      await CreatePanel.execute(
        description: settings.panel.description,
        statement: settings.panel.query,
        interval: (settings.panel.typeInterval == 'min'
            ? (settings.panel.interval * 60 * 1000)
            : settings.panel.typeInterval == 'hour'
                ? settings.panel.interval * 60 * 60 * 1000
                : settings.panel.interval * 1000),
      );
      settings.panel.description = '';
      settings.panel.query = '';
      settings.panel.interval = 10;
      _loadQuerys();
      formPanel.close(context);
    } catch (e) {
      showAlertDialog(context, 'Erro ao criar painel', e.toString());
    }
  }

  void _deletePanel(String id) async {
    try {
      await settings.panel.initialize();
      await DeletePanel.execute(id: id);
      _loadQuerys();
    } catch (e) {
      showAlertDialog(context, 'Erro ao deletar painel', e.toString());
    }
  }

  _loadQuerys() async {
    try {
      setState(() {
        loading = true;
      });
      final listPanels = await GetPanels.execute();
      setState(() {
        panels = listPanels;
        loading = false;
      });
    } catch (e) {
      showAlertDialog(
          context,
          'Erro ao carregar paineis, verifique se o serviço está ativo.',
          e.toString());
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    formPanel =
        Modal(title: "Cadastrar Painel", content: const FormPanel(), actions: [
      ModalAction(
        label: 'Salvar',
        onPress: () {
          _onSavePanel();
        },
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCategory(
        title: "Paineis",
        icon: Icons.table_view,
        iconStyle: IconStyle(),
        onChangeExpansion: (expanded) {
          if (expanded) {
            _loadQuerys();
          } else {
            setState(() {
              panels = [];
            });
          }
        },
        child: [
          if (loading)
            const Center(
              child: CircularProgressIndicator(),
            )
          else
            ...panels
                .map(
                  (e) => Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: PanelBox(
                      panel: e,
                      rightIcon: IconButton(
                        onPressed: () {
                          _deletePanel(e.id);
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ),
                  ),
                )
                .toList(),
          SizedBox(
            width: double.infinity,
            child: IconButton.outlined(
                onPressed: _showFormPanel,
                icon: const Icon(Icons.add),
                tooltip: 'Adicionar Painel'),
          ),
        ]);
  }
}

class FormPanel extends StatelessWidget {
  const FormPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      height: 500,
      child: ListView(
        children: [
          SettingsItem(
            child: SettingRowTextField(
              title: "Descrição Consulta SQL:",
              subtitle: 'Descrição para identificar o painel.',
              placeholder: '',
              enabled: true,
              required: true,
              validations: [
                (value) => value.trim().length >= 5
                    ? null
                    : "A descrição precisa ter pelo menos 5 caracteres.",
              ],
              initialValue: settings.panel.description,
              maxLines: 1,
              onChange: (value) {
                settings.panel.description = value;
              },
            ),
          ),
          SettingsItem(
            child: SettingRowTextField(
              title: "Consulta SQL:",
              subtitle:
                  'Lebre-se de otimizar sua consulta.\nNão é necessário declarar as colunas, apenas o (SELECT * FROM) já é suficiente.',
              placeholder: 'Query SQL',
              enabled: true,
              required: true,
              validations: [
                (value) => value.trim().length >= 5
                    ? null
                    : "A query precisa ter pelo menos 5 caracteres.",
              ],
              initialValue: settings.panel.query,
              maxLines: 4,
              onChange: (value) {
                settings.panel.query = value;
              },
            ),
          ),
          SettingsItem(
            child: SettingRowNumber(
              title: "Intervalo de Atualização:",
              subtitle:
                  "Tenha em mente que dependendo da query, o intervalo pode não ser suficiente.",

              enabled: true,

              initialValue: settings.panel.interval,
              minValue: 1,
              maxValue: 60,
              // maxLines: 5,
              onChange: (value) {
                settings.panel.interval = value;
              },
            ),
          ),
          SettingsItem(
            child: SettingRowDropDown(
              title: "Tipo de Intervalo:",
              enabled: true,
              items: settings.panel.availableTypes,
              selectedValue: settings.panel.typeInterval,
              onChange: (value) {
                settings.panel.typeInterval = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
