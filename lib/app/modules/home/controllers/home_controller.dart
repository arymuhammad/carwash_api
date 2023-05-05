// import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:ota_update/ota_update.dart';

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

  var idTrx = 1.obs;
  var tempStruk = {}.obs;
  var namaCabang = "";
  var alamatCabang = "";
  var kotaCabang = "";
  var noPolisi = [];
  var listnopol = [];
  String? kode;
  String? level;
  String? id;
  var jenisKendaran = [
    {"id": 1, "jenis": "Motor"},
    {"id": 2, "jenis": "Mobil"}
  ];
  var dataCabang = <Cabang>[].obs;
  var dataMerk = <Merk>[].obs;
  var dataTrx = <TrxCount>[].obs;
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final bool running = true;
  var listKaryawan = <Karyawan>[].obs;
  @override
  void onInit() {
    super.onInit();
    getCabang(kode, level);
    getMerkById(id);
    getTrx(kode, kode, date);
    getKaryawan(kode);
  }

  Future<List<Cabang>> getCabang(kode, level) async {
    var response = await BaseClient().get('https://saputracarwash.online/api',
        '/cabang/get_cabang.php?kode=$kode&level=$level');
    List<dynamic> cabang = json.decode(response)['rows'];
    List<Cabang> dtCabang = cabang.map((e) => Cabang.fromJson(e)).toList();
    dataCabang.value = dtCabang;
    return dtCabang;
  }

  Future<List<Merk>> getMerkById(jenis) async {
    var response = await BaseClient().get('https://saputracarwash.online/api',
        '/merk/get_merk.php?id_jenis=$jenis');
    List<dynamic> merk = json.decode(response)['rows'];
    List<Merk> dtMerk = merk.map((e) => Merk.fromJson(e)).toList();
    dataMerk.value = dtMerk;
    return dtMerk;
  }

  Stream<List<TrxCount>> getTrx(kodeCabang, kodeUser, date) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('https://saputracarwash.online/api',
          '/transaksi/get_trx.php?kode_cabang=$kodeCabang&kode_user=$kodeUser&tanggal=$date');
      List<dynamic> trx = json.decode(response)['rows'];
      List<TrxCount> dtTrx = trx.map((e) => TrxCount.fromJson(e)).toList();
      dataTrx.value = dtTrx;
      yield dtTrx;
    }
  }

  Stream<List<Trx>> getDatatrx(kodeCabang, date, status, idJenis) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get("https://saputracarwash.online/api",
          "/transaksi/getTrxStatus.php?kode_cabang=$kodeCabang&tanggal=$date&status=$status&id_jenis=$idJenis");
      List<dynamic> trx = json.decode(response)['rows'];
      List<Trx> dtTrx = trx.map((e) => Trx.fromJson(e)).toList();
      yield dtTrx;
    }
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
        Uri.parse('https://saputracarwash.online/api/transaksi/input_trx.php'),
        body: data);
  }

  Future<void> tryOtaUpdate() async {
    try {
      Get.defaultDialog(
          title: 'UPDATE APP',
          radius: 5,
          barrierDismissible: false,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Divider(),
              Text('Mengunduh Pembaruan'),
              Text('Harap Menunggu'),
              SizedBox(
                height: 10,
              ),
              LinearProgressIndicator(
                minHeight: 10,
              ),
              SizedBox(
                height: 5,
              ),
            ],
          ));
      OtaUpdate()
          .execute(
        'http://103.112.139.155/apk/carwash.apk',
        destinationFilename: 'carwash.apk',
      )
          .listen(
        (OtaEvent event) {
          currentEvent = event;
        },
      );
      // ignore: avoid_catches_without_on_clauses, empty_catches
    } catch (e) {}
  }

  Stream<List<Karyawan>> getKaryawan(kode) async* {
    while (running) {
      Future.delayed(const Duration(seconds: 1));
      var response = await BaseClient().get('https://saputracarwash.online/api',
          '/master/get_karyawan.php?cabang=$kode');
      List<dynamic> dtKaryawan = json.decode(response)['rows'];
      List<Karyawan> karyawan =
          dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
      // print(dtKaryawan);
      listKaryawan.value = karyawan;
      yield listKaryawan;
    }
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
              }));
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
              }));
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
              }));
    }
  }
}
