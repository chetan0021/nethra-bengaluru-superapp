import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/live_context.dart';

class AILogic {
  static final String _apiKey = 'AIzaSyAts3V2Abyp9_qx4EmqZU5ape3lv4sTGD8';
  static GenerativeModel? _model;
  static String _steeringContent = '';
  static bool _isInitialized = false;

  // Backup steering content if product.md fails to load
  static const String _backupSteering = '''
You are Nethra, "Namma Guide" - a voice-first AI assistant for Bengaluru. You're a friendly, slightly cynical local who knows the city better than Google Maps.

CORE IDENTITY:
- Name: Nethra / Namma Guide
- Vibe: Helpful but sarcastic. Loves the city but hates the traffic.
- Language: Mix English with local terms ("Tanglish"/"Kanglish")
- Catchphrases: "Macha", "Guru", "Scene", "Adjust maadi", "Bombat"

RESPONSE INTELLIGENCE:
1. ANALYZE THE QUERY FIRST - What is the user actually asking about?
2. Apply context only when relevant:
   - Rain warnings ONLY for travel queries (metro, auto, bus, go to, reach)
   - Traffic advice ONLY for peak hour travel to problem areas
   - Food recommendations ONLY when asked about food
   - General conversation for greetings and casual questions

RESPONSE RULES:
- Keep responses SHORT (1-2 sentences max) for voice consumption
- Use local personality but be contextually appropriate
- Don't force rain warnings on non-travel questions
- Heritage establishments over chains for food
- Be a helpful local friend, not a broken record
''';

  /// Initialize the AI model and load steering content
  static Future<void> initModel() async {
    try {
      debugPrint('🧠 Initializing Gemini AI Model...');
      
      // Load steering content from assets first
      await _loadSteeringContent();
      
      // Initialize Gemini model with gemini-2.0-flash-exp (latest experimental)
      _model = GenerativeModel(
        model: 'gemini-2.0-flash-exp',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          topK: 40,
          topP: 0.95,
          maxOutputTokens: 150, // Keep responses short for voice
        ),
      );
      
      _isInitialized = true;
      debugPrint('✅ Gemini AI Model initialized successfully with gemini-2.0-flash-exp');
      
    } catch (e) {
      debugPrint('❌ Failed to initialize AI Model: $e');
      // Use backup steering if initialization fails
      _steeringContent = _backupSteering;
      _isInitialized = true;
    }
  }

  /// Load steering content from product.md
  static Future<void> _loadSteeringContent() async {
    try {
      debugPrint('📄 Loading steering content from assets/product.md...');
      _steeringContent = await rootBundle.loadString('assets/product.md');
      debugPrint('✅ LOADED STEERING FILE');
    } catch (e) {
      debugPrint('⚠️ FILE ERROR. USING BACKUP.');
      debugPrint('Error details: $e');
      _steeringContent = _backupSteering;
    }
  }

  /// Get AI response using Google Gemini - FORCES LIVE API CALL
  static Future<String> getResponse(String userQuery, LiveContext context) async {
    if (!_isInitialized || _model == null) {
      return "AI Model not initialized. Error: Model is null or not initialized.";
    }

    try {
      // Construct the prompt exactly as specified
      final prompt = '''SYSTEM: $_steeringContent

CONTEXT: ${_formatContext(context)}

USER: $userQuery''';
      
      debugPrint('🧠 Sending to Gemini API...');
      debugPrint('📝 Full Prompt: $prompt');
      
      // CRITICAL: MUST await the actual API call - NO FALLBACK TO MOCK
      final content = [Content.text(prompt)];
      final response = await _model!.generateContent(content);
      
      final aiResponse = response.text?.trim();
      
      if (aiResponse == null || aiResponse.isEmpty) {
        debugPrint('❌ Empty response from Gemini API');
        return "API Error: Empty response from Gemini";
      }
      
      debugPrint('✅ Received from Gemini: $aiResponse');
      return aiResponse;
      
    } catch (e) {
      // CRITICAL: Return the specific error for debugging, NOT a generic greeting
      debugPrint('❌ GEMINI API ERROR: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Error details: ${e.toString()}');
      
      // Return the actual error so we can debug it
      return "API Error: ${e.toString()}";
    }
  }

  /// Format context for the prompt
  static String _formatContext(LiveContext context) {
    return '''
Current Time: ${context.formattedTime}
Weather: ${context.weather.displayName}
Location: ${context.userLocation}
Peak Hour: ${context.isPeakHour}
Is Wet Weather: ${context.weather.isWet}
Blind Mode: ${context.isBlindMode}''';
  }

  /// Check if the AI model is initialized
  static bool get isInitialized => _isInitialized;

  /// Get current steering content (for debugging)
  static String get steeringContent => _steeringContent;
}