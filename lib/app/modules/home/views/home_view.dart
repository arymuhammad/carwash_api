import 'package:carwash/app/model/login_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/trx_model.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key, this.userData});

  final Login? userData;
  final TextEditingController input = TextEditingController();
  final homeC = Get.put(HomeController());
  final flutterTts = FlutterTts();
  final date = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 13, 22, 107),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      'MOBIL',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white, height: 8),
                  Expanded(
                    child: StreamBuilder<List<Trx>>(
                      stream: homeC.getDatatrxSse(userData!.kodeCabang!, date, "3", 2),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    decoration: BoxDecoration(
                                      color:
                                          data[index].status! == "1"
                                              ? Colors.amberAccent[700]
                                              : Colors.transparent,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        data[index].nopol!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        data[index].kendaraan!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      trailing: Text(
                                        data[index].status! == "0"
                                            ? 'Menunggu'
                                            : 'Proses',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      dense: true,
                                      minVerticalPadding: 0.9,
                                    ),
                                  ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 2),
          Expanded(
            flex: 7,
            child: Container(
              width: Get.mediaQuery.size.width,
              decoration: const BoxDecoration(color: Colors.black),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: Get.mediaQuery.size.height / 1,
                    child: StreamBuilder<List<Trx>>(
                      stream: homeC.getDatatrxSse(userData!.kodeCabang!, date, 1, ""),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var status = snapshot.data!;
                          if (status.isEmpty) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Container(
                                    foregroundDecoration: const BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                          'assets/new_menu.jpeg',
                                        ),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  width: Get.mediaQuery.size.width / 1.6,
                                  height: Get.mediaQuery.size.height / 2,
                                  decoration: const BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  child: Text(
                                    status[0].nopol!,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 80,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  height: Get.mediaQuery.size.height / 2,
                                  alignment: Alignment.center,
                                  child: Text(
                                    status[0].kendaraan!,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 80,
                                    ),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 13, 22, 107),
              ),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      'MOTOR',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.white, height: 8),
                  Expanded(
                    child: StreamBuilder<List<Trx>>(
                      stream: homeC.getDatatrxSse(userData!.kodeCabang!, date, "3", 1),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.connectionState ==
                              ConnectionState.active) {
                            var data = snapshot.data!;
                            return ListView.builder(
                              itemCount: data.length,
                              itemBuilder:
                                  (context, index) => Container(
                                    decoration: BoxDecoration(
                                      color:
                                          data[index].status! == "1"
                                              ? Colors.amberAccent[700]
                                              : Colors.transparent,
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        data[index].nopol!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      subtitle: Text(
                                        data[index].kendaraan!,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      trailing: Text(
                                        data[index].status! == "0"
                                            ? 'Menunggu'
                                            : 'Proses',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                        ),
                                      ),
                                      dense: true,
                                      minVerticalPadding: 0.9,
                                    ),
                                  ),
                            );
                          } else {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            );
                          }
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return const Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
