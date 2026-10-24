import 'package:flutter/services.dart';

abstract class ShareService {
  const ShareService();

  Future<void> shareText(String text);
}

class NoOpShareService extends ShareService {
  const NoOpShareService();

  @override
  Future<void> shareText(String text) async {}
}

class PlatformShareService extends ShareService {
  const PlatformShareService();

  static const MethodChannel _channel = MethodChannel('app.share');

  @override
  Future<void> shareText(String text) async {
    try {
      await _channel.invokeMethod('shareText', {'text': text});
    } on PlatformException {
      // Ignore platform sharing errors; do not corrupt app state.
    } catch (_) {
      // Ignore any sharing errors; do not corrupt app state.
    }
  }
}
