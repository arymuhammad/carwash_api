// import 'package:dashboard_absensi/app/helper/loading_dialog.dart';
import 'package:carwash/app/helper/alert.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:ternav_icons/ternav_icons.dart';

import '../../home/controllers/home_controller.dart';
import '../controllers/laporan_controller.dart';
// import '../controllers/absensi_controller.dart';

class DrawerView extends GetView {
  DrawerView({super.key, this.level, this.cabang});
  // final absC = Get.put(AbsensiController());
  final String? level;
  final String? cabang;
  final lapC = Get.put(LaporanController());

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Row(
              children: const [
                Icon(Icons.info_outline_rounded),
                SizedBox(width: 5),
                Text('Filter Data'),
              ],
            ),
            const Divider(),
            const SizedBox(height: 15),
            SizedBox(
              height: 120,
              child: GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 5,
                    mainAxisExtent: 30),
                children: [
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        await lapC.getSummary(
                            lapC.date1.value = lapC.dateNow1,
                            lapC.date2.value = lapC.dateNow2,
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
                      },
                      child: const Text(
                        'Today',
                        style: TextStyle(fontSize: 11),
                      )),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(lapC.dateNow1)
                                    .add(const Duration(days: -1)))
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(DateTime.parse(lapC.dateNow2)
                                    .add(const Duration(days: -1)))
                                .toString(),
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
                      },
                      child: const Text('Yesterday',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var weekDay = d.weekday;
                        var firstDayOfWeek =
                            d.subtract(Duration(days: weekDay));
                        var lastDayOfWeek =
                            d.subtract(Duration(days: weekDay - 6));
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('This Week',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var weekDay = d.weekday;
                        var firstDayOfWeek =
                            d.subtract(Duration(days: weekDay + 7));
                        var lastDayOfWeek =
                            d.subtract(Duration(days: weekDay + 1));
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('Last Week',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var firstDayOfMonth = DateTime.utc(d.year, d.month, 1);
                        var day = d.difference(firstDayOfMonth);
                        var firstDayOfWeek =
                            d.subtract(Duration(days: day.inDays));
                        var lastDayOfWeek =
                            d.subtract(Duration(days: day.inDays - 29));
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('This Month',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var firstDayOfMonth = DateTime.utc(d.year, d.month, 1);
                        var day = d.difference(firstDayOfMonth);
                        var firstDayOfWeek =
                            d.subtract(Duration(days: day.inDays + 30));
                        var lastDayOfWeek =
                            d.subtract(Duration(days: day.inDays + 1));
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('Last Month',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var year = DateTime.utc(d.year, 1, 1);
                        var days = d.difference(year);
                        var firstDayOfWeek =
                            d.subtract(Duration(days: days.inDays));
                        var lastDayOfWeek = d.subtract(Duration(
                          days: days.inDays - 364,
                        ));
                        // print(lastDayOfWeek);
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('This Year',
                          style: TextStyle(fontSize: 11))),
                  OutlinedButton(
                      onPressed: () async {
                        showLoading();
                        var d = DateTime.now();
                        var year = DateTime.utc(d.year - 1, 1, 1);
                        var days = d.difference(year);
                        var firstDayOfWeek =
                            d.subtract(Duration(days: days.inDays));
                        var lastDayOfWeek =
                            d.subtract(Duration(days: days.inDays - 364));
                        await lapC.getSummary(
                            lapC.date1.value = DateFormat('yyyy-MM-dd')
                                .format(firstDayOfWeek)
                                .toString(),
                            lapC.date2.value = DateFormat('yyyy-MM-dd')
                                .format(lastDayOfWeek)
                                .toString(),
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
                      },
                      child: const Text('Last Year',
                          style: TextStyle(fontSize: 11))),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: const [
                Icon(Icons.calendar_month_rounded),
                SizedBox(width: 5),
                Text('Cari berdasarkan tanggal'),
              ],
            ),
            const Divider(),
            DateTimeField(
              controller: lapC.dateInputAwal,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0.5),
                  prefixIcon: Icon(Icons.calendar_month_sharp),
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
            const SizedBox(
              height: 5,
            ),
            DateTimeField(
              controller: lapC.dateInputAkhir,
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(0.5),
                  prefixIcon: Icon(Icons.calendar_month_sharp),
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
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(minimumSize: const Size(45, 45)),
                onPressed: () async {
                  if (lapC.dateInputAwal.text == "" &&
                      lapC.dateInputAkhir.text == "") {
                    showDefaultDialog(
                        "Perhatian", "Harap masukkan tanggal pencarian");
                  } else if (DateTime.parse(lapC.dateInputAwal.text)
                      .isAfter(DateTime.parse(lapC.dateInputAkhir.text))) {
                    showDefaultDialog("Perhatian",
                        "Tanggal awal harus lebih kecil dari tanggal akhir");
                  } else {
                    showLoading();
                    lapC.date1.value = lapC.dateInputAwal.text;
                    lapC.date2.value = lapC.dateInputAkhir.text;
                    await lapC.getSummary(
                        lapC.dateInputAwal.text,
                        lapC.dateInputAkhir.text,
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
                child: const Text('Cari'))
          ],
        ),
      ),
    );
  }
}
