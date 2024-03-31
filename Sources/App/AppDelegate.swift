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
    let pomodoroTimeManager = PomodoroTimeManager.shared

    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self

        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge],
            completionHandler: { _, _ in }
        )
        
        if let defaultFont = UIFont(name: "BMHANNA11yrsoldOTF", size: 17) {
            let attributes = [NSAttributedString.Key.font: defaultFont]
            UINavigationBar.appearance().titleTextAttributes = attributes
        }

        pomodoroTimeManager.restoreTimerInfo()
        return true
    }

    func applicationWillTerminate(_: UIApplication) {
        pomodoroTimeManager.saveTimerInfo()
    }

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _: UIApplication,
        didDiscardSceneSessions _: Set<UISceneSession>
    ) {}
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive _: UNNotificationResponse,
        withCompletionHandler _: @escaping () -> Void
    ) {}

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        willPresent _: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .banner, .list])
    }
}
