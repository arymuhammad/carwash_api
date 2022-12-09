import 'package:carwash/app/helper/alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

import '../controllers/master_controller.dart';

class MasterKendaraan extends GetView<MasterController> {
  MasterKendaraan({super.key});

  final masterC = Get.put(MasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: masterC.getKendaraan(),
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
                    DataColumn2(
                        label: Text('No '),
                        // size: ColumnSize.S,
                        fixedWidth: 45),
                    DataColumn(
                      label: Text('Nama Kendaraan'),
                    ),
                    DataColumn(
                      label: Text('Jenis Kendaraan'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(data.length, (index) {
                    masterC.idKendaraan = data.length + 1;

                    return DataRow(cells: [
                      DataCell(Text(data[index].id!)),
                      DataCell(Text(data[index].nama!)),
                      DataCell(Text(
                          data[index].idJenis! == "1" ? "Motor" : "Mobil")),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editData(data[index].id!, data[index].nama!);
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
                                          'Anda yakin ingin menghapus data ini?'),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                masterC.deleteMerk(
                                                    data[index].id!);
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
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            addkendaraan(masterC.idKendaraan);
          },
          child: const Icon(Icons.add)),
    );
  }

  void editData(id, nama) {
    Get.defaultDialog(
        radius: 5,
        title: 'Edit Data Kendaraan',
        content: Column(
          children: [
            SizedBox(
                height: 45,
                child: TextField(
                  controller: masterC.namaMerk,
                  decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.car_rental),
                      hintText: nama,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (masterC.namaMerk.text == "") {
                          masterC.namaMerk.text = nama;
                        } else {
                          masterC.namaMerk.text = masterC.namaMerk.text;
                        }
                        var data = {
                          "id": id,
                          "nama": masterC.namaMerk.text,
                          "sts": "update"
                        };
                        await masterC.addUpdateMerk(data);
                        showDefaultDialog2(
                            "Sukses", "Data berhasil diperbarui");
                        masterC.namaMerk.clear();
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

  addkendaraan(int id) {
    Get.defaultDialog(
        radius: 5,
        title: 'Tambah Data Kendaraan',
        content: Column(
          children: [
            Obx(() => DropdownButtonFormField(
                  decoration: const InputDecoration(
                      hintText: 'Jenis Kendaraan',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                  value: masterC.selectedjenisKendaraan.value == ""
                      ? null
                      : masterC.selectedjenisKendaraan.value,
                  // isDense: true,
                  onChanged: (String? data) {
                    masterC.selectedjenisKendaraan.value = data!;
                  },
                  items: masterC.jenisKendaran.map((data) {
                    return DropdownMenuItem<String>(
                        value: data["id"].toString(),
                        child: Text(data["jenis"].toString()));
                  }).toList(),
                )),
            const SizedBox(
              height: 5,
            ),
            SizedBox(
                height: 50,
                child: TextField(
                  controller: masterC.namaMerk,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.car_rental),
                      label: Text('Nama Kendaraan'),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20)))),
                )),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        var data = {
                          "id_jenis": masterC.selectedjenisKendaraan.value,
                          "nama": masterC.namaMerk.text,
                          "sts": "add"
                        };
                        await masterC.addUpdateMerk(data);
                        showDefaultDialog2(
                            "Sukses", "Data Kendaraan berhasil ditambahkan");
                        masterC.namaMerk.clear();
                        masterC.selectedjenisKendaraan.value = "";
                      },
                      child: const Text(
                        'Simpan',
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
}
