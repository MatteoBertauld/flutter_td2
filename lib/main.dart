import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/geolocation_service.dart';
import 'package:weather_app/ui/loading_screen.dart';
import 'package:weather_app/ui/search_page.dart';

import 'config.dart';
import 'package:weather_app/services/openweathermap_api.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => OpenWeatherMapApi(apiKey: openWeatherMapApiKey),
        ),
        Provider(create: (_) => GeolocationService()),
      ],
      child: const WeatherApp(), // Votre widget principal
    ),
  );
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      theme: ThemeData.dark(),
      home: LoadingScreen(),
    );
  }
}
