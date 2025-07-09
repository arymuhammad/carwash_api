import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math';
import 'dart:html' as html;
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carwash/app/model/cabang_model.dart';
import 'package:carwash/app/model/karyawan_model.dart';
import 'package:carwash/app/model/merk_model.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helper/base_client.dart';
import '../../../helper/service_api.dart';
import '../../../model/services_model.dart';
import '../../../model/trx_model.dart';
import '../../../model/user_model.dart';

class HomeWebController extends GetxController {
  var namaCabang = "";
  var alamatCabang = "";
  var kotaCabang = "";
  var total = 0;
  var serviceItem = [].obs;
  final bool running = true;
  var userData = <User>[].obs;
  List<String> metodpay = ["", "Cash", "BCA", "BRI", "BNI", "OVO", "DANA"];
  var paySelected = "".obs;
  var totalHarga = 0.obs;
  var totalSetelahDisc = 0.obs;
  var byr = 0;
  var cpi = 0;
  var kembali = 0.obs;
  late TextEditingController diskon = TextEditingController();
  late TextEditingController bayar = TextEditingController();
  String? idService;
  var listService = [].obs;
  var selectedService = [].obs;
  // PageController page = PageController();
  // SideMenuController sideMenu = SideMenuController();
  var currentPageIndex = 0.obs;
  // var expandedMaster = false.obs;
  late PageController pageController;
  late SideMenuController sideMenu;
  var idTrx = "";
  var dateNow = DateFormat('ddMMyy').format(DateTime.now());
  var date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  var dataCabang = <Cabang>[].obs;
  var selectedItem = "".obs;
  var selectedMerk = "".obs;
  var jenisKendaran = [
    {"id": 1, "jenis": "Motor"},
    {"id": 2, "jenis": "Mobil"},
  ];
  var dataMerk = <Merk>[].obs;

  TextEditingController mk = TextEditingController();
  late TextEditingController noPol1 = TextEditingController();
  late TextEditingController noPol2 = TextEditingController();
  late TextEditingController noPol3 = TextEditingController();
  final FocusNode focusNode = FocusNode();
  final GlobalKey autocompleteKey = GlobalKey();
  var dataNoPol = [].obs;
  var listKaryawan = <Karyawan>[].obs;
  var selectedPetugas = [].obs;
  var tempStruk = {}.obs;
  var listnopol = [];
  var noPolisi = [];
  final FlutterTts flutterTts = FlutterTts();
  final assetsAudioPlayer = AssetsAudioPlayer();


  @override
  void onInit() {
    // sideMenu.addListener((index) {
    //   page.jumpToPage(index);
    // });
    super.onInit();
    servicesById(idService);
    pageController = PageController();
    sideMenu = SideMenuController();
    // Listener sideMenu untuk sinkronisasi ke pageController
    sideMenu.addListener((int index) {
      final pageIndex =
          pageController.hasClients ? pageController.page?.round() ?? 0 : 0;
      if (index != pageIndex) {
        pageController.jumpToPage(index);
      }
    });

    // Listener pageController untuk sinkronisasi ke sideMenu
    pageController.addListener(() {
      if (!pageController.hasClients) return;

      final pageIndex = pageController.page?.round() ?? 0;
      if (sideMenu.currentPage != pageIndex) {
        sideMenu.changePage(pageIndex);
      }
    });
  }

  @override
  void onClose() {
    pageController.dispose();
    sideMenu.dispose();
    super.dispose();
  }

  Stream<List<Trx>> getDatatrx(cabang, date, status) async* {
    while (running) {
      await Future.delayed(const Duration(seconds: 5));
      // var response = await BaseClient().get("https://saputracarwash.online/api",
      //     "/transaksi/getTrxStatus.php?kode_cabang=$cabang&tanggal=$date&status=$status&id_jenis=");
      // List<dynamic> trx = json.decode(response)['rows'];
      // List<Trx> dtTrx = trx.map((e) => Trx.fromJson(e)).toList();
      // yield dtTrx;
      Stream<List<Trx>> dtTrx = ServiceApi().getDatatrxToday(
        cabang,
        date,
        status,
      );
      yield* dtTrx;
    }
  }

