# API Setup Guide for Real Weather & Traffic Data

## Overview
To enable real weather and traffic data in Nethra, you need to configure API keys from Google Cloud Console and OpenWeatherMap.

## Required APIs

### 1. OpenWeatherMap API (Weather Data)
**Purpose:** Get real-time weather data for Bengaluru

**Setup Steps:**
1. Go to [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Navigate to "API Keys" section
4. Copy your API key
5. Replace `YOUR_OPENWEATHER_API_KEY` in `lib/services/weather_service.dart`

**Free Tier:** 1,000 calls/day (sufficient for the app)

### 2. Google Maps API (Traffic Data)
**Purpose:** Get real-time traffic information for Bengaluru routes

**Setup Steps:**
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable the following APIs:
   - **Directions API** (for traffic data)
   - **Places API** (for location search)
   - **Geocoding API** (for address conversion)
4. Go to "Credentials" → "Create Credentials" → "API Key"
5. Copy your API key
6. Replace `YOUR_GOOGLE_MAPS_API_KEY` in `lib/services/traffic_service.dart`

**Important:** Restrict your API key to prevent unauthorized usage:
- Go to API key settings
- Add "Application restrictions" (Android/iOS package name)
- Add "API restrictions" (only enable the APIs you need)

## Configuration Steps

### Step 1: Update Weather Service
Edit `lib/services/weather_service.dart`:
```dart
static const String _apiKey = 'your_actual_openweather_api_key_here';
```

### Step 2: Update Traffic Service  
Edit `lib/services/traffic_service.dart`:
```dart
static const String _apiKey = 'your_actual_google_maps_api_key_here';
```

### Step 3: Add Location Permissions
The app already includes location permissions in `pubspec.yaml`, but you may need to add them to platform-specific files:

**Android** (`android/app/src/main/AndroidManifest.xml`):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

**iOS** (`ios/Runner/Info.plist`):
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide local weather and traffic information for Bengaluru.</string>
```

## Testing the Integration

### Without API Keys (Fallback Mode)
- The app will use intelligent seasonal weather patterns
- Traffic data will be estimated based on time and known Bengaluru patterns
- All functionality will work, but data won't be real-time

### With API Keys (Real Data Mode)
- Weather updates every 10 minutes from OpenWeatherMap
- Traffic data updates every 5 minutes from Google Maps
- Responses will be based on actual current conditions

## Cost Considerations

### OpenWeatherMap
- **Free Tier:** 1,000 calls/day
- **Usage:** ~144 calls/day (every 10 minutes)
- **Cost:** Free for normal usage

### Google Maps APIs
- **Free Tier:** $200 credit/month
- **Directions API:** $5 per 1,000 requests
- **Usage:** ~288 calls/day (every 5 minutes)
- **Monthly Cost:** ~$43 (but covered by free credit)

## Example Responses

### With Real Weather Data:
```
User: "Should I go out?"
Nethra: "Macha, it's actually sunny right now! Perfect weather to step out, guru."
```

### With Real Traffic Data:
```
User: "How's traffic to Electronic City?"
Nethra: "Silk Board is jammed solid - 90 minutes! Take Hosur Road instead, only 45 minutes."
```

## Troubleshooting

### Weather API Issues:
- Check API key is valid
- Ensure you haven't exceeded rate limits
- Verify network connectivity

### Traffic API Issues:
- Check Google Cloud billing is enabled
- Verify API restrictions allow your app
- Ensure Directions API is enabled

### Fallback Behavior:
If APIs fail, the app automatically falls back to:
- Seasonal weather patterns for Bengaluru
- Time-based traffic estimates for known routes
- All core functionality remains available

## Security Notes

1. **Never commit API keys to version control**
2. **Use environment variables in production**
3. **Restrict API keys to your app only**
4. **Monitor usage to prevent unexpected charges**
5. **Rotate keys periodically**

## Next Steps

1. Get your API keys from the providers above
2. Update the service files with your keys
3. Test the app to ensure real data is loading
4. Monitor API usage in the respective dashboards

The app will work perfectly without API keys using intelligent fallbacks, but real data makes Nethra much more accurate and useful!