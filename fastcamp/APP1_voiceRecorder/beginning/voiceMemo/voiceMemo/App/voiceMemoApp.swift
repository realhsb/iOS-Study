//
//  voiceMemoApp.swift
//  voiceMemo
//

import SwiftUI

@main
struct voiceMemoApp: App {
	
	/// AppDelegate를 구현하면 여기서 선언해줘야 함
	/// LowLevel 시스템을 처리해야 할 때
	/// UIKit의 델리게이트를 사용하기 위해선 아래의 선언이 필요하다 -> 앱 선언부에 1번만 선언하기.
	
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    WindowGroup {
      OnboardingView()
    }
  }
}
