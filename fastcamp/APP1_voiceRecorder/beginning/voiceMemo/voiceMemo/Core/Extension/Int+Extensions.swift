//
//  Int+Extensions.swift
//  voiceMemo
//

import Foundation

extension Int {
	var formattedTimeString: String {
		let time = Time.fromSeconds(self)
		let hoursString = String(format: "%02d", time.hours)
		let minutesString = String(format: "%02d", time.minutes)
		let secondsString = String(format: "%02d", time.seconds)
		
		return "\(hoursString) : \(minutesString) : \(secondsString)"		// 00 : 00 : 00 -> 타이머의 시간
	}
	
	var formattedSettingTime: String {
		let currentDate = Date()
		let settingDate = currentDate.addingTimeInterval(TimeInterval(self)) 	// 시간이 얼마나 지났는지 보여줌
		
		let formatter = DateFormatter()
		formatter.locale = Locale(identifier: "ko_KR")
		formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
		formatter.dateFormat = "HH:mm"
		
		let formattedTime = formatter.string(from: settingDate)
		return formattedTime
	}
}
