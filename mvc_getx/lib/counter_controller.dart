import 'package:get/get.dart';
import 'package:mvc_getx/counter_model.dart';


class CounterController extends GetxController {
  var model = CounterModel(0).obs;

  void increment() {
    model.update((val) {
      val!.count++;
    });
  }
}
