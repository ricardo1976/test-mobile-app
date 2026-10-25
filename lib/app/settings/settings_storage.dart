import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class SettingsStorage {
  SettingsStorage(this.file);

  final File file;

  Future<bool> isOnboardingCompleted() async {
    if (!await file.exists()) {
      return false;
    }
    try {
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return false;
      }
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return json['onboardingCompleted'] == true;
    } catch (_) {
      return false;
    }
  }

  Future<void> setOnboardingCompleted() async {
    try {
      final dir = file.parent;
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final json = <String, dynamic>{'onboardingCompleted': true};
      await file.writeAsString(jsonEncode(json));
    } catch (_) {
      // Ignore storage errors; do not block app usage.
    }
  }

  static Future<File> defaultFile() async {
    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}/settings.json');
  }
}
