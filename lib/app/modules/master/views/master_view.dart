import 'package:flutter/material.dart';
import 'package:carwash/app/modules/master/views/master_kendaraan.dart';
import 'package:carwash/app/modules/services/views/services_view.dart';
// import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import 'master_cabang.dart';
import 'master_karyawan.dart';
import 'master_level.dart';
import 'master_user.dart';

class MasterViewTabs extends GetView {
  MasterViewTabs(this.kode, this.level, {super.key});

  final String kode;
  final String level;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 6,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            bottom: TabBar(
              indicatorWeight: 7,
              tabs: const [
                Tab(
                  icon: Icon(Icons.business_outlined),
                  text: 'Master Cabang',
                ),
                Tab(
                  icon: Icon(Icons.people_alt_outlined),
                  text: 'Master Users',
                ),
                Tab(
                  icon: Icon(Icons.people_alt_outlined),
                  text: 'Master Karyawan',
                ),
                Tab(
                  icon: Icon(Icons.card_membership_outlined),
                  text: 'Master Level',
                ),
                Tab(
                  icon: Icon(Icons.car_rental),
                  text: 'Master Kendaraan',
                ),
                Tab(
                  icon: Icon(Icons.miscellaneous_services_rounded),
                  text: 'Master Services',
                ),
              ],
              isScrollable: Get.mediaQuery.size.width <= 1100 ? true : false,
            ),
          ),
          body: TabBarView(children: [
            MasterCabang(kode, level),
            MasterUsers(kode, level),
            MasterKaryawan(kode, level),
            MasterLevel(),
            MasterKendaraan(),
            ServicesView(),
          ]),
        ));
  }
}
