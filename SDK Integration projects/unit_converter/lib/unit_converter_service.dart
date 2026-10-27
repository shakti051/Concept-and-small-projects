import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class UnitConverterService {
  static const MethodChannel _channel =
      MethodChannel('unit_converter');

  static const Map<String, double> _factors = {
    'Centimeters': 0.01,
    'Meters': 1.0,
    'Feet': 0.3048,
    'Millimeters': 0.001,
  };

  static Future<double> convert({
    required double value,
    required String from,
    required String to,
  }) async {
    if (kIsWeb) {
      final fromFactor = _factors[from];
      final toFactor = _factors[to];

      if (fromFactor == null || toFactor == null) {
        throw ArgumentError('Unsupported unit');
      }

      final result = value * fromFactor / toFactor;
      return (result * 100).roundToDouble() / 100;
    }

    final result = await _channel.invokeMethod<num>(
      'convert',
      {
        'value': value,
        'from': from,
        'to': to,
      },
    );

    if (result == null) {
      throw PlatformException(
        code: 'EMPTY_RESULT',
        message: 'Native converter returned no result',
      );
    }

    return result.toDouble();
  }
}
