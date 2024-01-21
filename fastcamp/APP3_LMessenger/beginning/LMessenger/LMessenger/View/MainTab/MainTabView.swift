//
//  MainTabView.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel // user id 가져오기
    @EnvironmentObject var container: DIContainer
    @State private var selectedTab: MainTabType = .home
    var body: some View {
        TabView(selection: $selectedTab) {  // 바인딩으로 넘기기
//            해당되는 탭을 foreach로 그리기
            ForEach(MainTabType.allCases, id: \.self) { tab in
                Group {
                    switch tab {
                    case .home:
                        HomeView(viewModel: .init(container: container, userId: authViewModel.userId ?? ""))
                    case .chat:
                        ChatListView()
                    case .phone:
                        Color.blackFix
                    }
                }
                .tabItem {
                    // 현재 탭이 선택된 탭이면, fill 아이콘
                    Label(tab.title, image: tab.imageName(selected: selectedTab == tab))
                }
                .tag(tab)
            }
        }
        .tint(.bkText)  // 탭바 아이콘 글씨
    }
    
    // 안 눌린 탭바 아이콘 글씨 색을 검정색으로 설정하기
    // 이런 경우는 UIKit으로 접근해야 한다.
    
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.bkText)
    }
}

#Preview {
    MainTabView()
}
