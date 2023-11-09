//
//  AppDelegate.swift
//  Pomodoro
//
//  Created by 전여훈 on 2023/11/02.
//  Copyright © 2023 io.hgu. All rights reserved.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    let unNotificationCenter = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            // alert - 알림이 화면에 노출
            // sound - 소리
            // badge - 빨간색 동그라미 숫자
            options: [.alert, .sound, .badge],
            completionHandler: { granted, _ in
                print("granted notification, \(granted)")
            }
        )

//        let unAuthOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
//
//        Task {
//            try? await UNUserNotificationCenter
//                .current()
//                .requestAuthorization(options: unAuthOptions)
//        }

        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}

// AppDelegate에 UNUserNotificationCenterDelegate 프로토콜을 채택하여 알림이 도착했을 때의 동작을 정의합니다.
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        if let customData = userInfo["data"] as? String {
            print("Custom data received: \(customData)")

            switch response.actionIdentifier {
            case UNNotificationDefaultActionIdentifier:
                print("Defualt identifier")
            case "show":
                print("show more information...")
            default:
                break
            }
            completionHandler()
        }
    }

    // 이 메서드는 앱이 포그라운드에 있을 때 알림이 도착하면 호출됩니다. .badge, .banner, .list 옵션을 통해 알림이 어떻게 표시될지를 결정합니다.
    // Foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

        completionHandler([.badge, .banner, .list])
    }
}
