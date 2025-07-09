import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playNextEN() async {
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("en-GB");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  await homeC.flutterTts.speak("it's finished");
  await homeC.flutterTts.speak("Please make payment");
  await homeC.flutterTts.speak("Check your belongings again");
  await homeC.flutterTts.speak("Have a safe trip.");
}
