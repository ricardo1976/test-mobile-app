import 'package:share_plus/share_plus.dart';

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

  @override
  Future<void> shareText(String text) async {
    try {
      await Share.share(text);
    } catch (_) {
      // Ignore any sharing errors; do not corrupt app state.
    }
  }
}

