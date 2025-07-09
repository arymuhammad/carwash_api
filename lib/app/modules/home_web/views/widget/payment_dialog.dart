import 'package:barcode_widget/barcode_widget.dart';
import 'package:carwash/app/modules/home/controllers/home_controller.dart';
import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:carwash/app/modules/home_web/views/widget/chechkout_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../model/services_model.dart';

final homeC = Get.find<HomeWebController>();

paymentDialog(
  kasir,
  noTrx,
  tanggal,
  noPol,
  kendaraan,
  masuk,
  selesai,
  serviceItem,
  petugas,
  kode,
  cabang,
  alamat,
  telp,
  kota,
) {
  Get.defaultDialog(
    radius: 5,
    title: 'Konfirmasi Pembayaran',
    content: FutureBuilder<List<Services>>(
      future: homeC.servicesById(serviceItem),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var srv = snapshot.data!;
          var service = srv.map((e) => e.serviceName!);
          var harga = [];
          var hargat = [];

          // print(idService.length);
          srv.map((e) {
            var qty =
                serviceItem
                    .toString()
                    .split(',')
                    .where((data) => data == e.id!)
                    .length;
            harga.add(
              NumberFormat.simpleCurrency(
                locale: 'in',
                decimalDigits: 0,
              ).format(int.parse(e.harga!.toString()) * qty),
            );
            hargat.add(int.parse(e.harga!) * qty);

            int total = hargat.fold(0, (hargat, e) => hargat + e as int);
            homeC.totalHarga.value = total;
          }).toList();

          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: noTrx,
                  height: 100,
                  width: 320,
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Petugas",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Text(petugas, style: const TextStyle(fontSize: 17)),
                        ],
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
                          "Tanggal",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 21,
                        child: Text(
                          '${DateFormat('dd/MM/yyyy').format(DateTime.parse(tanggal))} $masuk',
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Nomor Kendaraan",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 21,
                        child: Text(
                          noPol,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Jenis",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 21,
                        child: Text(
                          kendaraan,
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Services",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: Row(
                        children: [
                          Text(service.join('\n')),
                          const SizedBox(width: 25),
                          Text(harga.join(' \n')),
                        ],
                      ),
                      //
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Total",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 21,
                        child: Text(
                          NumberFormat.simpleCurrency(
                            locale: 'in',
                            decimalDigits: 0,
                          ).format(homeC.totalHarga.value).toString(),
                          style: const TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                ElevatedButton(
                  onPressed: () {
                    checkOutDialog(
                      kasir,
                      noTrx,
                      kode,
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
                    );
                  },
                  child: const Text('Checkout', style: TextStyle(fontSize: 15)),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    ),
  );
}
