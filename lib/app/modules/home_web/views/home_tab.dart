import 'package:carwash/app/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_web_controller.dart';
import 'home_finish.dart';
import 'home_progress.dart';
import 'widget/add_dialog.dart';

class HomeViewTabs extends GetView {
  HomeViewTabs({super.key, required this.userData});

  final Login userData;

  final homeC = Get.put(HomeWebController());
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
                      borderRadius: BorderRadius.circular(15),
                    ),
                    tabs: const [
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.local_car_wash_rounded),
                            SizedBox(width: 3),
                            Text('On Progress'),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                        child: Row(
                          children: [
                            Icon(Icons.no_crash),
                            SizedBox(width: 3),
                            Text('Finish'),
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
                child: TabBarView(
                  children: [
                    HomeProgress(userData.kodeCabang!),
                    HomeFinish(userData: userData),
                  ],
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            homeC.generateNoTrx();
            addDialog(
              context,
              userData.kodeUser,
              userData.kodeCabang,
              userData.idLevel,
            );
          },
          child: const Icon(Icons.add_circle_rounded),
        ),
      ),
    );
  }
}
