import 'package:flutter/widgets.dart';

import 'app/app.dart';
import 'app/dependencies.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependencies = await AppDependencies.create();
  runApp(CuantoRecuerdasApp(dependencies: dependencies));
}
