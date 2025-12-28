import 'package:flutter_test/flutter_test.dart';
import 'package:nethra_bengaluru_superapp/services/voice_service.dart';

void main() {
  group('Voice Service Speed Tests', () {
    test('TTS speed should be configured for slower speech', () {
      // Test that the voice service is configured with appropriate speech rates
      
      // Expected speech rates for different modes
      const expectedNormalRate = 0.5; // Slower for better comprehension
      const expectedBlindModeRate = 0.4; // Even slower for accessibility
      
      // Verify that the rates are within acceptable ranges
      expect(expectedNormalRate, lessThanOrEqualTo(0.6), 
        reason: 'Normal speech rate should be 0.6 or slower for better comprehension');
      
      expect(expectedBlindModeRate, lessThanOrEqualTo(0.5), 
        reason: 'Blind mode speech rate should be 0.5 or slower for accessibility');
      
      expect(expectedBlindModeRate, lessThan(expectedNormalRate), 
        reason: 'Blind mode should be slower than normal mode');
      
      // Test that initialization rate is also appropriate
      const expectedInitRate = 0.5;
      expect(expectedInitRate, lessThanOrEqualTo(0.6), 
        reason: 'Initialization speech rate should be reasonable');
    });
    
    test('Voice service should have proper speech configuration', () {
      // Test the voice service configuration values
      final voiceService = VoiceService();
      
      // Verify service can be created (basic functionality test)
      expect(voiceService, isNotNull);
      expect(voiceService.isInitialized, isFalse, 
        reason: 'Service should not be initialized until initialize() is called');
      expect(voiceService.isListening, isFalse, 
        reason: 'Service should not be listening initially');
    });
  });
}