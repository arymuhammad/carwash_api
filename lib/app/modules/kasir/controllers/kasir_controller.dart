import 'package:carwash/app/helper/const.dart';
import 'package:carwash/app/helper/notif.dart';
import 'package:carwash/app/helper/service_api.dart';
import 'package:carwash/app/model/lap_kafe_model.dart';
import 'package:carwash/app/model/services_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KasirController extends GetxController {
  double dataBarang = 0.0;
  var datafB = <Services>[].obs;
  var listdata = [].obs;
  var lapKafe = <LapKafe>[].obs;
  var dateTrx = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());
  var generateTrx =
      int.parse(DateFormat('ddMMyyHHmmss').format(DateTime.now())).obs;
  var total = 0.obs;
  var kembalian = 0.obs;
  var noTrx = "";
  TextEditingController item = TextEditingController();
  TextEditingController transaksi = TextEditingController();
  TextEditingController pembayaran = TextEditingController();
  late TextEditingController bayar = TextEditingController();
  FocusNode myFocusNode = FocusNode();
  FocusNode myFocusNodePembayaran = FocusNode();
  final ScrollController scrollCtrl = ScrollController();
  List<String> metodpay = ["", "Cash", "BCA", "BRI", "BNI", "OVO", "DANA"];
  var paySelected = "".obs;
  var totalHarga = 0.obs;
  var byr = 0;
  var cpi = 0;
  var sort = true.obs;
  var searchDataLaporan = List<LapKafe>.empty(growable: true).obs;
  @override
  void onInit() {
    super.onInit();
    searchDataLaporan.value = lapKafe;
    // fetchData();
  }

  Future<List<Services>> fetchData() async {
    final result = await ServiceApi().getServicesByType("f%26b&b");
    return datafB.value = result;
  }

  void pay(String bayar) async {
    var result = int.parse(bayar) - total.value;
    kembalian.value = result;
    // print(kembalian.value);
  }

  Future<List<Services>> servicesById(String? idService) async {
    final response = await ServiceApi().getServicesById(idService);
    return response;
  }

  insertDataKafe(data) async {
    await ServiceApi().insertDataKafe(data);
  }

  Future<List<LapKafe>> getLaporan(
      String kodeCabang, String date1, String date2) async {
    final response =
        await ServiceApi().getLaporanKafe(kodeCabang, date1, date2);
    return lapKafe.value = response;
  }

  @override
  void onClose() {
    super.onClose();
  }

  onsortColum(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      if (ascending) {
        lapKafe.sort((a, b) => a.tanggal!.compareTo(b.tanggal!));
      } else {
        lapKafe.sort((a, b) => b.tanggal!.compareTo(a.tanggal!));
      }
    } else if (columnIndex == 1) {
      if (ascending) {
        lapKafe.sort((a, b) => a.noTrx!.compareTo(b.noTrx!));
      } else {
        lapKafe.sort((a, b) => b.noTrx!.compareTo(a.noTrx!));
      }
    }
    if (columnIndex == 2) {
      if (ascending) {
        lapKafe.sort((a, b) => a.kodeCabang!.compareTo(b.kodeCabang!));
      } else {
        lapKafe.sort((a, b) => b.kodeCabang!.compareTo(a.kodeCabang!));
      }
    }
    if (columnIndex == 4) {
      if (ascending) {
        lapKafe.sort((a, b) => a.grandTotal!.compareTo(b.grandTotal!));
      } else {
        lapKafe.sort((a, b) => b.grandTotal!.compareTo(a.grandTotal!));
      }
    }
    if (columnIndex == 5) {
      if (ascending) {
        lapKafe.sort((a, b) => a.payment!.compareTo(b.payment!));
      } else {
        lapKafe.sort((a, b) => b.payment!.compareTo(a.payment!));
      }
    }
  }

  filterDataLaporan(String data) {
    List<LapKafe> result = [];

    if (data.isEmpty) {
      result = lapKafe;
    } else {
      result = lapKafe
          .where((e) =>
              e.noTrx.toString().toLowerCase().contains(data.toLowerCase()) ||
              e.kodeCabang
                  .toString()
                  .toLowerCase()
                  .contains(data.toLowerCase()) ||
              e.tanggal.toString().toLowerCase().contains(data.toLowerCase()) ||
              e.payment.toString().toLowerCase().contains(data.toLowerCase()))
          .toList();
    }
    if (result.isEmpty) {
      result = lapKafe;
      fToast('E', 'Tidak ditemukan data dengan kata kunci $data');
    }
    searchDataLaporan.value = result;
  }
}
