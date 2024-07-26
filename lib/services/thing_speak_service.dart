import 'dart:convert';
import 'package:http/http.dart' as http;

class ThingSpeakService {
  Future<Map<String, dynamic>> fetchLatestData(String channelId, String apiKey) async {
    final url = Uri.parse(
        'https://api.thingspeak.com/channels/$channelId/feeds.json?api_key=$apiKey&results=2');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final feeds = data['feeds'];

      // Check if there are enough data points
      if (feeds.length < 2) {
        throw Exception('Not enough data points to determine speed and direction');
      }

      final double currentSpeed = double.parse(feeds[0]['field3']);
      final double previousSpeed = double.parse(feeds[1]['field3']);
      final double currentLatitude = double.parse(feeds[0]['field1']);
      final double currentLongitude = double.parse(feeds[0]['field2']);
      final double previousLatitude = double.parse(feeds[1]['field1']);
      final double previousLongitude = double.parse(feeds[1]['field2']);

      // Check if the bus is stopped
      final isStopped = currentSpeed < 8 && previousSpeed < 8;

      return {
        'currentLatitude': currentLatitude,
        'currentLongitude': currentLongitude,
        'currentSpeed': currentSpeed,
        'previousLatitude': previousLatitude,
        'previousLongitude': previousLongitude,
        'isStopped': isStopped,
      };
    } else {
      throw Exception('Failed to fetch data from ThingSpeak');
    }
  }
}
