import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_next_en.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playNopolEN(List<String> nopol) async {
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("en-GB");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  //  print(await flutterTts.getVoices);
  await homeC.flutterTts.speak(nopol.toString());
  await playNextEN();
}
