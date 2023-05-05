import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/alert.dart';
import '../../../helper/printer.dart';
import '../../login/controllers/login_controller.dart';
import '../controllers/home_controller.dart';

class HomeAdd extends GetView<HomeController> {
  HomeAdd(
      {super.key,
      required this.kodeCabang,
      required this.kodeUser,
      required this.level});
  final homeC = Get.put(HomeController());
  final loginC = Get.put(LoginController());
  final String kodeCabang;
  final String kodeUser;
  final String level;
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var dateNow = DateFormat('ddMMyy').format(DateTime.now());
  TextEditingController mk = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool willLeave = false;
        await Get.defaultDialog(
            radius: 5,
            title: 'Peringatan',
            content: const Text('Anda yakin ingin keluar dari aplikasi ini?'),
            confirm: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent[700]),
                child: const Text('TIDAK')),
            cancel: ElevatedButton(
                onPressed: () {
                  homeC.noPolisi.clear();
                  willLeave = true;
                  Get.back();
                },
                child: const Text('IYA')));
        return willLeave;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
          centerTitle: true,
          leading: const Icon(Icons.account_circle),
          actions: [
            // IconButton(
            //     onPressed: () async {
            //       homeC.getTrx(kodeCabang, kodeUser, date);
            //       homeC.getDate();
            //       homeC.getCabang(kodeCabang, level);
            //       homeC.getMerkById(homeC.selectedItem.value != ""
            //           ? homeC.selectedItem.value
            //           : "1");
            //       homeC.getKaryawan(kodeCabang);
            //     },
            //     icon: const Icon(Icons.refresh_rounded)),
            PopupMenuButton<int>(
              itemBuilder: (context) => [
                // PopupMenuItem 1
                PopupMenuItem(
                  value: 1,
                  // row with 2 children
                  child: Row(
                    children: const [
                      Icon(Icons.file_download_outlined, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Update App")
                    ],
                  ),
                ),
                // PopupMenuItem 2
                PopupMenuItem(
                  value: 2,
                  // row with two children
                  child: Row(
                    children: const [
                      Icon(Icons.print_rounded, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Printer Setting")
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  // row with two children
                  child: Row(
                    children: const [
                      Icon(Icons.logout_outlined, color: Colors.black),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Log Out")
                    ],
                  ),
                ),
              ],
              offset: const Offset(0, 1),
              color: Colors.white,
              elevation: 2,
              // on selected we show the dialog box
              onSelected: (value) {
                // if value 1 show dialog
                if (value == 1) {
                  homeC.tryOtaUpdate();
                  // if value 2 show dialog
                } else if (value == 2) {
                  Get.to(() => const PrintSetting());
                } else if (value == 3) {
                  Get.defaultDialog(
                    barrierDismissible: false,
                    radius: 5,
                    title: 'Peringatan',
                    content: Column(
                      children: [
                        const Text('Anda yakin ingin Logout?'),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await pref.remove("kode");
                                  await pref.setBool("is_login", false);
                                  loginC.isLogin.value = false;
                                  loginC.isLoading.value = false;

                                  Fluttertoast.showToast(
                                      msg: "Sukses, Anda berhasil Logout.",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.greenAccent[700],
                                      textColor: Colors.white,
                                      fontSize: 16.0);
                                  Get.back();
                                },
                                child: const Text('Ya')),
                            ElevatedButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Tidak')),
                          ],
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 10),
                  child: StreamBuilder(
                      stream: homeC.getTrx(kodeCabang, kodeUser, date),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          homeC.idTrx.value = snapshot.data!.length + 1;

                          homeC.noUrutTrx.value = '$kodeCabang$kodeUser';
                          for (int i = 0; i < snapshot.data!.length; i++) {
                            homeC.noPolisi.add(snapshot.data![i].nopol!);
                          }
                          homeC.listnopol = homeC.noPolisi.toSet().toList();
                          return Obx(
                            () => BarcodeWidget(
                                barcode: Barcode.code128(),
                                data:
                                    '${homeC.noUrutTrx.value}$dateNow-00${homeC.idTrx.value != 0 ? homeC.idTrx.value : 1}',
                                height: 100,
                                width: 320,
                                style: const TextStyle(fontSize: 20)),
                          );
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }),
                ),
                const SizedBox(
                  height: 50,
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
                        height: 20,
                        child: StreamBuilder(
                            stream: homeC.getDate(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                var today = DateTime.now();
                                if (today.hour == 23 && today.minute == 00) {
                                  loginC.logout();
                                }
                                return Text(snapshot.data!,
                                    style: const TextStyle(fontSize: 17));
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const Center(
                                child: CupertinoActivityIndicator(),
                              );
                            }),
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
                            style: TextStyle(fontSize: 17),
                          ),
                        )),
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
                                  style: const TextStyle(fontSize: 17));
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
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
                            "Jenis Kendaraan",
                            style: TextStyle(fontSize: 17),
                          ),
                        )),
                    Expanded(
                      flex: 8,
                      child: SizedBox(
                        height: 60,
                        child: Obx(
                          () => DropdownButtonFormField(
                            decoration: const InputDecoration(
                                border: OutlineInputBorder()),
                            value: homeC.selectedItem.value == ""
                                ? null
                                : homeC.selectedItem.value,
                            onChanged: (String? data) {
                              homeC.selectedItem.value = data!;
                            },
                            items: homeC.jenisKendaran.map((data) {
                              return DropdownMenuItem<String>(
                                  value: data["id"].toString(),
                                  child: Text(data["jenis"].toString()));
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    // ),
                  ],
                ),
                // }),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => FutureBuilder(
                      future: homeC.getMerkById(homeC.selectedItem.value != ""
                          ? homeC.selectedItem.value
                          : "1"),
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
                                            12, 10, 12, 10),
                                        child: const Text(
                                          "Merk Kendaraan",
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
                                              return const Iterable<
                                                  String>.empty();
                                            } else {
                                              List<String> matches = <String>[];
                                              matches.addAll(merkKendaraan);

                                              matches.retainWhere((s) {
                                                return s.toLowerCase().contains(
                                                    textValue.text
                                                        .toLowerCase());
                                              });
                                              return matches;
                                            }
                                          },
                                          onSelected: (String selection) {
                                            homeC.selectedMerk.value =
                                                selection;
                                          },
                                          fieldViewBuilder: (BuildContext
                                                  context,
                                              mk,
                                              FocusNode focusNode,
                                              VoidCallback onFieldSubmitted) {
                                            return TextField(
                                              decoration: const InputDecoration(
                                                  border: OutlineInputBorder()),
                                              controller: mk,
                                              focusNode: focusNode,
                                              onSubmitted: (String value) {},
                                            );
                                          },
                                          optionsViewBuilder: (BuildContext
                                                  context,
                                              void Function(String) onSelected,
                                              Iterable<String> options) {
                                            return Align(
                                              alignment: Alignment.topLeft,
                                              child: Material(
                                                  child: SizedBox(
                                                width: 210,
                                                height: 170,
                                                child: ListView.builder(
                                                  itemCount: options.length,
                                                  itemBuilder:
                                                      (context, index) =>
                                                          Column(
                                                    children:
                                                        options.map((opt) {
                                                      return InkWell(
                                                          onTap: () {
                                                            onSelected(opt);
                                                          },
                                                          child: Container(
                                                            width:
                                                                double.infinity,
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
                                  // ),
                                ],
                              )
                            ],
                          );
                        } else if (snapshot.hasError) {
                          // print(snapshot.error);
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      }),
                ),

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
                            "Nomor Kendaraan",
                            style: TextStyle(fontSize: 17),
                          ),
                        )),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                            textCapitalization: TextCapitalization.characters,
                            maxLength: 2,
                            textInputAction: TextInputAction.next,
                            controller: homeC.noPol1,
                            decoration: const InputDecoration(
                                counterText: '', border: OutlineInputBorder())),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                            textAlign: TextAlign.center,
                            maxLength: 4,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            controller: homeC.noPol2,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                            )),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 55,
                        child: TextField(
                            maxLength: 3,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.done,
                            controller: homeC.noPol3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: '',
                            )),
                      ),
                    ),
                    // ),
                  ],
                ),
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
                      child: SizedBox(
                          height: 99,
                          child: StreamBuilder(
                              stream: homeC.getKaryawan(kodeCabang),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }
                                return MultiSelectFormField(
                                    autovalidate: AutovalidateMode.disabled,
                                    chipBackGroundColor: Colors.blue,
                                    chipLabelStyle:
                                        const TextStyle(color: Colors.white),
                                    dialogTextStyle: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                    checkBoxActiveColor: Colors.blue,
                                    checkBoxCheckColor: Colors.white,
                                    dialogShapeBorder:
                                        const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12.0))),
                                    title: const Text(
                                      "Pilih Petugas",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    hintWidget: const Text(''),
                                    validator: (value) {
                                      if (value == null || value.length == 0) {
                                        return showSnackbar(
                                            "Error", "Pilih Petugas");
                                      }

                                      return null;
                                    },
                                    dataSource: [
                                      for (var i in homeC.listKaryawan)
                                        {
                                          "display": i.nama,
                                          "value": i.nama,
                                        }
                                    ],
                                    textField: 'display',
                                    valueField: 'value',
                                    okButtonLabel: 'OK',
                                    cancelButtonLabel: 'CANCEL',
                                    onSaved: (value) {
                                      if (value == null) return;
                                      homeC.selectedPetugas.value = value;
                                    });
                              })),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: Obx(
          () => Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: FloatingActionButton(
              onPressed: homeC.tempStruk.isNotEmpty
                  ? () async {
                      Map<String, dynamic> printStruk = {};
                      printStruk.addAll(homeC.tempStruk.cast());

                      await PrintSettingState(dataPrint: printStruk)
                          .printStruk();
                      homeC.tempStruk.clear();
                    }
                  : null,
              backgroundColor:
                  homeC.tempStruk.isNotEmpty ? Colors.blue : Colors.grey,
              tooltip: 'Copy Struk',
              child: const Icon(
                Icons.receipt_long,
                color: Colors.white,
              ),
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
            ),
            onPressed: () async {
              var jenis = homeC.selectedItem.value;
              var noTrx =
                  '${homeC.noUrutTrx.value}$dateNow-00${homeC.idTrx.value != 0 ? homeC.idTrx.value : 1}';
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
                    fontSize: 16.0);
              } else if (homeC.selectedMerk.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Gagal, Merk tidak boleh kosong.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
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
                    fontSize: 16.0);
              } else if (homeC.listnopol.contains(nopol)) {
                Fluttertoast.showToast(
                    msg: "Gagal, Nomor Kendaraan sudah terdaftar.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else if (homeC.selectedPetugas.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Gagal, Petugas belum dipilih.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.redAccent[700],
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                var dataInput = {
                  "no_trx": noTrx,
                  "kode_cabang": kodeCabang,
                  "kode_user": kodeUser,
                  "id_jenis": jenis,
                  "kendaraan": merk,
                  "no_polisi": nopol,
                  "jam_masuk":
                      DateFormat("HH:mm:ss").format(DateTime.now()).toString(),
                  "services": jenis == "1" ? "5" : "1",
                  "petugas": homeC.selectedPetugas.join(', '),
                  "paid": "0",
                  "status": "0",
                  "tanggal": date,
                };
                await homeC.submitData(dataInput);
                homeC.idTrx.value++;
                homeC.selectedMerk.value = "";
                homeC.selectedItem.value = "";
                homeC.noPol1.clear();
                homeC.noPol2.clear();
                homeC.noPol3.clear();
                homeC.noPolisi.clear();
                mk.clear();
                homeC.selectedPetugas.clear();
                Get.defaultDialog(
                    radius: 5,
                    title: 'Sukses',
                    middleText: 'Data berhasil di input',
                    textConfirm: 'OK',
                    confirmTextColor: Colors.white,
                    onConfirm: () async {
                      Get.back();
                    });
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
                  "tanggal": DateFormat("yyy-MM-dd HH:mm:ss")
                      .format(DateTime.now())
                      .toString(),
                  // "user": user,
                  "jeniskendaraan": merk,
                  "no_polisi": nopol
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
        ),
      ),
    );
  }
}
