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
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                SizedBox(
                  width: 300,
                  height: 60,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TabBar(
                      isScrollable: true,
                      labelPadding: const EdgeInsets.only(left: 10, right: 10),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.grey,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                          color: Colors.indigo,
                          borderRadius: BorderRadius.circular(15)),
                      tabs: [
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.home_work_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Cabang')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.supervised_user_circle_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Users')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.people_alt_outlined),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Karyawan')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.leaderboard_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Level')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.local_taxi_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Kendaraan')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.miscellaneous_services_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Master Services')
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                SizedBox(
                  width: 300,
                  height: 500,
                  child: TabBarView(children: [
                    MasterCabang(kode, level),
                    MasterUsers(kode, level),
                    MasterKaryawan(kode, level),
                    MasterLevel(),
                    MasterKendaraan(),
                    ServicesView(),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
