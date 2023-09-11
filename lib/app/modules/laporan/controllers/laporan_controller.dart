import 'dart:convert';

import 'package:carwash/app/helper/service_api.dart';
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
  var selectedCabang = "".obs;
  var tempSummService = [].obs;
  var tempJenisKendaraan = [].obs;
  var detailData = [].obs;
  late TextEditingController dateInputAwal;
  late TextEditingController dateInputAkhir;
  late TextEditingController datePeriode;
  var dateNow1 = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var dateNow2 = DateFormat('yyyy-MM-dd').format(DateTime.now());

  var report = <Laporan>[].obs;
  var qty = 1;
  var now = DateTime.now().obs;
  var dates = [].obs;
  final DateFormat formatter = DateFormat.yMMMd();

  @override
  void onInit() {
    var startOfMonth = DateTime(now.value.year, now.value.month, 1);
    for (int i = 0; i <= now.value.day - 1; i++) {
      var date = startOfMonth.add(Duration(days: i));
      dates.add(date);
    }
    super.onInit();
    dateInputAwal = TextEditingController();
    dateInputAkhir = TextEditingController();
    datePeriode = TextEditingController();
  }

  @override
  void onClose() {
    super.dispose();
    dateInputAwal.dispose();
    dateInputAkhir.dispose();
    datePeriode.dispose();
  }

  Future<List<Laporan>> getSummary(dateAwal, dateAkhir, idJenis, cabang) async {
    // var response = await BaseClient().get("https://saputracarwash.online/api",
    //     "/laporan/get_laporan.php?date1=$dateAwal&date2=$dateAkhir&id_jenis=$idJenis&cabang=$cabang");
    // // print(
    // //     "https://saputracarwash.online/api/laporan/get_laporan.php?date1=$dateAwal&date2=$dateAkhir&id_jenis=$idJenis&cabang=$cabang");
    // List<dynamic> dataLaporan = json.decode(response)['rows'];
    // List<Laporan> laporan =
    //     dataLaporan.map((e) => Laporan.fromJson(e)).toList();
    final response = await ServiceApi()
        .getSummaryReport(dateAwal, dateAkhir, idJenis, cabang);
    report.value = response;
    return response;
  }

  Future<List<Services>> servicesById(idService) async {
    // var response = await BaseClient().get("https://saputracarwash.online/api",
    //     "/master/get_services.php?id=$idService");
    // List<dynamic> srv = json.decode(response)['rows'];
    // List<Services> dtSrv = srv.map((e) => Services.fromJson(e)).toList();
    // return dtSrv;
    final response = await ServiceApi().getServicesById(idService);
    return response;
  }

  getPeriode() {
    var startOfMonth = DateTime(now.value.year, now.value.month + 1, 0);
    for (int i = 0; i <= startOfMonth.day - 1; i++) {
      var dateNew = now.value.add(Duration(days: i));
      dates.add(dateNew);
      // print(now);
    }
  }
}
