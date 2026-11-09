package com.example.flutter_counter_sdk

class CounterSdk {

    private var count = 0

    fun increment(): Int {
        count++
        return count
    }

    fun decrement(): Int {
        count--
        return count
    }

    fun getCount(): Int {
        return count
    }
}