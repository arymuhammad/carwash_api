import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/alert.dart';
import '../../../model/kendaraan_model.dart';
import '../controllers/master_controller.dart';

class MasterKendaraan extends GetView<MasterController> {
  MasterKendaraan({super.key});

  final masterC = Get.put(MasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: masterC.getKendaraan(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              var data = snapshot.data!;
              var masterKendaraan = <Kendaraan>[];
              data.map((e) => masterKendaraan.add(e)).toList();
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
                      'Nama Kendaraan',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Jenis Kendaraan',
                      style: TextStyle(color: Colors.white),
                    )),
                    DataColumn(
                        label: Text(
                      'Action',
                      style: TextStyle(color: Colors.white),
                    )),
                  ],
                  source: DataKendaraan(dtKendaraan: masterKendaraan));
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
        padding: const EdgeInsets.only(bottom: 50),
        child: FloatingActionButton(
            onPressed: () {
              addkendaraan(masterC.idKendaraan);
            },
            child: const Icon(Icons.add)),
      ),
    );
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

class DataKendaraan extends DataTableSource {
  DataKendaraan({required List<Kendaraan> dtKendaraan})
      : _kendaraan = dtKendaraan,
        assert(dtKendaraan != null);

  final List<Kendaraan> _kendaraan;
  final masterC = Get.put(MasterController());
  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _kendaraan.length) {
      return null;
    }
    final _data = _kendaraan[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${_data.id}')),
        DataCell(Text('${_data.nama}')),
        DataCell(Text(_data.idJenis == "1" ? "Motor" : "Mobil")),
        DataCell(Row(
          children: [
            IconButton(
              onPressed: () {
                editData(_data.id, _data.nama);
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
                                  var idMerk = {"id": _data.id!};
                                  await masterC.deleteMerk(idMerk);
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
  int get rowCount => _kendaraan.length;

  @override
  int get selectedRowCount => 0;

  void sort<T>(Comparable<T> Function(Kendaraan d) getField, bool ascending) {
    _kendaraan.sort((a, b) {
      final aValue = getField(a);
      final bValue = getField(b);
      return ascending
          ? Comparable.compare(aValue, bValue)
          : Comparable.compare(bValue, aValue);
    });

    notifyListeners();
  }

  editData(id, nama) {
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
}
