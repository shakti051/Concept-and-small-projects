package com.example.flutter_counter_sdk

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.flutter_counter_sdk/counter"

    private lateinit var counterSdk: CounterSdk

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        counterSdk = CounterSdk()

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "increment" -> {
                    result.success(counterSdk.increment())
                }

                "decrement" -> {
                    result.success(counterSdk.decrement())
                }

                "getCount" -> {
                    result.success(counterSdk.getCount())
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}