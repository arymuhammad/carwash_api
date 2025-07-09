// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;
import 'package:carwash/app/helper/service_api.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ota_update/ota_update.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../helper/app_exceptions.dart';
import '../../../helper/base_client.dart';
import '../../../model/cabang_model.dart';
import '../../../model/karyawan_model.dart';
import '../../../model/merk_model.dart';
import '../../../model/trx_count_model.dart';
import '../../../model/trx_model.dart';

class HomeController extends GetxController {
  late OtaEvent currentEvent;
  var dataNoPol = [].obs;
  var url = "";
  late TextEditingController noPol1 = TextEditingController();
  late TextEditingController noPol2 = TextEditingController();
  late TextEditingController noPol3 = TextEditingController();

  var tglReg =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()).toString().obs;
  var selectedItem = "".obs;
  var selectedMerk = "".obs;
  var generateBarcode = 1.obs;
  var initService = [];
  var serviceItem = [].obs;
  var servicepaid = [];

  var selectedPetugas = [].obs;
  var noUrutTrx = "".obs;

  var idTrx = "";
  var tempStruk = {}.obs;
  var namaCabang = "";
  var alamatCabang = "";
  var kotaCabang = "";
  var noPolisi = [];
  var listnopol = [];
  var downloadProgress = 0.0.obs;
  String? kode;
  String? level;
  String? id;
  var jenisKendaran = [
    {"id": 1, "jenis": "Motor"},
    {"id": 2, "jenis": "Mobil"},
  ];
  var dataCabang = <Cabang>[].obs;
  var dataMerk = <Merk>[].obs;
  var dataTrx = <TrxCount>[].obs;
  var dateNow = DateFormat('ddMMyy').format(DateTime.now());
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final bool running = true;
  var listKaryawan = <Karyawan>[].obs;

  late EventSource eventSource;
  var dtTrx = <Trx>[].obs;

  // StreamController untuk masing-masing stream data SSE
  late StreamController<List<dynamic>> stream1Controller;
  // late StreamController<List<dynamic>> stream2Controller;
  // late StreamController<List<dynamic>> stream3Controller;

  EventSource? eventSource1;
  // EventSource? eventSource2;
  // EventSource? eventSource3;

  @override
  void onInit() {
    //  print(
    //   '${ServiceApi().baseUrl}transaksi/transaksi_sse.php?kode_cabang=001&tanggal=2025-07-05&status=3&id_jenis=1',
    // );
    super.onInit();
    // getCabang(kode, level);
    // getMerkById(id);
    // getTrx(kode, date);
    // getKaryawan(kode);
    generateNoTrx();

    stream1Controller = StreamController<List<dynamic>>.broadcast();
    // stream2Controller = StreamController<List<dynamic>>.broadcast();
    // stream3Controller = StreamController<List<dynamic>>.broadcast();

    // connectSse1();
    // connectSse2();
    // connectSse3();
  }

  @override
  void dispose() {
    // eventSource.close();
    // eventSource1?.close();
    // eventSource2?.close();
    // eventSource3?.close();
    stream1Controller.close();
    // stream2Controller.close();
    // stream3Controller.close();
    super.dispose();
  }

  void connectSse1() async {
    final url =
        '${ServiceApi().baseUrl}transaksi/transaksi_sse.php?kode_cabang=001&tanggal=2025-07-05&status=3&id_jenis=2';
    eventSource1 = await EventSource.connect(url);

    eventSource1!.listen((event) {
      final data = jsonDecode(event.data ?? '{}');
      if (data['success'] == 1) {
        stream1Controller.add(data['rows']);
      } else {
        stream1Controller.add([]);
      }
    });
  }

  // void connectSse2() async {
  //   final url =
  //       '${ServiceApi().baseUrl}transaksi/transaksi_sse.php?kode_cabang=002&tanggal=2025-07-05&status=1&id_jenis=';
  //   eventSource2 = await EventSource.connect(url);
  //   eventSource2!.listen((event) {
  //     final data = jsonDecode(event.data ?? '{}');
  //     if (data['success'] == 1) {
  //       stream2Controller.add(data['rows']);
  //     } else {
  //       stream2Controller.add([]);
  //     }
  //   });
  // }

  // void connectSse3() async {
  //   final url =
  //       '${ServiceApi().baseUrl}transaksi/transaksi_sse.php?kode_cabang=003&tanggal=2025-07-05&status=3&id_jenis=1';
  //   eventSource3 = await EventSource.connect(url);
  //   eventSource3!.listen((event) {
  //     final data = jsonDecode(event.data ?? '{}');
  //     if (data['success'] == 1) {
  //       stream3Controller.add(data['rows']);
  //     } else {
  //       stream3Controller.add([]);
  //     }
  //   });
  // }

  Stream<List<dynamic>> get stream1 => stream1Controller.stream;
  // Stream<List<dynamic>> get stream2 => stream2Controller.stream;
  // Stream<List<dynamic>> get stream3 => stream3Controller.stream;

  // connectSse(String kodeCabang, tanggal, status, idJenis) async {
  //   final url =
  //       '${ServiceApi().baseUrl}transaksi/transaksi_sse.php?kode_cabang=$kodeCabang&tanggal=$tanggal&status=$status&id_jenis=$idJenis';
  //   eventSource = await EventSource.connect(url);

  //   eventSource.listen(
  //     (event) {
  //       final data = event.data;
  //       final jsonData = data != null ? jsonDecode(data) : null;

  //       if (jsonData != null && jsonData['success'] == 1) {
  //         // setState(() {
  //         dtTrx.value = jsonData['rows'];
  //         // pesan = jsonData['pesan'];
  //         // });
  //       } else {
  //         // setState(() {
  //         dtTrx.value = [];
  //         // pesan = jsonData?['pesan'] ?? 'Tidak ada data';
  //         // });
  //       }
  //     },
  //     onError: (error) {
  //       print('SSE error: $error');
  //       // Bisa coba reconnect atau tampilkan pesan error
  //     },
  //   );
  // }

  Future<List<Cabang>> getCabang(kode, level) async {
    final response = await http.get(
      Uri.parse(
        '${ServiceApi().baseUrl}cabang/get_cabang.php?kode=$kode&level=$level',
      ),
    );
    List<dynamic> cabang = json.decode(response.body)['rows'];
    List<Cabang> dtCabang = cabang.map((e) => Cabang.fromJson(e)).toList();
    dataCabang.value = dtCabang;
    return dtCabang;
  }

  Future<List<Merk>> getMerkById(jenis) async {
    var response = await http.get(
      Uri.parse('${ServiceApi().baseUrl}merk/get_merk.php?id_jenis=$jenis'),
    );
    List<dynamic> merk = json.decode(response.body)['rows'];
    List<Merk> dtMerk = merk.map((e) => Merk.fromJson(e)).toList();
    dataMerk.value = dtMerk;
    return dtMerk;
  }

  Future<List<TrxCount>> getTrx(kodeCabang, date) async {
    var response = await http.get(
      Uri.parse(
        '${ServiceApi().baseUrl}transaksi/get_trx.php?kode_cabang=$kodeCabang&tanggal=$date',
      ),
    );
    List<dynamic> trx = json.decode(response.body)['rows'];
    List<TrxCount> dtTrx = trx.map((e) => TrxCount.fromJson(e)).toList();
    dataTrx.value = dtTrx;
    return dtTrx;
  }

  Stream<List<Trx>> getDatatrxSse(kodeCabang, date, status, idJenis) {
    // while (running) {
    //   await Future.delayed(const Duration(seconds: 5));
    //   var response = await http.get(
    //     Uri.parse(
    //       '${ServiceApi().baseUrl}transaksi/getTrxStatus.php?kode_cabang=$kodeCabang&tanggal=$date&status=$status&id_jenis=$idJenis',
    //     ),
    //   );
    //   // print(
    //   //   '${ServiceApi().baseUrl}transaksi/getTrxStatus.php?kode_cabang=$kodeCabang&tanggal=$date&status=$status&id_jenis=$idJenis',
    //   // );
    //   List<dynamic> trx = json.decode(response.body)['rows'];
    //   List<Trx> dtTrx = trx.map((e) => Trx.fromJson(e)).toList();
    //   yield dtTrx;
    // }
    final url = Uri.parse(
      '${ServiceApi().baseUrl}transaksi/getTrxStatus_sse.php?kode_cabang=$kodeCabang&tanggal=$date&status=$status&id_jenis=$idJenis',
    );
    // print(
    //   '${ServiceApi().baseUrl}transaksi/getTrxStatus_sse.php?kode_cabang=$kodeCabang&tanggal=$date&status=$status&id_jenis=$idJenis',
    // );
    final controller = StreamController<List<Trx>>();
    final eventSource = html.EventSource(url.toString());

    eventSource.onMessage.listen((event) {
      try {
        final jsonData = jsonDecode(event.data);
        if (jsonData['success'] == 1) {
          List<dynamic> rows = jsonData['rows'];
          List<Trx> trxList = rows.map((e) => Trx.fromJson(e)).toList();
          controller.add(trxList);
        } else {
          controller.add([]);
        }
      } catch (e) {
        controller.addError(e);
      }
    });

    eventSource.onError.listen((error) {
      controller.addError('SSE error: $error');
      // eventSource.close();
    });

    controller.onCancel = () {
      eventSource.close();
    };

    return controller.stream;
  }

  Stream<String> getDate() async* {
    while (running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      DateTime now = DateTime.now();
      yield "${DateFormat('dd/MM/yyyy').format(now)} ${now.hour} : ${now.minute} : ${now.second}";
    }
  }

  submitData(data) async {
    await http.post(
      Uri.parse('${ServiceApi().baseUrl}transaksi/input_trx.php'),
      body: data,
    );
  }

  Future<void> tryOtaUpdate() async {
    try {
      Get.defaultDialog(
        title: 'UPDATE APP',
        radius: 5,
        barrierDismissible: false,
        onWillPop: () async {
          return false;
        },
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Divider(),
            const Text('Mengunduh Pembaruan'),
            Obx(() => Text('${(downloadProgress.value).toInt()}%')),
            const SizedBox(height: 5),
            Obx(
              () => LinearPercentIndicator(
                lineHeight: 10.0,
                percent: downloadProgress.value / 100,
                backgroundColor: Colors.grey[220],
                progressColor: Colors.blue,
                barRadius: const Radius.circular(5),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
      );
      OtaUpdate()
          .execute(
            'http://103.156.15.61/apk/carwash.apk',
            destinationFilename: 'carwash.apk',
          )
          .listen(
            (OtaEvent event) {
              downloadProgress.value = double.parse(event.value!);
            },
            // onError: errorHandle(Error()),
            onDone: () => Get.back(),
          );
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }

  Future<List<Karyawan>> getKaryawan(kode) async {
    // while (running) {
    // Future.delayed(const Duration(seconds: 1));
    var response = await http.get(
      Uri.parse('${ServiceApi().baseUrl}/master/get_karyawan.php?cabang=$kode'),
    );
    List<dynamic> dtKaryawan = json.decode(response.body)['rows'];
    List<Karyawan> karyawan =
        dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
    // print(dtKaryawan);
    listKaryawan.value = karyawan;
    return listKaryawan;
    // }
  }

  handleError(error) {
    // hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      Get.defaultDialog(
        title: 'Error',
        content: Text(message.toString()),
        confirm: ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: () {
            // getTrx(kode, kode, kode);
            // getCabang(kode, level);
            // getKaryawan(kode);
            // getMerkById(kode);
            Get.back();
          },
        ),
      );
    } else if (error is FetchDataException) {
      var message = error.message;
      Get.defaultDialog(
        title: 'Error',
        content: Text(message.toString()),
        confirm: ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: () {
            // getTrx(kode, kode, date);
            // getCabang(kode, level);
            // getKaryawan(kode);
            // getMerkById(kode);
            Get.back();
          },
        ),
      );
    } else if (error is ApiNotRespondingException) {
      // DialogHelper()
      //     .showErroDialog(description: 'Oops! It took longer to respond.');
      Get.defaultDialog(
        title: 'Error',
        content: const Text('Oops! It took longer to respond.'),
        confirm: ElevatedButton.icon(
          icon: const Icon(Icons.refresh),
          label: const Text('Retry'),
          onPressed: () async {
            // getTrx(kode, kode, date);
            // getCabang(kode, level);
            // getKaryawan(kode);
            // getMerkById(kode);
            Get.back();
          },
        ),
      );
    }
  }

  generateNoTrx() async {
    var generateNum = Random().nextInt(1000000000);
    return idTrx = '$generateNum';
  }
}
