import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/services/openweathermap_api.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({
    required this.locationName,
    required this.latitude,
    required this.longitude,
    super.key,
  });

  final String locationName;
  final double latitude;
  final double longitude;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    var api = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              //
            },
            child: const Text('Retour'),
          ),

          FutureBuilder(
            future: api.getWeather(widget.latitude, widget.longitude),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text('Une erreur est survenue.\n${snapshot.error}');
              }

              if (!snapshot.hasData) {
                return const Text('Données de localisation incorrect.');
              }

              return Column(
                children: [
                  // Titre ou condition météo
                  Text(
                    "${widget.locationName}",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),

                  Text(
                    "${snapshot.data!.condition}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),

                  // Description sous la condition
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "${snapshot.data!.description}",
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // Affichage de la température
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Affichage de la valeur numérique de la température
                        Text(
                          "${snapshot.data!.temperature}°C", // Exemple : Température en Celsius
                          style: TextStyle(
                            fontSize:
                                36, // Taille de police plus grande pour la température
                            fontWeight: FontWeight.bold,
                            color:
                                Colors
                                    .orangeAccent, // Couleur chaude pour une température
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Icône météo centrée
                  Center(
                    child: Image.network(
                      api.getIconUrl(snapshot.data!.icon),
                      height: 100,
                      width: 100,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
