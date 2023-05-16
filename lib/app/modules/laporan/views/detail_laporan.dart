import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/alert.dart';
import '../../../helper/printer_kasir.dart';
import '../../../model/cabang_model.dart';
import '../../master/controllers/master_controller.dart';
import '../controllers/laporan_controller.dart';
import 'drawer.dart';

class DetailLaporan extends GetView {
  DetailLaporan(this.cabang, this.level, {super.key});

  final String cabang;
  final String level;
  final lapC = Get.put(LaporanController());
  final masterC = Get.put(MasterController());

  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: DrawerView(level: level, cabang: cabang),
      key: _key,
      body: ListView(
        children: [
          Visibility(
            visible: level == "1" ? true : false,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8.0),
              child: FutureBuilder(
                future: masterC.getFutureCabang(),
                builder: (context, snapshot) {
                  var lst = <Cabang>{};
                  lst.add(Cabang(kodeCabang: '', namaCabang: ''));
                  if (snapshot.hasData) {
                    snapshot.data!.map((e) {
                      var resltData = Cabang(
                          kodeCabang: e.kodeCabang!, namaCabang: e.namaCabang!);
                      return lst.add(resltData);
                    }).toList();
                    return Obx(() => Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250,
                              child: DropdownButtonFormField(
                                decoration: const InputDecoration(
                                    hintText: 'Pilih Cabang',
                                    border: OutlineInputBorder()),
                                value: lapC.selectedCabang.value == ""
                                    ? null
                                    : lapC.selectedCabang.value,
                                // isDense: true,
                                onChanged: (String? data) async {
                                  // print(lst);
                                  showLoading();
                                  lapC.selectedCabang.value = data!;
                                  await lapC.getSummary(
                                      lapC.date1.value != ""
                                          ? lapC.date1.value
                                          : lapC.date1.value = lapC.dateNow1,
                                      lapC.date2.value != ""
                                          ? lapC.date2.value
                                          : lapC.date2.value = lapC.dateNow2,
                                      0,
                                      level == "1"
                                          ? lapC.selectedCabang.isNotEmpty
                                              ? lapC.selectedCabang.value
                                              : ""
                                          : cabang);
                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Get.back();
                                  });
                                },
                                items: lst.map((doc) {
                                  return DropdownMenuItem<String>(
                                      value: doc.kodeCabang!,
                                      child: Text(doc.namaCabang!));
                                }).toList(),
                              ),
                            ),
                          ],
                        ));
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                        CupertinoActivityIndicator(),
                        SizedBox(width: 5),
                        Text('Sedang memuat ....')
                      ]));
                },
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Obx(
            () => FutureBuilder(
              future: lapC.getSummary(
                  lapC.date1.value != ""
                      ? lapC.date1.value
                      : lapC.date1.value = lapC.dateNow1,
                  lapC.date2.value != ""
                      ? lapC.date2.value
                      : lapC.date2.value = lapC.dateNow2,
                  0,
                  level == "1"
                      ? lapC.selectedCabang.isNotEmpty
                          ? lapC.selectedCabang.value
                          : ""
                      : cabang),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!;
                  var listService = [];
                  var totalUnit = data.length;
                  var totalIncome = [];
                  var allData = [];

                  data.map((data) {
                    totalIncome.add(int.parse(data.grandTotal!));
                  }).toList();

                  data.map((data) {
                    listService.add(data.services!);
                  }).toList();

                  data.map((e) {
                    allData.add(e);
                  }).toList();

                  int netSales = totalIncome.fold(
                      0, (temp, grandTotal) => temp + grandTotal as int);
                  return SingleChildScrollView(
                    child: SizedBox(
                      height: 800,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SALES SUMMARY',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                                // const SizedBox(
                                //   width: 38,
                                // ),
                                Text(
                                    lapC.date1.value != "" &&
                                            lapC.date2.value != ""
                                        ? '${DateFormat('dd/MM/yyyy').format(DateTime.parse(lapC.date1.value))} - ${DateFormat('dd/MM/yyyy').format(DateTime.parse(lapC.date2.value))}'
                                        : '${DateFormat('dd/MM/yyyy').format(DateTime.now())} - ${DateFormat('dd/MM/yyyy').format(DateTime.now())}',
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            title: const Text('NET SALES'),
                            trailing: Text(
                                NumberFormat.simpleCurrency(
                                        locale: 'in', decimalDigits: 0)
                                    .format(netSales)
                                    .toString(),
                                style: const TextStyle(
                                  fontSize: 15,
                                )),
                          ),
                          ListTile(
                            title: const Text('TOTAL UNIT'),
                            trailing: Text('$totalUnit',
                                style: const TextStyle(
                                  fontSize: 15,
                                )),
                          ),
                          const Divider(),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('TOP ITEMS',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: DataTable2(
                                  columnSpacing: 1,
                                  horizontalMargin: 2,
                                  minWidth: 300,
                                  showBottomBorder: true,
                                  headingTextStyle:
                                      const TextStyle(color: Colors.white),
                                  headingRowColor:
                                      MaterialStateProperty.resolveWith(
                                          (states) => Colors.indigo),
                                  columns: const [
                                    DataColumn(
                                      label: Text('Unit'),
                                      // size: ColumnSize.S,
                                    ),
                                    DataColumn(
                                      label: Text('Qty Unit'),
                                    ),
                                    DataColumn(
                                      label: Text('Total Sales'),
                                    ),
                                  ],
                                  rows: List<DataRow>.generate(2, (index) {
                                    return DataRow(cells: [
                                      DataCell(
                                          Text(index == 0 ? 'Motor' : 'Mobil',
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ))),
                                      DataCell(Obx(
                                        () => FutureBuilder(
                                            future: lapC.getSummary(
                                                lapC.date1.value != ""
                                                    ? lapC.date1.value
                                                    : lapC.dateNow1,
                                                lapC.date2.value != ""
                                                    ? lapC.date2.value
                                                    : lapC.dateNow2,
                                                index == 0 ? 1 : 2,
                                                level == "1"
                                                    ? lapC.selectedCabang
                                                            .isNotEmpty
                                                        ? lapC.selectedCabang
                                                            .value
                                                        : ""
                                                    : cabang),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var totalUnit = snapshot.data!;
                                                return Text(
                                                    '${totalUnit.length}',
                                                    style: const TextStyle(
                                                      fontSize: 15,
                                                    ));
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    '${snapshot.error}');
                                              }
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }),
                                      )),
                                      DataCell(Obx(
                                        () => FutureBuilder(
                                            future: lapC.getSummary(
                                                lapC.date1.value != ""
                                                    ? lapC.date1.value
                                                    : lapC.dateNow1,
                                                lapC.date2.value != ""
                                                    ? lapC.date2.value
                                                    : lapC.dateNow2,
                                                index == 0 ? 1 : 2,
                                                level == "1"
                                                    ? lapC.selectedCabang
                                                            .isNotEmpty
                                                        ? lapC.selectedCabang
                                                            .value
                                                        : ""
                                                    : cabang),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                var totalDetail =
                                                    snapshot.data!;
                                                var totalPriceUnit = [];
                                                totalDetail.map((data) {
                                                  totalPriceUnit.add(int.parse(
                                                      data.grandTotal!));
                                                }).toList();

                                                int totalSales =
                                                    totalPriceUnit.fold(0,
                                                        (p, e) => p + e as int);
                                                return Row(
                                                  children: [
                                                    Text(
                                                        NumberFormat
                                                                .simpleCurrency(
                                                                    locale:
                                                                        'id',
                                                                    decimalDigits:
                                                                        0)
                                                            .format(totalSales)
                                                            .toString(),
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                        )),
                                                  ],
                                                );
                                              } else if (snapshot.hasError) {
                                                return Text(
                                                    '${snapshot.error}');
                                              }
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }),
                                      )),
                                    ]);
                                  })),
                            ),
                          ),
                          const Divider(),
                          Row(
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('SERVICES SUMMARY',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold)),
                              )
                            ],
                          ),
                          Expanded(
                              flex: 2,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FutureBuilder(
                                      future: lapC.servicesById(
                                          listService.isNotEmpty
                                              ? listService.join(',')
                                              : [0]),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          var srvc = snapshot.data!;

                                          return Column(
                                            children: [
                                              Expanded(
                                                child: DataTable2(
                                                    columnSpacing: 12,
                                                    horizontalMargin: 12,
                                                    minWidth: 300,
                                                    showBottomBorder: true,
                                                    headingTextStyle:
                                                        const TextStyle(
                                                            color:
                                                                Colors.white),
                                                    headingRowColor:
                                                        MaterialStateProperty
                                                            .resolveWith(
                                                                (states) =>
                                                                    Colors
                                                                        .indigo),
                                                    columns: const [
                                                      DataColumn2(
                                                        label: Text('Services'),
                                                        size: ColumnSize.S,
                                                      ),
                                                      DataColumn(
                                                          label: Text(
                                                              'Grand Total'))
                                                    ],
                                                    rows:
                                                        List<DataRow>.generate(
                                                            srvc.length,
                                                            (index) {
                                                      return DataRow(cells: [
                                                        DataCell(Text(
                                                            '${srvc[index].serviceName}',
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 15,
                                                            ))),
                                                        DataCell(Obx(
                                                          () => FutureBuilder(
                                                              future: lapC
                                                                  .getSummary(
                                                                      lapC.date1.value !=
                                                                              ""
                                                                          ? lapC
                                                                              .date1
                                                                              .value
                                                                          : lapC
                                                                              .dateNow1,
                                                                      lapC.date2.value !=
                                                                              ""
                                                                          ? lapC
                                                                              .date2
                                                                              .value
                                                                          : lapC
                                                                              .dateNow2,
                                                                      // cabang,
                                                                      // level,
                                                                      0,
                                                                      level ==
                                                                              "1"
                                                                          ? lapC
                                                                                  .selectedCabang.isNotEmpty
                                                                              ? lapC
                                                                                  .selectedCabang.value
                                                                              : ""
                                                                          : cabang),
                                                              builder: (context,
                                                                  snapshot) {
                                                                if (snapshot
                                                                    .hasData) {
                                                                  var idSvc =
                                                                      "";

                                                                  idSvc =
                                                                      listService
                                                                          .join(
                                                                              ',');
                                                                  List lst =
                                                                      idSvc.split(
                                                                          ',');

                                                                  var qty = lst
                                                                      .where((c) =>
                                                                          c ==
                                                                          srvc[index]
                                                                              .id!);
                                                                  lapC.qty = qty
                                                                      .length;

                                                                  return Row(
                                                                    children: [
                                                                      Text(
                                                                        '${NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(int.parse(srvc[index].harga!))} x ${qty.length}',
                                                                      ),
                                                                      const SizedBox(
                                                                        width:
                                                                            10,
                                                                      ),
                                                                      Text(
                                                                          NumberFormat.simpleCurrency(locale: 'id', decimalDigits: 0).format(int.parse(srvc[index].harga!) *
                                                                              lapC
                                                                                  .qty),
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                15,
                                                                          ))
                                                                    ],
                                                                  );
                                                                } else if (snapshot
                                                                    .hasError) {}
                                                                return const Center(
                                                                  child:
                                                                      CupertinoActivityIndicator(),
                                                                );
                                                              }),
                                                        )),
                                                      ]);
                                                    })),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              ElevatedButton(
                                                onPressed: data.isEmpty
                                                    ? null
                                                    : () {
                                                        var itemPrint = [];
                                                        for (int i = 0;
                                                            i < srvc.length;
                                                            i++) {
                                                          var idSvc = "";
                                                          idSvc = listService
                                                              .join(',');
                                                          List lst =
                                                              idSvc.split(',');

                                                          var qty = lst.where(
                                                              (c) =>
                                                                  c ==
                                                                  srvc[i].id!);
                                                          var dataItem = {
                                                            "startDate": lapC
                                                                        .date1
                                                                        .value !=
                                                                    ""
                                                                ? DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime
                                                                        .parse(lapC
                                                                            .date1
                                                                            .value))
                                                                    .toString()
                                                                : DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(
                                                                        DateTime
                                                                            .now())
                                                                    .toString(),
                                                            "endDate": lapC
                                                                        .date2
                                                                        .value !=
                                                                    ""
                                                                ? DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(DateTime
                                                                        .parse(lapC
                                                                            .date2
                                                                            .value))
                                                                    .toString()
                                                                : DateFormat(
                                                                        'dd/MM/yyyy')
                                                                    .format(
                                                                        DateTime
                                                                            .now())
                                                                    .toString(),
                                                            "totalQty":
                                                                '$totalUnit',
                                                            "jenis": srvc[i]
                                                                .serviceName!,
                                                            "qty": qty.length,
                                                            "harga":
                                                                srvc[i].harga!,
                                                            "totalHarga":
                                                                netSales
                                                                    .toString()
                                                          };
                                                          itemPrint
                                                              .add(dataItem);
                                                          // print(allData.length);
                                                        }
                                                        PrintKasirState(
                                                                dataPrint: null,
                                                                item: itemPrint)
                                                            .createPdfDaily();
                                                      },
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        data.isEmpty
                                                            ? Colors.grey
                                                            : Colors.indigo,
                                                    minimumSize:
                                                        const Size(45, 45)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: const [
                                                    Icon(Icons.print_outlined),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text('Print')
                                                  ],
                                                ),
                                              )
                                            ],
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text('${snapshot.hasError}');
                                        }
                                        return const Center(
                                          child: CupertinoActivityIndicator(),
                                        );
                                      })))
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  // print(snapshot.error);
                  return Text('${snapshot.error}');
                }
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _key.currentState!.openEndDrawer(),
        child: const Icon(Icons.filter_list_rounded),
      ),

      // SpeedDial(
      //     elevation: 8,
      //     overlayOpacity: 0,
      //     icon: Icons.calendar_month_outlined,
      //     activeIcon: Icons.close,
      //     activeBackgroundColor: Colors.lightBlue,
      //     // backgroundColor: const Color.fromARGB(255, 29, 30, 32),
      //     children: [
      //       SpeedDialChild(
      //         label: 'Custom Date',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () {
      //           searchDialog();
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'Last Year',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var year = DateTime.utc(d.year - 1, 1, 1);
      //           var days = d.difference(year);
      //           var firstDayOfWeek = d.subtract(Duration(days: days.inDays));
      //           var lastDayOfWeek =
      //               d.subtract(Duration(days: days.inDays - 364));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'This Year',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var year = DateTime.utc(d.year, 1, 1);
      //           var days = d.difference(year);
      //           var firstDayOfWeek = d.subtract(Duration(days: days.inDays));
      //           var lastDayOfWeek = d.subtract(Duration(
      //             days: d.day - 31,
      //           ));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'Last Month',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var firstDayOfMonth = DateTime.utc(d.year, d.month, 1);
      //           var day = d.difference(firstDayOfMonth);
      //           var firstDayOfWeek =
      //               d.subtract(Duration(days: day.inDays + 30));
      //           var lastDayOfWeek = d.subtract(Duration(days: day.inDays + 1));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'This Month',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var firstDayOfMonth = DateTime.utc(d.year, d.month, 1);
      //           var day = d.difference(firstDayOfMonth);
      //           var firstDayOfWeek = d.subtract(Duration(days: day.inDays));
      //           var lastDayOfWeek = d.subtract(Duration(days: day.inDays - 29));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'Last Week',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var weekDay = d.weekday;
      //           var firstDayOfWeek = d.subtract(Duration(days: weekDay + 7));
      //           var lastDayOfWeek = d.subtract(Duration(days: weekDay + 1));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'This Week',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           var d = DateTime.now();
      //           var weekDay = d.weekday;
      //           var firstDayOfWeek = d.subtract(Duration(days: weekDay));
      //           var lastDayOfWeek = d.subtract(Duration(days: weekDay - 6));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(firstDayOfWeek)
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(lastDayOfWeek)
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'Yesterday',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           await lapC.getSummary(
      //               lapC.date1.value = DateFormat('yyyy-MM-dd')
      //                   .format(DateTime.parse(dateNow1)
      //                       .add(const Duration(days: -1)))
      //                   .toString(),
      //               lapC.date2.value = DateFormat('yyyy-MM-dd')
      //                   .format(DateTime.parse(dateNow2)
      //                       .add(const Duration(days: -1)))
      //                   .toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //       SpeedDialChild(
      //         label: 'Today',
      //         labelBackgroundColor: Colors.blue,
      //         labelStyle: const TextStyle(color: Colors.white),
      //         backgroundColor: Colors.blue,
      //         onTap: () async {
      //           Get.defaultDialog(
      //               barrierDismissible: false,
      //               title: '',
      //               content: Column(
      //                 children: const [
      //                   Center(
      //                     child: CircularProgressIndicator(),
      //                   ),
      //                   SizedBox(
      //                     height: 8,
      //                   ),
      //                   Text('Loading data...')
      //                 ],
      //               ));
      //           await lapC.getSummary(
      //               lapC.date1.value = dateNow1.toString(),
      //               lapC.date2.value = dateNow2.toString(),
      //               0,
      //               level == "1"
      //                   ? lapC.selectedCabang.isNotEmpty
      //                       ? lapC.selectedCabang.value
      //                       : ""
      //                   : cabang);
      //           Future.delayed(const Duration(seconds: 1), () {
      //             Get.back();
      //           });
      //         },
      //       ),
      //     ]),
    );
  }
}
