import 'package:carwash/app/model/login_model.dart';
import 'package:carwash/app/modules/home_web/views/widget/payment_dialog.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_sound_id.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../model/services_model.dart';
import '../../../model/trx_model.dart';
import '../../home/controllers/home_controller.dart';
import '../controllers/home_web_controller.dart';

class HomeFinish extends GetView<HomeController> {
  HomeFinish({super.key, required this.userData});

  final homeC = Get.put(HomeWebController());
  final Login userData;

  final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: homeC.getDatatrxSse(userData.kodeCabang!, date, "1,2"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CupertinoActivityIndicator());
          } else {
            var dataTrx = snapshot.data!;
            var finished = <Trx>[];
            dataTrx.map((e) => finished.add(e)).toList();
            return PaginatedDataTable2(
              headingRowColor: WidgetStateProperty.resolveWith(
                (states) => Colors.indigo,
              ),
              showFirstLastButtons: true,
              columnSpacing: 10,
              horizontalMargin: 8,
              minWidth: 800,
              rowsPerPage: 20,
              headingRowHeight: 35,
              fixedLeftColumns: 1,
              renderEmptyRowsInTheEnd: false,
              empty: const Center(child: Text('Belum ada data')),
              columns: const [
                DataColumn(
                  label: Text(
                    'No Transaksi',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DataColumn2(
                  label: Text(
                    'No Kendaraan',
                    style: TextStyle(color: Colors.white),
                  ),
                  fixedWidth: 110,
                ),
                DataColumn2(
                  label: Text(
                    'Kendaraan',
                    style: TextStyle(color: Colors.white),
                  ),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Masuk', style: TextStyle(color: Colors.white)),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Mulai', style: TextStyle(color: Colors.white)),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Selesai', style: TextStyle(color: Colors.white)),
                  size: ColumnSize.S,
                ),
                DataColumn2(
                  label: Text('Service', style: TextStyle(color: Colors.white)),
                  fixedWidth: 130,
                ),
                DataColumn2(
                  label: Text('Petugas', style: TextStyle(color: Colors.white)),
                  fixedWidth: 110,
                ),
                DataColumn2(
                  label: Text('Status', style: TextStyle(color: Colors.white)),
                  size: ColumnSize.S,
                ),
                DataColumn(
                  label: Text('Action', style: TextStyle(color: Colors.white)),
                ),
              ],
              source: DataFinished(
                userData.namaCabang!,
                userData.kodeCabang!,
                userData.username!,
                userData.alamat!,
                userData.telp!,
                userData.kota!,
                dtFinished: finished,
              ),
            );
          }
        } else if (snapshot.hasError) {
          return const Center(child: Text('Belum ada data masuk'));
        }
        return const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CupertinoActivityIndicator(),
              SizedBox(width: 5),
              Text('Sedang memuat ....'),
            ],
          ),
        );
      },
    );
  }
}

class DataFinished extends DataTableSource {
  DataFinished(
    this.cabang,
    this.kode,
    this.user,
    this.alamat,
    this.telp,
    this.kota, {
    required List<Trx> dtFinished,
  }) : _trx = dtFinished,
       assert(dtFinished != null);
  final List<Trx> _trx;
  final String cabang;
  final String kode;
  final String user;
  final String alamat;
  final String telp;
  final String kota;
  final homeC = Get.find<HomeWebController>();



  @override
  DataRow? getRow(int index) {
    assert(index >= 0);

    if (index >= _trx.length) {
      return null;
    }
    final data = _trx[index];
    return DataRow.byIndex(
      index: index,
      cells: <DataCell>[
        DataCell(Text('${data.notrx}')),
        DataCell(Text('${data.nopol}')),
        DataCell(Text('${data.kendaraan}')),
        DataCell(Text('${data.masuk}')),
        DataCell(Text('${data.mulai}')),
        DataCell(Text('${data.selesai}')),
        DataCell(
          FutureBuilder<List<Services>>(
            future: homeC.servicesById(data.services!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var srv = snapshot.data!;
                return Text(
                  srv.map((e) => e.serviceName!).join(', ').toString(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                );
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }
              return const Center(child: CupertinoActivityIndicator());
            },
          ),
        ),
        DataCell(
          Text(
            data.petugas! != ""
                ? data.petugas!.toLowerCase().toString().substring(
                      0,
                      data.petugas!.length > 25 ? 25 : data.petugas!.length,
                    ) +
                    (data.petugas!.length > 25 ? '...' : '')
                : "not set",
            style: const TextStyle(fontSize: 14),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color:
                  data.paid! == "0"
                      ? Colors.redAccent[700]
                      : Colors.greenAccent[700],
            ),
            child: Text(
              data.paid! == "0" ? "UNPAID" : "PAID",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
        DataCell(
          Row(
            children: [
              IconButton(
                onPressed:
                    data.paid! != "1"
                        ? () {
                          paymentDialog(
                            user,
                            data.notrx!,
                            data.tanggal!,
                            data.nopol!,
                            data.kendaraan!,
                            data.masuk!,
                            data.selesai!,
                            data.services!,
                            data.petugas!,
                            kode,
                            cabang,
                            alamat,
                            telp,
                            kota,
                          );
                        }
                        : null,
                icon: Icon(
                  Icons.payments_outlined,
                  size: 30,
                  color: data.paid! != "1" ? Colors.lightBlue : Colors.grey,
                ),
                splashRadius: 20,
              ),
              IconButton(
                onPressed:
                    data.paid! != "1"
                        ? () {
                          playSoundID(int.parse(data.idJenis!), data.nopol!);
                        }
                        : null,
                icon: Icon(
                  data.paid! != "1" ? Icons.speaker : Icons.speaker,
                  size: 30,
                  color: data.paid! != "1" ? Colors.lightBlue : Colors.grey,
                ),
                splashRadius: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _trx.length;

  @override
  int get selectedRowCount => 0;

}
