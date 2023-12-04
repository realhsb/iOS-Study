//
//  NotificationService.swift
//  voiceMemo
//

import UserNotifications

struct NotificationService {
	func sendNotification() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
			if granted {
				let content = UNMutableNotificationContent()
				content.title = "타이머 종료"
				content.body = "설정한 타이머가 종료되었습니다."
				content.sound = UNNotificationSound.default
				
				let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
				let request = UNNotificationRequest(
					identifier: UUID().uuidString,
					content: content,
					trigger: trigger
				)
				
				UNUserNotificationCenter.current().add(request)
			}
		}
	}
}

// completion handler를 받아야 함 -> delegate 받음

//  1. 앱 델리게이트 만듦. 실행됐을 떄 아래의 UNUserNotificationCenterDelegate를 NotificationService를 통해서 구현
//	2.  앱 델리게이트를 다루는 거 만들기
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
	func userNotificationCenter(
		_ center: UNUserNotificationCenter,
		willPresent notification: UNNotification,
		withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
	) {
		completionHandler([.banner, .sound])
	}
}
