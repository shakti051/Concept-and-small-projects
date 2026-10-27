//package com.example.shopping_list_flutter

//import io.flutter.embedding.android.FlutterActivity

//class MainActivity : FlutterActivity()

package com.example.shopping_list_flutter

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channelName = "com.example.shoppinglist/native"

    private val shoppingItems =
        mutableListOf<Map<String, Any>>()

    private var nextId = 1

    override fun configureFlutterEngine(
        flutterEngine: FlutterEngine
    ) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName
        ).setMethodCallHandler { call, result ->

            when (call.method) {

                "getItems" -> {
                    result.success(shoppingItems.toList())
                }

                "addItem" -> {
                    val name =
                        call.argument<String>("name")?.trim()

                    val quantity =
                        call.argument<Int>("quantity")

                    if (name.isNullOrBlank() ||
                        quantity == null || quantity <= 0
                    ) {
                        result.error(
                            "INVALID_INPUT",
                            "Name and positive quantity are required",
                            null
                        )
                    } else {
                        val item = mapOf(
                            "id" to nextId++,
                            "name" to name,
                            "quantity" to quantity
                        )

                        shoppingItems.add(item)
                        result.success(item)
                    }
                }

                "editItem" -> {
                    val id = call.argument<Int>("id")
                    val name =
                        call.argument<String>("name")?.trim()
                    val quantity =
                        call.argument<Int>("quantity")

                    val index =
                        shoppingItems.indexOfFirst {
                            it["id"] == id
                        }

                    if (id == null ||
                        name.isNullOrBlank() ||
                        quantity == null || quantity <= 0
                    ) {
                        result.error(
                            "INVALID_INPUT",
                            "Valid item details are required",
                            null
                        )
                    } else if (index == -1) {
                        result.error(
                            "NOT_FOUND",
                            "Shopping item not found",
                            null
                        )
                    } else {
                        val updatedItem = mapOf(
                            "id" to id,
                            "name" to name,
                            "quantity" to quantity
                        )

                        shoppingItems[index] = updatedItem
                        result.success(updatedItem)
                    }
                }

                "deleteItem" -> {
                    val id = call.argument<Int>("id")

                    val removed = shoppingItems.removeAll {
                        it["id"] == id
                    }

                    result.success(removed)
                }

                else -> result.notImplemented()
            }
        }
    }
}
