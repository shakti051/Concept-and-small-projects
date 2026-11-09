package com.example.recipe_app_sdk

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity() {

    private val CHANNEL = "com.example.recipe_app_sdk/recipe"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "getCategories" -> {

                    CoroutineScope(Dispatchers.IO).launch {

                        try {
                            // Call Kotlin Retrofit API
                            val response = recipeService.getCategories()

                            // Convert Kotlin objects into Flutter-compatible data
                            val categories = response.categories.map { category ->

                                mapOf(
                                    "idCategory" to category.idCategory,
                                    "strCategory" to category.strCategory,
                                    "strCategoryThumb" to category.strCategoryThumb,
                                    "strCategoryDescription" to category.strCategoryDescription
                                )
                            }

                            // Return response on main thread
                            withContext(Dispatchers.Main) {
                                result.success(categories)
                            }

                        } catch (e: Exception) {

                            withContext(Dispatchers.Main) {
                                result.error(
                                    "API_ERROR",
                                    e.message,
                                    null
                                )
                            }
                        }
                    }
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}