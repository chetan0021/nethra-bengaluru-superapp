# Technology Stack: Nethra Bengaluru SuperApp

## Framework & Platform
- **Framework**: Flutter 3.8.1+ (Cross-platform mobile development)
- **Language**: Dart
- **Platforms**: Android (API 21+), iOS (12.0+), with Linux/macOS/Windows support
- **Architecture**: Provider pattern for state management

## Core Dependencies
### UI & Visual Effects
- `flutter_chat_ui: ^1.6.10` - Chat interface framework
- `glassmorphism: ^3.0.0` - Glass morphism effects
- `avatar_glow: ^2.0.2` - Glowing animations for voice button
- `flutter_animate: ^4.5.0` - Smooth UI animations
- `google_fonts: ^6.1.0` - Poppins typography system

### Voice & AI Services
- `speech_to_text: ^7.0.0` - Voice input recognition
- `flutter_tts: ^3.8.5` - Text-to-speech output
- `google_generative_ai: ^0.4.0` - Gemini AI integration
- `permission_handler: ^11.2.0` - Microphone permissions

### State & Data Management
- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Local data persistence
- `http: ^1.1.2` - API communication

## Development Tools
- `flutter_lints: ^5.0.0` - Code quality and style enforcement
- `build_runner: ^2.4.7` - Code generation
- `flutter_test` - Unit and widget testing

## Common Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run on connected device
flutter run

# Run in debug mode with hot reload
flutter run --debug

# Run on specific device
flutter run -d <device-id>

# List available devices
flutter devices
```

### Building
```bash
# Build APK for Android
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle --release

# Build for iOS (requires macOS)
flutter build ios --release

# Build for web
flutter build web --release
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/ai_logic_test.dart

# Run widget tests
flutter test test/widget_test.dart
```

### Code Quality
```bash
# Analyze code for issues
flutter analyze

# Format code
dart format lib/

# Check for outdated dependencies
flutter pub outdated

# Upgrade dependencies
flutter pub upgrade
```

### Platform-Specific Setup
```bash
# Android: Clean build
cd android && ./gradlew clean && cd ..

# iOS: Clean build (macOS only)
cd ios && rm -rf Pods/ Podfile.lock && pod install && cd ..

# Clean Flutter build cache
flutter clean && flutter pub get
```

## Architecture Patterns
- **Services**: Singleton pattern for VoiceService, ContextService
- **Models**: Immutable data classes with copyWith methods
- **UI**: Stateful widgets with Provider for state management
- **Theme**: Centralized theme system with accessibility support

## Performance Considerations
- Target 60 FPS for all animations
- Glassmorphism effects optimized for mobile GPUs
- Voice processing handled asynchronously
- Chat history limited to prevent memory issues
- Lazy loading for large conversation lists

## Security & Privacy
- Voice data processed locally, not stored permanently
- User conversations encrypted in local storage
- No personal data collection beyond app functionality
- Location data approximate city-level only