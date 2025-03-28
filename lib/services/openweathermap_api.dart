import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather.dart';

import '../models/location.dart';

class OpenWeatherMapApi {
  OpenWeatherMapApi({
    required this.apiKey,
    this.units = 'metric',
    this.lang = 'fr',
  });

  static const String baseUrl = 'https://api.openweathermap.org';

  final String apiKey;
  final String units;
  final String lang;

  String getIconUrl(String icon) {
    return 'https://openweathermap.org/img/wn/$icon@4x.png';
  }

  Future<Iterable<Location>> searchLocations(
    String query, {
    int limit = 5,
  }) async {
    final response = await http.get(
      Uri.parse('$baseUrl/geo/1.0/direct?appid=$apiKey&q=$query&limit=$limit'),
    );

    if (response.statusCode == HttpStatus.ok) {
      try {
        // Décoder la réponse JSON
        var responseData = jsonDecode(response.body) as List;
        print(responseData);
        return responseData.map((e) => Location.fromJson(e));
      } catch (e) {
        // Si le décodage échoue, on lance une exception
        throw Exception('Erreur lors du décodage des données: $e');
      }
    }

    throw Exception(
      'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})',
    );
  }

  Future<Weather> getWeather(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/data/2.5/weather?appid=$apiKey&lat=$lat&lon=$lon&units=$units&lang=$lang',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      try {
        // Décoder la réponse JSON
        var responseData = jsonDecode(response.body) as Map<String, dynamic>;
        print(responseData);
        return Weather.fromJson(responseData);
      } catch (e) {
        // Si le décodage échoue, on lance une exception
        throw Exception('Erreur lors du décodage des données: $e');
      }
    }

    throw Exception(
      'Impossible de récupérer les données météo (HTTP ${response.statusCode})',
    );
  }

  Future<String?> getLocationName(double lat, double lon) async {
    final response = await http.get(
      Uri.parse(
        '$baseUrl/geo/1.0/reverse?appid=$apiKey&lat=$lat&lon=$lon&limit=1',
      ),
    );

    if (response.statusCode == HttpStatus.ok) {
      return (json.decode(response.body) as List<dynamic>).firstOrNull?["name"];
    }

    throw Exception(
      'Impossible de récupérer les données de localisation (HTTP ${response.statusCode})',
    );
  }
}
