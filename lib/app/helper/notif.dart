import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

showSnackbar(title, content) {
  Get.snackbar(title, content,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.only(left: 500),
      // padding: const EdgeInsets.only(right: 50),
      backgroundColor:
          title == "Sukses" ? Colors.greenAccent[700] : Colors.redAccent[700],
      colorText: Colors.white,
      icon: Icon(
        title == "Sukses" ? Icons.check_circle : Icons.cancel,
        color: Colors.white,
      ),
      leftBarIndicatorColor: Colors.white,
      duration: const Duration(milliseconds: 1500),
      snackStyle: SnackStyle.GROUNDED);
}

// defaultSnackBar(context, status, message) {
//   var snackBar = SnackBar(
//     content: Text(message),
//     backgroundColor: status == "E" ? Colors.redAccent[700] : mainColor,
//     duration: const Duration(milliseconds: 2000),
//   );

// Find the ScaffoldMessenger in the widget tree
// and use it to show a SnackBar.
//   ScaffoldMessenger.of(context).showSnackBar(snackBar);
// }

fToast(status, msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.grey[700],
      textColor: Colors.white,
      webBgColor: status == "S" ? '#00C853' : '#D50000',
      timeInSecForIosWeb: 2,
      webPosition: 'right',
      fontSize: 16.0);
}
