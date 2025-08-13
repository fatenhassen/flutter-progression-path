import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const String _apiKey = 'e34102d9b404799b82f43c5656706996';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeatherByCity(String cityName, String units) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=$units'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data for $cityName');
    }
  }

  Future<List<Weather>> getFiveDayForecast(
    String cityName,
    String units,
  ) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/forecast?q=$cityName&appid=$_apiKey&units=$units'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      final String city = data['city']['name'];

      Map<int, List<dynamic>> dailyData = {};
      for (var item in forecastList) {
        final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
        if (!dailyData.containsKey(date.day)) {
          dailyData[date.day] = [];
        }
        dailyData[date.day]!.add(item);
      }

      List<Weather> dailyForecasts = [];
      dailyData.forEach((day, items) {
        double maxTemp = items
            .map<double>((item) => (item['main']['temp_max'] ?? 0).toDouble())
            .reduce((a, b) => a > b ? a : b);
        double minTemp = items
            .map<double>((item) => (item['main']['temp_min'] ?? 0).toDouble())
            .reduce((a, b) => a < b ? a : b);

        var representativeItem = items.firstWhere(
          (item) =>
              DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000).hour >= 12,
          orElse: () => items.first,
        );

        representativeItem['main']['temp_max'] = maxTemp;
        representativeItem['main']['temp_min'] = minTemp;

        dailyForecasts.add(Weather.fromJson(representativeItem, city));
      });

      return dailyForecasts.take(5).toList();
    } else {
      throw Exception('Failed to load 5-day forecast for $cityName');
    }
  }

  Future<Weather> getWeatherByLocation(String units) async {
    final Position position = await _determinePosition();
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$_apiKey&units=$units',
      ),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather data for your location');
    }
  }
 
  Future<List<Weather>> getWeatherForMultipleCities(
    List<String> cities,
    String units,
  ) async {
    List<Weather> results = [];
    for (String city in cities) {
      try {
        final weather = await getWeatherByCity(city, units);
        results.add(weather);
      } catch (e) {
        print("Error fetching weather for $city: $e");
      }
    }
    return results;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Location permissions are permanently denied, cannot request permissions.',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
