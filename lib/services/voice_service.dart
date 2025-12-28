import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logging/logging.dart';

/// Haptic feedback patterns for different interactions
class HapticPatterns {
  static final Logger _logger = Logger('HapticPatterns');

  /// Light haptic for button presses and UI interactions
  static Future<void> lightTap() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Haptic feedback might not be available on all devices
      _logger.fine('Haptic feedback not available: $e');
    }
  }

  /// Medium haptic for voice activation and important actions
  static Future<void> voiceActivation() async {
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      _logger.fine('Haptic feedback not available: $e');
    }
  }

  /// Heavy haptic for errors, alerts, and critical feedback
  static Future<void> errorAlert() async {
    try {
      await HapticFeedback.heavyImpact();
      // Double tap pattern for errors
      await Future.delayed(const Duration(milliseconds: 100));
      await HapticFeedback.heavyImpact();
    } catch (e) {
      _logger.fine('Haptic feedback not available: $e');
    }
  }

  /// Success pattern - light double tap
  static Future<void> success() async {
    try {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 80));
      await HapticFeedback.lightImpact();
    } catch (e) {
      _logger.fine('Haptic feedback not available: $e');
    }
  }

  /// Voice recording start pattern
  static Future<void> recordingStart() async {
    try {
      await HapticFeedback.mediumImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.lightImpact();
    } catch (e) {
      _logger.fine('Haptic feedback not available: $e');
    }
  }

  /// Voice recording stop pattern
  static Future<void> recordingStop() async {
    try {
      await HapticFeedback.lightImpact();
      await Future.delayed(const Duration(milliseconds: 50));
      await HapticFeedback.mediumImpact();
    } catch (e) {
      _logger.fine('Haptic feedback not available: $e');
    }
  }
}

