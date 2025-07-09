import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carwash/app/modules/home_web/controllers/home_web_controller.dart';
import 'package:get/get.dart';

final homeC = Get.find<HomeWebController>();
playNextID() async {
  await homeC.flutterTts.awaitSpeakCompletion(true);
  await homeC.flutterTts.setLanguage("id-ID");
  await homeC.flutterTts.setVolume(1.0);
  await homeC.flutterTts.setPitch(1.0);
  await homeC.flutterTts.setSpeechRate(0.9);
  await homeC.flutterTts.speak("sudah selesai");
  await homeC.flutterTts.speak("Silahkan melakukan pembayaran");
  await homeC.flutterTts.speak("Periksa kembali barang bawaan anda");
  await homeC.flutterTts.speak("Semoga selamat sampai tujuan");

  await homeC.assetsAudioPlayer.open(
    Audio("assets/audio/airport.mp3"),
    showNotification: true,
    autoStart: true,
  );
}
