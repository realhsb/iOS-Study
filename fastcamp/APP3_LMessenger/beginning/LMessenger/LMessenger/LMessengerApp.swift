//
//  LMessengerApp.swift
//  LMessenger
//
//

import SwiftUI

@main   // 앱 시작점 - > 구현되어 있는 메인 함수 호출
struct LMessengerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate // UIKit의 lifecycle을 쓰게 해주는 프로퍼티 
    @StateObject var container: DIContainer = .init(services: Services())   // 외부에서 주입
    var body: some Scene {
        WindowGroup {
            AuthenticatedView(authViewModel: .init(container: container), navigationRouter: .init())   // init할 때 뷰모델을 생성하고 있으므로, 컨테이너도 주입
                .environmentObject(container)
        }
    }
}
