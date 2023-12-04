//
//  TodoViewModel.swift
//  voiceMemo
//
// 	Todo를 생성하는 화면

import Foundation

class TodoViewModel: ObservableObject {
	@Published var title: String
	@Published var time: Date
	@Published var day: Date
	@Published var isDisplayCalendar: Bool
	
	init(		// 초기화 값 넣을지말지 잘 선택 
		title: String = "",
			 time: Date = Date(),
			 day: Date = Date(),
			 isDisplayCalendar: Bool = false
	) {
		self.title = title
		self.time = time
		self.day = day
		self.isDisplayCalendar = isDisplayCalendar
	}
}

// 비즈니스 모델
extension TodoViewModel {
	func setIsDisplayCalendar(_ isDisplay: Bool) {
		isDisplayCalendar = isDisplay
	}
}
