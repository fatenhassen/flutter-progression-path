class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String description;
  final String icon;
  final double humidity;
  final double windSpeed;
  final double feelsLike;
  final double maxTemp;
  final double minTemp;
  final String? date;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.icon,
    required this.humidity,
    required this.windSpeed,
    required this.feelsLike,
    required this.maxTemp,
    required this.minTemp,
    this.date,
  });

  factory Weather.fromJson(Map<String, dynamic> json, [String? cityName]) {
    
    String? formattedDate;
    if (json.containsKey('dt')) {
      final timestamp = json['dt'];
      if (timestamp != null) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
        formattedDate = dateTime.toString();  
      }
    } else if (json.containsKey('dt_txt')) {
      
      formattedDate = json['dt_txt'];
    }

    return Weather(
      cityName: cityName ?? json['name'] ?? '',
      temperature: (json['main']?['temp'] ?? 0).toDouble(),
      mainCondition: json['weather']?[0]?['main'] ?? '',
      description: json['weather']?[0]?['description'] ?? '',
      icon: json['weather']?[0]?['icon'] ?? '',
      humidity: (json['main']?['humidity'] ?? 0).toDouble(),
      windSpeed: (json['wind']?['speed'] ?? 0).toDouble(),
      feelsLike: (json['main']?['feels_like'] ?? 0).toDouble(),
      maxTemp: (json['main']?['temp_max'] ?? 0).toDouble(),
      minTemp: (json['main']?['temp_min'] ?? 0).toDouble(),
      date: formattedDate,
    );
  }
}
