import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'unit_converter_service.dart';

void main() {
  runApp(const UnitConverterApp());
}

class UnitConverterApp extends StatelessWidget {
  const UnitConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF5267E8);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seed),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E5EF)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE2E5EF)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: seed, width: 1.6),
          ),
        ),
      ),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  
  static const List<String> _units = [
    'Centimeters',
    'Meters',
    'Feet',
    'Millimeters',
  ];

  final TextEditingController _valueController = TextEditingController(
    text: '100',
  );

  String _fromUnit = 'Centimeters';
  String _toUnit = 'Meters';
  String? _resultText;
  String? _errorText;
  bool _isConverting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _convert());
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  Future<void> _convert() async {
    final rawValue = _valueController.text.trim();
    final value = double.tryParse(rawValue);

    if (rawValue.isEmpty || value == null || !value.isFinite) {
      setState(() {
        _resultText = null;
        _errorText = 'Enter a valid number to convert.';
        _isConverting = false;
      });
      return;
    }

    setState(() {
      _isConverting = true;
      _errorText = null;
    });

    try {
      // Uses Dart on Web and native Kotlin on Android.
      final result = await UnitConverterService.convert(
        value: value,
        from: _fromUnit,
        to: _toUnit,
      );

      if (!mounted) return;

      setState(() {
        _resultText = _formatNumber(result);
        _errorText = null;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;

      setState(() {
        _resultText = null;
        _errorText = e.message ?? 'Conversion failed.';
      });
    } on ArgumentError catch (e) {
      if (!mounted) return;

      setState(() {
        _resultText = null;
        _errorText = e.message.toString();
      });
    } on MissingPluginException {
      if (!mounted) return;

      setState(() {
        _resultText = null;
        _errorText = 'Native MethodChannel is not configured.';
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _resultText = null;
        _errorText = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _isConverting = false);
      }
    }
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) return value.toInt().toString();
    return value.toStringAsFixed(2).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  void _swapUnits() {
    setState(() {
      final oldFrom = _fromUnit;
      _fromUnit = _toUnit;
      _toUnit = oldFrom;
    });
    _convert();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F7FB),
        title: const Text(
          'Unit Converter',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF5267E8), Color(0xFF7C68E8)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.straighten_rounded,
                          color: Colors.white,
                          size: 34,
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Convert with confidence',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            height: 1.15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Length conversions powered by native Kotlin.',
                          style: TextStyle(
                            color: Color(0xFFE9EBFF),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'INPUT VALUE',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Color(0xFF73798D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _valueController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _convert(),
                    decoration: const InputDecoration(
                      hintText: 'Enter a value',
                      prefixIcon: Icon(Icons.edit_outlined),
                    ),
                    onChanged: (_) {
                      setState(() {
                        _errorText = null;
                        _resultText = null;
                      });
                    },
                  ),
                  const SizedBox(height: 22),
                  const Text(
                    'CONVERT UNITS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: Color(0xFF73798D),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _unitDropdown(_fromUnit, (value) {
                          if (value == null) return;
                          setState(() => _fromUnit = value);
                          _convert();
                        }),
                      ),
                      const SizedBox(width: 8),
                      Material(
                        color: colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(14),
                        child: IconButton(
                          tooltip: 'Swap units',
                          onPressed: _swapUnits,
                          icon: const Icon(Icons.swap_horiz_rounded),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _unitDropdown(_toUnit, (value) {
                          if (value == null) return;
                          setState(() => _toUnit = value);
                          _convert();
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: FilledButton.icon(
                      onPressed: _isConverting ? null : _convert,
                      icon: _isConverting
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.sync_alt_rounded),
                      label: Text(
                        _isConverting ? 'Converting…' : 'Convert',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE6E8F1)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A172044),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline_rounded,
                              color: Color(0xFF5267E8),
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'CONVERSION RESULT',
                              style: TextStyle(
                                fontSize: 12,
                                letterSpacing: 1.1,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF73798D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        if (_errorText != null)
                          Text(
                            _errorText!,
                            style: const TextStyle(
                              color: Color(0xFFB3261E),
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        else if (_resultText == null)
                          const Text(
                            'Your result will appear here.',
                            style: TextStyle(color: Color(0xFF73798D)),
                          )
                        else ...[
                          Text(
                            _resultText!,
                            style: const TextStyle(
                              fontSize: 38,
                              height: 1.1,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF20243A),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_fromUnit  →  $_toUnit',
                            style: const TextStyle(
                              color: Color(0xFF73798D),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  Center(
                    child: Text(
                      kIsWeb
                          ? 'Calculations handled by Dart (Web)'
                          : 'Calculations handled by native Android (Kotlin)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Color(0xFF858B9D)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _unitDropdown(String selected, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      initialValue: selected,
      isExpanded: true,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      items: _units
          .map(
            (unit) => DropdownMenuItem<String>(
              value: unit,
              child: Text(
                unit,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