  Stream<List<Trx>> getDatatrxSse(String cabang, String date, String status) {
    final url = Uri.parse(
      '${ServiceApi().baseUrl}transaksi/getTrxStatus_sse.php?kode_cabang=$cabang&tanggal=$date&status=$status&id_jenis=',
    );

    final controller = StreamController<List<Trx>>();
    final eventSource = html.EventSource(url.toString());

    eventSource.onMessage.listen((event) {
      try {
        final jsonData = jsonDecode(event.data);
        if (jsonData['success'] == 1) {
          List<dynamic> rows = jsonData['rows'];
          List<Trx> trxList = rows.map((e) => Trx.fromJson(e)).toList();
          controller.add(trxList);
        } else {
          controller.add([]);
        }
      } catch (e) {
        controller.addError(e);
      }
    });

    eventSource.onError.listen((error) {
      controller.addError('SSE error: $error');
      // eventSource.close();
    });

    controller.onCancel = () {
      eventSource.close();
    };

    return controller.stream;
  }

  Future<List<User>> streamDataUser(username) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    // var response = await BaseClient().get("https://saputracarwash.online/api",
    //     "/user/get_user_data.php?username=$username");
    // List<dynamic> user = json.decode(response)['rows'];
    // List<User> dtUser = user.map((e) => User.fromJson(e)).toList();
    final response = await ServiceApi().getUser(username);
    userData.value = response;
    await pref.setString("kode_cabang", response[0].kodeCabang!);
    await pref.setString("nama_cabang", response[0].namaCabang!);
    await pref.setString("level", response[0].level!);
    await pref.setString("username", response[0].namaUser!);
    return response;
  }

  void pembayaran(String bayar) async {
    var result = 0;
    if (totalSetelahDisc.value != 0) {
      result = int.parse(bayar) - totalSetelahDisc.value;
    } else {
      result = int.parse(bayar) - totalHarga.value;
    }
    kembali.value = result;
  }

  discount() {
    var disct = totalHarga.value * int.parse(diskon.text) / 100;
    totalSetelahDisc.value = totalHarga.value - disct as int;
  }

  updateDataTrx(data) async {
    // var response = await http.post(
    //     Uri.parse("https://saputracarwash.online/api/transaksi/updateData.php"),
    //     body: data);
    await ServiceApi().updateDataPembayaran(data);
  }

  Future<List<Services>> servicesById(String? idService) async {
    // var response = await BaseClient().get("https://saputracarwash.online/api",
    //     "/master/get_services.php?id=$idService");
    // List<dynamic> srv = json.decode(response)['rows'];
    // List<Services> dtSrv = srv.map((e) => Services.fromJson(e)).toList();
    final response = await ServiceApi().getServicesById(idService);
    return response;
  }

  generateNoTrx() async {
    var generateNum = Random().nextInt(1000000000);
    return idTrx = '$generateNum';
  }

  Stream<String> getDate() async* {
    while (running) {
      await Future<void>.delayed(const Duration(seconds: 1));
      DateTime now = DateTime.now();
      yield "${DateFormat('dd/MM/yyyy').format(now)} ${now.hour} : ${now.minute} : ${now.second}";
    }
  }

  Future<List<Cabang>> getCabang(kode, level) async {
    final response = await http.get(
      Uri.parse(
        '${ServiceApi().baseUrl}/cabang/get_cabang.php?kode=$kode&level=$level',
      ),
    );
    List<dynamic> cabang = json.decode(response.body)['rows'];
    List<Cabang> dtCabang = cabang.map((e) => Cabang.fromJson(e)).toList();
    dataCabang.value = dtCabang;
    return dtCabang;
  }

  Future<List<Merk>> getMerkById(jenis) async {
    var response = await http.get(
      Uri.parse('${ServiceApi().baseUrl}/merk/get_merk.php?id_jenis=$jenis'),
    );
    List<dynamic> merk = json.decode(response.body)['rows'];
    List<Merk> dtMerk = merk.map((e) => Merk.fromJson(e)).toList();
    dataMerk.value = dtMerk;
    return dtMerk;
  }

  Future<List<Karyawan>> getKaryawan(kode) async {
    var response = await http.get(
      Uri.parse('${ServiceApi().baseUrl}/master/get_karyawan.php?cabang=$kode'),
    );
    List<dynamic> dtKaryawan = json.decode(response.body)['rows'];
    List<Karyawan> karyawan =
        dtKaryawan.map((e) => Karyawan.fromJson(e)).toList();
    // print(dtKaryawan);
    listKaryawan.value = karyawan;
    return listKaryawan;
  }

  submitData(data) async {
    await http.post(
      Uri.parse('${ServiceApi().baseUrl}transaksi/input_trx.php'),
      body: data,
    );
  }
}
