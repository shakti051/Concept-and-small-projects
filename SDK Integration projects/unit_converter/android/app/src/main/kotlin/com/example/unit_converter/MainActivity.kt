package com.example.unit_converter


import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channelName = "unit_converter"
    private val converter = NativeUnitConverter()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "convert" -> {
                    try {
                        val value = call.argument<Number>("value")
                            ?.toDouble()
                            ?: throw IllegalArgumentException("Value is required")
                        val from = call.argument<String>("from")
                            ?: throw IllegalArgumentException("Source unit is required")
                        val to = call.argument<String>("to")
                            ?: throw IllegalArgumentException("Target unit is required")

                        result.success(converter.convert(value, from, to))
                    } catch (e: Exception) {
                        result.error("CONVERSION_ERROR", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
