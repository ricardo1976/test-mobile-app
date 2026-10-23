import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDependencies.create();
  runApp(const CuantoRecuerdasApp());
}
