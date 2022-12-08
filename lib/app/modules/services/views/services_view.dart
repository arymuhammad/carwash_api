import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/helper/alert.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../master/controllers/master_controller.dart';
import '../controllers/services_controller.dart';

class ServicesView extends GetView<ServicesController> {
  ServicesView({Key? key}) : super(key: key);

  final masterC = Get.put(MasterController());
  TextEditingController namaService = TextEditingController();
  TextEditingController harga = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: masterC.getFutureServices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return DataTable2(
                  columnSpacing: 1,
                  horizontalMargin: 5,
                  minWidth: 600,
                  showBottomBorder: true,
                  headingTextStyle: const TextStyle(color: Colors.white),
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.lightBlue),
                  columns: const [
                    DataColumn2(
                        label: Text('No'),
                        // size: ColumnSize.S,
                        fixedWidth: 30),
                    DataColumn2(
                        label: Text('Nama Service'), size: ColumnSize.S),
                    DataColumn2(label: Text('Harga'), size: ColumnSize.S),
                    DataColumn2(label: Text('Action'), size: ColumnSize.S),
                  ],
                  rows: List<DataRow>.generate(data.length, (index) {
                    masterC.idService = data.length + 1;
                    return DataRow(cells: [
                      DataCell(Text(data[index].id!)),
                      DataCell(Text(data[index].serviceName!)),
                      DataCell(Text(NumberFormat.simpleCurrency(
                              locale: 'in', decimalDigits: 0)
                          .format(int.parse(data[index].harga!))
                          .toString())),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editData(data[index].id!,
                                  data[index].serviceName!, data[index].harga!);
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
                              deleteData(data[index].id!);
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
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
          addData(masterC.idService);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  editData(id, nama, hrg) {
    Get.defaultDialog(
        radius: 5,
        title: 'Edit Jenis Service',
        content: Column(
          children: [
            const Divider(),
            SizedBox(
              height: 45,
              child: TextField(
                controller: namaService,
                decoration: InputDecoration(
                    hintText: nama, border: const OutlineInputBorder()),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: harga,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: harga.toString(),
                    border: const OutlineInputBorder()),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (namaService.text == "") {
                        namaService.text = nama;
                      } else {
                        namaService.text = namaService.text;
                      }
                      if (harga.text == "") {
                        harga.text = hrg;
                      } else {
                        harga.text = harga.text;
                      }
                      var data = {
                        "id": id,
                        "nama": namaService.text,
                        "harga": harga.text
                      };
                      masterC.addService(data);
                      showDefaultDialog2(
                          "Sukses", "Data services berhasil diperbarui");
                      namaService.clear();
                      harga.clear();
                    },
                    child: const Text('Update')),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Batal')),
              ],
            )
          ],
        ));
  }

  deleteData(String id) {
    Get.defaultDialog(
        radius: 5,
        title: 'Peringatan',
        content: Column(
          children: [
            const Text('Anda yakin ingin menghapus data ini?'),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      var data = {"id": id};
                      await masterC.deleteService(data);
                      showDefaultDialog2("Sukses", "Data berhasil dihapus");
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
  }

  addData(int id) {
    Get.defaultDialog(
        radius: 5,
        title: 'Tambah Jenis Service',
        content: Column(
          children: [
            const Divider(),
            SizedBox(
              height: 45,
              child: TextField(
                controller: namaService,
                decoration: const InputDecoration(
                    hintText: 'Nama Service',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 45,
              child: TextField(
                controller: harga,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    hintText: 'Rp',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (namaService.text == "" && harga.text == "") {
                        showSnackbar("Error", "Data tidak boleh kosong");
                      } else {
                        var data = {
                          "nama": namaService.text,
                          "harga": harga.text
                        };
                        await masterC.addService(data);
                        showDefaultDialog2(
                            "Sukses", "Data services berhasil ditambahkan");
                        namaService.clear();
                        harga.clear();
                      }
                    },
                    child: const Text('Simpan')),
                ElevatedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text('Batal')),
              ],
            )
          ],
        ));
  }
}
