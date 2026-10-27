package com.example.unit_converter

import kotlin.math.roundToInt

class NativeUnitConverter {
    private val conversionFactors = mapOf(
        "Centimeters" to 0.01,
        "Meters" to 1.0,
        "Feet" to 0.3048,
        "Millimeters" to 0.001
    )

    fun convert(value: Double, fromUnit: String, toUnit: String): Double {
        val fromFactor = conversionFactors[fromUnit]
            ?: throw IllegalArgumentException("Invalid source unit: $fromUnit")
        val toFactor = conversionFactors[toUnit]
            ?: throw IllegalArgumentException("Invalid target unit: $toUnit")

        val result = value * fromFactor / toFactor
        return (result * 100).roundToInt() / 100.0
    }
}
