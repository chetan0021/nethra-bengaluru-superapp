import 'package:flutter_test/flutter_test.dart';

void main() {
  group('First Group', () {
    test('First Test', () {
      expect(1 + 1, equals(2));
    });
  });

  group('Second Group', () {
    test('Second Test', () {
      expect(2 + 2, equals(4));
    });
  });
}