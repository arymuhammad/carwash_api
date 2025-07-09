import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../helper/alert.dart';
import '../../../../helper/printer_kasir.dart';

final homeC = Get.find<HomeWebController>();
checkOutDialog(
  kasir,
  noTrx,
  kodeCabang,
  tanggal,
  noPol,
  kendaraan,
  masuk,
  service,
  harga,
  petugas,
  cabang,
  alamat,
  telp,
  kota,
) {
  Get.defaultDialog(
    barrierDismissible: false,
    radius: 5,
    title: 'Pembayaran',
    content: SizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Divider(),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: const Text(
                    "TOTAL",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: Obx(
                  () => SizedBox(
                    height: 50,
                    child:
                        homeC.totalSetelahDisc.value == 0
                            ? TextField(
                              textAlignVertical: TextAlignVertical.top,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText:
                                    NumberFormat.simpleCurrency(
                                      locale: 'in',
                                      decimalDigits: 0,
                                    ).format(homeC.totalHarga.value).toString(),
                                hintStyle: const TextStyle(color: Colors.black),
                              ),
                              cursorHeight: 20,
                              style: const TextStyle(fontSize: 20),
                              readOnly: true,
                            )
                            : Row(
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text:
                                        NumberFormat.simpleCurrency(
                                              locale: 'in',
                                              decimalDigits: 0,
                                            )
                                            .format(homeC.totalHarga.value)
                                            .toString(),
                                    style: const TextStyle(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 150,
                                  child: TextField(
                                    textAlignVertical: TextAlignVertical.top,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText:
                                          NumberFormat.simpleCurrency(
                                                locale: 'in',
                                                decimalDigits: 0,
                                              )
                                              .format(
                                                homeC.totalSetelahDisc.value,
                                              )
                                              .toString(),
                                      hintStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    cursorHeight: 20,
                                    style: const TextStyle(fontSize: 20),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                  ),
                ),
              ),
            ],
          ),
          // Row(
          //   children: <Widget>[
          //     Expanded(
          //         flex: 5,
          //         child: Container(
          //           padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          //           child: const Text(
          //             "Diskon",
          //             style: TextStyle(fontSize: 17),
          //           ),
          //         )),
          //     Expanded(
          //       flex: 8,
          //       child: SizedBox(
          //           height: 50,
          //           child: TextField(
          //             controller: homeC.diskon,
          //             decoration: InputDecoration(
          //                 suffixIcon: const Icon(Icons.percent),
          //                 contentPadding: const EdgeInsets.all(8),
          //                 border: OutlineInputBorder(
          //                     borderRadius: BorderRadius.circular(20))),
          //             onChanged: (data) {
          // homeC.disc.value = data;
          // print(homeC.disc.value);
          // homeC.discount();
          //               // print(homeC.totalSetelahDisc.value);
          //             },
          //             keyboardType: TextInputType.number,
          //             inputFormatters: [
          //               FilteringTextInputFormatter.digitsOnly
          //             ],
          //           )),
          //     ),
          //   ],
          // ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: const Text(
                    "Metode Pembayaran",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
              ),
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      isExpanded: true,
                      hint: const Text('Select payment method'),
                      icon: const Icon(Icons.payment_sharp),
                      value:
                          homeC.paySelected.value == ""
                              ? null
                              : homeC.paySelected.value,
                      onChanged: (String? data) {
                        homeC.paySelected.value = data!;
                      },
                      items:
                          homeC.metodpay.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: const Text("Bayar", style: TextStyle(fontSize: 17)),
                ),
              ),
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: homeC.bayar,
                    style: const TextStyle(fontSize: 20),
                    decoration: InputDecoration(
                      prefixText: 'Rp',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onChanged: (value) {
                      homeC.pembayaran(value);
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                  child: const Text("Kembali", style: TextStyle(fontSize: 17)),
                ),
              ),
              Expanded(
                flex: 8,
                child: SizedBox(
                  height: 50,
                  child: Obx(
                    () => TextField(
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            NumberFormat.simpleCurrency(
                              locale: 'in',
                              decimalDigits: 0,
                            ).format(homeC.kembali.value).toString(),
                        hintStyle: const TextStyle(color: Colors.black),
                      ),
                      cursorHeight: 20,
                      style: const TextStyle(fontSize: 20),
                      readOnly: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (homeC.bayar.text == "") {
                    showSnackbar("Error", "Pembayaran Rp.0");
                  }
                  var dataTrx = {
                    "notrx": noTrx,
                    "paid": "1",
                    "total": homeC.totalHarga.value.toString(),
                    // remove diskon
                    // "diskon":
                    //     homeC.diskon.text != "" ? homeC.diskon.text : "0",
                    "grandTotal":
                        homeC.totalSetelahDisc.value != 0
                            ? homeC.totalSetelahDisc.value.toString()
                            : homeC.totalHarga.value.toString(),
                    "bayar": homeC.bayar.text,
                    "kembali": homeC.kembali.value.toString(),
                    "payment": homeC.paySelected.value,
                    "status": "2",
                  };
                  homeC.updateDataTrx(dataTrx);
                  homeC.byr = int.parse(homeC.bayar.text);

                  var data = {
                    "kasir": kasir,
                    "cabang": cabang,
                    "alamat": alamat,
                    "telp": telp,
                    "kota": kota,
                    "no_trx": noTrx,
                    "tanggal": DateFormat(
                      'dd/MM/yyyy HH:mm:ss',
                    ).format(DateTime.now()),
                    "nopol": noPol,
                    "kendaraan": kendaraan,
                    "service_name": service.join('\n'),
                    "harga": harga.join('\n'),
                    "petugas": petugas,
                    "grand_total": homeC.totalHarga.value,
                    "total_setelah_diskon": homeC.totalSetelahDisc.value,
                    // remove diskon
                    // "diskon": homeC.diskon.text,
                    "pembayaran": homeC.paySelected.value,
                    "bayar": homeC.byr,
                    "kembali": homeC.kembali.value,
                  };

                  PrintKasirState(dataPrint: data, item: null).createPdf();
                  homeC.paySelected.value = "";
                  homeC.kembali.value = 0;
                  homeC.bayar.clear();
                  homeC.diskon.text = "";
                  homeC.totalSetelahDisc.value = 0;
                  Get.back();
                  Get.back();
                },
                child: const Text('Bayar'),
              ),
              ElevatedButton(
                onPressed: () {
                  homeC.paySelected.value = "";
                  homeC.kembali.value = 0;
                  homeC.bayar.clear();
                  homeC.diskon.text = "";
                  homeC.totalSetelahDisc.value = 0;
                  Get.back();
                },
                child: const Text('Batal'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
