/// API Configuration for Nethra Bengaluru SuperApp
/// 
/// Uses only Google Cloud APIs - no third-party services needed!
/// Get your API key from: https://console.cloud.google.com/ → Credentials
class ApiConfig {
  // Single Google Cloud API Key (works for all Google services)
  static const String googleApiKey = 'AIzaSyAts3V2Abyp9_qx4EmqZU5ape3lv4sTGD8';
  
  // Google API Base URLs
  static const String googleMapsBaseUrl = 'https://maps.googleapis.com/maps/api';
  static const String googleSearchBaseUrl = 'https://www.googleapis.com/customsearch/v1';
  
  // Bengaluru coordinates for location-based services
  static const double bengaluruLatitude = 12.9716;
  static const double bengaluruLongitude = 77.5946;
  
  // Cache timeouts
  static const Duration weatherCacheTimeout = Duration(minutes: 15);
  static const Duration trafficCacheTimeout = Duration(minutes: 5);
  
  // Check if API is configured
  static bool get isConfigured => 
    googleApiKey != 'YOUR_GOOGLE_API_KEY' && 
    googleApiKey.isNotEmpty;
    
  // All services use the same Google API key
  static bool get isWeatherConfigured => isConfigured;
  static bool get isTrafficConfigured => isConfigured;
  static bool get isFullyConfigured => isConfigured;
}