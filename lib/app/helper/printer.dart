import 'dart:async';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class PrintSetting extends StatefulWidget {
  const PrintSetting({
    super.key,
  });

  @override
  // ignore: no_logic_in_create_state
  PrintSettingState createState() => PrintSettingState(dataPrint: null);
}

class PrintSettingState extends State<PrintSetting> {
  final Map<String, dynamic>? dataPrint;
  PrintSettingState({required this.dataPrint});
  BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

  bool _connected = false;
  BluetoothDevice? _device;
  String tips = 'no device connect';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => initBluetooth());
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initBluetooth() async {
    bluetoothPrint.startScan(timeout: const Duration(seconds: 4));

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) {
      switch (state) {
        case BluetoothPrint.CONNECTED:
          setState(() {
            _connected = true;
            tips = 'connect success';
          });
          break;
        case BluetoothPrint.DISCONNECTED:
          setState(() {
            _connected = false;
            tips = 'disconnect success';
          });
          break;
        default:
          break;
      }
    });

    if (!mounted) return;

    if (isConnected!) {
      setState(() {
        _connected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Printer'),
        backgroundColor: const Color.fromARGB(255, 29, 30, 32),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () =>
            bluetoothPrint.startScan(timeout: const Duration(seconds: 4)),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    child: Text(tips),
                  ),
                ],
              ),
              const Divider(),
              StreamBuilder<List<BluetoothDevice>>(
                stream: bluetoothPrint.scanResults,
                initialData: const [],
                builder: (c, snapshot) => Column(
                  children: snapshot.data!
                      .map((d) => ListTile(
                            title: Text(d.name ?? ''),
                            subtitle: Text(d.address!),
                            onTap: () async {
                              setState(() {
                                _device = d;
                              });
                            },
                            trailing:
                                _device != null && _device?.address == d.address
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.green,
                                      )
                                    : null,
                          ))
                      .toList(),
                ),
              ),
              const Divider(),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        OutlinedButton(
                          onPressed: _connected
                              ? null
                              : () async {
                                  if (_device != null &&
                                      _device!.address != null) {
                                    await bluetoothPrint.connect(_device!);
                                  } else {
                                    setState(() {
                                      tips = 'please select device';
                                    });
                                  }
                                },
                          child: const Text('connect'),
                        ),
                        const SizedBox(width: 10.0),
                        OutlinedButton(
                          onPressed: _connected
                              ? () async {
                                  await bluetoothPrint.disconnect();
                                }
                              : null,
                          child: const Text('disconnect'),
                        ),
                      ],
                    ),
                    OutlinedButton(
                      onPressed: _connected
                          ? () async {
                              await bluetoothPrint.printTest();
                            }
                          : null,
                      child: const Text('print test'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: StreamBuilder<bool>(
        stream: bluetoothPrint.isScanning,
        initialData: false,
        builder: (c, snapshot) {
          if (snapshot.data!) {
            return FloatingActionButton(
              onPressed: () => bluetoothPrint.stopScan(),
              backgroundColor: Colors.red,
              child: const Icon(Icons.stop),
            );
          } else {
            return FloatingActionButton(
                child: const Icon(Icons.search),
                onPressed: () => bluetoothPrint.startScan(
                    timeout: const Duration(seconds: 4)));
          }
        },
      ),
    );
  }

  printStruk() async {
    _connected;
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

    bool? isConnected = await bluetoothPrint.isConnected;

    bluetoothPrint.state.listen((state) async {
      if (state == 12 && isConnected!) {
        _connected = true;
        Map<String, dynamic> config = {};

        List<LineText> list = [];

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Saputra Car Wash\n',
          width: 2,
          height: 2,
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'Profesional Auto Detailing\n\n',
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'No Trx  : ${dataPrint!["no_trx"]}',
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content:
              'Tgl/jam : ${DateFormat("dd/MM/yyyy HH:mm:ss").format(DateTime.parse('${dataPrint!["tanggal"]}'))}',
          weight: 2,
          align: LineText.ALIGN_LEFT,
          linefeed: 1,
        ));

        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '===============================',
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));
        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: 'No Kendaraan : ${dataPrint!["no_polisi"]}',
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));

        list.add(LineText(
            type: LineText.TYPE_TEXT,
            content: 'Jenis  : ${dataPrint!["jeniskendaraan"]}',
            weight: 0,
            align: LineText.ALIGN_LEFT,
            linefeed: 1));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '===============================\n\n\n',
          weight: 2,
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));
        list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: '-- Terima kasih --',
          align: LineText.ALIGN_CENTER,
          linefeed: 1,
        ));

        await bluetoothPrint.printReceipt(config, list);

        Fluttertoast.showToast(
            msg: "Print Struk Berhasil.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.greenAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _connected = false;

        Fluttertoast.showToast(
            msg: "Print Struk Gagal. Cek koneksi printer.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.redAccent[700],
            textColor: Colors.white,
            fontSize: 16.0);
      }
    });
  }
}
