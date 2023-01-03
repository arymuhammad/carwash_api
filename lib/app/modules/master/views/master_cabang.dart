import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/helper/alert.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';
import '../controllers/master_controller.dart';

class MasterCabang extends GetView<MasterController> {
  MasterCabang(this.kode, this.level, {super.key});

  final String? kode;
  final String? level;
  final masterC = Get.put(MasterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: masterC.getCabang(kode, level),
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
                    DataColumn2(label: Text('Kode '), fixedWidth: 50
                        // size: ColumnSize.S,
                        ),
                    DataColumn(
                      label: Text('Cabang'),
                    ),
                    DataColumn2(label: Text('Kota'), fixedWidth: 70),
                    DataColumn(
                      label: Text('Alamat'),
                    ),
                    DataColumn(
                      label: Text('No Telp'),
                    ),
                    DataColumn(
                      label: Text('Users'),
                    ),
                    DataColumn(
                      label: Text('Karyawan'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(data.length, (index) {
                    if (data.isEmpty) {
                      masterC.noUrut.value = masterC.noUrut.value;
                    } else {
                      masterC.noUrut.value = data.length + 1;
                    }

                    return DataRow(cells: [
                      DataCell(Text(data[index].kodeCabang!)),
                      DataCell(Text(data[index].namaCabang!)),
                      DataCell(Text(data[index].kota!)),
                      DataCell(Text(data[index].alamat! != ""
                          ? data[index].alamat!
                          : "alamat belum di isi")),
                      DataCell(Text(data[index].telp! != ""
                          ? data[index].telp!
                          : "Telpon belum di isi")),
                      DataCell(FutureBuilder(
                          future: masterC.futureUsers(data[index].kodeCabang!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var users = [];
                              snapshot.data!
                                  .map((e) => users.add(e.namaUser!))
                                  .toList();

                              return Text(users.isNotEmpty
                                  ? users.join(', ')
                                  : "Belum ada user");
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          })),
                      DataCell(FutureBuilder(
                          future:
                              masterC.futureKaryawan(data[index].kodeCabang!),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              var karyawans = [];
                              snapshot.data!
                                  .map((e) => karyawans.add(e.nama!))
                                  .toList();

                              return Text(karyawans.isNotEmpty
                                  ? karyawans.join(', ')
                                  : "Belum ada karyawan");
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const Center(
                              child: CupertinoActivityIndicator(),
                            );
                          })),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editData(
                                data[index].kodeCabang!,
                                data[index].namaCabang!,
                                data[index].kota!,
                                data[index].alamat!,
                                data[index].telp!,
                              );
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
                                              onPressed: () async {
                                                var idCabang = {
                                                  "kode":
                                                      data[index].kodeCabang!
                                                };
                                                await masterC
                                                    .deleteCabang(idCabang);
                                                showDefaultDialog2("Sukses",
                                                    "Data berhasil dihapus");
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
      floatingActionButton: level != "1"
          ? null
          : FloatingActionButton(
              onPressed: () {
                addCabang();
              },
              child: const Icon(Icons.add)),
    );
  }

  editData(kode, nama, kota, alamat, telpon) {
    Get.defaultDialog(
        radius: 5,
        title: 'Edit Data Cabang',
        content: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                    flex: 5,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                      child: const Text(
                        "Nama Cabang",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 20,
                      child: Text(nama, style: const TextStyle(fontSize: 17))),
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
                        "Kota",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 20,
                      child: Text(kota, style: const TextStyle(fontSize: 17))),
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
                        "Alamat",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 110,
                      width: 76,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                              controller: masterC.alamatCabang..text = alamat,
                              maxLines: 3,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      )),
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
                        "No Telpon",
                        style: TextStyle(fontSize: 17),
                      ),
                    )),
                Expanded(
                  flex: 8,
                  child: SizedBox(
                      height: 48,
                      width: 46,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          TextFormField(
                              controller: masterC.telpCabang..text = telpon,
                              style: const TextStyle(fontSize: 17)),
                        ],
                      )),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (masterC.namaCabang.text == "") {
                          masterC.namaCabang.text = nama;
                        } else {
                          masterC.namaCabang.text = masterC.namaCabang.text;
                        }

                        if (masterC.alamatCabang.text == "") {
                          masterC.alamatCabang.text = alamat;
                        } else {
                          masterC.alamatCabang.text = masterC.alamatCabang.text;
                        }

                        if (masterC.kotaCabang.text == "") {
                          masterC.kotaCabang.text = kota;
                        } else {
                          masterC.kotaCabang.text = masterC.kotaCabang.text;
                        }

                        if (masterC.telpCabang.text == "") {
                          masterC.telpCabang.text = telpon;
                        } else {
                          masterC.telpCabang.text = masterC.telpCabang.text;
                        }

                        var data = {
                          "kode": kode,
                          "nama": masterC.namaCabang.text,
                          "kota": masterC.kotaCabang.text,
                          "alamat": masterC.alamatCabang.text,
                          "telp": masterC.telpCabang.text,
                          "sts": "update"
                        };
                        await masterC.updateDataCabang(data);
                        showDefaultDialog2(
                            "Sukses", "Data Cabang berhasil diperbarui");
                        masterC.namaCabang.clear();
                        masterC.kotaCabang.clear();
                        masterC.alamatCabang.clear();
                        masterC.telpCabang.clear();
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

  void addCabang() {
    Get.defaultDialog(
        radius: 5,
        title: 'Tambah Cabang Baru',
        content: Column(
          children: [
            const Divider(),
            TextField(
              controller: masterC.namaCabang,
              decoration: InputDecoration(
                  label: const Text('Nama Cabang'),
                  prefixIcon: const Icon(Icons.business_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: masterC.kotaCabang,
              decoration: InputDecoration(
                  label: const Text('kota'),
                  prefixIcon: const Icon(Icons.map_sharp),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: masterC.alamatCabang,
              decoration: InputDecoration(
                  label: const Text('Alamat'),
                  prefixIcon: const Icon(Icons.corporate_fare_rounded),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: masterC.telpCabang,
              decoration: InputDecoration(
                  label: const Text('No Telpon'),
                  prefixIcon: const Icon(Icons.phone_iphone_outlined),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30))),
            ),
            const SizedBox(
              height: 5,
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(45, 45)),
                    onPressed: () async {
                      if (masterC.alamatCabang.text == "") {
                        showSnackbar('Error', 'alamat tidak boleh kosong');
                      } else if (masterC.namaCabang.text == "") {
                        showSnackbar('Error', 'nama cabang tidak boleh kosong');
                      } else {
                        var kodeCabang = '00${masterC.noUrut.value}';
                        var data = {
                          "kode": kodeCabang,
                          "nama": masterC.namaCabang.text,
                          "kota": masterC.kotaCabang.text,
                          "alamat": masterC.alamatCabang.text,
                          "telp": masterC.telpCabang.text,
                          "sts": "add"
                        };

                        await masterC.addCabang(data);
                        showDefaultDialog2(
                            "Sukses", "Cabang baru berhasil ditambahkan");
                        masterC.alamatCabang.clear();
                        masterC.namaCabang.clear();
                        masterC.kotaCabang.clear();
                        masterC.telpCabang.clear();
                        masterC.noUrut++;
                      }
                    },
                    child: const Text(
                      'Simpan',
                      style: TextStyle(fontSize: 17),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(45, 45)),
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontSize: 17),
                    )),
              ],
            )
          ],
        ));
  }
}
