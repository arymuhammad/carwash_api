// import 'dart:developer';
// import 'dart:ui';

import 'package:carwash/app/model/services_model.dart';
import 'package:carwash/app/modules/kasir/views/konfirmasi_pembayaran.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:collection/collection.dart';
import 'package:get/get.dart';

import '../../../helper/const.dart';
import '../../../helper/currency_format.dart';
import '../controllers/kasir_controller.dart';
import 'laporan_kasir.dart';

class KasirView extends GetView {
  KasirView(
      {super.key,
      required this.namaCabang,
      required this.kodeCabang,
      required this.username,
      required this.userId,
      required this.alamat,
      required this.telp,
      required this.kota});
  final String namaCabang;
  final String kodeCabang;
  final String username;
  final String userId;
  final String alamat;
  final String telp;
  final String kota;
  final trxCtr = Get.put(KasirController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'No Transaksi $kodeCabang${trxCtr.generateTrx}',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                              child: FutureBuilder(
                            future: trxCtr.fetchData(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var data = snapshot.data;
                                List<String> fb = [];
                                data!.map((e) {
                                  fb.add(e.serviceName!);
                                }).toList();
                                return TypeAheadField<String>(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: trxCtr.item,
                                    decoration: const InputDecoration(
                                      prefixIcon: Icon(Icons.fastfood_rounded),
                                      labelText: 'Ketik nama item',
                                      border: OutlineInputBorder(),
                                      filled: true,
                                      fillColor: Colors.white,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    if (pattern.isNotEmpty) {
                                      return fb.where((data) => data
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()));
                                    }
                                    return [];
                                  },
                                  itemBuilder: (context, suggestion) {
                                    return ListTile(
                                      tileColor: Colors.white,
                                      title: Text(suggestion),
                                    );
                                  },
                                  onSuggestionSelected: (suggestion) {
                                    trxCtr.item.text = suggestion;
                                    data
                                        .where(
                                            (e) => e.serviceName! == suggestion)
                                        .map((e) {
                                      trxCtr.listdata.add(Services(
                                          id: e.id,
                                          harga: e.harga,
                                          serviceName: e.serviceName));
                                    }).toList();
                                    int sum = trxCtr.listdata.fold(
                                        0,
                                        (hargaBarang, dst) =>
                                            hargaBarang + int.parse(dst.harga));

                                    trxCtr.total.value = sum;
                                    trxCtr.item.clear();
                                  },
                                );
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: CupertinoActivityIndicator(),
                                  ),
                                  SizedBox(width: 5),
                                  Text('Sedang memuat...'),
                                ],
                              );
                            },
                          )),
                        ],
                      ),
                    ),
                    Expanded(
                        child: Obx(() => trxCtr.listdata.isEmpty
                            ? const Center(child: Text('Belum ada Transaksi'))
                            : SingleChildScrollView(
                                child: DataTable(
                                    columnSpacing: 50,
                                    horizontalMargin: 10,
                                    border: TableBorder.symmetric(
                                        outside: const BorderSide()),
                                    headingRowColor:
                                        const MaterialStatePropertyAll(
                                            Colors.indigo),
                                    headingTextStyle: const TextStyle(
                                      color: Colors.white,
                                    ),
                                    columns: const [
                                      DataColumn(label: Text('Nama Barang')),
                                      DataColumn(label: Text('Harga NET')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('Total Harga')),
                                      DataColumn(label: Text('Aksi')),
                                    ],
                                    rows: trxCtr.listdata
                                        .groupSetsBy((e) => e.id)
                                        .entries
                                        .map((e) {
                                      return DataRow(cells: [
                                        DataCell(
                                            Text(e.value.first.serviceName)),
                                        DataCell(Text(
                                            CurrencyFormat.convertToIdr(
                                                int.parse(e.value.first.harga),
                                                0))),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                if (trxCtr.listdata
                                                    .where((data) =>
                                                        data.id ==
                                                        e.value.first.id)
                                                    .isNotEmpty) {
                                                  trxCtr.listdata.removeAt(
                                                      trxCtr.listdata
                                                          .lastIndexWhere(
                                                              (data) =>
                                                                  data.id ==
                                                                  e.value.first
                                                                      .id));
                                                  var initialV = 0;
                                                  int sum = trxCtr.listdata
                                                      .fold(
                                                          initialV,
                                                          (hargaBarang, dst) =>
                                                              hargaBarang
                                                                  .toInt() +
                                                              int.parse(dst
                                                                  .harga
                                                                  .toString()));

                                                  trxCtr.total.value = sum;
                                                }
                                              },
                                              icon: Icon(
                                                Icons.remove_circle,
                                                color: Colors.redAccent[700],
                                              ),
                                              splashRadius: 20,
                                              tooltip: 'Kurangi',
                                            ),
                                            Text(trxCtr.listdata
                                                .where((data) =>
                                                    data.id == e.value.first.id)
                                                .length
                                                .toString()),
                                            IconButton(
                                              onPressed: () {
                                                trxCtr.listdata.add(Services(
                                                  id: e.value.first.id,
                                                  serviceName:
                                                      e.value.first.serviceName,
                                                  harga: e.value.first.harga,
                                                ));
                                                var initialV = 0;
                                                int sum = trxCtr.listdata.fold(
                                                    initialV,
                                                    (hargaBarang, dst) =>
                                                        hargaBarang.toInt() +
                                                        int.parse(dst.harga
                                                            .toString()));

                                                trxCtr.total.value = sum;
                                              },
                                              icon: const Icon(
                                                Icons.add_circle,
                                                color: Colors.blue,
                                              ),
                                              splashRadius: 20,
                                              tooltip: 'Tambah',
                                            )
                                          ],
                                        )),
                                        DataCell(Text(
                                            CurrencyFormat.convertToIdr(
                                                trxCtr.listdata
                                                    .where((data) =>
                                                        data.id ==
                                                        e.value.first.id)
                                                    .fold(
                                                        0,
                                                        (hargaBarang, e) =>
                                                            hargaBarang +
                                                            int.parse(e.harga)),
                                                0))),
                                        DataCell(IconButton(
                                          onPressed: () {
                                            Get.defaultDialog(
                                                title: 'Perhatian',
                                                content: Text(
                                                    'Hapus Item Ini?\n- ${e.value.first.serviceName}'),
                                                confirm: ElevatedButton(
                                                  child: const Text('OK'),
                                                  onPressed: () {
                                                    trxCtr.listdata.removeWhere(
                                                        (data) =>
                                                            data.id ==
                                                            e.value.first.id);

                                                    int sum = trxCtr.listdata
                                                        .fold(
                                                            0,
                                                            (hargaBarang,
                                                                    dst) =>
                                                                hargaBarang +
                                                                int.parse(
                                                                    dst.harga));

                                                    trxCtr.total.value = sum;

                                                    Get.back();
                                                  },
                                                ),
                                                barrierDismissible: false,
                                                cancel: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.redAccent[700],
                                                      elevation: 15,
                                                    ),
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child:
                                                        const Text('BATAL')));
                                          },
                                          icon: Icon(Icons.delete_sharp,
                                              color: Colors.redAccent[700]),
                                          splashRadius: 20,
                                          tooltip: 'Hapus',
                                        ))
                                      ]);
                                    }).toList()),
                              ))),
                  ],
                ),
                // Positioned(
                //     bottom: 20,
                //     left: 5,
                //     right: 5,
                //     child: Card(
                //       shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(10)),
                //       elevation: 8,
                //       child: Padding(
                //         padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                //         child: Container(
                //           height: 70,
                //           width: Get.mediaQuery.size.width,
                //           decoration: BoxDecoration(
                //               color: Colors.white,
                //               borderRadius: BorderRadius.circular(20)),
                //           child: Row(
                //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //             children: [
                //               Row(
                //                 children: [
                //                   Icon(
                //                     Icons.monetization_on_outlined,
                //                     color: Colors.redAccent[700],
                //                     size: 40,
                //                   ),
                //                   const Text(
                //                     ' Total: ',
                //                     style: TextStyle(
                //                         fontSize: 18,
                //                         fontWeight: FontWeight.bold),
                //                   ),
                //                   Obx(() => Text(
                //                         CurrencyFormat.convertToIdr(
                //                                 trxCtr.total.value, 0)
                //                             .toString(),
                //                         style: const TextStyle(
                //                             fontSize: 18,
                //                             fontWeight: FontWeight.bold),
                //                       )),
                //                 ],
                //               ),
                //               Row(
                //                 children: [
                //                   Obx(
                //                     () => Text(
                //                       '(${trxCtr.listdata.length} item)',
                //                       style: const TextStyle(
                //                           fontSize: 18,
                //                           fontWeight: FontWeight.bold),
                //                     ),
                //                   ),
                //                   Icon(
                //                     Icons.local_mall_outlined,
                //                     color: Colors.greenAccent[700],
                //                     size: 40,
                //                   ),
                //                 ],
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //     ))
              ],
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                decoration: const BoxDecoration(color: Colors.indigo),
                child: Stack(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.monetization_on_outlined,
                                color: white,
                                size: 40,
                              ),
                              // const Text(
                              //   ' Total: ',
                              //   style: TextStyle(
                              //       fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                              Obx(() => Text(
                                    CurrencyFormat.convertToIdr(
                                            trxCtr.total.value, 0)
                                        .toString(),
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.yellow,
                                    ),
                                  )),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.local_mall_outlined,
                                color: white,
                                size: 40,
                              ),
                              Obx(
                                () => Text(
                                  '(${trxCtr.listdata.length} item)',
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.yellow,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Obx(
                            () => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.delete_sweep_sharp,
                                    color: white,
                                  ),
                                  onPressed: trxCtr.listdata.isEmpty
                                      ? null
                                      : () {
                                          Get.defaultDialog(
                                              title: 'Peringatan',
                                              content: const Text(
                                                  'Batalkan Transaksi Ini?'),
                                              confirm: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.blueAccent[700],
                                                  elevation: 15,
                                                ),
                                                onPressed: () {
                                                  trxCtr.listdata.clear();
                                                  trxCtr.total.value = 0;
                                                  Get.back();
                                                  trxCtr.myFocusNode
                                                      .requestFocus();
                                                  // // scanBarcodeDiscovery();
                                                },
                                                child: Text(
                                                  'OK',
                                                  style:
                                                      TextStyle(color: white),
                                                ),
                                              ),
                                              barrierDismissible: false,
                                              cancel: ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.redAccent[700],
                                                    elevation: 15,
                                                  ),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                  child: Text(
                                                    'BATAL',
                                                    style:
                                                        TextStyle(color: white),
                                                  )));
                                        },
                                  label: Text(
                                    'BATALKAN',
                                    style: TextStyle(color: white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: trxCtr.listdata.isEmpty
                                        ? Colors.grey[300]
                                        : Colors.redAccent[700],
                                    // elevation: 15,
                                    fixedSize: const Size(150, 40),
                                    side: BorderSide.none,
                                  )),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton.icon(
                                label: Text(
                                  'CHECKOUT',
                                  style: TextStyle(color: white),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: trxCtr.listdata.isEmpty
                                      ? Colors.grey[300]
                                      : Colors.blueAccent[700],
                                  // elevation: 15,
                                  fixedSize: const Size(150, 40),
                                ),
                                icon: Icon(
                                  Icons.payments,
                                  color: white,
                                ),
                                onPressed: trxCtr.listdata.isEmpty
                                    ? null
                                    : () {
                                        trxCtr.noTrx =
                                            '$kodeCabang${trxCtr.generateTrx}';
                                        var serviceItem = trxCtr.listdata
                                            .map((e) => e.id)
                                            .join(',')
                                            .toString();
                                        // print(user);
                                        bayar(
                                            username,
                                            userId,
                                            kodeCabang,
                                            namaCabang,
                                            trxCtr.noTrx,
                                            trxCtr.dateTrx,
                                            serviceItem,
                                            alamat,
                                            telp,
                                            kota);
                                        // checkOut(context, user);
                                      },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    //Laporan kafe sementara di hide
                    // Positioned(
                    //     bottom: 0,
                    //     left: 0,
                    //     right: 0,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(8.0),
                    //       child: ElevatedButton(
                    //           style: ElevatedButton.styleFrom(
                    //             backgroundColor: Colors.greenAccent[700],
                    //             // elevation: 15,
                    //             fixedSize: const Size(150, 40),
                    //           ),
                    //           onPressed: () async {
                    //             await trxCtr.getLaporan(
                    //                 kodeCabang, initDate1, initDate2);
                    //             laporanKasir(kodeCabang, initDate1, initDate2,
                    //                 alamat, telp, kota);
                    //           },
                    //           child: const Text('LAPORAN')),
                    //     ))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
