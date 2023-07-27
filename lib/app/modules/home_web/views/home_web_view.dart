import 'package:carwash/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/modules/home_web/views/home_tab.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/alert.dart';
import '../../laporan/views/laporan_view.dart';
import '../../login/controllers/login_controller.dart';
import '../../master/views/master_view.dart';
import '../controllers/home_web_controller.dart';

class HomeWebView extends GetView<HomeWebController> {
  HomeWebView({super.key, this.kodeCabang, this.username});
  final String? kodeCabang;
  final String? username;

  final homeC = Get.put(HomeWebController());
  final loginC = Get.put(LoginController());
  final lapC = Get.put(LaporanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saputra Car Wash'),
        backgroundColor: Colors.indigo,
      ),
      body: FutureBuilder(
          future: homeC.streamDataUser(username),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SideMenu(
                    controller: homeC.page,
                    style: SideMenuStyle(
                        openSideMenuWidth: 230,
                        displayMode: SideMenuDisplayMode.auto,
                        hoverColor: Colors.indigo[300],
                        selectedColor: Colors.white,
                        unselectedIconColor: Colors.white,
                        selectedTitleTextStyle:
                            TextStyle(color: Colors.grey[700]),
                        unselectedTitleTextStyle:
                            const TextStyle(color: Colors.white),
                        selectedIconColor: Colors.grey[700],
                        backgroundColor: Colors.indigo),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 170,
                            maxWidth: 290,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                username != ""
                                    ? const CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        backgroundImage:
                                            AssetImage('assets/logo.png'),
                                      )
                                    : Container(),
                                const SizedBox(
                                  width: 4,
                                ),
                                username != ""
                                    ? Text(
                                        ' ${username!.capitalizeFirst}\n ${snapshot.data![0].level!.capitalizeFirst}',
                                        style: const TextStyle(
                                            fontSize: 17, color: Colors.white),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        const Divider(
                          indent: 8.0,
                          endIndent: 8.0,
                        ),
                      ],
                    ),
                    footer: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: snapshot.data![0].level != "Owner"
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 12),
                                            child: const Icon(
                                                Icons.maps_home_work_outlined,
                                                color: Colors.white),
                                          )),
                                      Expanded(
                                        flex: 8,
                                        child: SizedBox(
                                          height: 20,
                                          child: Text(
                                            '${snapshot.data![0].namaCabang}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 12),
                                            child: const Icon(Icons.map_sharp,
                                                color: Colors.white),
                                          )),
                                      Expanded(
                                        flex: 8,
                                        child: SizedBox(
                                          height: 20,
                                          child: Text(
                                            '${snapshot.data![0].kota}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 2,
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8, right: 12),
                                            child: const Icon(Icons.call,
                                                color: Colors.white),
                                          )),
                                      Expanded(
                                        flex: 8,
                                        child: SizedBox(
                                          height: 20,
                                          child: Text(
                                            '${snapshot.data![0].telp}',
                                            style: const TextStyle(
                                                fontSize: 17,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: const [
                                    Center(
                                        child: Text(
                                      'OWNER',
                                      style: TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ))
                                  ])),
                    onDisplayModeChanged: (mode) {
                      // print(mode);
                    },
                    items: [
                      SideMenuItem(
                        priority: 0,
                        title: 'Beranda',
                        onTap: () {
                          homeC.page.jumpToPage(0);
                        },
                        icon: const Icon(Icons.home_rounded),
                      ),
                      SideMenuItem(
                        priority: 1,
                        title: 'Data Master',
                        onTap: () {
                          if (snapshot.data![0].level != "3") {
                            homeC.page.jumpToPage(1);
                          } else {
                            Get.defaultDialog(
                                title: 'Info',
                                content: const Text(
                                    'fitur ini hanya untuk administrator'));
                          }
                        },
                        icon: const Icon(Icons.developer_board_rounded),
                      ),
                      SideMenuItem(
                        priority: 2,
                        title: 'Laporan',
                        onTap: () {
                          homeC.page.jumpToPage(2);
                        },
                        icon: const Icon(Icons.assignment),
                      ),
                      SideMenuItem(
                        priority: 3,
                        title: 'Log Out',
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (BuildContext ctx) {
                                return AlertDialog(
                                  title: Row(
                                    children: const [
                                      Icon(Icons.info_outline_rounded),
                                      SizedBox(width: 5),
                                      Text('Info'),
                                    ],
                                  ),
                                  content:
                                      const Text('Anda yakin ingin Logout?'),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        ElevatedButton(
                                            onPressed: () async {
                                              SharedPreferences pref =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await pref.remove("kode");
                                              await pref.setBool(
                                                  "is_login", false);
                                              lapC.selectedCabang.value = "";
                                              loginC.isLogin.value = false;
                                              loginC.isLoading.value = false;
                                              Get.back();
                                              showSnackbar('Sukses',
                                                  'Anda berhasil logout');
                                              // showLogin();
                                            },
                                            child: const Text("Ya")),
                                        ElevatedButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: const Text("Tidak"))
                                      ],
                                    ),
                                  ],
                                );
                              });
                        },
                        icon: const Icon(Icons.logout_outlined),
                      ),
                    ],
                  ),
                  Expanded(
                    child: PageView(
                      controller: homeC.page,
                      children: [
                        HomeViewTabs(
                            snapshot.data![0].namaCabang!,
                            snapshot.data![0].kodeCabang!,
                            username!,
                            snapshot.data![0].alamat!,
                            snapshot.data![0].telp!,
                            snapshot.data![0].kota!),
                        MasterViewTabs(snapshot.data![0].kodeCabang!,
                            snapshot.data![0].idLevel!),
                        LaporanView(
                            snapshot.data![0].kodeCabang! != ""
                                ? snapshot.data![0].kodeCabang!
                                : "",
                            snapshot.data![0].idLevel!),
                      ],
                    ),
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
    );
  }
}
