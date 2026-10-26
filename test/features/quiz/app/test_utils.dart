import 'dart:io';

import 'package:cuanto_recuerdas/app/settings/settings_storage.dart';

class MemorySettingsStorage extends SettingsStorage {
  MemorySettingsStorage() : super(File(''));

  bool _done = false;

  @override
  Future<bool> isOnboardingCompleted() async => _done;

  @override
  Future<void> setOnboardingCompleted() async {
    _done = true;
  }
}

SettingsStorage testSettingsStorage() => MemorySettingsStorage();
