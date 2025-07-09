import 'package:barcode_widget/barcode_widget.dart';
import 'package:carwash/app/helper/printer.dart';
import 'package:carwash/app/modules/home/controllers/home_controller.dart';
import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import '../../../../helper/alert.dart';
import '../../../home/views/home_add.dart';

final homeC = Get.put(HomeWebController());

addDialog(BuildContext context, kodeUser, kodeCabang, level) {
  showDialog(
    context: context,
    builder: (context) {
      return LayoutBuilder(
        builder: (context, constraints) {
          bool isWideScreen = constraints.maxWidth >= 800;
          return AlertDialog(
            insetPadding: const EdgeInsets.all(8),
            title: const Text('Add Unit'),
            content: Container(
              width:
                  MediaQuery.of(context).size.width /
                  (isWideScreen ? 1.7 : 1.6),
              height: MediaQuery.of(context).size.height / 1.2,
              decoration: const BoxDecoration(color: Colors.white),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: '$kodeCabang-${homeC.idTrx}${homeC.dateNow}',
                      height: 70,
                      width: 320,
                      style: const TextStyle(fontSize: 20),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: const Text(
                              "Tanggal",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 20,
                            child: StreamBuilder(
                              stream: homeC.getDate(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data!,
                                    style: const TextStyle(fontSize: 15),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
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
                              "Cabang",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 20,
                            child: FutureBuilder(
                              future: homeC.getCabang(kodeCabang, level),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    '${homeC.dataCabang[0].namaCabang} (${homeC.dataCabang[0].kodeCabang})',
                                    style: const TextStyle(fontSize: 15),
                                  );
                                } else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: const Text(
                              "Jenis Kendaraan",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 40,
                            child: Obx(
                              () => DropdownButtonFormField(
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.all(8),
                                  border: OutlineInputBorder(),
                                ),
                                value:
                                    homeC.selectedItem.value == ""
                                        ? null
                                        : homeC.selectedItem.value,
                                onChanged: (String? data) {
                                  homeC.selectedItem.value = data!;
                                },
                                items:
                                    homeC.jenisKendaran.map((data) {
                                      return DropdownMenuItem<String>(
                                        value: data["id"].toString(),
                                        child: Text(data["jenis"].toString()),
                                      );
                                    }).toList(),
                              ),
                            ),
                          ),
                        ),
                        // ),
                      ],
                    ),
                    // }),
                    const SizedBox(height: 10),
                    Obx(
                      () => FutureBuilder(
                        future: homeC.getMerkById(
                          homeC.selectedItem.value != ""
                              ? homeC.selectedItem.value
                              : "1",
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<String> merkKendaraan = <String>[];

                            homeC.dataMerk.map((doc) {
                              merkKendaraan.add(doc.merk.toString());
                            }).toList();

                            return Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        padding: const EdgeInsets.fromLTRB(
                                          12,
                                          10,
                                          12,
                                          10,
                                        ),
                                        child: const Text(
                                          "Merk Kendaraan",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 8,
                                      child: SizedBox(
                                        height: 40,
                                        child: RawAutocomplete(
                                          key: homeC.autocompleteKey,
                                          focusNode: homeC.focusNode,
                                          textEditingController: homeC.mk,
                                          optionsBuilder: (
                                            TextEditingValue textValue,
                                          ) {
                                            if (textValue.text == '') {
                                              return const Iterable<
                                                String
                                              >.empty();
                                            } else {
                                              List<String> matches = <String>[];
                                              matches.addAll(merkKendaraan);

                                              matches.retainWhere((s) {
                                                return s.toLowerCase().contains(
                                                  textValue.text.toLowerCase(),
                                                );
                                              });
                                              return matches;
                                            }
                                          },
                                          onSelected: (String selection) {
                                            homeC.selectedMerk.value =
                                                selection;
                                          },
                                          fieldViewBuilder: (
                                            BuildContext context,
                                            mk,
                                            FocusNode focusNode,
                                            VoidCallback onFieldSubmitted,
                                          ) {
                                            return TextField(
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.all(
                                                  8,
                                                ),
                                                border: OutlineInputBorder(),
                                              ),
                                              controller: mk,
                                              focusNode: focusNode,
                                              onSubmitted: (String value) {},
                                            );
                                          },
                                          optionsViewBuilder: (
                                            BuildContext context,
                                            void Function(String) onSelected,
                                            Iterable<String> options,
                                          ) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                child: SizedBox(
                                                  width: 210,
                                                  height: 170,
                                                  child: ListView.builder(
                                                    itemCount: options.length,
                                                    itemBuilder:
                                                        (
                                                          context,
                                                          index,
                                                        ) => Column(
                                                          children:
                                                              options.map((
                                                                opt,
                                                              ) {
                                                                return InkWell(
                                                                  onTap: () {
                                                                    onSelected(
                                                                      opt,
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    width:
                                                                        double
                                                                            .infinity,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          10,
                                                                        ),
                                                                    child: Text(
                                                                      opt,
                                                                    ),
                                                                  ),
                                                                );
                                                              }).toList(),
                                                        ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                    // ),
                                  ],
                                ),
                              ],
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

                    const SizedBox(height: 10),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                            child: const Text(
                              "Nomor Kendaraan",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              textCapitalization: TextCapitalization.characters,
                              maxLength: 2,
                              textInputAction: TextInputAction.next,
                              controller: homeC.noPol1,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                counterText: '',
                                border: OutlineInputBorder(),
                              ),
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 4,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              textAlign: TextAlign.center,
                              maxLength: 4,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                              controller: homeC.noPol2,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          flex: 2,
                          child: SizedBox(
                            height: 40,
                            child: TextField(
                              maxLength: 3,
                              textCapitalization: TextCapitalization.characters,
                              textInputAction: TextInputAction.done,
                              controller: homeC.noPol3,
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8),
                                border: OutlineInputBorder(),
                                counterText: '',
                              ),
                              inputFormatters: [UpperCaseTextFormatter()],
                            ),
                          ),
                        ),
                        // ),
                      ],
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
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 80,
                            child: FutureBuilder(
                              future: homeC.getKaryawan(kodeCabang),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                                return MultiSelectFormField(
                                  autovalidate: AutovalidateMode.disabled,
                                  chipBackGroundColor: Colors.blue,
                                  chipLabelStyle: const TextStyle(
                                    color: Colors.white,
                                  ),
                                  dialogTextStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  checkBoxActiveColor: Colors.blue,
                                  checkBoxCheckColor: Colors.white,
                                  dialogShapeBorder:
                                      const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(12.0),
                                        ),
                                      ),
                                  title: const Text(
                                    "Pilih Petugas",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  hintWidget: const Text(''),
                                  validator: (value) {
                                    if (value == null || value.length == 0) {
                                      return showSnackbar(
                                        "Error",
                                        "Pilih Petugas",
                                      );
                                    }

                                    return null;
                                  },
                                  dataSource: [
                                    for (var i in homeC.listKaryawan)
                                      {"display": i.nama, "value": i.nama},
                                  ],
                                  textField: 'display',
                                  valueField: 'value',
                                  okButtonLabel: 'OK',
                                  cancelButtonLabel: 'CANCEL',
                                  onSaved: (value) {
                                    if (value == null) return;
                                    homeC.selectedPetugas.value = value;
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () async {
                        var jenis = homeC.selectedItem.value;
                        var noTrx =
                            '$kodeCabang-${homeC.idTrx}${homeC.dateNow}';
                        var merk = homeC.selectedMerk.value;
                        var nopol =
                            '${homeC.noPol1.text}-${homeC.noPol2.text}-${homeC.noPol3.text}';
                        if (merk.isEmpty &&
                            homeC.noPol1.text == "" &&
                            homeC.noPol2.text == "" &&
                            homeC.noPol3.text == "" &&
                            homeC.selectedItem.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Gagal, Anda belum mengisi data.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent[700],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (homeC.selectedMerk.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Gagal, Merk tidak boleh kosong.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent[700],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (homeC.noPol1.text == "" &&
                            homeC.noPol2.text == "" &&
                            homeC.noPol3.text == "") {
                          Fluttertoast.showToast(
                            msg: "Gagal, Nomor Kendaraan tidak boleh kosong.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent[700],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (homeC.listnopol.contains(nopol)) {
                          Fluttertoast.showToast(
                            msg: "Gagal, Nomor Kendaraan sudah terdaftar.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent[700],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else if (homeC.selectedPetugas.isEmpty) {
                          Fluttertoast.showToast(
                            msg: "Gagal, Petugas belum dipilih.",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent[700],
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        } else {
                          var dataInput = {
                            "no_trx": noTrx,
                            "kode_cabang": kodeCabang,
                            "kode_user": kodeUser,
                            "id_jenis": jenis,
                            "kendaraan": merk,
                            "no_polisi": nopol,
                            "jam_masuk":
                                DateFormat(
                                  "HH:mm:ss",
                                ).format(DateTime.now()).toString(),
                            "services": jenis == "1" ? "5" : "1",
                            "petugas": homeC.selectedPetugas.join(', '),
                            "paid": "0",
                            "status": "0",
                            "tanggal": homeC.date,
                          };
                          await homeC.submitData(dataInput);

                          homeC.selectedMerk.value = "";
                          homeC.selectedItem.value = "";
                          homeC.noPol1.clear();
                          homeC.noPol2.clear();
                          homeC.noPol3.clear();
                          homeC.noPolisi.clear();
                          homeC.mk.clear();
                          homeC.idTrx = '';
                          homeC.selectedPetugas.clear();
                          Get.defaultDialog(
                            radius: 5,
                            title: 'Sukses',
                            middleText: 'Data berhasil di input',
                            textConfirm: 'OK',
                            confirmTextColor: Colors.white,
                            onConfirm: () async {
                              Get.back();
                              Get.back();
                            },
                          );
                          // Fluttertoast.showToast(
                          //     msg: "Berhasil, Data Terkirim.",
                          //     toastLength: Toast.LENGTH_SHORT,
                          //     gravity: ToastGravity.BOTTOM,
                          //     timeInSecForIosWeb: 1,
                          //     backgroundColor: Colors.greenAccent[700],
                          //     textColor: Colors.white,
                          //     fontSize: 16.0);
                          // homeC.selectedMer
                          Map<String, dynamic> struk = {};
                          var dataPrint = {
                            "no_trx": noTrx,
                            "tanggal":
                                DateFormat(
                                  "yyy-MM-dd HH:mm:ss",
                                ).format(DateTime.now()).toString(),
                            // "user": user,
                            "jeniskendaraan": merk,
                            "no_polisi": nopol,
                          };
                          struk.addAll(dataPrint);
                          homeC.tempStruk.addAll(dataPrint);
                          // print(struk);
                          PrintSettingState(dataPrint: struk).printStruk();
                        }
                      },
                      child: const Text(
                        'Simpan',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
