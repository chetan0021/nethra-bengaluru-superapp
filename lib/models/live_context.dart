/// Live context data for AI decision making
class LiveContext {
  final DateTime currentTime;
  final WeatherStatus weather;
  final String userLocation;
  final bool isBlindMode;
  final String? specificArea; // Bengaluru-specific areas like "Silk Board", "ORR"

  const LiveContext({
    required this.currentTime,
    required this.weather,
    required this.userLocation,
    this.isBlindMode = false,
    this.specificArea,
  });

  /// Check if current time is peak traffic hours (5 PM - 8 PM)
  bool get isPeakHour {
    final hour = currentTime.hour;
    return hour >= 17 && hour <= 20;
  }

  /// Check if it's early morning (6 AM - 9 AM)
  bool get isEarlyMorning {
    final hour = currentTime.hour;
    return hour >= 6 && hour <= 9;
  }

  /// Check if it's late night (10 PM - 6 AM)
  bool get isLateNight {
    final hour = currentTime.hour;
    return hour >= 22 || hour <= 6;
  }

  /// Get formatted time string (HH:MM)
  String get formattedTime {
    return '${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')}';
  }

  /// Create a copy with updated values
  LiveContext copyWith({
    DateTime? currentTime,
    WeatherStatus? weather,
    String? userLocation,
    bool? isBlindMode,
    String? specificArea,
  }) {
    return LiveContext(
      currentTime: currentTime ?? this.currentTime,
      weather: weather ?? this.weather,
      userLocation: userLocation ?? this.userLocation,
      isBlindMode: isBlindMode ?? this.isBlindMode,
      specificArea: specificArea ?? this.specificArea,
    );
  }

  @override
  String toString() {
    return 'LiveContext(time: $formattedTime, weather: $weather, location: $userLocation, blindMode: $isBlindMode)';
  }
}

/// Weather status enumeration
enum WeatherStatus {
  rain('Rain'),
  clear('Clear'),
  cloudy('Cloudy'),
  thunderstorm('Thunderstorm'),
  drizzle('Drizzle');

  const WeatherStatus(this.displayName);
  final String displayName;

  /// Check if weather conditions are wet (rain, drizzle, thunderstorm)
  bool get isWet => this == rain || this == drizzle || this == thunderstorm;
}

/// Chat message model for conversation history
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final MessageType type;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.type = MessageType.text,
  });

  /// Create a user message
  factory ChatMessage.user(String content) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: true,
      timestamp: DateTime.now(),
      type: MessageType.text,
    );
  }

  /// Create an assistant message
  factory ChatMessage.assistant(String content, {MessageType type = MessageType.text}) {
    return ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: content,
      isUser: false,
      timestamp: DateTime.now(),
      type: type,
    );
  }

  /// Get formatted timestamp
  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

/// Message type enumeration
enum MessageType {
  text,
  voice,
  system,
  error,
}