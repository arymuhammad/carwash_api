import 'package:carwash/app/helper/service_api.dart';
import 'package:carwash/app/model/cabang_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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

  var cabang = <Cabang>[].obs; // Pastikan ini diisi dari MasterController
  var summaryCache =
      <String, Map<String, int>>{}.obs; // cabang -> tanggal -> total
  // Map untuk menyimpan status loading per cabang dan tanggal
  var loadingStatus = <String, Map<String, bool>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    getPeriode();
    dateInputAwal = TextEditingController();
    dateInputAkhir = TextEditingController();
    datePeriode = TextEditingController();
    // Contoh: setelah cabang dan dates siap, panggil fetchAllSummary
    ever(cabang, (_) {
      if (cabang.isNotEmpty && dates.isNotEmpty) {
        fetchAllSummary();
      }
    });
  }

  @override
  void onClose() {
    dateInputAwal.dispose();
    dateInputAkhir.dispose();
    datePeriode.dispose();
    super.onClose();
  }

  Future<void> fetchAllSummary() async {
    summaryCache.clear();
    loadingStatus.clear();

    for (var c in cabang) {
      summaryCache[c.kodeCabang!] = {};
      loadingStatus[c.kodeCabang!] = {};

      for (var date in dates) {
        String dateStr = DateFormat('yyyy-MM-dd').format(date);
        loadingStatus[c.kodeCabang]![dateStr] = true;
        loadingStatus.refresh();
        int total = await getSummarySingle(dateStr, c.kodeCabang!);
        summaryCache[c.kodeCabang]![dateStr] = total;
        loadingStatus[c.kodeCabang]![dateStr] = false;
        
        
        summaryCache.refresh();
        loadingStatus.refresh();
      }
    }
  }

  Future<int> getSummarySingle(String date, String kodeCabang) async {
    try {
      List<Laporan> laporanList = await getSummary(date, date, 0, kodeCabang);
      int total = 0;
      for (var laporan in laporanList) {
        total += int.tryParse(laporan.grandTotal ?? '0') ?? 0;
      }
      return total;
    } catch (e) {
      print('Error getSummarySingle: $e');
      return 0;
    }
  }

  Future<List<Laporan>> getSummary(dateAwal, dateAkhir, idJenis, cabang) async {
    // var response = await BaseClient().get("https://saputracarwash.online/api",
    //     "/laporan/get_laporan.php?date1=$dateAwal&date2=$dateAkhir&id_jenis=$idJenis&cabang=$cabang");
    // // print(
    // //     "https://saputracarwash.online/api/laporan/get_laporan.php?date1=$dateAwal&date2=$dateAkhir&id_jenis=$idJenis&cabang=$cabang");
    // List<dynamic> dataLaporan = json.decode(response)['rows'];
    // List<Laporan> laporan =
    //     dataLaporan.map((e) => Laporan.fromJson(e)).toList();
    final response = await ServiceApi().getSummaryReport(
      dateAwal,
      dateAkhir,
      idJenis,
      cabang,
    );
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
    dates.clear(); // clear list
    var startOfMonth = DateTime(now.value.year, now.value.month, 1);
    var endOfMonth = DateTime(now.value.year, now.value.month + 1, 0);
    for (int i = 0; i < endOfMonth.day; i++) {
      var dateNew = startOfMonth.add(Duration(days: i));
      dates.add(dateNew);
    }
  }
}
