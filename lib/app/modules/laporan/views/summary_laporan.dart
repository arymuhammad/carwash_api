// ignore_for_file: must_be_immutable

import 'package:carwash/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:carwash/app/modules/master/controllers/master_controller.dart';
import 'package:data_table_2/data_table_2.dart';
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
    // Sinkronisasi cabang dari masterC ke lapC (lakukan sekali, misal di onReady atau binding)
    if (lapC.cabang.isEmpty && masterC.cabang.isNotEmpty) {
      lapC.cabang.assignAll(masterC.cabang);
    }

    return Obx(() {
      if (masterC.cabang.isEmpty || lapC.summaryCache.isEmpty) {
        return const Center(child: CircularProgressIndicator());
      }

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
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (periode) {
                     if (periode != null) {
    lapC.now.value = periode;
  } else {
    // Jika periode dihapus (null), set ke bulan sekarang
    final now = DateTime.now();
    lapC.now.value = DateTime(now.year, now.month, 1);
  }
  lapC.getPeriode();
  lapC.datePeriode.text = DateFormat("MMMM yyyy").format(lapC.now.value);
  lapC.fetchAllSummary();
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
          Scrollbar(
            controller: scrollController,
            thickness: 8,
            radius: const Radius.circular(10),
            thumbVisibility: true,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: scrollController,
              child: DataTable(
                // fixedLeftColumns: 0,
                headingRowColor: const WidgetStatePropertyAll(Colors.indigo),
                headingTextStyle: const TextStyle(color: Colors.white),
                showBottomBorder: true,
                border: const TableBorder.symmetric(outside: BorderSide()),
                headingRowHeight: 35,
                columns: [
                  const DataColumn(
                    label: SizedBox(width: 100, child: Text('Cabang')),
                  ),
                  for (DateTime date in lapC.dates)
                    DataColumn(
                      label: SizedBox(
                        width: 100,
                        child: Text(lapC.formatter.format(date)),
                      ),
                    ),
                ],
                rows: List.generate(masterC.cabang.length, (i) {
                  final kodeCabang = masterC.cabang[i].kodeCabang!;
                  return DataRow(
                    cells: [
                      DataCell(Text('${masterC.cabang[i].namaCabang}')),
                      for (DateTime date in lapC.dates)
                        DataCell(
                          Obx(() {
                            String dateStr = DateFormat(
                              'yyyy-MM-dd',
                            ).format(date);
                            bool isLoading =
                                lapC.loadingStatus[kodeCabang]?[dateStr] ??
                                true;
                            int total =
                                lapC.summaryCache[kodeCabang]?[dateStr] ?? 0;

                            if (isLoading) {
                              return const Center(
                                child: SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            } else {
                              return Text(
                                NumberFormat.simpleCurrency(
                                  locale: 'in',
                                  decimalDigits: 0,
                                ).format(total),
                              );
                            }
                          }),
                        ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      );
    });
  }
}
