// ignore_for_file: use_build_context_synchronously

import 'package:data7_panel/components/dialogAlert.dart';
import 'package:data7_panel/components/modal.dart';
import 'package:data7_panel/components/settings/settings.dart';
import 'package:data7_panel/components/settings/settings_textfield.dart';
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
      await Settings.panel.initialize();
      await CreatePanel.execute(
        description: Settings.panel.description,
        statement: Settings.panel.query,
        interval: (Settings.panel.typeInterval == 'min'
            ? (Settings.panel.interval * 60 * 1000)
            : Settings.panel.typeInterval == 'hour'
                ? Settings.panel.interval * 60 * 60 * 1000
                : Settings.panel.interval * 1000),
      );
      Settings.panel.description = '';
      Settings.panel.query = '';
      Settings.panel.interval = 10;
      _loadQuerys();
      formPanel.close(context);
    } catch (e) {
      showAlertDialog(context, 'Erro ao criar painel', e.toString());
    }
  }

  void _deletePanel(String id) async {
    try {
      await Settings.panel.initialize();
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

  Widget _panelBox(Panel panel) {
    return Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  panel.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  panel.statement,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Intervalo: ${panel.interval} ms',
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                _deletePanel(panel.id);
              },
              icon: const Icon(Icons.delete, color: Colors.red),
            ),
          ],
        ));
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
            ...panels.map((e) => _panelBox(e)).toList(),
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
              initialValue: Settings.panel.description,
              maxLines: 1,
              onChange: (value) {
                Settings.panel.description = value;
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
              initialValue: Settings.panel.query,
              maxLines: 4,
              onChange: (value) {
                Settings.panel.query = value;
              },
            ),
          ),
          SettingsItem(
            child: SettingRowNumber(
              title: "Intervalo de Atualização:",
              subtitle:
                  "Tenha em mente que dependendo da query, o intervalo pode não ser suficiente.",

              enabled: true,

              initialValue: Settings.panel.interval,
              minValue: 1,
              maxValue: 60,
              // maxLines: 5,
              onChange: (value) {
                Settings.panel.interval = value;
              },
            ),
          ),
          SettingsItem(
            child: SettingRowDropDown(
              title: "Tipo de Intervalo:",
              enabled: true,
              items: Settings.panel.availableTypes,
              selectedValue: Settings.panel.typeInterval,
              onChange: (value) {
                Settings.panel.typeInterval = value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
