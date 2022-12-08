import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/base_client.dart';
import '../../../model/laporan_model.dart';
import '../../../model/services_model.dart';

class LaporanController extends GetxController {
  var date1 = "".obs;
  var date2 = "".obs;
  var selectedItem = "".obs;
  var cabang = "";
  var tempSummService = [].obs;
  var tempJenisKendaraan = [].obs;
  var detailData = [].obs;
  TextEditingController dateInputAwal = TextEditingController();
  TextEditingController dateInputAkhir = TextEditingController();
  var dateNow1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var dateNow2 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var report = <Laporan>[].obs;
  var qty = 1;
  @override
  void onInit() {
    super.onInit();
  }

  Future<List<Laporan>> getSummary(dateAwal, dateAkhir, idJenis) async {
    var response = await BaseClient().get("https://saputracarwash.online/api",
        "/laporan/get_laporan.php?date1=$date1&date2=$dateAkhir&id_jenis=$idJenis");
    List<dynamic> dataLaporan = json.decode(response)['rows'];
    List<Laporan> laporan =
        dataLaporan.map((e) => Laporan.fromJson(e)).toList();
    report.value = laporan;
    return laporan;
  }

  Future<List<Services>> servicesById(idService) async {
    var response = await BaseClient().get("https://saputracarwash.online/api",
        "/master/get_services.php?id=$idService");
    List<dynamic> srv = json.decode(response)['rows'];
    List<Services> dtSrv = srv.map((e) => Services.fromJson(e)).toList();
    return dtSrv;
  }
}
