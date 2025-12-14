import 'dart:convert';
import 'package:http/http.dart' as http;

class AiService {
  static const String _geminiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  /// استبدل YOUR_GEMINI_KEY بمفتاحك
  static const String _apiKey = 'YOUR_GEMINI_KEY';

  static Future<String> generateDailyMessage(
      String mood, String goalTitle) async {
    try {
      final response = await http.post(
        Uri.parse('$_geminiUrl?key=$_apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "أرسل جملة تحفيزية قصيرة (أقل من 20 كلمة) باللغة العربية للمستخدم الذي يشعر بـ '$mood' وهدفه هو '$goalTitle'."
                }
              ]
            }
          ]
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text']
            .toString()
            .trim();
      } else {
        return "استمر، أنت قادر على تحقيق هدفك! 💪";
      }
    } catch (_) {
      return "استمر، أنت قادر على تحقيق هدفك! 💪";
    }
  }
}
