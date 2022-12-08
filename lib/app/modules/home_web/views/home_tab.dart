import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_finish.dart';
import 'home_progress.dart';

class HomeViewTabs extends GetView {
  const HomeViewTabs(this.namaCabang, this.kodeCabang, this.username,
      this.alamatCabang, this.kotaCabang,
      {super.key});

  final String namaCabang;
  final String kodeCabang;
  final String username;
  final String alamatCabang;
  final String kotaCabang;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            bottom: const TabBar(
              indicatorWeight: 7,
              tabs: [
                Tab(
                  icon: Icon(Icons.local_car_wash_rounded),
                  text: 'On Progress',
                ),
                Tab(
                  icon: Icon(Icons.no_crash),
                  text: 'Finish',
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            HomeProgress(kodeCabang),
            HomeFinish(
                namaCabang, kodeCabang, username, alamatCabang, kotaCabang),
          ]),
        ));
  }
}
