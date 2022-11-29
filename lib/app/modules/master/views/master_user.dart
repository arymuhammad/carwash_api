// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/helper/alert.dart';
import 'package:get/get.dart';
import 'package:data_table_2/data_table_2.dart';

// import '../../home/controllers/auth_controller.dart';
import '../../../model/level_model.dart';
import '../../../model/user_model.dart';
import '../controllers/master_controller.dart';

class MasterUsers extends GetView<MasterController> {
  MasterUsers(this.kode, {super.key});

  final String kode;
  final masterC = Get.put(MasterController());
  TextEditingController namaUser = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<User>>(
        stream: masterC.getUsers(kode),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else {
              var data = snapshot.data!;
              // List<Map<String, dynamic>> list = [];
              // data.map((doc) {
              //   list.add(doc);
              // }).toList();
              // print(list);
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
                      label: Text('Kode User'),
                      // size: ColumnSize.S,
                    ),
                    DataColumn(
                      label: Text('Username'),
                    ),
                    DataColumn(
                      label: Text('Level'),
                    ),
                    DataColumn(
                      label: Text('No Telpon'),
                    ),
                    DataColumn(
                      label: Text('Status'),
                    ),
                    DataColumn(
                      label: Text('Action'),
                    ),
                  ],
                  rows: List<DataRow>.generate(data.length, (index) {
                    masterC.kodeUser.value = data.length + 1;
                    return DataRow(cells: [
                      DataCell(Text(data[index].kodeCabang! != ""
                          ? data[index].kodeCabang!
                          : 'Belum terdaftar dicabang manapun')),
                      DataCell(Text(data[index].kodeUser!)),
                      DataCell(Text(data[index].namaUser!)),
                      DataCell(FutureBuilder<List<Level>>(
                        future: masterC.getFutureLevel(data[index].idLevel!),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            var level = snapshot.data!;
                            return Text(level[0].nama!);
                          } else if (snapshot.hasError) {
                            return Text('${snapshot.error}');
                          }
                          return const Center(
                            child: CupertinoActivityIndicator(),
                          );
                        },
                      )),
                      DataCell(Text(data[index].telp!)),
                      DataCell(Text(data[index].status!)),
                      DataCell(Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              editData(
                                  data[index].kodeUser!,
                                  data[index].namaUser!,
                                  data[index].telp!,
                                  data[index].idLevel!,
                                  data[index].kodeCabang!);
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
                              // print(data[index].id);
                              Get.defaultDialog(
                                  radius: 5,
                                  title: 'Hapus Akun',
                                  content: Column(
                                    children: [
                                      Text(
                                          'Apakah Anda yakin ingin menghapus data ini?\n${data[index].namaUser}'),
                                      const Divider(),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                var userid = {
                                                  "kode_user":
                                                      data[index].kodeUser!
                                                };
                                                masterC.deleteUser(userid);
                                                showDefaultDialog2("Sukses",
                                                    "User berhasil dihapus");
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
            addUser();
          },
          child: const Icon(Icons.add)),
    );
  }

  editData(kodeUser, nama, telp, level, kodeCabang) {
    Get.defaultDialog(
        radius: 5,
        title: 'Edit Data User',
        content: Column(
          children: [
            const Divider(),
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: nama,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              obscureText: true,
              controller: password,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), hintText: '******'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: masterC.notelp,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(), hintText: telp),
            ),
            const SizedBox(
              height: 5,
            ),
            FutureBuilder(
              future: masterC.getFutureLevel(""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Level User', border: OutlineInputBorder()),
                      value: masterC.selectedLevel.value == ""
                          ? null
                          : masterC.selectedLevel.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedLevel.value = data!;
                        // print(homeC.selectedItem);
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.id!,
                            child: Text(
                              doc.nama!,
                            ));
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
            const SizedBox(height: 5),
            FutureBuilder(
              future: masterC.getFutureCabang(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Pilih Cabang',
                          border: OutlineInputBorder()),
                      value: masterC.selectedCabang.value == ""
                          ? null
                          : masterC.selectedCabang.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedCabang.value = data!;
                        // print(homeC.selectedItem);
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.kodeCabang!,
                            child: Text(
                              doc.namaCabang!,
                            ));
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
            const Divider(),
            Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: ElevatedButton(
                      onPressed: () {
                        if (namaUser.text == "") {
                          namaUser.text = nama;
                        } else {
                          namaUser.text = namaUser.text;
                        }
                        if (masterC.notelp.text == "") {
                          masterC.notelp.text = telp;
                        } else {
                          masterC.notelp.text = masterC.notelp.text;
                        }
                        if (masterC.selectedLevel.isEmpty) {
                          masterC.selectedLevel.value = level.toString();
                        } else {
                          masterC.selectedLevel.value =
                              masterC.selectedLevel.value;
                        }

                        if (masterC.selectedCabang.isEmpty) {
                          masterC.selectedCabang.value = kodeCabang;
                        } else {
                          masterC.selectedCabang.value =
                              masterC.selectedCabang.value;
                        }
                        // masterC.updateUser(
                        //     id,
                        //     masterC.namaUser.text,
                        //     masterC.notelp.text,
                        //     masterC.selectedLevel.value,
                        //     masterC.selectedCabang.value);
                        Get.back();
                        namaUser.clear();
                        masterC.notelp.clear();
                        masterC.selectedLevel.value = "";
                        masterC.selectedCabang.value = "";
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

  addUser() {
    Get.defaultDialog(
        radius: 5,
        title: 'Tambah User',
        content: Column(
          children: [
            const Divider(),
            TextField(
              controller: masterC.email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Username')),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: password,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                label: Text('Password'),
              ),
              obscureText: true,
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: namaUser,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('Nama Lengkap')),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: masterC.notelp,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), label: Text('No Telpon')),
            ),
            const SizedBox(
              height: 5,
            ),
            StreamBuilder(
              stream: masterC.getLevel(""),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Level User', border: OutlineInputBorder()),
                      value: masterC.selectedLevel.value == ""
                          ? null
                          : masterC.selectedLevel.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedLevel.value = data!;
                        // print(homeC.selectedItem);
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.id!,
                            child: Text(
                              doc.nama!,
                            ));
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
            const SizedBox(height: 5),
            StreamBuilder(
              stream: masterC.getCabang(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Obx(
                    () => DropdownButtonFormField(
                      decoration: const InputDecoration(
                          hintText: 'Pilih Cabang',
                          border: OutlineInputBorder()),
                      value: masterC.selectedCabang.value == ""
                          ? null
                          : masterC.selectedCabang.value,
                      // isDense: true,
                      onChanged: (String? data) {
                        masterC.selectedCabang.value = data!;
                        // print(homeC.selectedItem);
                      },
                      items: snapshot.data!.map((doc) {
                        return DropdownMenuItem<String>(
                            value: doc.kodeCabang!,
                            child: Text(
                              doc.namaCabang!,
                            ));
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
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (masterC.email.text == "") {
                        showDefaultDialog(
                            "Perhatian", "Username tidak boleh kosong");
                      } else if (password.text == "") {
                        showDefaultDialog(
                            "Perhatian", "Password tidak boleh kosong");
                      } else if (masterC.selectedLevel.value == "") {
                        showDefaultDialog(
                            "Perhatian", "Level tidak boleh kosong");
                      } else if (masterC.selectedCabang.isEmpty) {
                        showDefaultDialog(
                            "Perhatian", "Harap pilih nama cabang");
                      } else {
                        // Get.defaultDialog(
                        //     barrierDismissible: false,
                        //     title: '',
                        //     content: Column(
                        //       children: const [
                        //         Center(
                        //           child: CircularProgressIndicator(),
                        //         ),
                        //         SizedBox(
                        //           height: 8,
                        //         ),
                        //         Text('Loading data...')
                        //       ],
                        //     ));
                        var dataUser = {
                          "kode_cabang": masterC.selectedCabang.value,
                          "kode_user": "00${masterC.kodeUser.value}",
                          "username": namaUser.text,
                          "password": password.text,
                          "level": masterC.selectedLevel.value,
                          "notelp": masterC.notelp.text,
                          // "status":
                        };
                        await masterC.addUser(dataUser);
                        showDefaultDialog2(
                            "Sukse", "User baru berhasil ditambahkan");
                        masterC.selectedCabang.value = "";
                        masterC.selectedLevel.value = "";
                        namaUser.clear();
                        password.clear();
                        masterC.notelp.clear();
                      }
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
