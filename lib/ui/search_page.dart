import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/models/location.dart';
import 'package:weather_app/services/openweathermap_api.dart';
import 'package:weather_app/ui/weather_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String query = '';
  Future<Iterable<Location>>? locationsSearchResults;

  @override
  Widget build(BuildContext context) {
    var api = context.read<OpenWeatherMapApi>();

    return Scaffold(
      appBar: AppBar(title: const Text('Recherche')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                query =
                    value
                        .trim(); // Met à jour la variable 'query' avec la nouvelle valeur
              });
            },
            decoration: InputDecoration(hintText: 'Entrez du texte ici...'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    locationsSearchResults = api.searchLocations(query);
                  });
                },
                child: const Text('Rechercher'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                },
                child: const Text('Géolocalisation'),
              ),
            ],
          ),

          if (query.isEmpty)
            const Text('Saisissez une ville dans la barre de recherche.')
          else
            FutureBuilder(
              future: api.searchLocations(query),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return Text('Une erreur est survenue.\n${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return const Text('Aucun résultat pour cette recherche.');
                }

                return Column(
                  children: [
                    for (final location in snapshot.data!)
                      ListTile(
                        title: Text("${location.name} ${location.country}"),
                        subtitle: Text("${location.lat} ${location.lon}"),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder:
                                  (BuildContext context) => WeatherPage(
                                    locationName: location.name,
                                    latitude: location.lat,
                                    longitude: location.lon,
                                  ),
                            ),
                          );
                        },
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
