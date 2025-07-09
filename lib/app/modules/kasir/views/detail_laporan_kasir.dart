import 'package:barcode_widget/barcode_widget.dart';
import 'package:carwash/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../model/services_model.dart';

final trxCtr = Get.put(KasirController());

detailLaporan(
    petugas, cabang, noTrx, tanggal, serviceItem, alamat, telp, kota) {
  Get.defaultDialog(
    radius: 5,
    title: 'Detail Laporan',
    content: FutureBuilder<List<Services>>(
      future: trxCtr.servicesById(serviceItem),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var srv = snapshot.data!;

          var service = srv.map((e) => e.serviceName!);
          var priceItem = srv.map((e) => e.harga!);
          var totalPriceItem = [];
          var qtyItem = [];
          var amount = [];
          srv.map((e) {
            var qty = serviceItem
                .toString()
                .split(',')
                .where((data) => data == e.id!)
                .length;
            qtyItem.add('$qty');
            totalPriceItem.add(
                NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0)
                    .format(int.parse(e.harga!.toString()) * qty));
            amount.add(int.parse(e.harga!) * qty);

            int total = amount.fold(0, (hargat, data) => hargat + data as int);
            trxCtr.totalHarga.value = total;
          }).toList();

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: noTrx,
                  height: 100,
                  width: 320,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Kasir",
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                  Expanded(
                    flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(petugas, style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Tanggal : ",
                              style: TextStyle(fontSize: 15),
                            ),
                            const SizedBox(width: 5,),
                        Text(tanggal,
                        style: const TextStyle(fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5,),
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //         flex: 2,
              //         child: Container(
              //           padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              //           child: const Text(
              //             "Tanggal",
              //             style: TextStyle(fontSize: 17),
              //           ),
              //         )),
              //     Expanded(
              //       flex: 8,
              //       child: Text(tanggal,
              //           style: const TextStyle(fontSize: 17)),
              //     ),
              //   ],
              // ),
             
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Pesanan",
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                  Expanded(
                      flex: 8,
                      child:  SizedBox(
                        height: 150,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(service.join('\n')),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(qtyItem.join('\n')),
                              const SizedBox(
                                width: 25,
                              ),
                              Text(priceItem.join('\n')),
                              const SizedBox(
                                width: 25,
                              ),
                              Text(
                                totalPriceItem.join(' \n'),
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      )
                      //
                      ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                
                children: <Widget>[
                  Expanded(
                      flex: 2,
                      child: Container()),
                  Expanded(
                    flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Total",
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                        SizedBox(
                          height: 21,
                          child: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'in', decimalDigits: 0)
                                .format(trxCtr.totalHarga.value)
                                .toString(),
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                   
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 15),
                  ))
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    ),
  );
}
