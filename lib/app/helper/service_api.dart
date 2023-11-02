import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/cabang_model.dart';
import '../model/karyawan_model.dart';
import '../model/kendaraan_model.dart';
import '../model/laporan_model.dart';
import '../model/level_model.dart';
import '../model/login_model.dart';
import '../model/services_model.dart';
import '../model/trx_model.dart';
import '../model/user_model.dart';

class ServiceApi {
  var baseUrl = "https://saputraauto.my.id/api/";

  login(username, password) async {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}user/login.php?username=$username&password=$password'));
      switch (response.statusCode) {
        case 200:
          dynamic users = json.decode(response.body)['rows'];
          Login dtUser = Login.fromJson(users);
          return dtUser;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Trx>> getDatatrxToday(cabang, date, status) async* {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}transaksi/getTrxStatus.php?kode_cabang=$cabang&tanggal=$date&status=$status&id_jenis='));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Trx> data = result.map((e) => Trx.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Cabang>> getDataCabang(kode, level) async* {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}cabang/get_cabang.php?kode=$kode&level=$level'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Cabang> data = result.map((e) => Cabang.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Karyawan>> getDataKaryawan(kode, level) async* {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}master/get_karyawan.php?cabang=$kode&level=$level'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Karyawan> data =
              result.map((e) => Karyawan.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Level>> getLevelById(id) async* {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}master/get_level.php?id=$id'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Level> data = result.map((e) => Level.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Kendaraan>> getDataKendaraan() async* {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}master/get_kendaraan.php'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Kendaraan> data =
              result.map((e) => Kendaraan.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<Services>> getServices() async* {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}master/get_services.php?id='));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Services> data =
              result.map((e) => Services.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getLevelFutureById(id) async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}master/get_level.php?id=$id'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Level> data = result.map((e) => Level.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  Stream<List<User>> getAllUser(kode, level) async* {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}user/get_user_data.php?kode=$kode&level=$level'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<User> data = result.map((e) => User.fromJson(e)).toList();
          yield data;
          break;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getUser(username) async {
    try {
      final response = await http.get(
          Uri.parse('${baseUrl}user/get_user_data.php?username=$username'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<User> data = result.map((e) => User.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getUserFuture(kode) async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl}user/get_user_data.php?kode=$kode'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<User> data = result.map((e) => User.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getKaryawanFuture(kode) async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl}master/get_karyawan.php?cabang=$kode'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Karyawan> data =
              result.map((e) => Karyawan.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  updateDataPembayaran(data) async {
    await http.post(Uri.parse("${baseUrl}transaksi/updateData.php"),
        body: data);
  }

  addCabang(data) async {
    await http.post(Uri.parse("${baseUrl}cabang/addupdate_cabang.php"),
        body: data);
  }

  addKaryawan(data) async {
    await http.post(Uri.parse("${baseUrl}master/addupdate_karyawan.php"),
        body: data);
  }

  addUser(data) async {
    await http.post(Uri.parse("${baseUrl}master/addupdate_user.php"),
        body: data);
  }

  addLevel(data) async {
    await http.post(Uri.parse("${baseUrl}master/addupdate_level.php"),
        body: data);
  }

  addServices(data) async {
    await http.post(Uri.parse("${baseUrl}master/addupdate_services.php"),
        body: data);
  }

  addMerk(data) async {
    await http.post(Uri.parse("${baseUrl}merk/addupdate_merk.php"), body: data);
  }

  deleteCabang(id) async {
    await http.post(Uri.parse("${baseUrl}cabang/delete_cabang.php"), body: id);
  }

  deleteUser(id) async {
    await http.post(Uri.parse("${baseUrl}master/delete_user.php"), body: id);
  }

  deleteKaryawan(id) async {
    await http.post(Uri.parse("${baseUrl}master/delete_karyawan.php"),
        body: id);
  }

  deleteLevel(id) async {
    await http.post(Uri.parse("${baseUrl}master/delete_level.php"), body: id);
  }

  deleteMerk(id) async {
    await http.post(Uri.parse("${baseUrl}merk/delete_merk.php"), body: id);
  }

  deleteServices(id) async {
    await http.post(Uri.parse("${baseUrl}master/delete_services.php"),
        body: id);
  }

  getServicesById(idService) async {
    try {
      final response = await http
          .get(Uri.parse('${baseUrl}master/get_services.php?id=$idService'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Services> data =
              result.map((e) => Services.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getSummaryReport(dateAwal, dateAkhir, idJenis, cabang) async {
    try {
      final response = await http.get(Uri.parse(
          '${baseUrl}laporan/get_laporan.php?date1=$dateAwal&date2=$dateAkhir&id_jenis=$idJenis&cabang=$cabang'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Laporan> data = result.map((e) => Laporan.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }

  getCabang() async {
    try {
      final response =
          await http.get(Uri.parse('${baseUrl}cabang/get_cabang.php'));

      switch (response.statusCode) {
        case 200:
          List<dynamic> result = json.decode(response.body)['rows'];
          List<Cabang> data = result.map((e) => Cabang.fromJson(e)).toList();
          return data;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on SocketException catch (_) {
      rethrow;
    }
  }
}
