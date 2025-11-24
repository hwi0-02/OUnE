import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for managing the current bottom navigation tab index
final homeTabIndexProvider = StateProvider<int>((ref) => 0);
