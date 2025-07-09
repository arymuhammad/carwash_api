import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_nopol_id.dart';
import 'package:carwash/app/modules/home_web/views/widget/play_sound_en.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playSoundID(int jenis, String text) async {
  var jK = "";
  if (jenis == 1) {
    jK = "Motor";
  } else {
    jK = "Mobil";
  }
  var nopol = text.split('');
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("id-ID");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  await AssetsAudioPlayer.newPlayer().open(
    Audio("assets/audio/airport.mp3"),
    forceOpen: true,
    autoStart: true,
  );
  Future.delayed(const Duration(milliseconds: 1800), () async {
    await homeC.flutterTts.speak(
      'Di informasikan, kepada pemilik $jK, dengan nomor polisi',
    );
    await playNopolID(nopol);
    Future.delayed(const Duration(milliseconds: 1800), () async {
      await playSoundEN(jenis, text);
      await homeC.assetsAudioPlayer.open(
        Audio("assets/audio/airport.mp3"),
        showNotification: true,
        autoStart: true,
      );
    });
  });
}
