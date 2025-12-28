# Google API Setup Guide for Nethra

## Overview
Nethra now uses **only Google APIs** - no third-party services needed! This makes setup much simpler and more reliable.

## Required Google Cloud APIs

### 1. Google Maps Platform APIs
**Purpose:** Traffic data, directions, and location services

**APIs to Enable:**
- **Directions API** ✅ (for real-time traffic)
- **Places API** ✅ (for location search)
- **Geocoding API** ✅ (for address conversion)

### 2. Custom Search API (Optional)
**Purpose:** Enhanced weather detection via Google Search

**APIs to Enable:**
- **Custom Search JSON API** (optional, for better weather data)

## Setup Steps

### Step 1: Google Cloud Console Setup
1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Go to **APIs & Services** → **Library**
4. Enable these APIs:
   - Directions API
   - Places API  
   - Geocoding API
   - Custom Search JSON API (optional)

### Step 2: Create API Key
1. Go to **APIs & Services** → **Credentials**
2. Click **Create Credentials** → **API Key**
3. Copy your API key
4. **Important:** Restrict your API key (see security section below)

### Step 3: Configure the App
Edit `lib/config/api_config.dart`:
```dart
static const String googleApiKey = 'your_actual_google_api_key_here';
```

### Step 4: Security Configuration
**Restrict your API key to prevent unauthorized usage:**

1. Go to API key settings in Google Cloud Console
2. **Application restrictions:**
   - Select "Android apps" 
   - Add your package name: `com.example.nethra_bengaluru_superapp`
3. **API restrictions:**
   - Select "Restrict key"
   - Choose only the APIs you enabled above

## How It Works

### Weather Detection (Smart Multi-Source)
1. **Google Search API:** Searches for "weather in Bengaluru today"
2. **Smart Patterns:** Uses Bengaluru-specific weather patterns
3. **Seasonal Intelligence:** Monsoon, winter, summer patterns
4. **Time-based Logic:** Morning mist, afternoon rain, etc.

### Traffic Data (Real-time)
1. **Google Directions API:** Real traffic conditions
2. **Multiple Routes:** Checks major Bengaluru routes
3. **Smart Fallback:** Time-based estimates for known problem areas

## Cost Estimation

### Google Maps APIs (Free Tier)
- **$200 free credit per month**
- **Directions API:** $5 per 1,000 requests
- **Expected usage:** ~300 requests/day
- **Monthly cost:** ~$45 (covered by free credit)

### Custom Search API (Optional)
- **100 searches/day free**
- **Expected usage:** ~50 searches/day for weather
- **Cost:** Free for normal usage

## Testing Without API Key

The app works perfectly without any API keys using:
- **Intelligent weather patterns** based on Bengaluru seasons
- **Time-based traffic estimates** for known routes
- **All core functionality** remains available

## Example Responses

### With Real Data:
```
User: "How's the weather?"
Nethra: "Macha, it's actually sunny right now! Perfect weather to step out."

User: "Traffic to Electronic City?"
Nethra: "Silk Board is jammed - 90 minutes! Take Hosur Road, only 45 minutes."
```

### With Fallback Data:
```
User: "Should I carry umbrella?"
Nethra: "It's monsoon season guru, always carry umbrella! Better safe than soaked."
```

## Troubleshooting

### API Key Issues:
- Verify the key is copied correctly
- Check that required APIs are enabled
- Ensure billing is enabled in Google Cloud
- Verify API restrictions allow your app

### No Real Data:
- App automatically falls back to smart patterns
- Check logs for API error messages
- Verify network connectivity

## Security Best Practices

1. **Never commit API keys to version control**
2. **Always restrict API keys to your app**
3. **Monitor usage in Google Cloud Console**
4. **Set up billing alerts**
5. **Rotate keys periodically**

## Next Steps

1. **Get your Google API key** from Google Cloud Console
2. **Enable the required APIs** (Directions, Places, Geocoding)
3. **Update** `lib/config/api_config.dart` with your key
4. **Test the app** to see real data in action
5. **Monitor usage** in Google Cloud Console

The app provides intelligent fallbacks, so it works great even without API keys. But with Google APIs, Nethra becomes incredibly accurate and context-aware!

## Benefits of Google-Only Approach

✅ **Single API Key** - One key for all services  
✅ **Reliable Infrastructure** - Google's global network  
✅ **Comprehensive Data** - Traffic, weather, places  
✅ **Smart Fallbacks** - Works offline with patterns  
✅ **Cost Effective** - Free tier covers normal usage  
✅ **Easy Setup** - No multiple service accounts needed