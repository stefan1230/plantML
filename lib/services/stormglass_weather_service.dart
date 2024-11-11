// lib/services/stormglass_weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class StormGlassWeatherService {
  final String apiKey =
      '938e142e-a014-11ef-8770-0242ac130003-938e14d8-a014-11ef-8770-0242ac130003';
  final String apiUrl = 'https://api.stormglass.io/v2/weather/point';

  Future<Map<String, dynamic>> fetchWeather(
      double latitude, double longitude) async {
    final url = Uri.parse(
        '$apiUrl?lat=$latitude&lng=$longitude&params=airTemperature,precipitation');

    final response = await http.get(
      url,
      headers: {
        'Authorization': apiKey,
      },
    );

    if (response.statusCode == 200) {
      // Parse and return the data
      final data = json.decode(response.body);
      return data;
    } else {
      // If the server returns an error, print it
      print('Error: ${response.body}');
      throw Exception('Failed to load weather data');
    }
  }
}
