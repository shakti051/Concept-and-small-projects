import 'package:get/get.dart';
import 'package:mvvm_getx/counter_model.dart';

class CounterViewModel extends GetxController {
  final _model = CounterModel(0);

  var count = 0.obs;

  @override
  void onInit() {
    count.value = _model.count;
    super.onInit();
  }

  void increment() {
    _model.count++;
    count.value = _model.count;
  }
}
