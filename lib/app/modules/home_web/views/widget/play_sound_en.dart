import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_nopol_en.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playSoundEN(int jenis, String text) async {
  var jK = "";
  if (jenis == 1) {
    jK = "motorcycle";
  } else {
    jK = "Car";
  }
  var nopol = text.split('');
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("en-GB");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  await homeC.flutterTts.speak("Informed, to the owner of $jK, with a police number");
  await playNopolEN(nopol);
}
