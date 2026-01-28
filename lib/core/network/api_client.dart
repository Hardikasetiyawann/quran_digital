import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final http.Client client;
  ApiClient(this.client);

  Future<Map<String, dynamic>> get(String url) async {
    final res = await client.get(Uri.parse(url));
    if (res.statusCode == 200) {
      return json.decode(res.body);
    } else {
      throw Exception('Network Error');
    }
  }
}
