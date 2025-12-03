import 'dart:async';
import 'package:mvc_bloc/counter_model.dart';


class CounterController {
  CounterModel counter = CounterModel(value: 0); // exposed!

  final _controller = StreamController<CounterModel>.broadcast();

  Stream<CounterModel> get counterStream => _controller.stream;

  void increment() {
    counter.value++;
    _controller.sink.add(counter); // send whole model to view
  }

  void dispose() {
    _controller.close();
  }
}
