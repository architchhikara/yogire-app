import 'dart:convert';
import 'package:http/http.dart' as http;

class SunTimeService {
  final String baseUrl = "https://api.sunrise-sunset.org/json";

  Future<Map<String, DateTime>?> getSunTimes(double lat, double lng) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?lat=$lat&lng=$lng&formatted=0'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'OK') {
          final results = data['results'];
          return {
            'sunrise': DateTime.parse(results['sunrise']).toLocal(),
            'sunset': DateTime.parse(results['sunset']).toLocal(),
            'solar_noon': DateTime.parse(results['solar_noon']).toLocal(),
          };
        }
      }
    } catch (e) {
      print("Error fetching sun times: $e");
    }
    return null;
  }
}
