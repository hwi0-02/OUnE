import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';

/// Utility class for generating deterministic random values
/// This ensures the same input always produces the same output
class DeterministicRandom {
  /// Creates a deterministic Random instance from a string seed
  /// 
  /// Example:
  /// ```dart
  /// final random = DeterministicRandom.fromSeed('user-123-2024-01-15');
  /// final value = random.nextInt(100);
  /// ```
  static Random fromSeed(String seed) {
    final bytes = utf8.encode(seed);
    final digest = sha256.convert(bytes);
    return Random(_bytesToInt(digest.bytes.sublist(0, 8)));
  }

  /// Creates a deterministic integer hash from a date and optional identifier
  /// 
  /// Example:
  /// ```dart
  /// final hash = DeterministicRandom.fromDate(DateTime.now(), id: 'theme-move');
  /// final index = hash % 5;
  /// ```
  static int fromDate(DateTime date, {String? id}) {
    int hash = date.year * 10000 + date.month * 100 + date.day;
    if (id != null) {
      hash += id.codeUnits.fold(0, (p, c) => p + c);
    }
    return hash;
  }

  /// Creates a deterministic seed string from user ID and date
  static String createSeed(String userId, DateTime date, {String? suffix}) {
    final base = '$userId-${date.year}-${date.month}-${date.day}';
    return suffix != null ? '$base-$suffix' : base;
  }

  /// Converts a list of bytes to an integer
  static int _bytesToInt(List<int> bytes) {
    int result = 0;
    for (final byte in bytes) {
      result = (result << 8) | byte;
    }
    return result;
  }
}
