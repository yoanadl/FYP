// import Flutter
// import UIKit
// import Firebase

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//       FirebaseApp.configure()
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

// import UIKit
// import Flutter
// import FirebaseCore
// import flutter_local_notifications

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(_ application: UIApplication,
//                              didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//     FirebaseApp.configure()
    
//     // Initialize flutter_local_notifications
//     let flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin()
//     let initializationSettings = DarwinInitializationSettings()
    
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: { notificationResponse in
//         // Handle notification response
//       }
//     )
    
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }



import UIKit
import Flutter

import flutter_local_notifications

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
    GeneratedPluginRegistrant.register(with: registry)}

    GeneratedPluginRegistrant.register(with: self)

      if #available(iOS 10.0, *) {
         UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
