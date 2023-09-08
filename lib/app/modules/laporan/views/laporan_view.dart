import 'package:carwash/app/model/cabang_model.dart';
import 'package:carwash/app/modules/laporan/views/detail_laporan.dart';
import 'package:carwash/app/modules/laporan/views/summary_laporan.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/alert.dart';
import '../../../helper/printer_kasir.dart';
import '../../master/controllers/master_controller.dart';
import '../controllers/laporan_controller.dart';
import 'drawer.dart';

class LaporanView extends GetView<LaporanController> {
  LaporanView(
      this.cabang, this.level, this.nama, this.alamat, this.telp, this.kota,
      {super.key});

  final String cabang;
  final String level;
  final String nama;
  final String alamat;
  final String telp;
  final String kota;
  final lapC = Get.put(LaporanController());
  final masterC = Get.put(MasterController());
  TextEditingController dateInputAwal = TextEditingController();
  TextEditingController dateInputAkhir = TextEditingController();

  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                  width: 300,
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(left: 10, right: 10),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(15)),
                      tabs: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.currency_exchange),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Summary')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.assignment_sharp),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Detail Laporan')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: 300,
                  height: 500,
                  child: TabBarView(children: [
                    SummaryLaporan(),
                    DetailLaporan(cabang, level, nama, alamat, telp, kota)
                    // MasterUsers(kode, level),
                    // MasterKaryawan(kode, level),
                    // MasterLevel(),
                    // MasterKendaraan(),
                    // ServicesView(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }

  searchDialog() {
    Get.bottomSheet(Container(
      decoration: const BoxDecoration(color: Colors.white),
      height: 145,
      child: Padding(
        padding: const EdgeInsets.only(top: 15, left: 8.0, right: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DateTimeField(
                    controller: dateInputAwal,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'Tanggal Awal',
                        border: OutlineInputBorder()),
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),
                ),
                Expanded(
                  child: DateTimeField(
                    controller: dateInputAkhir,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(1),
                        prefixIcon: Icon(Icons.calendar_month),
                        hintText: 'Tanggal Akhir',
                        border: OutlineInputBorder()),
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) {
                      return showDatePicker(
                          context: context,
                          firstDate: DateTime(1900),
                          initialDate: currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                    },
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4.0, top: 8, right: 4),
              child: ElevatedButton(
                  onPressed: () async {
                    // print(dateInputAwal.text);
                    if (dateInputAwal.text == "" && dateInputAkhir.text == "") {
                      showDefaultDialog(
                          "Perhatian", "Harap masukkan tanggal pencarian");
                    } else {
                      Get.defaultDialog(
                          barrierDismissible: false,
                          title: '',
                          content: Column(
                            children: const [
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text('Loading data...')
                            ],
                          ));
                      lapC.date1.value = dateInputAwal.text;
                      lapC.date2.value = dateInputAkhir.text;
                      await lapC.getSummary(
                          dateInputAwal.text,
                          dateInputAkhir.text,
                          0,
                          level == "1"
                              ? lapC.selectedCabang.isNotEmpty
                                  ? lapC.selectedCabang.value
                                  : ""
                              : cabang);
                      Future.delayed(const Duration(seconds: 1), () {
                        Get.back();
                        Get.back();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(Get.mediaQuery.size.width, 45),
                  ),
                  child: const Text(
                    'Cari',
                    style: TextStyle(fontSize: 20),
                  )),
            )
          ],
        ),
      ),
    ));
  }

  detailTrx(detailData, index) {
    var id = index == 0 ? 2 : 1;
    Get.defaultDialog(
        radius: 5,
        title: 'Detail Top Items',
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            const Divider(),
            SizedBox(
              height: 350.0, // Change as per your requirement
              width: 300.0,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount:
                      detailData.where((c) => c["id_jenis"] == id).length,
                  itemBuilder: (ctx, i) {
                    return ListTile(
                      title: Text(detailData[i]["no_polisi"]),
                      subtitle: Text(detailData[i]["kendaraan"]),
                      trailing: Text(NumberFormat.simpleCurrency(
                              locale: 'id', decimalDigits: 0)
                          .format(detailData[i]["grand_total"])
                          .toString()),
                    );
                  }),
            ),
            const Divider(),
          ],
        ));
  }
}
