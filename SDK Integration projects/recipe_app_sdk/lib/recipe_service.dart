import 'package:flutter/services.dart';

class RecipeService {
  static const MethodChannel _channel =
      MethodChannel('com.example.recipe_app_sdk/recipe');

  Future<List<dynamic>> getCategories() async {
    try {
      final List<dynamic> result =
          await _channel.invokeMethod('getCategories');

      return result;
    } on PlatformException catch (e) {
      throw Exception('Failed to fetch categories: ${e.message}');
    }
  }
}
