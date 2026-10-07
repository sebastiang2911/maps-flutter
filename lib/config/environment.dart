abstract final class Environment {
  static const mapboxAccessToken = String.fromEnvironment(
    'MAPBOX_ACCESS_TOKEN',
  );

  static String get requiredMapboxAccessToken {
    if (mapboxAccessToken.isEmpty) {
      throw StateError(
        'MAPBOX_ACCESS_TOKEN is missing. Pass it with '
        '--dart-define=MAPBOX_ACCESS_TOKEN=<token>.',
      );
    }
    return mapboxAccessToken;
  }
}