/// Voice Service - Handles Speech-to-Text and Text-to-Speech
class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;
  VoiceService._internal();

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  final Logger _logger = Logger('VoiceService');
  
  bool _isListening = false;
  bool _isInitialized = false;
  
  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;

  /// Initialize voice services
  Future<bool> initialize() async {
    try {
      // Request microphone permission
      final permission = await Permission.microphone.request();
      if (permission != PermissionStatus.granted) {
        _logger.warning('Microphone permission denied');
        return false;
      }

      // Initialize Speech-to-Text with enhanced error handling
      final sttAvailable = await _speechToText.initialize(
        onError: (error) {
          _logger.severe('STT Error: ${error.errorMsg}');
        },
        onStatus: (status) {
          _logger.info('STT Status: $status');
        },
      );

      // Initialize Text-to-Speech with slower, more natural speech
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5); // Slower default rate for better comprehension
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);

      _isInitialized = sttAvailable;
      _logger.info('Voice service initialized: $_isInitialized');
      return _isInitialized;
    } catch (e) {
      _logger.severe('Voice service initialization error: $e');
      return false;
    }
  }

  /// Start listening for speech with optimized SpeechListenOptions
  Future<void> startListening({
    required Function(String) onResult,
    required Function() onComplete,
    Duration? customTimeout,
    bool enablePartialResults = false,
  }) async {
    if (!_isInitialized || _isListening) {
      _logger.warning('Cannot start listening: initialized=$_isInitialized, listening=$_isListening');
      return;
    }

    try {
      // Enhanced haptic feedback for voice activation
      await HapticPatterns.recordingStart();
      
      _isListening = true;
      _logger.info('Starting speech recognition with optimized settings');
      
      await _speechToText.listen(
        onResult: (result) {
          _logger.fine('STT Result: ${result.recognizedWords} (confidence: ${result.confidence})');
          
          // Handle partial results for real-time feedback
          if (enablePartialResults && !result.finalResult) {
            // Provide partial result callback if needed
            // This can be used for real-time UI updates
            return;
          }
          
          // Handle final results
          if (result.finalResult) {
            // Success haptic when speech is recognized
            HapticPatterns.success();
            
            // Validate result confidence for better accuracy
            if (result.confidence > 0.3) { // Lowered threshold for Indian English
              _logger.info('Speech recognized with confidence: ${result.confidence}');
              onResult(result.recognizedWords);
            } else {
              _logger.warning('Low confidence result: ${result.confidence}');
              // Still pass the result but log the low confidence
              onResult(result.recognizedWords);
            }
            onComplete();
          }
        },
        // Enhanced STT configuration for better control
        listenFor: customTimeout ?? const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 2), // Reduced from 3s for faster response
        localeId: 'en_IN', // Indian English for better local accent recognition
        // Use SpeechListenOptions for modern API configuration
        listenOptions: SpeechListenOptions(
          partialResults: enablePartialResults, // Allow partial results for real-time feedback
          onDevice: false, // Use cloud STT for better accuracy (when available)
          cancelOnError: true, // Cancel on error for clean state
        ),
      );
      
      _logger.info('Speech recognition started successfully');
      
    } catch (e) {
      _logger.severe('Start listening error: $e');
      // Error haptic feedback
      await HapticPatterns.errorAlert();
      _isListening = false;
      onComplete();
    }
  }

  /// Start listening for quick voice commands with shorter timeout
  Future<void> startQuickListening({
    required Function(String) onResult,
    required Function() onComplete,
  }) async {
    await startListening(
      onResult: onResult,
      onComplete: onComplete,
      customTimeout: const Duration(seconds: 15), // Shorter timeout for quick commands
      enablePartialResults: false, // Disable for quick commands to avoid noise
    );
  }

  /// Start listening with real-time partial results for interactive scenarios
  Future<void> startInteractiveListening({
    required Function(String) onResult,
    required Function() onComplete,
    Function(String)? onPartialResult,
  }) async {
    await startListening(
      onResult: onResult,
      onComplete: onComplete,
      customTimeout: const Duration(seconds: 45), // Longer timeout for interactive mode
      enablePartialResults: true, // Enable partial results for real-time feedback
    );
  }
  /// Stop listening
  Future<void> stopListening() async {
    if (!_isListening) {
      _logger.fine('Stop listening called but not currently listening');
      return;
    }
    
    try {
      await _speechToText.stop();
      _isListening = false;
      _logger.info('Speech recognition stopped successfully');
      // Enhanced haptic feedback for stopping
      await HapticPatterns.recordingStop();
    } catch (e) {
      _logger.severe('Stop listening error: $e');
      // Error haptic if stop fails
      await HapticPatterns.errorAlert();
    }
  }

  /// Speak text - now works for all modes, with enhanced experience for blind mode
  Future<void> speak(String text, {bool isBlindMode = false}) async {
    try {
      // Stop any current speech first
      await _flutterTts.stop();
      
      // Wait a moment before starting new speech
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Configure TTS based on mode with optimized settings
      if (isBlindMode) {
        // Optimized for accessibility - slower, clearer, more detailed
        await _flutterTts.setLanguage('en-IN'); // Indian English if available
        await _flutterTts.setSpeechRate(0.4); // Slower for better comprehension
        await _flutterTts.setVolume(0.95); // Higher volume for accessibility
        await _flutterTts.setPitch(0.95); // Slightly lower pitch for clarity
        
        // Set additional accessibility options if available
        try {
          await _flutterTts.awaitSpeakCompletion(true);
        } catch (e) {
          // Ignore if not supported on platform
        }
      } else {
        // Standard voice for regular use - slower and more natural
        await _flutterTts.setLanguage('en-IN'); // Indian English if available
        await _flutterTts.setSpeechRate(0.5); // Slower for better understanding
        await _flutterTts.setVolume(0.85);
        await _flutterTts.setPitch(1.0);
      }
      
      // Clean and enhance text for TTS
      final cleanText = _cleanTextForTTS(text);
      final enhancedText = isBlindMode ? _enhanceForLocalGuide(cleanText) : cleanText;
      
      _logger.fine('TTS Speaking: $enhancedText');
      
      // Speak with appropriate method
      if (isBlindMode) {
        await _speakWithPausesEnhanced(enhancedText);
      } else {
        await _flutterTts.speak(enhancedText);
      }
      
    } catch (e) {
      _logger.severe('TTS error: $e');
    }
  }

  /// Speak text with natural pauses for better comprehension (enhanced version)
  Future<void> _speakWithPausesEnhanced(String text) async {
    // Split text into sentences for natural pauses
    final sentences = text.split(RegExp(r'[.!?]+'));
    
    for (int i = 0; i < sentences.length; i++) {
      final sentence = sentences[i].trim();
      if (sentence.isNotEmpty) {
        // Add breathing room before important information
        if (sentence.contains('Important') || sentence.contains('Warning') || sentence.contains('Alert')) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
        
        await _flutterTts.speak(sentence);
        
        // Calculate dynamic pause based on sentence complexity
        final baseDelay = sentence.length * 45; // Slightly faster base rate
        final complexityBonus = _calculateComplexityBonus(sentence);
        final totalDelay = baseDelay + complexityBonus + 400; // Minimum 400ms
        
        await Future.delayed(Duration(milliseconds: totalDelay));
        
        // Add longer pause between sentences for better comprehension
        if (i < sentences.length - 1) {
          await Future.delayed(const Duration(milliseconds: 900));
        }
      }
    }
  }

  /// Calculate additional pause time based on sentence complexity
  int _calculateComplexityBonus(String sentence) {
    int bonus = 0;
    
    // Add pause for numbers and addresses
    if (RegExp(r'\d+').hasMatch(sentence)) {
      bonus += 200;
    }
    
    // Add pause for location names
    if (sentence.contains('Road') || sentence.contains('Street') || sentence.contains('Metro')) {
      bonus += 150;
    }
    
    // Add pause for time-related information
    if (sentence.contains('minutes') || sentence.contains('hours') || sentence.contains('PM') || sentence.contains('AM')) {
      bonus += 100;
    }
    
    return bonus;
  }

  /// Clean text for TTS (remove emojis and markdown) - enhanced version
  String _cleanTextForTTS(String text) {
    return text
        .replaceAll(RegExp(r'[^\w\s\.,!?-]'), '') // Remove emojis and special chars
        .replaceAll(RegExp(r'\*+'), '') // Remove markdown asterisks
        .replaceAll(RegExp(r'#+'), '') // Remove markdown headers
        .replaceAll('boss', 'friend') // Make it more TTS friendly
        .replaceAll('Ayyo', 'Oh no') // Convert local slang for TTS
        .replaceAll('Namma', 'Our') // Convert local terms
        .replaceAll('macha', 'friend') // Convert local slang
        .replaceAll('guru', 'friend') // Convert local slang
        .replaceAll('ORR', 'Outer Ring Road') // Expand abbreviations
        .replaceAll('KR Puram', 'K R Puram') // Better pronunciation
        .replaceAll('HSR', 'H S R Layout') // Expand abbreviations
        .replaceAll('BTM', 'B T M Layout') // Expand abbreviations
        .replaceAll('JP Nagar', 'J P Nagar') // Better pronunciation
        .replaceAll('MG Road', 'Mahatma Gandhi Road') // Full form for clarity
        .replaceAll('UB City', 'U B City Mall') // Better context
        .trim();
  }

  /// Enhance text with local guide personality for TTS (enhanced version)
  String _enhanceForLocalGuide(String text) {
    // Add friendly local guide intro for TTS
    if (text.contains('Welcome') || text.contains('Namaste')) {
      return 'Hello there! $text I am Nethra, your personal Bengaluru guide. I am here to help you navigate our beautiful city with care and local knowledge.';
    }
    
    if (text.contains('Blind mode activated') || text.contains('Accessibility')) {
      return 'Accessibility mode is now active. I am Nethra, your personal Bengaluru guide. I will speak all my responses clearly and provide detailed descriptions to help you. Feel free to ask me about traffic conditions, local food recommendations, directions, or anything about our wonderful city.';
    }
    
    // Add local context for better TTS experience
    if (text.contains('rain') || text.contains('weather')) {
      return 'Important weather update from your local guide. $text Please prioritize your safety during travel. I recommend checking current conditions before heading out.';
    }
    
    if (text.contains('traffic')) {
      return 'Traffic advisory from your Bengaluru guide. $text I recommend these alternatives based on current conditions and my local knowledge.';
    }
    
    if (text.contains('food') || text.contains('restaurant')) {
      return 'Local food recommendation from your guide. $text These are authentic places that locals have loved for years. I can provide more details if needed.';
    }
    
    // Enhanced responses for common queries
    if (text.contains('Metro') || text.contains('Namma Metro')) {
      return 'Metro information from your local guide. $text The Namma Metro is often the most reliable option during peak hours.';
    }
    
    if (text.contains('auto') || text.contains('rickshaw')) {
      return 'Auto rickshaw guidance from your Bengaluru expert. $text Remember, auto availability can vary based on weather and time of day.';
    }
    
    // Default enhancement with natural pauses and local touch
    return 'Your Bengaluru guide here. $text I hope this information helps you navigate our city better.';
  }

  /// Configure logging level for voice service
  static void configureLogging({Level level = Level.INFO}) {
    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      // In production, you might want to use a proper logging framework
      // For now, we'll use print but with structured logging
      final timestamp = record.time.toIso8601String();
      final levelName = record.level.name;
      final loggerName = record.loggerName;
      final message = record.message;
      
      // Only print INFO and above in production, FINE and below for debug
      if (record.level >= Level.INFO) {
        // ignore: avoid_print
        print('[$timestamp] $levelName [$loggerName]: $message');
      }
    });
  }

  /// Dispose resources
  void dispose() {
    try {
      _speechToText.cancel();
      _flutterTts.stop();
      _logger.info('Voice service disposed');
    } catch (e) {
      // Platform methods may not be available in test environment
      _logger.warning('Error during dispose (may be expected in tests): $e');
    }
  }
}