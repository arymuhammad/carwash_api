import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_next_id.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playNopolID(List<String> nopol) async {
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("id-ID");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  if (nopol.length > 10) {
    // print(nopol.length);
    await homeC.flutterTts.speak(nopol[0].toString());
    await homeC.flutterTts.speak(nopol[1].toString());
    await homeC.flutterTts.speak(nopol[3].toString());
    await homeC.flutterTts.speak(nopol[4].toString());
    await homeC.flutterTts.speak(nopol[5].toString());
    await homeC.flutterTts.speak(nopol[6].toString());
    await homeC.flutterTts.speak(nopol[8].toString());
    await homeC.flutterTts.speak(nopol[9].toString());
    await homeC.flutterTts.speak(nopol[10].toString());
    await playNextID();
  } else if (nopol.length == 10) {
    int underscoreIndex = nopol.indexOf('-');
    // print(nopol.length);
    // print(underscoreIndex);
    // print(nopol.join('').toString()[underscoreIndex]);
    if (underscoreIndex == 2) {
      await homeC.flutterTts.speak(nopol[0].toString());
      await homeC.flutterTts.speak(nopol[1].toString());
      await homeC.flutterTts.speak(nopol[3].toString());
      await homeC.flutterTts.speak(nopol[4].toString());
      await homeC.flutterTts.speak(nopol[5].toString());
      await homeC.flutterTts.speak(nopol[6].toString());
      await homeC.flutterTts.speak(nopol[8].toString());
      await homeC.flutterTts.speak(nopol[9].toString());
      await playNextID();
    } else {
      await homeC.flutterTts.speak(nopol[0].toString());
      await homeC.flutterTts.speak(nopol[2].toString());
      await homeC.flutterTts.speak(nopol[3].toString());
      await homeC.flutterTts.speak(nopol[4].toString());
      await homeC.flutterTts.speak(nopol[5].toString());
      await homeC.flutterTts.speak(nopol[7].toString());
      await homeC.flutterTts.speak(nopol[8].toString());
      await homeC.flutterTts.speak(nopol[9].toString());
      await playNextID();
    }
  } else if (nopol.length == 9) {
    // print(nopol.length);
    await homeC.flutterTts.speak(nopol[0].toString());
    await homeC.flutterTts.speak(nopol[2].toString());
    await homeC.flutterTts.speak(nopol[3].toString());
    await homeC.flutterTts.speak(nopol[4].toString());
    await homeC.flutterTts.speak(nopol[5].toString());
    await homeC.flutterTts.speak(nopol[7].toString());
    await homeC.flutterTts.speak(nopol[8].toString());
    // await homeC.flutterTts.speak(nopol[9].toString());
    await playNextID();
  } else if (nopol.length == 8) {
    // print(nopol.length);
    await homeC.flutterTts.speak(nopol[0].toString());
    await homeC.flutterTts.speak(nopol[2].toString());
    await homeC.flutterTts.speak(nopol[3].toString());
    await homeC.flutterTts.speak(nopol[4].toString());
    await homeC.flutterTts.speak(nopol[5].toString());
    await homeC.flutterTts.speak(nopol[7].toString());
    await homeC.flutterTts.speak(nopol[8].toString());
    await playNextID();
  } else {
    await playNextID();
  }
}
