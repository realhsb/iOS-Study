//
//  AppDelegate.swift
//  voiceMemo
//

import UIKit	// 유킷!

class AppDelegate: NSObject, UIApplicationDelegate {
  var notificationDelegate = NotificationDelegate()
	
	// app delegate 구성 -> voiceMemoApp에서 사용할 수 있게 설정해야 함.
	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
	) -> Bool {
		UNUserNotificationCenter.current().delegate = notificationDelegate
		return true
	}
}
