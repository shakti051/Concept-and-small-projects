import 'package:flutter/material.dart';
import 'package:mvvm_stream/app/di.dart';

import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initAppModule();
  runApp(MyApp());
}
