//
//  Time.swift
//  voiceMemo
//

import Foundation

struct Time {
	// 들어온 seconds -> 시, 분, 초, 변환된 타임
	
	var hours: Int
	var minutes: Int
	var seconds: Int
	
	var convertedSeconds: Int {
		return (hours * 3600) + (minutes * 60) + seconds
	}
	
	static func fromSeconds(_ seconds: Int) -> Time {
		let hours = seconds / 3600
		let minutes = (seconds % 3600) / 60
		let remainingSeconds = (seconds % 3600) % 60
		return Time(hours: hours, minutes: minutes, seconds: remainingSeconds)
	}
}
