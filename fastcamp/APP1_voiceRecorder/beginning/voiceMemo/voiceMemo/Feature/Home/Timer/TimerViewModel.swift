//
//  TimerViewModel.swift
//  voiceMemo
//

import Foundation

class TimerViewModel: ObservableObject {
	@Published var isDisplaySetTimeView: Bool	// 뷰를 2타입으로 보여줌
	@Published var time: Time
	@Published var timer: Timer?
	@Published var timeRemaining: Int
	@Published var isPaused: Bool
	
	init(
		isDisplaySetTimeView: Bool = true,	// 설정된 값이 없으므로 트루
		time: Time = .init(hours: 0, minutes: 0, seconds: 0),
		timer: Timer? = nil,
		timeRemaining: Int = 0,
		isPaused: Bool = false
	) {
		self.isDisplaySetTimeView = isDisplaySetTimeView
		self.time = time
		self.timer = timer
		self.timeRemaining = timeRemaining
		self.isPaused = isPaused
	}
}

extension TimerViewModel {
	// 뷰에서 상호작용하는 함수이므로 private X
	
	// 피커를 따라락 옮겨서 시간 설정할 떄
	func settingBtnTapped() {
		isDisplaySetTimeView = false
		timeRemaining = time.convertedSeconds	// 객체 생성되고 변환된 세컨즈 시간 사용
		
		// TODO: - 타이머 시작 메서드 호출 ✅
		startTImer()
	}
	
	func cancelBtnTapped() {
		// TODO: - 타이머 종료 메서드 호출 ✅
		stopTimer()
		isDisplaySetTimeView = true
	}
	
	// 재개 or 일시정지 버튼
	func pauseOrRestartBtnTapped() {
		if isPaused {
			// TODO: - 타이머 시작 메서드 호출 ✅
			startTImer()
		} else {
			timer?.invalidate()	// 타이머 멈추기
			timer = nil
		}
		
		isPaused.toggle()
	}
}

// 이 파일 내에서만 사용. 다른 뷰에서 사용X
// func 앞에 private를 붙이지 않아도 private이 됨
private extension TimerViewModel {
	
	func startTImer() {
		guard timer == nil else { return }	// 닐이 아니어야 타이머 세팅
		
		timer = Timer.scheduledTimer(
			withTimeInterval: 1,		// 1초씩 변화
			repeats: true,
			block: { _ in
				if self.timeRemaining > 0 {
					self.timeRemaining -= 1	// 1초씩 감소
				} else {	// remaining 시간이 없으면 타이머 종료
					// TODO: - 타이머 종료 메서드 호출
					self.stopTimer()		// captuer closure라 self 붙여야 함 
				}
			}
		)
	}
	
	func stopTimer() {
		timer?.invalidate()	// 타이머 멈추기
		timer = nil
	}
}
