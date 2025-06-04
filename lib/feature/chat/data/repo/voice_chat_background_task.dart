
import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_sound/flutter_sound.dart' as fs;
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class VoiceChatBackgroundTask extends BackgroundAudioTask {
final recorder = fs.FlutterSoundRecorder();
final player = AudioPlayer();
final _audioBuffer = BytesBuilder();
final _audioStreamController = StreamController<Uint8List>();

WebSocketChannel? channel;
StreamSubscription? socketSubscription;
Timer? flushTimer;
bool isSessionConfirmed = false;
bool pauseSending = false;

@override
Future<void> onStart(Map<String, dynamic>? params) async {
final wsUrl = params?['wsUrl'] as String;
await Permission.microphone.request();
await recorder.openRecorder();


channel = WebSocketChannel.connect(Uri.parse(wsUrl));
socketSubscription = channel!.stream.listen((event) async {
  if (event is Uint8List) {
    pauseSending = true;
    await recorder.pauseRecorder();
    await _playAudio(event);
    await recorder.resumeRecorder();
    pauseSending = false;
  } else if (event is String && event.length == 36) {
    isSessionConfirmed = true;
  }
});

_audioStreamController.stream.listen((buffer) {
  final energy = _calculateRMS(buffer);
  if (energy > 800) {
    _audioBuffer.add(buffer);
  }
});

flushTimer = Timer.periodic(Duration(seconds: 2), (_) {
  if (!pauseSending &&
      _audioBuffer.length >= 4000 &&
      isSessionConfirmed &&
      channel != null) {
    channel!.sink.add(_audioBuffer.toBytes());
    _audioBuffer.clear();
  }
});

await recorder.startRecorder(
  codec: fs.Codec.pcm16WAV,
  sampleRate: 16000,
  numChannels: 1,
  bitRate: 16000 * 2,
  toStream: _audioStreamController.sink,
);

AudioServiceBackground.setState(
  controls: [MediaControl.stop],
  processingState: AudioProcessingState.ready,
  playing: true,
);
}
@pragma('vm:entry-point')
void backgroundEntryPoint() {
// ignore: deprecated_member_use
AudioServiceBackground.run(() => VoiceChatBackgroundTask());
}

Future<void> _playAudio(Uint8List bytes) async {
final base64Data = base64Encode(bytes);
final uri = Uri.parse('data:audio/wav;base64,$base64Data');
try {
await player.setAudioSource(AudioSource.uri(uri));
await player.play();
} catch (e) {
print('❌ Failed to play audio: $e');
}
}

double _calculateRMS(Uint8List data) {
final buffer = Int16List.view(data.buffer);
double sumSquares = 0;
for (var sample in buffer) {
sumSquares += sample * sample;
}
return sqrt(sumSquares / buffer.length);
}

@override
Future<void> onStop() async {
await recorder.stopRecorder();
await recorder.closeRecorder();
await player.dispose();
await channel?.sink.close();
await socketSubscription?.cancel();
await _audioStreamController.close();
flushTimer?.cancel();
await super.onStop();
}
}

