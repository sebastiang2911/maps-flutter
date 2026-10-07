# Maps App

## Configuration

Supply a Mapbox public access token at build time:

```sh
flutter run --dart-define=MAPBOX_ACCESS_TOKEN=your_token
```

Add the Google Maps key locally before running the app:

- Android: add `GOOGLE_MAPS_API_KEY=your_key` to `android/local.properties`.
- iOS: copy `ios/Flutter/Secrets.xcconfig.example` to
  `ios/Flutter/Secrets.xcconfig`, then replace the example value.

Do not commit access tokens. Values supplied with `--dart-define` are bundled
into the application and should therefore use a URL-restricted public token,
not a Mapbox secret token.
