import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GMSApiKey") as? String,
          !apiKey.isEmpty,
          !apiKey.hasPrefix("$(") else {
      fatalError("GOOGLE_MAPS_API_KEY is missing from ios/Flutter/Secrets.xcconfig")
    }
    GMSServices.provideAPIKey(apiKey)
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
