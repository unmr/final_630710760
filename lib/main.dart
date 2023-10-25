import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  String selectedCity = "Bangkok";
  String unit = "°C";
  Map<String, dynamic> weatherData = {
    "city": "Bangkok",
    "country": "Thailand",
    "lastUpdated": "2023-10-25 19:45",
    "tempC": 28.8,
    "tempF": 83.9,
    "feelsLikeC": 33.6,
    "feelsLikeF": 92.4,
    "windKph": 7.6,
    "windMph": 4.7,
    "humidity": 76,
    "uv": 6,
    "condition": {
      "text": "Partly cloudy",
      "icon":
      "https://cdn.weatherapi.com/weather/128x128/night/116.png",
      "code": 1063
    }
  };

  Future<void> fetchWeatherData() async {
    final uri = Uri.https(
        'cpsu-test-api.herokuapp.com', '/api/1_2566/weather/current', {'city': selectedCity});
    final httpClient = HttpClient();

    try {
      final request = await httpClient.getUrl(uri);
      final response = await request.close();

      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = json.decode(responseBody);
        setState(() {
          weatherData = data;
        });
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      httpClient.close();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'City: ${weatherData['city'] ?? 'Loading...'}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Temperature: ${weatherData['tempC'] ?? 'Loading...'} $unit',
              style: TextStyle(fontSize: 24),
            ),
            ElevatedButton(
              onPressed: () {
                fetchWeatherData();
              },
              child: Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }
}