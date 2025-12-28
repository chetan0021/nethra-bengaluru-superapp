import '../models/live_context.dart';
import 'google_weather_service.dart';
import 'traffic_service.dart';

/// Context Service - Provides live context data for AI decisions
class ContextService {
  static final ContextService _instance = ContextService._internal();
  factory ContextService() => _instance;
  ContextService._internal();

  bool _isBlindMode = false;
  final GoogleWeatherService _weatherService = GoogleWeatherService();
  final TrafficService _trafficService = TrafficService();
  
  bool get isBlindMode => _isBlindMode;

  /// Get current live context with real data
  Future<LiveContext> getCurrentContext() async {
    final weather = await _getCurrentWeather();
    
    return LiveContext(
      currentTime: DateTime.now(),
      weather: weather,
      userLocation: 'Bengaluru',
      isBlindMode: _isBlindMode,
      specificArea: await _getCurrentArea(), // Try to detect current area
    );
  }

  /// Get current weather (real or fallback)
  Future<WeatherStatus> _getCurrentWeather() async {
    try {
      return await _weatherService.getCurrentWeather();
    } catch (e) {
      // Fallback to intelligent mock based on season/time
      return _getSeasonalWeather();
    }
  }

  /// Get current area (placeholder for location detection)
  Future<String> _getCurrentArea() async {
    // TODO: Implement location detection
    // For now, return a common area
    return 'Koramangala';
  }

  /// Get traffic information for a route
  Future<TrafficInfo> getTrafficInfo(String origin, String destination) async {
    return await _trafficService.getTrafficInfo(origin, destination);
  }

  /// Get traffic for major Bengaluru routes
  Future<Map<String, TrafficInfo>> getMajorRoutesTraffic() async {
    return await _trafficService.getMajorRoutesTraffic();
  }

  /// Toggle blind mode
  void toggleBlindMode() {
    _isBlindMode = !_isBlindMode;
  }

  /// Set blind mode
  void setBlindMode(bool enabled) {
    _isBlindMode = enabled;
  }

  /// Seasonal weather fallback based on Bengaluru patterns
  WeatherStatus _getSeasonalWeather() {
    final now = DateTime.now();
    final month = now.month;
    final hour = now.hour;
    
    // Monsoon season (June-September)
    if (month >= 6 && month <= 9) {
      // Evening showers are common during monsoon
      if (hour >= 15 && hour <= 19) {
        return WeatherStatus.rain;
      } else {
        return WeatherStatus.cloudy;
      }
    }
    
    // Winter (December-February) - pleasant weather
    if (month == 12 || month <= 2) {
      return WeatherStatus.clear;
    }
    
    // Summer (March-May) - hot and dry
    if (month >= 3 && month <= 5) {
      return WeatherStatus.clear;
    }
    
    // Post-monsoon (October-November) - pleasant
    return WeatherStatus.clear;
  }

  /// Check if weather/traffic APIs are configured
  bool get hasRealDataAPIs => 
    _weatherService.isConfigured && _trafficService.isConfigured;

  /// Refresh all data
  Future<void> refreshData() async {
    await _weatherService.refreshWeather();
  }
}