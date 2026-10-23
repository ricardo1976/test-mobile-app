/// Contract for an advertising service.
///
/// V0.1 uses a no-op implementation. Future implementations may provide
/// real ad delivery without changing quiz domain logic.
abstract class AdService {
  /// Initializes the advertising SDK or service.
  Future<void> initialize();

  /// Shows an interstitial ad, if available.
  Future<void> showInterstitial();
}

/// No-op implementation used by default in V0.1.
class NoOpAdService implements AdService {
  const NoOpAdService();

  @override
  Future<void> initialize() async {}

  @override
  Future<void> showInterstitial() async {}
}
