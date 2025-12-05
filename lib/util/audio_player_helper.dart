import 'package:audioplayers/audioplayers.dart';

class AudioPlayerHelper {
  static final AudioPlayer _audioPlayer = AudioPlayer();

  static Future<void> playAudio(String filePath) async {
    await _audioPlayer.play(AssetSource(filePath));
  }
}
