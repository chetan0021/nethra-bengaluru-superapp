import 'package:flutter_test/flutter_test.dart';
import 'package:logging/logging.dart';
import 'package:nethra_bengaluru_superapp/services/voice_service.dart';

void main() {
  group('VoiceService STT Optimization Tests', () {
    setUpAll(() {
      // Initialize Flutter bindings for platform channels
      TestWidgetsFlutterBinding.ensureInitialized();
      
      // Configure logging for tests
      VoiceService.configureLogging(level: Level.ALL);
    });

    test('should configure logging properly', () {
      // Test that logging configuration doesn't throw errors
      expect(() => VoiceService.configureLogging(level: Level.INFO), returnsNormally);
      expect(() => VoiceService.configureLogging(level: Level.WARNING), returnsNormally);
      expect(() => VoiceService.configureLogging(level: Level.SEVERE), returnsNormally);
    });

    test('should create voice service instance', () {
      // Test that VoiceService can be instantiated
      final voiceService = VoiceService();
      expect(voiceService, isNotNull);
      expect(voiceService.isInitialized, false);
      expect(voiceService.isListening, false);
    });

    test('should handle method calls with proper parameters', () {
      final voiceService = VoiceService();
      
      // Test that the new methods exist and accept the correct parameters
      expect(() async {
        await voiceService.startListening(
          onResult: (result) {},
          onComplete: () {},
          customTimeout: const Duration(seconds: 10),
          enablePartialResults: true,
        );
      }, returnsNormally);

      expect(() async {
        await voiceService.startQuickListening(
          onResult: (result) {},
          onComplete: () {},
        );
      }, returnsNormally);

      expect(() async {
        await voiceService.startInteractiveListening(
          onResult: (result) {},
          onComplete: () {},
          onPartialResult: (partial) {},
        );
      }, returnsNormally);
    });

    test('should handle stopListening gracefully', () async {
      final voiceService = VoiceService();
      // Test that stopListening doesn't throw when not listening
      expect(() => voiceService.stopListening(), returnsNormally);
    });

    test('should dispose resources properly', () async {
      final voiceService = VoiceService();
      // Test that dispose doesn't throw errors
      expect(() => voiceService.dispose(), returnsNormally);
      
      // Wait a bit to ensure any async operations complete
      await Future.delayed(const Duration(milliseconds: 100));
    });
  });

  group('HapticPatterns Tests', () {
    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should execute haptic patterns without errors', () async {
      // Test that all haptic patterns can be called without errors
      expect(() => HapticPatterns.lightTap(), returnsNormally);
      expect(() => HapticPatterns.voiceActivation(), returnsNormally);
      expect(() => HapticPatterns.errorAlert(), returnsNormally);
      expect(() => HapticPatterns.success(), returnsNormally);
      expect(() => HapticPatterns.recordingStart(), returnsNormally);
      expect(() => HapticPatterns.recordingStop(), returnsNormally);
    });
  });
}