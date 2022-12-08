import 'package:carwash/app/helper/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import '../controllers/master_controller.dart';

class MasterKaryawan extends GetView<MasterController> {
  MasterKaryawan(this.kode, this.level, {super.key});
  final String kode;
  final String level;
  final masterC = Get.put(MasterController());
  TextEditingController namaLengkap = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: masterC.getKaryawan(kode, level),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              var data = snapshot.data!;
              return DataTable2(
                  columnSpacing: 1,
                  horizontalMargin: 8,
                  minWidth: 600,
                  showBottomBorder: true,
                  headingTextStyle: const TextStyle(color: Colors.white),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.lightBlue),
                  columns: const [
                    DataColumn(
                      label: Text('Kode Cabang'),
                      // size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text('Nama'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(data.length, (index) {
                    masterC.noUrut.value = data.length + 1;

                    return DataRow(cells: [
                      DataCell(Text(data[index].cabang! != ""
                          ? data[index].cabang!
                          : 'Belum terdaftar dicabang manapun')),
                      DataCell(Text(data[index].nama!)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editData(data[index].id!, data[index].nama!,
                                  data[index].cabang!);
                            },
                            icon: const Icon(
                              Icons.edit_note_sharp,
                              size: 30,
                              color: Colors.lightBlue,
                            ),
                            splashRadius: 20,
                          ),
                          IconButton(
                            onPressed: () {
                              Get.defaultDialog(
                                  radius: 5,
                                  title: 'Peringatan',
                                  content: Column(
                                    children: [
                                      const Text(
                                          'Yakin ingin menghapus data ini?'),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () async {
                                                var deleteId = {
                                                  "id": data[index].id!
                                                };
                                                await masterC
                                                    .deleteKaryawan(deleteId);
                                                showDefaultDialog2("Sukses",
                                                    "Data Karyawan berhasil dihapus");
                                              },
                                              child: const Text('Hapus')),
                                          ElevatedButton(
                                              onPressed: () {
                                                Get.back();
                                              },
                                              child: const Text('Batal')),
                                        ],
                                      )
                                    ],
                                  ));
                            },
                            icon: const Icon(
                              Icons.delete,
                              size: 30,
                              color: Colors.lightBlue,
                            ),
                            splashRadius: 20,
                          ),
                        ],
                      )),
                    ]);
                  }));
            }
          } else if (snapshot.hasError) {
            return const Text('Belum ada data');
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addKaryawan();
          },
          child: const Icon(Icons.add)),
    );
  }

  void editData(id, nama, cabang) {
    print(cabang);
    print(level);
    Get.defaultDialog(
        radius: 5,
        title: 'Detail Data',
        content: Column(
          children: [
            SizedBox(
              height: 45,
              child: TextField(
                controller: namaLengkap,
                decoration: InputDecoration(
                    hintText: nama, border: const OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
              stream: masterC.getCabang(cabang, level),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Pilih Cabang',
                          border: OutlineInputBorder()),
                      value: masterC.selectedCabangKaryawan.value == ""
                          ? null
                          : masterC.selectedCabangKaryawan.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedCabangKaryawan.value = data!;
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.kodeCabang!,
                            child: Text(doc.namaCabang!));
                      }).toList(),
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
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (namaLengkap.text == "") {
                          namaLengkap.text = nama;
                        } else {
                          namaLengkap.text = namaLengkap.text;
                        }
                        if (masterC.selectedCabangKaryawan.isEmpty) {
                          masterC.selectedCabangKaryawan.value = cabang;
                        } else {
                          masterC.selectedCabangKaryawan.value =
                              masterC.selectedCabangKaryawan.value;
                        }
                        var dataKaryawan = {
                          "id": id,
                          "nama": namaLengkap.text,
                          "cabang": masterC.selectedCabangKaryawan.value,
                          "sts": "update"
                        };
                        await masterC.updateKaryawan(dataKaryawan);
                        showDefaultDialog2(
                            "Sukses", "Data Karyawan berhasil diupdate");
                        masterC.selectedCabangKaryawan.value = "";
                        namaLengkap.clear();
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(fontSize: 15),
                      ),
                    )),
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text(
                        'Batal',
                        style: TextStyle(fontSize: 15),
                      ),
                    )),
              ],
            ),
          ],
        ));
  }

  addKaryawan() {
    Get.defaultDialog(
        radius: 5,
        title: 'Tambah Karyawan',
        content: Column(
          children: [
            const Divider(),
            TextField(
              controller: namaLengkap,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Nama Lengkap')),
            ),
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
              stream: masterC.getCabang(kode, level),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Pilih Cabang',
                          border: OutlineInputBorder()),
                      value: masterC.selectedCabangKaryawan.value == ""
                          ? null
                          : masterC.selectedCabangKaryawan.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedCabangKaryawan.value = data!;
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.kodeCabang!,
                            child: Text(doc.namaCabang!));
                      }).toList(),
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
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      var dataKaryawan = {
                        "cabang": masterC.selectedCabangKaryawan.value,
                        "nama": namaLengkap.text,
                        "sts": "add"
                      };
                      masterC.addKaryawan(dataKaryawan);
                      showDefaultDialog2(
                          "Sukses", "Data Karyawan berhasil ditambahkan");
                      masterC.selectedCabangKaryawan.value = "";
                      namaLengkap.clear();
                      masterC.persentase.clear();
                    },
                    child: const Text('Simpan')),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Batal'))
              ],
            )
          ],
        ));
  }
}
