import 'package:carwash/app/model/login_model.dart';
import 'package:carwash/app/modules/home_web/views/widget/add_dialog.dart';
import 'package:carwash/app/modules/laporan/controllers/laporan_controller.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:carwash/app/modules/home_web/views/home_tab.dart';
import 'package:get/get.dart';

import '../../../helper/alert.dart';
import '../../kasir/views/kasir_view.dart';
import '../../laporan/views/laporan_view.dart';
import '../../login/controllers/login_controller.dart';
import '../../master/views/master_view.dart';
import '../controllers/home_web_controller.dart';

class HomeWebView extends GetView<HomeWebController> {
  HomeWebView({super.key, this.userData});
  final Login? userData;

  final loginC = Get.put(LoginController());
  final lapC = Get.put(LaporanController());

  @override
  Widget build(BuildContext context) {
    List<SideMenuItemType> items = [
      SideMenuItem(
        title: 'Dashboard',
        onTap: (index, _) {
          homeC.sideMenu.changePage(index);
        },
        icon: const Icon(Icons.home_work_rounded),
      ),

      SideMenuItem(
        title: 'Cafe',
        onTap: (index, _) {
          if (userData!.idLevel == '3') {
            Get.defaultDialog(
              title: 'Info',
              content: const Text('fitur ini hanya untuk administrator'),
            );
          } else {
            homeC.sideMenu.changePage(index);
          }
        },
        icon: const Icon(Icons.fastfood_rounded),
      ),
      SideMenuItem(
        title: 'Data Master',
        onTap: (index, _) {
          if (userData!.level != "3") {
            homeC.sideMenu.changePage(2);
          } else {
            Get.defaultDialog(
              title: 'Info',
              content: const Text('fitur ini hanya untuk administrator'),
            );
          }
        },
        icon: const Icon(Icons.developer_board_rounded),
      ),
      SideMenuItem(
        title: 'Laporan',
        onTap: (index, _) {
          if (userData!.idLevel == '3') {
            Get.defaultDialog(
              title: 'Info',
              content: const Text('fitur ini hanya untuk administrator'),
            );
          } else {
            homeC.sideMenu.changePage(index);
          }
        },
        icon: const Icon(Icons.assignment),
      ),

      SideMenuItem(
        title: 'Logout',
        onTap: (index, _) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext ctx) {
              return AlertDialog(
                title: const Row(
                  children: [
                    Icon(Icons.info_outline_rounded),
                    SizedBox(width: 5),
                    Text('Info'),
                  ],
                ),
                content: const Text('Anda yakin ingin Logout?'),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          loginC.logout();
                          // SharedPreferences pref =
                          //     await SharedPreferences.getInstance();
                          // await pref.remove("kode");
                          // await pref.setBool("is_login", false);
                          // // lapC.selectedCabang.value = "";
                          // // loginC.isLogin.value = false;
                          // // loginC.isLoading.value = false;
                          Get.back();
                          showSnackbar('Sukses', 'Anda berhasil logout');
                          // showLogin();
                        },
                        child: const Text("Ya"),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Tidak"),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        icon: const Icon(Icons.logout_rounded),
      ),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isWideScreen = constraints.maxWidth >= 800;
        final sideMenuKey = ValueKey(isWideScreen);
        return Scaffold(
          // appBar: AppBar(
          //   title: const Text('Saputra Car Wash'),
          //   backgroundColor: Colors.indigo,
          // ),
          body: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SideMenu(
                key: sideMenuKey,
                controller: homeC.sideMenu,
                style: SideMenuStyle(
                  openSideMenuWidth: 230,
                  displayMode: SideMenuDisplayMode.auto,
                  hoverColor: Colors.indigo[300],
                  selectedColor: Colors.white,
                  unselectedIconColor: Colors.white,
                  selectedTitleTextStyle: TextStyle(color: Colors.grey[700]),
                  unselectedTitleTextStyle: const TextStyle(
                    color: Colors.white,
                  ),
                  selectedIconColor: Colors.grey[700],
                  backgroundColor: Colors.indigo,
                ),
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
                            userData!.username != ""
                                ? const SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: AssetImage(
                                      'assets/new_logo.jpg',
                                    ),
                                  ),
                                )
                                : Container(),
                            const SizedBox(width: 4),
                            userData!.username != ""
                                ? Text(
                                  ' ${userData!.username!.capitalizeFirst}\n ${userData!.level!.capitalizeFirst}',
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.white,
                                  ),
                                )
                                : Container(),
                          ],
                        ),
                      ),
                    ),
                    const Divider(indent: 8.0, endIndent: 8.0),
                  ],
                ),
                footer: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                      userData!.level != "Owner"
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
                                        left: 8,
                                        right: 12,
                                      ),
                                      child: const Icon(
                                        Icons.maps_home_work_outlined,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: SizedBox(
                                      height: 20,
                                      child: Text(
                                        '${userData!.namaCabang}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
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
                                        left: 8,
                                        right: 12,
                                      ),
                                      child: const Icon(
                                        Icons.map_sharp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: SizedBox(
                                      height: 20,
                                      child: Text(
                                        '${userData!.kota}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
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
                                        left: 8,
                                        right: 12,
                                      ),
                                      child: const Icon(
                                        Icons.call,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 8,
                                    child: SizedBox(
                                      height: 20,
                                      child: Text(
                                        '${userData!.telp}',
                                        style: const TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                          : const Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Center(
                                child: Text(
                                  'OWNER',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                ),
                onDisplayModeChanged: (mode) {
                  // print(mode);
                },
                items: items,
              ),
              Expanded(
                child: PageView(
                  controller: homeC.pageController,
                  children: [
                    HomeViewTabs(userData: userData!),
                    KasirView(
                      namaCabang: userData!.namaCabang!,
                      kodeCabang: userData!.kodeCabang!,
                      username: userData!.username!,
                      userId: userData!.kodeUser!,
                      alamat: userData!.alamat!,
                      telp: userData!.telp!,
                      kota: userData!.kota!,
                    ),
                    MasterViewTabs(userData!.kodeCabang!, userData!.idLevel!),
                    LaporanView(
                      userData!.kodeCabang! != "" ? userData!.kodeCabang! : "",
                      userData!.idLevel!,
                      userData!.namaCabang!,
                      userData!.alamat!,
                      userData!.telp!,
                      userData!.kota!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
