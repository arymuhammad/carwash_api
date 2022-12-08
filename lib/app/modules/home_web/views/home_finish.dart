import 'package:barcode_widget/barcode_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/helper/alert.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../../../helper/printer_kasir.dart';
import '../../../model/services_model.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/home_web_controller.dart';

class HomeFinish extends GetView<HomeController> {
  HomeFinish(this.namaCabang, this.kodeCabang, this.username, this.alamatCabang,
      this.kotaCabang,
      {super.key});

  final homeC = Get.put(HomeWebController());

  final String namaCabang;
  final String kodeCabang;
  final String username;
  final String alamatCabang;
  final String kotaCabang;

  FlutterTts flutterTts = FlutterTts();
  final assetsAudioPlayer = AssetsAudioPlayer();

  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: homeC.getDatatrx(kodeCabang, date, "1,2"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          } else {
            var dataTrx = snapshot.data!;

            return DataTable2(
                columnSpacing: 10,
                horizontalMargin: 8,
                minWidth: 800,
                showBottomBorder: true,
                headingTextStyle: const TextStyle(color: Colors.white),
                headingRowColor: MaterialStateProperty.resolveWith(
                    (states) => Colors.lightBlue),
                columns: const [
                  DataColumn2(
                    label: Text('No Transaksi'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(label: Text('No Kendaraan'), fixedWidth: 100),
                  DataColumn(
                    label: Text('Kendaraan'),
                  ),
                  DataColumn2(label: Text('Masuk'), fixedWidth: 80),
                  DataColumn2(label: Text('Mulai'), fixedWidth: 80),
                  DataColumn2(label: Text('Selesai'), fixedWidth: 80),
                  DataColumn(
                    label: Text('Service'),
                  ),
                  DataColumn(
                    label: Text('Petugas'),
                  ),
                  DataColumn2(label: Text('Status'), fixedWidth: 70),
                  DataColumn2(label: Text('Action'), fixedWidth: 100),
                ],
                rows: List<DataRow>.generate(dataTrx.length, (index) {
                  return DataRow(cells: [
                    DataCell(Text(dataTrx[index].notrx!)),
                    DataCell(Text(dataTrx[index].nopol!)),
                    DataCell(Text(dataTrx[index].kendaraan!)),
                    DataCell(Text(dataTrx[index].masuk! != ""
                        ? dataTrx[index].masuk!
                        : "not set")),
                    DataCell(Text(dataTrx[index].mulai! != ""
                        ? dataTrx[index].mulai!
                        : "-:-:-")),
                    DataCell(Text(dataTrx[index].selesai! != ""
                        ? dataTrx[index].selesai!
                        : "-:-:-")),
                    DataCell(FutureBuilder<List<Services>>(
                      future: homeC.servicesById(dataTrx[index].services!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var srv = snapshot.data!;
                          return Text(srv
                              .map((e) => e.serviceName!)
                              .join(', ')
                              .toString());
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    )),
                    DataCell(Text(dataTrx[index].petugas! != ""
                        ? dataTrx[index].petugas!
                        : "not set")),
                    DataCell(Text(
                      dataTrx[index].paid! == "0" ? "UNPAID" : "PAID",
                      style: TextStyle(
                          color: dataTrx[index].paid! == "0"
                              ? Colors.redAccent[700]
                              : Colors.greenAccent[700]),
                    )),
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: dataTrx[index].paid! != "1"
                              ? () {
                                  bayar(
                                      username,
                                      dataTrx[index].notrx!,
                                      dataTrx[index].tanggal!,
                                      dataTrx[index].nopol!,
                                      dataTrx[index].kendaraan!,
                                      dataTrx[index].masuk!,
                                      dataTrx[index].selesai!,
                                      dataTrx[index].services!,
                                      dataTrx[index].petugas!);
                                }
                              : null,
                          icon: Icon(
                            Icons.payments_outlined,
                            size: 30,
                            color: dataTrx[index].paid! != "1"
                                ? Colors.lightBlue
                                : Colors.grey,
                          ),
                          splashRadius: 20,
                        ),
                        IconButton(
                          onPressed: dataTrx[index].paid! != "1"
                              ? () {
                                  playSound(int.parse(dataTrx[index].idJenis!),
                                      dataTrx[index].nopol!);
                                }
                              : null,
                          icon: Icon(
                            dataTrx[index].paid! != "1"
                                ? Icons.speaker
                                : Icons.speaker,
                            size: 30,
                            color: dataTrx[index].paid! != "1"
                                ? Colors.lightBlue
                                : Colors.grey,
                          ),
                          splashRadius: 20,
                        )
                      ],
                    )),
                  ]);
                }));
          }
        } else if (snapshot.hasError) {
          return const Center(child: Text('Belum ada data masuk'));
        }
        return const Center(child: CupertinoActivityIndicator());
      },
    );
  }

  bayar(kasir, noTrx, tanggal, noPol, kendaraan, masuk, selesai, serviceItem,
      petugas) {
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
            srv.map((e) {
              harga.add(
                  NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0)
                      .format(int.parse(e.harga!)));
              hargat.add(int.parse(e.harga!));

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
                      style: const TextStyle(fontSize: 20)),
                  const SizedBox(
                    height: 10,
                  ),
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
                          )),
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
                          )),
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                            height: 21,
                            child: Text(
                                '${DateFormat('dd/MM/yyyy').format(DateTime.parse(tanggal))} $masuk',
                                style: const TextStyle(fontSize: 17))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                          )),
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                            height: 21,
                            child: Text(noPol,
                                style: const TextStyle(fontSize: 17))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                          )),
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                            height: 21,
                            child: Text(kendaraan,
                                style: const TextStyle(fontSize: 17))),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                          )),
                      Expanded(
                          flex: 8,
                          child: Row(
                            children: [
                              Text(service.join('\n')),
                              const SizedBox(
                                width: 25,
                              ),
                              Text(harga.join(' \n')),
                            ],
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
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: const Text(
                              "Total",
                              style: TextStyle(fontSize: 17),
                            ),
                          )),
                      Expanded(
                        flex: 8,
                        child: SizedBox(
                          height: 21,
                          child: Text(
                            NumberFormat.simpleCurrency(
                                    locale: 'in', decimalDigits: 0)
                                .format(homeC.totalHarga.value)
                                .toString(),
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(),
                  ElevatedButton(
                      onPressed: () {
                        checkOut(kasir, noTrx, kodeCabang, tanggal, noPol,
                            kendaraan, masuk, service, harga, petugas);
                      },
                      child: const Text(
                        'Checkout',
                        style: TextStyle(fontSize: 15),
                      ))
                ],
              ),
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

  checkOut(kasir, noTrx, kodeCabang, tanggal, noPol, kendaraan, masuk, service,
      harga, petugas) {
    Get.defaultDialog(
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
                    child: SizedBox(
                      height: 50,
                      child: TextField(
                        textAlignVertical: TextAlignVertical.top,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: NumberFormat.simpleCurrency(
                                    locale: 'in', decimalDigits: 0)
                                .format(homeC.totalHarga.value)
                                .toString(),
                            hintStyle: const TextStyle(color: Colors.black)),
                        cursorHeight: 20,
                        style: const TextStyle(fontSize: 20),
                        readOnly: true,
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
                            value: homeC.paySelected.value == ""
                                ? null
                                : homeC.paySelected.value,
                            onChanged: (String? data) {
                              homeC.paySelected.value = data!;
                            },
                            items: homeC.metodpay.map((value) {
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
                        controller: homeC.bayar,
                        style: const TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            prefixText: 'Rp',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20))),
                        keyboardType: TextInputType.number,
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
                                    .format(homeC.kembali.value)
                                    .toString(),
                                hintStyle:
                                    const TextStyle(color: Colors.black)),
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
                        if (homeC.bayar.text == "") {
                          showSnackbar("Error", "Pembayaran Rp.0");
                        }
                        var dataTrx = {
                          "notrx": noTrx,
                          "paid": "1",
                          "grandTotal": homeC.totalHarga.value.toString(),
                          "bayar": homeC.bayar.text,
                          "kembali": homeC.kembali.value.toString(),
                          "payment": homeC.paySelected.value,
                          "status": "2"
                        };
                        homeC.updateDataTrx(dataTrx);
                        homeC.byr = int.parse(homeC.bayar.text);

                        var data = {
                          "kasir": kasir,
                          "cabang": namaCabang,
                          "alamat": alamatCabang,
                          "kota": kotaCabang,
                          "no_trx": noTrx,
                          "tanggal": DateFormat('dd/MM/yyyy HH:mm:ss')
                              .format(DateTime.now()),
                          "nopol": noPol,
                          "kendaraan": kendaraan,
                          "service_name": service.join('\n'),
                          "harga": harga.join('\n'),
                          "petugas": petugas,
                          "grand_total": homeC.totalHarga.value,
                          "pembayaran": homeC.paySelected.value,
                          "bayar": homeC.byr,
                          "kembali": homeC.kembali.value
                        };

                        PrintKasirState(dataPrint: data, item: null)
                            .createPdf();
                        homeC.paySelected.value = "";
                        homeC.kembali.value = 0;
                        homeC.bayar.clear();
                        Get.back();
                        Get.back();
                      },
                      child: const Text('Bayar')),
                  ElevatedButton(
                      onPressed: () {
                        homeC.paySelected.value = "";
                        homeC.kembali.value = 0;
                        homeC.bayar.clear();
                        Get.back();
                      },
                      child: const Text('Batal')),
                ],
              )
            ],
          ),
        ));
  }

  playSound(int jenis, String text) async {
    var jK = "";
    if (jenis == 1) {
      jK = "Motor";
    } else {
      jK = "Mobil";
    }
    var nopol = text.split('');
    // print(nopol);
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await assetsAudioPlayer.open(
      Audio("assets/audio/Airport.mp3"),
      showNotification: true,
      autoStart: true,
    );
    Future.delayed(const Duration(milliseconds: 1800), () async {
      await flutterTts
          .speak('Di informasikan, kepada pemilik $jK, dengan nomor polisi');
      await playNopol(nopol);
      Future.delayed(const Duration(milliseconds: 1800), () async {
        await playSoundEnglish(jenis, text);
        await assetsAudioPlayer.open(
          Audio("assets/audio/Airport.mp3"),
          showNotification: true,
          autoStart: true,
        );
      });
    });
  }

  playSoundEnglish(int jenis, String text) async {
    var jK = "";
    if (jenis == 1) {
      jK = "motorcycle";
    } else {
      jK = "Car";
    }
    var nopol = text.split('');
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-GB");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts
        .speak("Informed, to the owner of $jK, with a police number");
    await playNopolEnglish(nopol);
  }

  playNopol(List<String> nopol) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.speak(nopol[0].toString());
    await flutterTts.speak(nopol[2].toString());
    await flutterTts.speak(nopol[3].toString());
    await flutterTts.speak(nopol[4].toString());
    await flutterTts.speak(nopol[5].toString());
    await flutterTts.speak(nopol[7].toString());
    await flutterTts.speak(nopol[8].toString());
    if (nopol.length > 10) {
      // print(nopol.length);
      await flutterTts.speak(nopol[9].toString());
      await flutterTts.speak(nopol[10].toString());
      await playNext();
    } else if (nopol.length > 9) {
      await flutterTts.speak(nopol[9].toString());
      await playNext();
    } else {
      await playNext();
    }
  }

  playNopolEnglish(List<String> nopol) async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-GB");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    //  print(await flutterTts.getVoices);
    await flutterTts.speak(nopol.toString());
    await playNextEnglish();
  }

  playNext() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("id-ID");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.speak("sudah selesai");
    await flutterTts.speak("Silahkan melakukan pembayaran");
    await flutterTts.speak("Periksa kembali barang bawaan anda");
    await flutterTts.speak("Semoga selamat sampai tujuan");

    await assetsAudioPlayer.open(
      Audio("assets/audio/Airport.mp3"),
      showNotification: true,
      autoStart: true,
    );
  }

  playNextEnglish() async {
    await flutterTts.awaitSpeakCompletion(true);
    await flutterTts.setLanguage("en-GB");
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
    await flutterTts.setSpeechRate(0.9);
    await flutterTts.speak("it's finished");
    await flutterTts.speak("Please make payment");
    await flutterTts.speak("Check your belongings again");
    await flutterTts.speak("Have a safe trip.");
  }
}
