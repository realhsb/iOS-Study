//
//  Todo.swift
//  voiceMemo
//

import Foundation

struct Todo: Hashable {	// 제목, 시간, 날짜, 선택여부
	var title: String
	var time: Date
	var day: Date
	var selected: Bool
	
	// Date+Extensions로 Date 재구성했지만, 그대로 쓰면 불편 computed property로 변환 
	var convertedDayAndTime: String {
		// 오늘 - 오후 03:00에 알림
		String("\(day.formattedDay) - \(time.formattedTime)에 알림")
	}
}
