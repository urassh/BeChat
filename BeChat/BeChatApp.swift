//
//  BeChatApp.swift
//  BeChat
//
//  Created by 浦山秀斗 on 2024/08/05.
//

import FirebaseCore
import SwiftUI
import Firebase
import FirebaseMessaging
import UserNotifications

@main
struct BeChatApp: App {
    init() {
        FirebaseApp.configure()
     
    }
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            LoginView()
        }
    }
}


// MARK: - AppDelegate Main
class AppDelegate: NSObject, UIApplicationDelegate, MessagingDelegate {
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
    
      Messaging.messaging().delegate = self
      UNUserNotificationCenter.current().delegate = self
      
      // Push通知許可のポップアップを表示
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, _ in
         guard granted else { return }
         DispatchQueue.main.async {
            application.registerForRemoteNotifications()
         }
      }
      return true
   }
}

// MARK: - AppDelegate Push Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let messageID = userInfo["gcm.message_id"] {
            print("MessageID: \(messageID)")
        }
        print(userInfo)
        completionHandler(.newData)
    }
    
    // アプリがForeground時にPush通知を受信する処理
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}
