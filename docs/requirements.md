# Technical Requirements: Nethra Bengaluru SuperApp

## 1. Project Overview
**Product Name:** Nethra (The Voice-First Local Guide)  
**App Identity:** "Namma Guide"  
**Target Platform:** Flutter (Cross-platform)  
**Core Mission:** Voice-first, hyper-local intelligence agent for Bengaluru with real-time context awareness

## 2. Dependencies & Versions

### Core Flutter Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Chat UI Framework
  flutter_chat_ui: ^1.6.10
  
  # Visual Effects
  glassmorphism: ^3.0.0
  avatar_glow: ^2.0.2
  flutter_animate: ^4.5.0
  
  # Voice Services
  speech_to_text: ^6.6.0
  flutter_tts: ^3.8.5
  
  # Typography & Theming
  google_fonts: ^6.1.0
  
  # State Management & Utilities
  provider: ^6.1.1
  shared_preferences: ^2.2.2
  
  # HTTP & API
  http: ^1.1.2
  
  # Permissions
  permission_handler: ^11.2.0
```

### Development Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
  build_runner: ^2.4.7
```

## 3. Data Flow Architecture

### Live Context Injection System
```
[USER QUERY] 
    ↓
[CONTEXT AGGREGATOR]
    ├── Time Service (HH:MM format)
    ├── Weather Service (Rain/Clear status)
    └── Location Context (Bengaluru-specific)
    ↓
[AI LOGIC ENGINE]
    ├── Safety Protocol (Rain + Travel)
    ├── Realism Protocol (Peak Hours + Traffic)
    └── Culture Protocol (Food + Local Heritage)
    ↓
[RESPONSE GENERATOR]
    ├── Text Response
    ├── TTS Audio (if Blind Mode)
    └── UI Update
```

### Context Data Structure
```dart
class LiveContext {
  final DateTime currentTime;
  final WeatherStatus weather;
  final String userLocation;
  final bool isBlindMode;
}

enum WeatherStatus { rain, clear, cloudy }
```

### AI Logic Decision Tree
1. **Safety Gate:** `weather == rain && query.contains(['travel', 'auto', 'bike'])`
2. **Realism Gate:** `time.hour >= 17 && time.hour <= 20 && query.contains(['silk board', 'orr', 'traffic'])`
3. **Culture Gate:** `query.contains(['food', 'restaurant', 'eat'])`

## 4. UI Design System

### Cyberpunk Bengaluru Color Palette
```dart
class NethraPalette {
  // Primary Colors
  static const Color deepIndigo = Color(0xFF1A1A2E);      // Background
  static const Color neonCyan = Color(0xFF00FFF5);        // Primary Accent
  static const Color electricPurple = Color(0xFF7B2CBF);  // Secondary Accent
  
  // Supporting Colors
  static const Color darkSlate = Color(0xFF16213E);       // Card Background
  static const Color softWhite = Color(0xFFE8E8E8);       // Text Primary
  static const Color mutedGray = Color(0xFF9E9E9E);       // Text Secondary
  
  // Accessibility (Blind Mode)
  static const Color highContrastBg = Color(0xFF000000);  // Black Background
  static const Color highContrastText = Color(0xFFFFFF00); // Yellow Text
}
```

### Typography System (Poppins)
```dart
class NethraTypography {
  static const String fontFamily = 'Poppins';
  
  // Text Styles
  static const TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: NethraPalette.neonCyan,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: NethraPalette.softWhite,
  );
  
  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: NethraPalette.softWhite,
  );
  
  static const TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: NethraPalette.mutedGray,
  );
}
```

### Glassmorphism Specifications
```dart
class GlassConfig {
  static const double blurRadius = 10.0;
  static const double opacity = 0.1;
  static const double borderRadius = 16.0;
  static const Color glassColor = Color(0x1AFFFFFF);
}
```

## 5. Voice Service Requirements

### Speech-to-Text Configuration
- **Language:** English (en-US) + Kannada (kn-IN) support
- **Activation:** Push-to-talk button with haptic feedback
- **Visual Feedback:** AvatarGlow animation during recording
- **Timeout:** 30 seconds maximum recording

### Text-to-Speech Configuration
- **Voice:** Natural, clear pronunciation
- **Speed:** Adjustable (0.5x to 2.0x)
- **Auto-play:** Enabled in Blind Mode only
- **Content Processing:** Strip emojis and markdown before TTS

## 6. Accessibility Requirements

### Blind Mode Features
- **Activation:** Triple-tap gesture or voice command "Enable blind mode"
- **Visual Changes:**
  - Background: Pure black (#000000)
  - Text: High contrast yellow (#FFFF00)
  - Remove all glassmorphism effects
  - Increase font sizes by 20%
- **Audio Behavior:**
  - Immediate TTS playback for all responses
  - Audio confirmation for all button presses
  - Spoken navigation cues

### General Accessibility
- **Minimum Touch Targets:** 44x44 dp
- **Screen Reader Support:** Full semantic labeling
- **Keyboard Navigation:** Complete app navigation via external keyboard
- **High Contrast Mode:** System-level high contrast support

## 7. Performance Requirements

### Response Times
- **Voice Recognition:** < 2 seconds processing
- **AI Response Generation:** < 3 seconds
- **UI Animations:** 60 FPS smooth animations
- **App Launch:** < 4 seconds cold start

### Memory & Storage
- **RAM Usage:** < 150 MB during normal operation
- **Storage:** < 50 MB app size
- **Cache Management:** Automatic cleanup of old conversation data

## 8. Platform-Specific Requirements

### Android
- **Minimum SDK:** API 21 (Android 5.0)
- **Target SDK:** API 34 (Android 14)
- **Permissions:** Microphone, Location (optional)

### iOS
- **Minimum Version:** iOS 12.0
- **Target Version:** iOS 17.0
- **Permissions:** Microphone, Location (optional)

## 9. Security & Privacy

### Data Handling
- **Voice Data:** Processed locally, not stored permanently
- **User Conversations:** Stored locally only, encrypted
- **Location Data:** Approximate city-level only
- **No Personal Data:** No collection of personal identifiers

### Permissions
- **Microphone:** Required for voice input
- **Location:** Optional for enhanced local recommendations
- **Storage:** Local app data only

## 10. Testing Requirements

### Unit Testing
- AI logic decision tree validation
- Voice service integration tests
- UI component rendering tests

### Integration Testing
- End-to-end voice interaction flow
- Accessibility mode switching
- Context injection accuracy

### Performance Testing
- Voice recognition latency
- Animation frame rate consistency
- Memory leak detection