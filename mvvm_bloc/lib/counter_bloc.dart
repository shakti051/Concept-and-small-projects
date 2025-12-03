import 'dart:async';
import 'package:mvvm_bloc/counter_model.dart';


class CounterViewModel {
  final CounterModel _counter = CounterModel(value: 0);

  final _counterController = StreamController<int>.broadcast();

  Stream<int> get counterStream => _counterController.stream;

  void increment() {
    _counter.value++;
    _counterController.sink.add(_counter.value);    // exposing only VALUE
  }

  void dispose() {
    _counterController.close();
  }
}
