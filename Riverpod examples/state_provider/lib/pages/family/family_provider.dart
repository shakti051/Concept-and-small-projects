import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

final familyCounterProvider = 
    StateProvider.family<int, int>((ref, initialValue) {
  ref.onDispose(() {
    print('[familyCounterProvider($initialValue)] disposed');
  });
  return initialValue;
});