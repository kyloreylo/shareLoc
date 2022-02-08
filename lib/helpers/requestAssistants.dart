//main imports
import 'dart:convert';
//pubsecyaml imports
import 'package:http/http.dart' as http;

class RequestAssistant {
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      String jsonData = response.body;

      var decodeData = jsonDecode(jsonData);
      return decodeData;
    }
  }
}
