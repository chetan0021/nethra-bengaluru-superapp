import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';

/// Traffic Service - Provides real traffic data for Bengaluru
class TrafficService {
  static final TrafficService _instance = TrafficService._internal();
  factory TrafficService() => _instance;
  TrafficService._internal();
  
  // Cache for traffic data
  final Map<String, TrafficInfo> _trafficCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};

  /// Get traffic information for a specific route in Bengaluru
  Future<TrafficInfo> getTrafficInfo(String origin, String destination) async {
    try {
      final cacheKey = '$origin-$destination';
      
      // Return cached data if still valid
      if (_trafficCache.containsKey(cacheKey) && 
          _cacheTimestamps.containsKey(cacheKey) &&
          DateTime.now().difference(_cacheTimestamps[cacheKey]!) < ApiConfig.trafficCacheTimeout) {
        debugPrint('🚗 Using cached traffic data for $cacheKey');
        return _trafficCache[cacheKey]!;
      }

      debugPrint('🚗 Fetching fresh traffic data: $origin → $destination');
      
      final url = Uri.parse(
        '${ApiConfig.googleMapsBaseUrl}/directions/json?origin=$origin&destination=$destination&departure_time=now&traffic_model=best_guess&key=${ApiConfig.googleApiKey}'
      );
      
      final response = await http.get(url).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 'OK' && data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];
          
          final durationInTraffic = leg['duration_in_traffic'] ?? leg['duration'];
          final normalDuration = leg['duration'];
          
          final trafficInfo = TrafficInfo(
            origin: origin,
            destination: destination,
            durationInTraffic: Duration(seconds: durationInTraffic['value']),
            normalDuration: Duration(seconds: normalDuration['value']),
            distance: leg['distance']['text'],
            trafficLevel: _calculateTrafficLevel(
              durationInTraffic['value'], 
              normalDuration['value']
            ),
          );
          
          // Cache the result
          _trafficCache[cacheKey] = trafficInfo;
          _cacheTimestamps[cacheKey] = DateTime.now();
          
          debugPrint('✅ Traffic data: ${trafficInfo.trafficLevel} (${trafficInfo.durationInTraffic.inMinutes}min vs ${trafficInfo.normalDuration.inMinutes}min normal)');
          return trafficInfo;
        }
      }
      
      debugPrint('❌ Traffic API error: ${response.statusCode}');
      return _getFallbackTrafficInfo(origin, destination);
      
    } catch (e) {
      debugPrint('❌ Traffic service error: $e');
      return _getFallbackTrafficInfo(origin, destination);
    }
  }

  /// Calculate traffic level based on duration comparison
  TrafficLevel _calculateTrafficLevel(int trafficDuration, int normalDuration) {
    final ratio = trafficDuration / normalDuration;
    
    if (ratio >= 2.0) {
      return TrafficLevel.heavy;
    } else if (ratio >= 1.5) {
      return TrafficLevel.moderate;
    } else if (ratio >= 1.2) {
      return TrafficLevel.light;
    } else {
      return TrafficLevel.free;
    }
  }

  /// Get traffic info for major Bengaluru routes
  Future<Map<String, TrafficInfo>> getMajorRoutesTraffic() async {
    final routes = <String, TrafficInfo>{};
    
    // Major problematic routes in Bengaluru
    final majorRoutes = [
      {'origin': 'Silk Board, Bengaluru', 'destination': 'Electronic City, Bengaluru'},
      {'origin': 'Whitefield, Bengaluru', 'destination': 'MG Road, Bengaluru'},
      {'origin': 'Koramangala, Bengaluru', 'destination': 'Indiranagar, Bengaluru'},
      {'origin': 'Hebbal, Bengaluru', 'destination': 'Marathahalli, Bengaluru'},
    ];
    
    for (final route in majorRoutes) {
      try {
        final traffic = await getTrafficInfo(route['origin']!, route['destination']!);
        routes[route['origin']!] = traffic;
      } catch (e) {
        debugPrint('❌ Failed to get traffic for ${route['origin']}: $e');
      }
    }
    
    return routes;
  }

  /// Fallback traffic info based on time and known patterns
  TrafficInfo _getFallbackTrafficInfo(String origin, String destination) {
    final now = DateTime.now();
    final hour = now.hour;
    final isWeekday = now.weekday <= 5;
    
    TrafficLevel level;
    Duration estimatedDuration;
    
    // Peak hours logic
    if (isWeekday && ((hour >= 8 && hour <= 10) || (hour >= 17 && hour <= 20))) {
      // Check if it's a known problematic route
      if (_isProblematicRoute(origin, destination)) {
        level = TrafficLevel.heavy;
        estimatedDuration = const Duration(minutes: 90); // Assume 1.5 hours for bad routes
      } else {
        level = TrafficLevel.moderate;
        estimatedDuration = const Duration(minutes: 45);
      }
    } else if (isWeekday && (hour >= 11 && hour <= 16)) {
      level = TrafficLevel.light;
      estimatedDuration = const Duration(minutes: 30);
    } else {
      level = TrafficLevel.free;
      estimatedDuration = const Duration(minutes: 20);
    }
    
    debugPrint('🚗 Fallback traffic: $level for $origin → $destination');
    
    return TrafficInfo(
      origin: origin,
      destination: destination,
      durationInTraffic: estimatedDuration,
      normalDuration: const Duration(minutes: 20),
      distance: '15 km', // Rough estimate for Bengaluru routes
      trafficLevel: level,
    );
  }

  /// Check if route is known to be problematic
  bool _isProblematicRoute(String origin, String destination) {
    final problematicAreas = [
      'silk board', 'electronic city', 'whitefield', 'outer ring road', 
      'orr', 'hebbal', 'tin factory', 'marathahalli'
    ];
    
    final originLower = origin.toLowerCase();
    final destLower = destination.toLowerCase();
    
    return problematicAreas.any((area) => 
      originLower.contains(area) || destLower.contains(area)
    );
  }

  /// Check if API key is configured
  bool get isConfigured => ApiConfig.isTrafficConfigured;
}

/// Traffic information model
class TrafficInfo {
  final String origin;
  final String destination;
  final Duration durationInTraffic;
  final Duration normalDuration;
  final String distance;
  final TrafficLevel trafficLevel;

  const TrafficInfo({
    required this.origin,
    required this.destination,
    required this.durationInTraffic,
    required this.normalDuration,
    required this.distance,
    required this.trafficLevel,
  });

  /// Get delay compared to normal traffic
  Duration get delay => durationInTraffic - normalDuration;

  /// Get traffic description for AI context
  String get description {
    switch (trafficLevel) {
      case TrafficLevel.free:
        return 'Free flowing traffic';
      case TrafficLevel.light:
        return 'Light traffic';
      case TrafficLevel.moderate:
        return 'Moderate traffic congestion';
      case TrafficLevel.heavy:
        return 'Heavy traffic jam';
    }
  }
}

/// Traffic level enumeration
enum TrafficLevel {
  free,
  light,
  moderate,
  heavy,
}