import 'package:carwash/app/model/cabang_model.dart';
import 'package:carwash/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/alert.dart';
import '../../../helper/printer_kasir.dart';

final trxCtr = Get.put(KasirController());

checkOut(kasir, userId, noTrx, kodeCabang, namaCabang, tanggal, serviceItem, serviceName,
    price, alamat, telp, kota) {
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
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: Obx(
                    () => SizedBox(
                        height: 50,
                        child:
                            // trxCtr.totalSetelahDisc.value == 0
                            // ? TextField(
                            //     textAlignVertical: TextAlignVertical.top,
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: NumberFormat.simpleCurrency(
                            //                 locale: 'in', decimalDigits: 0)
                            //             .format(trxCtr.totalHarga.value)
                            //             .toString(),
                            //         hintStyle:
                            //             const TextStyle(color: Colors.black)),
                            //     cursorHeight: 20,
                            //     style: const TextStyle(fontSize: 20),
                            //     readOnly: true,
                            //   )
                            // :
                            Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: NumberFormat.simpleCurrency(
                                          locale: 'in', decimalDigits: 0)
                                      .format(trxCtr.totalHarga.value)
                                      .toString(),
                                  style: const TextStyle(
                                      // decoration:
                                      //     TextDecoration.lineThrough,
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                            // const SizedBox(width: 5),
                            // SizedBox(
                            //   width: 150,
                            //   child: TextField(
                            //     textAlignVertical: TextAlignVertical.top,
                            //     decoration: InputDecoration(
                            //         border: InputBorder.none,
                            //         hintText: NumberFormat.simpleCurrency(
                            //                 locale: 'in',
                            //                 decimalDigits: 0)
                            //             .format(
                            //                 trxCtr.totalSetelahDisc.value)
                            //             .toString(),
                            //         hintStyle: const TextStyle(
                            //             color: Colors.black)),
                            //     cursorHeight: 20,
                            //     style: const TextStyle(fontSize: 20),
                            //     readOnly: true,
                            //   ),
                            // )
                          ],
                        )),
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
            //             controller: trxCtr.diskon,
            //             decoration: InputDecoration(
            //                 suffixIcon: const Icon(Icons.percent),
            //                 contentPadding: const EdgeInsets.all(8),
            //                 border: OutlineInputBorder(
            //                     borderRadius: BorderRadius.circular(20))),
            //             onChanged: (data) {
            // trxCtr.disc.value = data;
            // print(trxCtr.disc.value);
            // trxCtr.discount();
            //               // print(trxCtr.totalSetelahDisc.value);
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
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 50,
                      child: Obx(
                        () => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20))),
                          isExpanded: true,
                          hint: const Text('Select payment method'),
                          icon: const Icon(Icons.payment_sharp),
                          value: trxCtr.paySelected.value == ""
                              ? null
                              : trxCtr.paySelected.value,
                          onChanged: (String? data) {
                            trxCtr.paySelected.value = data!;
                          },
                          items: trxCtr.metodpay.map((value) {
                            return DropdownMenuItem<String>(
                                value: value, child: Text(value));
                          }).toList(),
                        ),
                      )),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: const Text(
                        "Bayar",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                    height: 50,
                    child: TextField(
                      controller: trxCtr.bayar,
                      style: const TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          prefixText: 'Rp',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20))),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) {
                        trxCtr.pay(value);
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
                      child: const Text(
                        "Kembali",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 50,
                      child: Obx(
                        () => TextField(
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: NumberFormat.simpleCurrency(
                                      locale: 'in', decimalDigits: 0)
                                  .format(trxCtr.kembalian.value)
                                  .toString(),
                              hintStyle: const TextStyle(color: Colors.black)),
                          cursorHeight: 20,
                          style: const TextStyle(fontSize: 20),
                          readOnly: true,
                        ),
                      )),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (trxCtr.paySelected.isEmpty) {
                        showSnackbar("Error", "Harap pilih metode pembayaran");
                      } else if (trxCtr.bayar.text == "") {
                        showSnackbar("Error", "Pembayaran Rp.0");
                      } else {
                        var dataTrx = {
                          "tanggal":
                              DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          "no_trx": noTrx,
                          "kode_cabang": kodeCabang,
                          "kode_user": userId,
                          "kasir": kasir,
                          "services": serviceItem.toString(),
                          "paid": "1",
                          "total": trxCtr.totalHarga.value.toString(),
                          // remove diskon
                          // "diskon":
                          //     trxCtr.diskon.text != "" ? trxCtr.diskon.text : "0",
                          "grandTotal": trxCtr.totalHarga.value.toString(),
                          "bayar": trxCtr.bayar.text,
                          "kembali": trxCtr.kembalian.value.toString(),
                          "payment": trxCtr.paySelected.value,
                          "status": "2"
                        };
                        trxCtr.insertDataKafe(dataTrx);
                        trxCtr.byr = int.parse(trxCtr.bayar.text);

                        var data = {
                          "kasir": kasir,
                          "cabang": namaCabang,
                          "alamat": alamat,
                          "telp": telp,
                          "kota": kota,
                          "no_trx": noTrx,
                          "tanggal": DateFormat('dd/MM/yyyy HH:mm:ss')
                              .format(DateTime.now()),
                          "nopol": "",
                          "kendaraan": "",
                          "service_name": serviceName.join('\n'),
                          "harga": price.join('\n'),
                          "petugas": "",
                          "grand_total": trxCtr.totalHarga.value,
                          "total_setelah_diskon": 0,
                          // remove diskon
                          // "diskon": trxCtr.diskon.text,
                          "pembayaran": trxCtr.paySelected.value,
                          "bayar": trxCtr.byr,
                          "kembali": trxCtr.kembalian.value
                        };

                        PrintKasirState(dataPrint: data, item: null)
                            .createPdf();
                        trxCtr.paySelected.value = "";
                        trxCtr.kembalian.value = 0;
                        trxCtr.bayar.clear();
                        // trxCtr.diskon.text = "";
                        // trxCtr.totalSetelahDisc.value = 0;
                        showSnackbar("Sukses", "Pembayaran Berhasil");
                        trxCtr.listdata.clear();

                        Get.back(closeOverlays: true);
                        Get.back();
                      }
                    },
                    child: const Text('Bayar')),
                ElevatedButton(
                    onPressed: () {
                      trxCtr.paySelected.value = "";
                      trxCtr.kembalian.value = 0;
                      trxCtr.bayar.clear();
                      // trxCtr.diskon.text = "";
                      // trxCtr.totalSetelahDisc.value = 0;
                      Get.back();
                    },
                    child: const Text('Batal')),
              ],
            )
          ],
        ),
      ));
}
