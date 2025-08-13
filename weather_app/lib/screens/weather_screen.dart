 

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final _weatherService = WeatherService();
  final _cityController = TextEditingController();
  Weather? _weather;
  List<Weather> _forecast = [];
  bool _isLoading = false;
  String? _error;
  bool _isCelsius = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherByLocation();
  }

  Future<void> _fetchWeather(String cityName) async {
    if (cityName.isEmpty) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      String units = _isCelsius ? 'metric' : 'imperial';
      final weatherData = await _weatherService.getWeatherByCity(
        cityName,
        units,
      );
      final forecastData = await _weatherService.getFiveDayForecast(
        cityName,
        units,
      );
      setState(() {
        _weather = weatherData;
        _forecast = forecastData;
        _cityController.text = weatherData.cityName;
      });
    } catch (e) {
      setState(() {
        _error = "Could not fetch weather data. Please check the city name.";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchWeatherByLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      String units = _isCelsius ? 'metric' : 'imperial';
      final weatherData = await _weatherService.getWeatherByLocation(units);
      final forecastData = await _weatherService.getFiveDayForecast(
        weatherData.cityName,
        units,
      );
      setState(() {
        _weather = weatherData;
        _forecast = forecastData;
        _cityController.text = weatherData.cityName;
      });
    } catch (e) {
      setState(() {
        _error = "Could not fetch weather data for your location.";
        _weather = null;
        _forecast = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Color> getThemeColors(String condition) {
   
    final lowerCaseCondition = condition.toLowerCase();

    
    if (lowerCaseCondition.contains('clear')) {
      return [const Color(0xFFf8b122), const Color(0xFFf8d422)];
    }
     
    else if (lowerCaseCondition.contains('rain') ||
        lowerCaseCondition.contains('drizzle') ||
        lowerCaseCondition.contains('thunderstorm')) {
      return [const Color.fromARGB(255, 45, 63, 126), const Color(0xFF42569a)];
    }
    
    else if (lowerCaseCondition.contains('cloud') ||
        lowerCaseCondition.contains('mist') ||
        lowerCaseCondition.contains('haze')) {
      return [const Color(0xFF556065), const Color(0xFF748c95)];
    }
    
    else if (lowerCaseCondition.contains('snow')) {
      return [
        const Color.fromARGB(255, 71, 172, 209),
        const Color.fromARGB(255, 136, 179, 194),
      ];
    }

    
    return [const Color(0xFF4385f7), const Color(0xFF3366cc)];
  }

  @override
  Widget build(BuildContext context) {
    List<Color> backgroundColors = _weather != null
        ? getThemeColors(_weather!.mainCondition)
        : [const Color(0xFF4385f7), const Color(0xFF3366cc)];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: backgroundColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildHeader(),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 20),
                      if (_weather != null) _buildCurrentWeatherCard(),
                      const SizedBox(height: 20),
                      if (_forecast.isNotEmpty) _buildForecastSection(),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "SkyScope",
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          "Your weather companion",
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _cityController,
                onSubmitted: (value) => _fetchWeather(value),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search for a city (e.g. London, GB)',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _buildUnitToggle(),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ToggleButtons(
        isSelected: [_isCelsius, !_isCelsius],
        onPressed: (index) {
          setState(() {
            _isCelsius = index == 0;
          });
          if (_cityController.text.isNotEmpty) {
            _fetchWeather(_cityController.text);
          } else {
            _fetchWeatherByLocation();
          }
        },
        color: Colors.white.withOpacity(0.7),
        selectedColor: Colors.white,
        fillColor: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        borderWidth: 0,
        selectedBorderColor: Colors.transparent,
        children: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("°C"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text("°F"),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentWeatherCard() {
    String unit = _isCelsius ? "C" : "F";
    String speedUnit = _isCelsius ? 'km/h' : 'mph';

    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Now in ${_weather!.cityName}",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "${_weather!.temperature.round()}°$unit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 80,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                  Image.network(
                    "http://openweathermap.org/img/wn/${_weather!.icon}@4x.png",
                    width: 120,
                    height: 120,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                _weather!.mainCondition,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(color: Colors.white30),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDetailItem(
                    Icons.thermostat,
                    "Feels like",
                    "${_weather!.feelsLike.round()}°",
                  ),
                  _buildDetailItem(
                    Icons.water_drop_outlined,
                    "Humidity",
                    "${_weather!.humidity.round()}%",
                  ),
                  _buildDetailItem(
                    Icons.air,
                    "Wind",
                    "${_weather!.windSpeed.round()} $speedUnit",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.8)),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.8))),
        const SizedBox(height: 5),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "5-Day Forecast",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 300,
          child: ListView.builder(
            itemCount: _forecast.length,
            itemBuilder: (context, index) {
              return _buildForecastCard(_forecast[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildForecastCard(Weather day) {
    String unit = _isCelsius ? "C" : "F";
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Text(
                  DateFormat('E, MMM d').format(DateTime.parse(day.date!)),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Image.network(
                  "http://openweathermap.org/img/wn/${day.icon}@2x.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Flexible(
                flex: 2,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "${day.maxTemp.round()}°$unit",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${day.minTemp.round()}°$unit",
                      style: TextStyle(color: Colors.white.withOpacity(0.7)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
