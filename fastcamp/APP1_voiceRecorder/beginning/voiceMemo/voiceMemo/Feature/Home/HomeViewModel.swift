//
//  HomeViewModel.swift
//  voiceMemo
//

import Foundation

class HomeViewModel: ObservableObject {
	@Published var selectedTab: Tab
	@Published var todosCount: Int	// 아이템이 몇 개 존재하는지
	@Published var memosCount: Int
	@Published var voiceRecordersCount: Int
	
	init(
		selectedTab: Tab = .voiceRecorder,
		todosCount: Int = 0,	// 서버에서 받아오는 것이 없으므로 0으로 지정
		memosCount: Int = 0,
		voiceRecordersCount: Int = 0
	) {
		self.selectedTab = selectedTab
		self.todosCount = todosCount
		self.memosCount = memosCount
		self.voiceRecordersCount = voiceRecordersCount
	}
}

extension HomeViewModel {
	// 3가지는 -> TodosCount ~ VoiceRecorderCount 개수 변경
	func setTodosCount(_ count: Int) {
		todosCount = count
	}
	
	func setMemosCount(_ count: Int) {
		memosCount = count
	}
	
	func setVoiceRecordersCount(_ count: Int) {
		voiceRecordersCount = count
	}
	
	// Tab 변경 메서드
	func changeSelectedTab(_ tab: Tab) {
		selectedTab = tab
	}
}
