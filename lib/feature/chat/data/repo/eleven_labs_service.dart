import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ElevenLabsService {
  final String apiKey;
  final String voiceId;

  ElevenLabsService({required this.apiKey, required this.voiceId});
  Future<Uint8List?> textToSpeech(String text) async {
    final url = Uri.parse("https://api.elevenlabs.io/v1/text-to-speech/UR972wNGq3zluze0LoIp/stream");
    final headers = {
      "xi-api-key": "sk_1e09b48baa11951d0ed05db83bf90d9a66eda024b170438b",
      "Content-Type": "application/json",
    };
    final payload = {
      "text": text,
      "model_id": "eleven_turbo_v2_5",
      "voice_settings": {
        "stability": 0.5,
        "similarity_boost": 0.7,
      },
    };


    try {
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(payload),
      );

      if (response.statusCode == 200) {
        return response.bodyBytes; // Returns the binary audio data.
      } else {
        print("Error: ${response.statusCode} - ${response.reasonPhrase}");
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error during Eleven Labs TTS request: $e");
      return null;
    }
  }
}
