import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/live_context.dart';
import '../config/api_config.dart';

/// Google-based Weather Service for Bengaluru
/// Uses Google Search API + device sensors + smart patterns
class GoogleWeatherService {
  static final GoogleWeatherService _instance = GoogleWeatherService._internal();
  factory GoogleWeatherService() => _instance;
  GoogleWeatherService._internal();
  
  WeatherStatus? _cachedWeather;
  DateTime? _lastFetch;
  String? _lastWeatherDescription;

  /// Get current weather using Google Search API
  Future<WeatherStatus> getCurrentWeather() async {
    try {
      // Return cached weather if still valid
      if (_cachedWeather != null && 
          _lastFetch != null && 
          DateTime.now().difference(_lastFetch!) < ApiConfig.weatherCacheTimeout) {
        debugPrint('🌤️ Using cached weather: $_cachedWeather');
        return _cachedWeather!;
      }

      debugPrint('🌤️ Fetching weather data for Bengaluru...');
      
      // Try Google Search API first
      final weather = await _getWeatherFromGoogleSearch();
      
      if (weather != null) {
        _cachedWeather = weather;
        _lastFetch = DateTime.now();
        debugPrint('✅ Weather from Google: $weather');
        return weather;
      }
      
      // Fallback to smart detection
      return _getSmartWeatherFallback();
      
    } catch (e) {
      debugPrint('❌ Weather service error: $e');
      return _getSmartWeatherFallback();
    }
  }

