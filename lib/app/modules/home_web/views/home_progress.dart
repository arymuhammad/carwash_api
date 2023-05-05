import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/alert.dart';
import '../../../model/services_model.dart';
import '../../../model/trx_model.dart';
import '../../home/controllers/home_controller.dart';
import '../../master/controllers/master_controller.dart';
import '../controllers/home_web_controller.dart';

class HomeProgress extends GetView<HomeController> {
  HomeProgress(this.cabang, {super.key});
  final String cabang;
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final homeC = Get.put(HomeWebController());
  final masterC = Get.put(MasterController());

  FlutterTts flutterTts = FlutterTts();
  final assetsAudioPlayer = AssetsAudioPlayer();
  TextEditingController mk = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Trx>>(
      stream: homeC.getDatatrx(cabang, date, "0"),
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
                empty: const Center(child: Text('Belum ada data'),),
                columns: const [
                  DataColumn2(
                    label: Text('No Transaksi'),
                    size: ColumnSize.L,
                  ),
                  DataColumn(
                    label: Text('No Kendaraan'),
                  ),
                  DataColumn(
                    label: Text('Kendaraan'),
                  ),
                  DataColumn(
                    label: Text('Masuk'),
                  ),
                  DataColumn(
                    label: Text('Mulai'),
                  ),
                  DataColumn(
                    label: Text('Selesai'),
                  ),
                  DataColumn(
                    label: Text('Service'),
                  ),
                  DataColumn(
                    label: Text('Petugas'),
                  ),
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
                              .map((e) {
                                return e.serviceName!;
                              })
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
                    DataCell(Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            editData(
                              dataTrx[index].notrx!,
                              dataTrx[index].tanggal!,
                              dataTrx[index].nopol!,
                              dataTrx[index].kendaraan!,
                              dataTrx[index].masuk,
                              dataTrx[index].services!,
                              dataTrx[index].petugas!,
                            );
                          },
                          icon: const Icon(
                            Icons.edit_note_sharp,
                            size: 30,
                            color: Colors.lightBlue,
                          ),
                          splashRadius: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, right: 0),
                          child: IconButton(
                            onPressed: () async {
                              if (dataTrx[index].mulai! == "") {
                                var dataMulai = {
                                  "status": "0",
                                  "jam_mulai": DateFormat("HH:mm:ss")
                                      .format(DateTime.now()),
                                  "notrx": dataTrx[index].notrx
                                };
                                homeC.updateDataTrx(dataMulai);
                                // }
                              } else if (dataTrx[index].selesai! == "") {
                                var dataMulai = {
                                  "status": "1",
                                  "jam_selesai": DateFormat("HH:mm:ss")
                                      .format(DateTime.now()),
                                  "notrx": dataTrx[index].notrx
                                };
                                homeC.updateDataTrx(dataMulai);

                                playSound(dataTrx[index].idJenis!,
                                    dataTrx[index].nopol!);
                              }
                            },
                            icon: Icon(
                              dataTrx[index].mulai! == ""
                                  ? Icons.play_circle_outline
                                  : Icons.stop_circle_outlined,
                              size: 30,
                              color: Colors.lightBlue,
                            ),
                            splashRadius: 20,
                          ),
                        ),
                      ],
                    )),
                  ]);
                }));
          }
        } else if (snapshot.hasError) {
          return const Center(child: Text('Belum ada data masuk'));
        }
        return const Center(
          child: CupertinoActivityIndicator(),
        );
      },
    );
  }

  playSound(String jenis, String text) async {
    var jK = "";
    if (jenis == "1") {
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

  playSoundEnglish(String jenis, String text) async {
    var jK = "";
    if (jenis == "1") {
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

  editData(notrx, tanggal, nopol, kendaraan, masuk, service, petugas) {
    Get.defaultDialog(
        radius: 5,
        title: 'Detail Data',
        content: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: notrx,
                  height: 100,
                  width: 320,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(
                height: 15,
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
                        height: 18,
                        child: Text(
                            DateFormat('dd/MM/yyyy')
                                .format(DateTime.parse(tanggal))
                                .toString(),
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
                          "No Kendaraan",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                        height: 18,
                        child:
                            Text(nopol, style: const TextStyle(fontSize: 17))),
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
                          "Nama Kendaraan",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                        height: 18,
                        child: Text(kendaraan,
                            style: const TextStyle(fontSize: 17))),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                      flex: 5,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                        child: const Text(
                          "Jam masuk",
                          style: TextStyle(fontSize: 17),
                        ),
                      )),
                  Expanded(
                    flex: 8,
                    child: SizedBox(
                        height: 18,
                        child:
                            Text(masuk, style: const TextStyle(fontSize: 17))),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              FutureBuilder(
                  future: homeC.servicesById(""),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var merk = snapshot.data!;
                      List<String> merkKendaraan = <String>[];
                      var dataKendaraan = [];

                      merk.map((doc) {
                        merkKendaraan.add(doc.serviceName.toString());
                      }).toList();

                      for (int i = 0; i < merk.length; i++) {
                        dataKendaraan.add(Services(
                            id: merk[i].id.toString(),
                            serviceName: merk[i].serviceName.toString()));
                      }

                      return Column(
                        children: [
                          Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 5,
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(
                                        12, 10, 12, 10),
                                    child: const Text(
                                      "Pilih Services",
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  )),
                              Expanded(
                                flex: 8,
                                child: SizedBox(
                                    height: 50,
                                    child: RawAutocomplete(
                                      key: _autocompleteKey,
                                      focusNode: _focusNode,
                                      textEditingController: mk,
                                      optionsBuilder:
                                          (TextEditingValue textValue) {
                                        if (textValue.text == '') {
                                          return const Iterable<String>.empty();
                                        } else {
                                          List<String> matches = <String>[];
                                          matches.addAll(merkKendaraan);

                                          matches.retainWhere((s) {
                                            return s.toLowerCase().contains(
                                                textValue.text.toLowerCase());
                                          });
                                          return matches;
                                        }
                                      },
                                      onSelected: (String selection) {},
                                      fieldViewBuilder: (BuildContext context,
                                          mk,
                                          FocusNode focusNode,
                                          VoidCallback onFieldSubmitted) {
                                        return TextField(
                                          decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              hintText:
                                                  'ketik nama service (Cuci Motor)'),
                                          controller: mk,
                                          focusNode: focusNode,
                                          onSubmitted: (String value) {
                                            for (int i = 0;
                                                i < dataKendaraan.length;
                                                i++) {
                                              if (dataKendaraan[i]
                                                      .serviceName ==
                                                  value) {
                                                homeC.listService.add(
                                                    dataKendaraan[i]
                                                        .serviceName);
                                                homeC.serviceItem
                                                    .add(dataKendaraan[i].id);
                                              }
                                            }
                                            homeC.selectedService.add(value);
                                            mk.clear();
                                            focusNode.requestFocus();
                                          },
                                        );
                                      },
                                      optionsViewBuilder: (BuildContext context,
                                          void Function(String) onSelected,
                                          Iterable<String> options) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Material(
                                              child: SizedBox(
                                            width: 255,
                                            height: 150,
                                            child: ListView.builder(
                                              itemCount: options.length,
                                              itemBuilder: (context, index) =>
                                                  Column(
                                                children: options.map((opt) {
                                                  return InkWell(
                                                      onTap: () {
                                                        onSelected(opt);
                                                      },
                                                      child: Container(
                                                        width: double.infinity,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(10),
                                                        child: Text(opt),
                                                      ));
                                                }).toList(),
                                              ),
                                            ),
                                          )),
                                        );
                                      },
                                    )),
                              ),
                            ],
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }),
              const SizedBox(
                height: 15,
              ),
              Obx(() {
                return Row(
                  children: [
                    Expanded(
                        flex: 5,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                          child: Container(),
                        )),
                    Expanded(
                        flex: 8,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          width: 70,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    homeC.selectedService
                                        .toSet()
                                        .toList()
                                        .join('\n'),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    children: [
                                      for (var i in homeC.selectedService
                                          .toSet()
                                          .toList())
                                        Text(
                                            'x ${homeC.listService.where((name) => name == i).length}'),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                );
              }),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: ElevatedButton(
                        onPressed: () async {
                          if (homeC.serviceItem.isEmpty) {
                            homeC.serviceItem.value =
                                service.toString().split(',').cast();
                          } else {
                            homeC.serviceItem = homeC.serviceItem;
                          }

                          var data = {
                            "notrx": notrx,
                            "services": homeC.serviceItem.join(','),
                          };
                          await homeC.updateDataTrx(data);
                          showDefaultDialog2(
                              "Sukses", "Data berhasil diperbarui");
                          homeC.selectedService.clear();
                          homeC.serviceItem.clear();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(40, 40)),
                        child: const Text(
                          'Update',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                  Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: ElevatedButton(
                        onPressed: () {
                          homeC.selectedService.clear();
                          homeC.listService.clear();
                          homeC.serviceItem.clear();
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            minimumSize: const Size(45, 40)),
                        child: const Text(
                          'Batal',
                          style: TextStyle(fontSize: 15),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ));
  }
}
