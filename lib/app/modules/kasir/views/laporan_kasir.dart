import 'package:carwash/app/modules/kasir/controllers/kasir_controller.dart';
import 'package:carwash/app/modules/kasir/views/detail_laporan_kasir.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/currency_format.dart';

final trxCtr = Get.put(KasirController());

laporanKasir(kodeCabang, date1, date2, alamat, telp, kota) {
  Get.defaultDialog(
      title: 'Laporan Penjualan Kafe',
      radius: 5,
      content: Scrollbar(
        controller: trxCtr.scrollCtrl,
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: trxCtr.scrollCtrl,
            child: SizedBox(
              height: 500,
              width: 900,
              child: Obx(
                () => PaginatedDataTable(
                  sortColumnIndex: 0,
                  headingRowHeight: 35,
                  sortAscending: true,
                  showFirstLastButtons: true,
                  showEmptyRows: true,
                  actions: [
                    SizedBox(
                        width: 280,
                        child: TextFormField(
                            obscureText: false,
                            decoration: const InputDecoration(
                              labelText: "Enter something to filter",
                              suffixIcon: Icon(Icons.search_rounded),
                            ),
                            onChanged: (value) {
                              trxCtr.filterDataLaporan(value);
                            })),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.indigo,
                      ),
                    ),
                  ],
                  header: Container(),
                  source: RowSource(
                      myData: trxCtr.searchDataLaporan,
                      count: trxCtr.searchDataLaporan.length,
                      alamat: alamat,
                      telp: telp,
                      kota: kota),
                  rowsPerPage: 6,
                  columnSpacing: 0.5,
                  columns: [
                    DataColumn(
                        label: const Text(
                          "Tanggal",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex, trxCtr.sort.value);
                        }),
                    DataColumn(
                        label: const Text(
                          "No Transaksi",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex, trxCtr.sort.value);
                        }),
                    DataColumn(
                        label: const Text(
                          "Cabang",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex, trxCtr.sort.value);
                        }),
                    DataColumn(
                        label: const Text(
                          "Kasir",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex, trxCtr.sort.value);
                        }),
                    DataColumn(
                        label: const Text(
                          "Grand Total",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex, trxCtr.sort.value);
                        }),
                    DataColumn(
                        label: const Text(
                          "Payment",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        onSort: (columnIndex, ascending) {
                          trxCtr.sort.value = !trxCtr.sort.value;

                          trxCtr.onsortColum(columnIndex,  trxCtr.sort.value);
                        }),
                    const DataColumn(
                      label: Text(
                        "Action",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ));
}

class RowSource extends DataTableSource {
  final List<dynamic>? myData;
  final int count;
  final String alamat;
  final String telp;
  final String kota;
  RowSource({
    required this.myData,
    required this.count,
    required this.alamat,
    required this.telp,
    required this.kota,
  });

  @override
  DataRow? getRow(int index) {
    if (index < rowCount) {
      return recentFileDataRow(myData![index], alamat, kota, telp);
    } else {
      return null;
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}

DataRow recentFileDataRow(var data, String alamat, String telp, String kota) {
  return DataRow(
    cells: [
      DataCell(Text(data.tanggal ?? "null")),
      DataCell(Text(data.noTrx)),
      DataCell(Text(data.kodeCabang ?? "null")),
      DataCell(Text(data.petugas ?? "null")),
      DataCell(
          Text(CurrencyFormat.convertToIdr(int.parse(data.grandTotal), 0))),
      DataCell(Text(data.payment)),
      DataCell(TextButton(
        onPressed: () {
          detailLaporan(data.petugas!, data.kodeCabang!, data.noTrx!,
              data.tanggal!, data.services!, alamat, telp, kota);
        },
        child: const Text('Lihat detail'),
      )),
    ],
  );
}