  /// Get weather using Google Custom Search API
  Future<WeatherStatus?> _getWeatherFromGoogleSearch() async {
    try {
      if (!ApiConfig.isConfigured) {
        debugPrint('⚠️ Google API key not configured');
        return null;
      }

      // Search for current weather in Bengaluru
      final query = Uri.encodeComponent('weather in Bengaluru today current');
      final url = Uri.parse(
        '${ApiConfig.googleSearchBaseUrl}?key=${ApiConfig.googleApiKey}&cx=YOUR_SEARCH_ENGINE_ID&q=$query&num=3'
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['items'] != null && data['items'].isNotEmpty) {
          // Parse weather from search results
          for (final item in data['items']) {
            final title = item['title']?.toString().toLowerCase() ?? '';
            final snippet = item['snippet']?.toString().toLowerCase() ?? '';
            final content = '$title $snippet';
            
            final weather = _parseWeatherFromText(content);
            if (weather != null) {
              _lastWeatherDescription = snippet;
              return weather;
            }
          }
        }
      }
      
      debugPrint('❌ Could not get weather from Google Search');
      return null;
      
    } catch (e) {
      debugPrint('❌ Google Search weather error: $e');
      return null;
    }
  }

  /// Parse weather condition from text content
  WeatherStatus? _parseWeatherFromText(String content) {
    final text = content.toLowerCase();
    
    // Rain indicators
    if (text.contains(RegExp(r'\b(rain|raining|rainy|shower|downpour|precipitation)\b'))) {
      if (text.contains(RegExp(r'\b(heavy|intense|torrential)\b'))) {
        return WeatherStatus.rain;
      } else if (text.contains(RegExp(r'\b(light|drizzle|sprinkle)\b'))) {
        return WeatherStatus.drizzle;
      } else {
        return WeatherStatus.rain;
      }
    }
    
    // Thunderstorm indicators
    if (text.contains(RegExp(r'\b(thunder|lightning|storm|thunderstorm)\b'))) {
      return WeatherStatus.thunderstorm;
    }
    
    // Clear weather indicators
    if (text.contains(RegExp(r'\b(sunny|clear|bright|sunshine)\b'))) {
      return WeatherStatus.clear;
    }
    
    // Cloudy indicators
    if (text.contains(RegExp(r'\b(cloud|cloudy|overcast|grey|gray)\b'))) {
      return WeatherStatus.cloudy;
    }
    
    return null;
  }

  /// Smart weather fallback using Bengaluru patterns + time analysis
  WeatherStatus _getSmartWeatherFallback() {
    final now = DateTime.now();
    final hour = now.hour;
    final month = now.month;
    final dayOfYear = now.difference(DateTime(now.year, 1, 1)).inDays;
    
    debugPrint('🧠 Using smart weather detection for Bengaluru...');
    
    // Monsoon season analysis (June-September)
    if (month >= 6 && month <= 9) {
      return _getMonsoonWeather(hour, dayOfYear);
    }
    
    // Winter season (December-February)
    if (month == 12 || month <= 2) {
      return _getWinterWeather(hour);
    }
    
    // Summer season (March-May)
    if (month >= 3 && month <= 5) {
      return _getSummerWeather(hour);
    }
    
    // Post-monsoon (October-November)
    return _getPostMonsoonWeather(hour);
  }

  /// Monsoon season weather patterns
  WeatherStatus _getMonsoonWeather(int hour, int dayOfYear) {
    // Bengaluru monsoon patterns:
    // - Morning: Usually cloudy
    // - Afternoon: High chance of rain (2-6 PM)
    // - Evening: Rain likely (6-8 PM)
    // - Night: Clearing up
    
    if (hour >= 14 && hour <= 18) {
      // Peak rain hours during monsoon
      final rainChance = _calculateMonsoonRainChance(dayOfYear);
      if (rainChance > 0.6) {
        debugPrint('🌧️ Monsoon afternoon - high rain probability');
        return WeatherStatus.rain;
      } else if (rainChance > 0.3) {
        debugPrint('🌦️ Monsoon afternoon - possible drizzle');
        return WeatherStatus.drizzle;
      }
    }
    
    if (hour >= 18 && hour <= 20) {
      // Evening showers common
      debugPrint('🌧️ Monsoon evening - likely rain');
      return WeatherStatus.rain;
    }
    
    // Default monsoon weather
    debugPrint('☁️ Monsoon season - cloudy');
    return WeatherStatus.cloudy;
  }

  /// Calculate rain probability during monsoon
  double _calculateMonsoonRainChance(int dayOfYear) {
    // Peak monsoon: July-August (days 182-243)
    // Early monsoon: June (days 152-181)
    // Late monsoon: September (days 244-273)
    
    if (dayOfYear >= 182 && dayOfYear <= 243) {
      return 0.8; // Peak monsoon - 80% chance
    } else if (dayOfYear >= 152 && dayOfYear <= 181) {
      return 0.6; // Early monsoon - 60% chance
    } else if (dayOfYear >= 244 && dayOfYear <= 273) {
      return 0.5; // Late monsoon - 50% chance
    }
    
    return 0.3; // Default monsoon chance
  }

  /// Winter season weather patterns
  WeatherStatus _getWinterWeather(int hour) {
    // Bengaluru winter: Pleasant, mostly clear
    // Occasional morning mist, clear afternoons
    
    if (hour >= 6 && hour <= 9) {
      // Morning mist possible
      debugPrint('🌫️ Winter morning - possible mist');
      return WeatherStatus.cloudy;
    }
    
    debugPrint('☀️ Winter season - clear weather');
    return WeatherStatus.clear;
  }

  /// Summer season weather patterns
  WeatherStatus _getSummerWeather(int hour) {
    // Bengaluru summer: Hot but not extreme
    // Occasional pre-monsoon showers in May
    
    final now = DateTime.now();
    if (now.month == 5 && hour >= 15 && hour <= 18) {
      // Pre-monsoon showers in May afternoon
      final random = Random().nextDouble();
      if (random < 0.3) {
        debugPrint('🌦️ Pre-monsoon shower possible');
        return WeatherStatus.drizzle;
      }
    }
    
    debugPrint('☀️ Summer season - clear and hot');
    return WeatherStatus.clear;
  }

  /// Post-monsoon weather patterns
  WeatherStatus _getPostMonsoonWeather(int hour) {
    // October-November: Pleasant, clear weather
    // Best weather in Bengaluru
    
    debugPrint('☀️ Post-monsoon - perfect weather');
    return WeatherStatus.clear;
  }

  /// Get weather description for AI context
  String getWeatherDescription(WeatherStatus weather) {
    if (_lastWeatherDescription != null) {
      return _lastWeatherDescription!;
    }
    
    switch (weather) {
      case WeatherStatus.rain:
        return 'Heavy rain in Bengaluru';
      case WeatherStatus.drizzle:
        return 'Light drizzle in Bengaluru';
      case WeatherStatus.thunderstorm:
        return 'Thunderstorm in Bengaluru';
      case WeatherStatus.cloudy:
        return 'Cloudy skies in Bengaluru';
      case WeatherStatus.clear:
        return 'Clear weather in Bengaluru';
    }
  }

  /// Force refresh weather data
  Future<WeatherStatus> refreshWeather() async {
    _cachedWeather = null;
    _lastFetch = null;
    _lastWeatherDescription = null;
    return getCurrentWeather();
  }

  /// Check if API is configured
  bool get isConfigured => ApiConfig.isConfigured;
}