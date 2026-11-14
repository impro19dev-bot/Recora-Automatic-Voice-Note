import AppTrackingTransparency
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let messenger = engineBridge.applicationRegistrar.messenger()

    let windowChannel = FlutterMethodChannel(
      name: "com.callrecora.automaticvoice/ump_window",
      binaryMessenger: messenger
    )
    windowChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "syncWindow":
        result(UmpPresentationAnchor.sync())
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    // ATT is its own system prompt. It does not read or write UMP consent.
    let attChannel = FlutterMethodChannel(
      name: "com.callrecora.automaticvoice/att",
      binaryMessenger: messenger
    )
    attChannel.setMethodCallHandler { call, result in
      switch call.method {
      case "status":
        result(AttPrompt.statusString())
      case "request":
        AttPrompt.request { status in
          result(status)
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}

/// Separate from Google UMP. Requests the iOS tracking prompt only once when needed.
enum AttPrompt {
  private static var inFlight = false

  static func statusString() -> String {
    guard #available(iOS 14, *) else {
      // ATT did not exist before iOS 14.
      return "authorized"
    }
    return map(ATTrackingManager.trackingAuthorizationStatus)
  }

  static func request(completion: @escaping (String) -> Void) {
    guard #available(iOS 14, *) else {
      DispatchQueue.main.async {
        completion("authorized")
      }
      return
    }

    let current = ATTrackingManager.trackingAuthorizationStatus
    // Already decided — never show the prompt again.
    if current != .notDetermined {
      DispatchQueue.main.async {
        completion(map(current))
      }
      return
    }

    if inFlight {
      // Another request is presenting; return the live status when it settles.
      DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
        completion(statusString())
      }
      return
    }

    inFlight = true
    waitUntilReadyToPresent(attempt: 0) {
      ATTrackingManager.requestTrackingAuthorization { status in
        inFlight = false
        let value = map(status)
        DispatchQueue.main.async {
          completion(value)
        }
      }
    }
  }

  /// Wait until the app is active and no other modal (e.g. UMP) is on screen.
  private static func waitUntilReadyToPresent(attempt: Int, ready: @escaping () -> Void) {
    DispatchQueue.main.async {
      let active = UIApplication.shared.applicationState == .active
      let busy = topViewController()?.presentedViewController != nil
      if active && !busy {
        // Short beat so the splash transition / UMP dismiss animation finishes.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
          let stillBusy = topViewController()?.presentedViewController != nil
          if UIApplication.shared.applicationState == .active && !stillBusy {
            ready()
          } else if attempt < 20 {
            waitUntilReadyToPresent(attempt: attempt + 1, ready: ready)
          } else {
            ready()
          }
        }
        return
      }
      if attempt < 20 {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
          waitUntilReadyToPresent(attempt: attempt + 1, ready: ready)
        }
      } else {
        ready()
      }
    }
  }

  private static func topViewController(
    base: UIViewController? = foregroundRootViewController()
  ) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(base: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      return topViewController(base: tab.selectedViewController)
    }
    if let presented = base?.presentedViewController {
      return topViewController(base: presented)
    }
    return base
  }

  private static func foregroundRootViewController() -> UIViewController? {
    return foregroundWindow()?.rootViewController
  }

  private static func foregroundWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
    if let window = scene?.windows.first(where: { $0.isKeyWindow }) {
      return window
    }
    return scene?.windows.first
  }

  @available(iOS 14, *)
  private static func map(_ status: ATTrackingManager.AuthorizationStatus) -> String {
    switch status {
    case .authorized:
      return "authorized"
    case .denied:
      return "denied"
    case .restricted:
      return "restricted"
    case .notDetermined:
      return "notDetermined"
    @unknown default:
      return "unknown"
    }
  }
}

/// google_mobile_ads presents the UMP form from
/// `UIApplication.shared.delegate.window`. This app uses UIScene, so that
/// window lives on the scene and must be mirrored before the form is shown.
enum UmpPresentationAnchor {
  @discardableResult
  static func sync() -> Bool {
    guard let appDelegate = UIApplication.shared.delegate as? FlutterAppDelegate else {
      return false
    }
    if let sceneWindow = foregroundWindow(), appDelegate.window !== sceneWindow {
      appDelegate.window = sceneWindow
    }
    return appDelegate.window?.rootViewController != nil
  }

  private static func foregroundWindow() -> UIWindow? {
    let scenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
    let scene = scenes.first { $0.activationState == .foregroundActive } ?? scenes.first
    if let window = scene?.windows.first(where: { $0.isKeyWindow }) {
      return window
    }
    return scene?.windows.first
  }
}
