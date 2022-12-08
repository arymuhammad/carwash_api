import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../helper/alert.dart';

class ServicesController extends GetxController {
  var id = 0;
  TextEditingController nama = TextEditingController();
  TextEditingController harga = TextEditingController();

  @override
  void onClose() {
    super.onClose();
    nama.dispose();
    harga.dispose();
  }
}
