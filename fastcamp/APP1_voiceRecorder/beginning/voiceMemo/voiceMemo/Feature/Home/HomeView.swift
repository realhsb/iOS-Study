//
//  HomeView.swift
//  voiceMemo
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject private var pathModel: PathModel // Path Model 설정
	@StateObject private var homeViewModel = HomeViewModel()
	
  var body: some View {
		ZStack {
			// 탭뷰
			TabView(selection: $homeViewModel.selectedTab) { // 바인딩해서 가져오기
				TodoListView()
					.tabItem {
						Image(
							homeViewModel.selectedTab == .todoList
							? "todoIcon_selected"
							: "todoIcon"
						)
					}
					.tag(Tab.todoList)
				
				MemoListView()
					.tabItem {
						Image(
							homeViewModel.selectedTab == .memo
							? "memoIcon_selected"
							: "memoIcon"
						)
					}
					.tag(Tab.memo)

				VoiceRecorderView()
					.tabItem {
						Image(
							homeViewModel.selectedTab == .voiceRecorder
							? "recordIcon_selected"
							: "recordIcon"
						)
					}
					.tag(Tab.voiceRecorder)

				TimerView()
					.tabItem {
						Image(
							homeViewModel.selectedTab == .timer
							? "timerIcon_selected"
							: "timerIcon"
						)
					}
					.tag(Tab.timer)
				
				SettingView()
					.tabItem {
						Image(
							homeViewModel.selectedTab == .setting
							? "settingIcon_selected"
							: "settingIcon"
						)
					}
					.tag(Tab.setting)
			
			}
			.environmentObject(homeViewModel)
			// MemoListView나 TodoListView는 environment object로 homeViewModel을 주입받아야 함
			
			// 구분선
			SeperatorLineView()
		}
  }
}

// MARK: - 구분선
private struct SeperatorLineView: View {
	fileprivate var body: some View {
		VStack {
			Spacer()
			
			Rectangle()
				.fill(
					LinearGradient(
						gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.1)]),
						startPoint: .top,
						endPoint: .bottom
					)
				)
				.frame(height: 10)
				.padding(.bottom, 60)
		}//: VSTACK
	}
}

struct HomeView_Previews: PreviewProvider {
  static var previews: some View {
    HomeView()
			.environmentObject(PathModel())
			.environmentObject(TodoListViewModel())
			.environmentObject(MemoListViewModel())
  }
}
