import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/geolocation_service.dart';
import 'package:weather_app/services/openweathermap_api.dart';
import 'package:weather_app/ui/search_page.dart';
import 'package:weather_app/ui/weather_page.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    GetLocationdata();
  }

  Future<void> GetLocationdata() async {
    final geolocationService = context.read<GeolocationService>();
    final openWeatherMap = context.read<OpenWeatherMapApi>();

    final geolocationStatus = await geolocationService.checkStatus();

    if (geolocationStatus == GeolocationStatus.available) {
      try {
        var position = await geolocationService.getCurrentPosition();
        String? name;

        if (position != null) {
          name = await openWeatherMap.getLocationName(
            position!.latitude,
            position!.longitude,
          );
        }

        name = name ?? "A votre position";

        if (position != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder:
                  (context) => WeatherPage(
                    locationName: name!,
                    latitude: position.latitude,
                    longitude: position.longitude,
                  ),
            ),
          );
        } else {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SearchPage()),
            );
          }
        }
      } catch (e) {
        // En cas d'erreur (par exemple, absence de permissions), redirige vers la page de recherche
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SearchPage()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SearchPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chargement...")),
      body: Center(
        child:
            CircularProgressIndicator(), // Affichage du CircularProgressIndicator
      ),
    );
  }
}
