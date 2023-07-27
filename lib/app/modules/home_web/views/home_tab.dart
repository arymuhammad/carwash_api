import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_finish.dart';
import 'home_progress.dart';

class HomeViewTabs extends GetView {
  const HomeViewTabs(this.namaCabang, this.kodeCabang, this.username,
      this.alamatCabang,this.telp, this.kotaCabang,
      {super.key});

  final String namaCabang;
  final String kodeCabang;
  final String username;
  final String alamatCabang;
  final String telp;
  final String kotaCabang;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
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
                              Icon(Icons.local_car_wash_rounded),
                              SizedBox(
                                width: 3,
                              ),
                              Text('On Progress')
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 40,
                          child: Row(
                            children: const [
                              Icon(Icons.no_crash),
                              SizedBox(
                                width: 3,
                              ),
                              Text('Finish')
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
                    HomeProgress(kodeCabang),
                    HomeFinish(namaCabang, kodeCabang, username, alamatCabang, telp,
                        kotaCabang),
                  ]),
                ),
              ],
            ),
          ),
        ));
  }
}
