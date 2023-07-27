// ignore_for_file: must_be_immutable

import 'package:carwash/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:carwash/app/modules/master/controllers/master_controller.dart';
// import 'package:data_table_2/data_table_2.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class SummaryLaporan extends GetView {
  SummaryLaporan({super.key});
  ScrollController scrollController = ScrollController();
  final masterC = Get.put(MasterController());
  final lapC = Get.put(LaporanController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 250,
              child: DateTimeField(
                controller: lapC.datePeriode,
                style: const TextStyle(fontSize: 14),
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(0.5),
                    prefixIcon: Icon(Icons.calendar_month_sharp),
                    hintText: 'Pilih Periode',
                    border: OutlineInputBorder()),
                onChanged: (periode) {
                  lapC.now.value = periode!;
                  lapC.dates.clear();
                  lapC.getPeriode();
                },
                format: DateFormat("MMMM yyyy"),
                onShowPicker: (context, currentValue) {
                  return showMonthYearPicker(
                    context: context,
                    firstDate: DateTime(2000),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: Get.mediaQuery.size.height / 3,
          width: 100,
          child: Scrollbar(
            controller: scrollController,
            thickness: 8,
            radius: const Radius.circular(10),
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: Obx(
                () => DataTable(
                  // fixedLeftColumns: 0,
                  headingRowColor:
                      const MaterialStatePropertyAll(Colors.indigo),
                  headingTextStyle: const TextStyle(color: Colors.white),
                  showBottomBorder: true,
                  border: TableBorder.symmetric(outside: const BorderSide()),
                  columns: [
                    const DataColumn(
                        label: SizedBox(width: 100, child: Text('Cabang'))),
                    for (DateTime date in lapC.dates)
                      DataColumn(
                          label: SizedBox(
                              width: 100,
                              child: Text(lapC.formatter.format(date))))
                  ],
                  rows: List.generate(masterC.cabang.length, (i) {
                    return DataRow(cells: [
                      DataCell(Text('${masterC.cabang[i].namaCabang}')),
                      for (DateTime date in lapC.dates)
                        DataCell(FutureBuilder(
                          future: lapC.getSummary(
                              DateFormat('yyyy-MM-dd').format(date),
                              DateFormat('yyyy-MM-dd').format(date),
                              0,
                              masterC.cabang[i].kodeCabang),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var data = snapshot.data!;
                              var totalIncome = [];
                              data.map((data) {
                                totalIncome.add(int.parse(data.grandTotal!));
                              }).toList();
                              int netSales = totalIncome.fold(
                                  0,
                                  (temp, grandTotal) =>
                                      temp + grandTotal as int);
                              return Text(NumberFormat.simpleCurrency(
                                      locale: 'in', decimalDigits: 0)
                                  .format(netSales)
                                  .toString());
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          },
                        )),
                    ]);
                  }),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
