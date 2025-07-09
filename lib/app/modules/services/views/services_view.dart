import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../helper/alert.dart';
import '../../../model/services_model.dart';
import '../../master/controllers/master_controller.dart';
import '../controllers/services_controller.dart';

class ServicesView extends GetView<ServicesController> {
  ServicesView({super.key});

  final masterC = Get.put(MasterController());
  final TextEditingController namaService = TextEditingController();
  final TextEditingController harga = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: masterC.getServices(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var data = snapshot.data!;
            var masterService = <Services>[];
            data.map((e) => masterService.add(e)).toList();
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else {
              return PaginatedDataTable2(
                  headingRowColor: MaterialStateProperty.resolveWith(
                      (states) => Colors.indigo),
                  showFirstLastButtons: true,
                  columns: const [
                    DataColumn2(
                        label: Text(
                          'No',
                          style: TextStyle(color: Colors.white),
                        ),
                        size: ColumnSize.S,
                        fixedWidth: 60),
                    DataColumn(
                        label: Text(
                      'Nama Service',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Harga',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Action',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  source: DataService(dtServices: masterService));
            }
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CupertinoActivityIndicator(),
                SizedBox(width: 5),
                Text('Sedang memuat ....')
              ],
            ),
          );
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 50.0),
        child: FloatingActionButton(
          onPressed: () {
            addData(masterC.idService);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
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
                          "harga": harga.text,
                          "sts": "add"
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

class DataService extends DataTableSource {
  DataService({required List<Services> dtServices})
      : _service = dtServices,
        assert(dtServices != null);
  final List<Services> _service;
  final masterC = Get.put(MasterController());
  TextEditingController namaService = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _service.length) {
      return null;
    }
    final _data = _service[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${_data.id}')),
        DataCell(Text('${_data.serviceName}')),
        DataCell(Text(
            NumberFormat.simpleCurrency(locale: 'in', decimalDigits: 0)
                .format(int.parse(_data.harga!)))),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {
                editData(_data.id, _data.serviceName, _data.harga);
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
                        const Text('Anda yakin ingin menghapus data ini?'),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () async {
                                  var idService = {"id": _data.id!};
                                  await masterC.deleteService(idService);
                                  showDefaultDialog2(
                                      "Sukses", "Data berhasil dihapus");
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
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _service.length;

  @override
  int get selectedRowCount => 0;

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
                    hintText: hrg, border: const OutlineInputBorder()),
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
                        "harga": harga.text,
                        "sts": "update"
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
}
