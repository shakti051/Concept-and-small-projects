import 'package:flutter/services.dart';

class CounterService {
  static const MethodChannel _channel = MethodChannel(
    'com.example.flutter_counter_sdk/counter',
  );

  Future<int> increment() async {
    final int result = await _channel.invokeMethod('increment');
    return result;
  }

  Future<int> decrement() async {
    final int result = await _channel.invokeMethod('decrement');
    return result;
  }

  Future<int> getCount() async {
    final int result = await _channel.invokeMethod('getCount');
    return result;
  }
}