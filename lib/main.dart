import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late TextEditingController _controllerQuestoes, _controllerRespostas;
  String? _resposta, body;
  String _canSendSMSMessage = 'A verificação não está em execução.';
  List<String> campo = [];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    _controllerQuestoes = TextEditingController();
    _controllerRespostas = TextEditingController();
  }

  Future<void> _enviarQuestao(List<String> recipients) async {
    try {
      String _result = await sendSMS(
          message: _controllerQuestoes.text, recipients: recipients);
      setState(() => _resposta = _result);
    } catch (error) {
      setState(() => _resposta = error.toString());
    }
  }

  Future<bool> _canSendSMS() async {
    bool _result = await canSendSMS();
    setState(() => _canSendSMSMessage =
        _result ? 'This unit can send SMS' : 'This unit cannot send SMS');
    return _result;
  }

  Widget _phoneTile(String name) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
          decoration: BoxDecoration(
              border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
            top: BorderSide(color: Colors.grey.shade300),
            left: BorderSide(color: Colors.grey.shade300),
            right: BorderSide(color: Colors.grey.shade300),
          )),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: const Icon(Icons.crop_din),
                  onPressed: () {},
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(38),
                    child: Text(
                      name,
                      textScaleFactor: 1,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => campo.remove(name)),
                ),
              ],
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.red[50],
        appBar: AppBar(
          title: const Text('DEVTVAS - QUESTIONS'),
        ),
        body: ListView(
          children: <Widget>[
            ListTile(
              tileColor: Colors.red[50],
              leading: const Icon(Icons.text_fields_rounded),
              title: TextField(
                decoration: const InputDecoration(labelText: 'Add Question'),
                controller: _controllerQuestoes,
                onChanged: (String value) => setState(() {}),
              ),
            ),
            const Divider(),
            ListTile(
              tileColor: Colors.red[50],
              leading: const Icon(Icons.queue_sharp),
              title: TextField(
                controller: _controllerRespostas,
                decoration: const InputDecoration(labelText: 'Add Answer´s'),
                keyboardType: TextInputType.number,
                onChanged: (String value) => setState(() {}),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: _controllerRespostas.text.isEmpty
                    ? null
                    : () => setState(() {
                          campo.add(_controllerRespostas.text.toString());
                          _controllerRespostas.clear();
                        }),
              ),
            ),
            const Divider(),
            if (campo == null || campo.isEmpty)
              const SizedBox(height: 0)
            else
              SizedBox(
                height: 450,
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ListView(
                    scrollDirection: Axis.vertical,
                    children: List<Widget>.generate(campo.length, (int index) {
                      return _phoneTile(campo[index]);
                    }),
                  ),
                ),
              ),
            // ListTile(
            //   title: const Text('Can send SMS'),
            //   subtitle: Text(_canSendSMSMessage),
            //   trailing: IconButton(
            //     padding: const EdgeInsets.symmetric(vertical: 16),
            //     icon: const Icon(Icons.check),
            //     onPressed: () {
            //       _canSendSMS();
            //     },
            //   ),
            // ),

            Visibility(
              visible: _resposta != null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        _resposta ?? 'No Data',
                        maxLines: null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(25),
          ),
          child: GestureDetector(
            onTap: () {
              _salvar();
            },
            child: Center(
              child: Text(
                "SALVAR",
                style: Theme.of(context).accentTextTheme.button,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _salvar() {
    if (campo.isEmpty) {
      setState(() => _resposta = 'É necessário pelo menos 1 resposta!!!');
    } else {
      _enviarQuestao(campo);
    }
  }
}
