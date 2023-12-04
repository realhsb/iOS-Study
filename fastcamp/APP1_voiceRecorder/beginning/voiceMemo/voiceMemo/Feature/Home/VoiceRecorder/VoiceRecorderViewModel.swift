//
//  VoiceRecorderViewModel.swift
//  voiceMemo
//

import AVFoundation	// 임포트!

// ObservableObject 채택? -> 오디오 서비스 객체 생성을 뷰에 얹어서 사용
// NSObject 채택? -> AVAudioPlayerDelegate가 내부적으로 NSObject를 채택하고 있음
// CoreFoundation 런타임 매커
// AVAudioPlayerDelegate를 사용해서 객체 생성하기 위해서는 NSObject 또는 뫄뫄를 채택해야 함
// AVAudioPlayerDelegate가 간접적으로 런타임 매커니즘을 사용케 함.
// NSObject 상속 받는 것이 간단. 안 그러면 AVAudioPlayerDelegate의 모든 메소드 재정의해야 함.

// 메모 녹음, 메모 재생 
class VoiceRecorderViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
	// 뷰에 보여질 퍼블릭 프로퍼티
	@Published var isDisplayRemoveVoiceRecorderAlert: Bool		// 상태값
	@Published var isDisplayAlert: Bool
	@Published var alertMessage: String
	
	/// 음성메모 녹음 관련 프로퍼티
	var audioRecorder: AVAudioRecorder?
	@Published var isRecording: Bool	// 현재 재생 중인지
	
	/// 음성메모 재생 관련 프로퍼티
	var audioPlayer: AVAudioPlayer?
	@Published var isPlaying: Bool
	@Published var isPaused: Bool
	@Published var playedTime: TimeInterval	// 얼마나 재생했는지
	private var progressTimer: Timer?
	
	/// 음성메모된 파일
	/// 배열 사용. For Each로 접근
	var recordedFiles: [URL]
	
	/// 현재 선택된 음성메모 파일
	@Published var selectedRecoredFile: URL?	// 없을 수도 있으니 옵셔널
	init(
		isDisplayRemoveVoiceRecorderAlert: Bool = false,
		isDisplayErrorAlert: Bool = false,
		errorAlertMessage: String = "",
//		audioRecorder: AVAudioRecorder? = nil,	nil로 줄 필요없어서 초기화 안 함.
		isRecording: Bool = false,
//		audioPlayer: AVAudioPlayer? = nil,
		isPlaying: Bool = false,
		isPaused: Bool = false,
		playedTime: TimeInterval = 0,
//		progressTimer: Timer? = nil,
		recordedFiles: [URL] = [],		// 녹음된 게 없으니 빈 배열
		selectedRecoredFile: URL? = nil
	) {
		self.isDisplayRemoveVoiceRecorderAlert = isDisplayRemoveVoiceRecorderAlert
		self.isDisplayAlert = isDisplayErrorAlert
		self.alertMessage = errorAlertMessage
		self.isRecording = isRecording
		self.isPlaying = isPlaying
		self.isPaused = isPaused
		self.playedTime = playedTime
		self.recordedFiles = recordedFiles
		self.selectedRecoredFile = selectedRecoredFile
	}
}

/// extension 3가지
/// 1) 음성과 관련없는 뷰의 로직
/// 2) 음성메모 녹음
/// 3) 음성메모 재생


// MARK: - 음성과 관련없는 뷰의 로직
extension VoiceRecorderViewModel {
	// 셀을 탭했을 때
	func voiceRecordCellTapped(_ recordedFile: URL) {
		if selectedRecoredFile != recordedFile { // 선택 중인 셀과 다른 셀을 탭했을 때 -> 정지
			// TODO: - 플레잉 정지 메서드 호출 ✅
			stopPlaying()
			selectedRecoredFile = recordedFile
		}
	}
	
	func removeBtnTapped() {
		// TODO: - 삭제 얼럿 노출을 위한 상태 변경 메서드 호출 ✅
		setIsDisplayRemoveVoiceRecorderAlert(true)
	}
	
	func removeSelectedVoiceRecord() { // 삭제 버튼을 누르면 상태변화 & 얼럿 호출. 얼럿에서 삭제 버튼을 눌렀을 때 호출되는 메서드
		guard let fileToRemove = selectedRecoredFile,		// 파일이 존재하면 인덱스 값 사용
					let indexToRemove = recordedFiles.firstIndex(of: fileToRemove)	else {
			// TODO: - 선택된 음성메모를 찾을 수 없다는 에러 얼럿 노출
			displayAlert(message: "선택된 음성메모 파일을 찾을 수 없습니다.")
			return
		}
		
		do {	// 삭제 성공
			try FileManager.default.removeItem(at: fileToRemove)
			recordedFiles.remove(at: indexToRemove)
			selectedRecoredFile = nil
			
			// TODO: - 재생 정지 메서드 호출 ✅
			stopPlaying()
			
			// TODO: - 삭제 성공 얼럿 노출 ✅
			displayAlert(message: "선택된 음성메모 파일을 성공적으로 삭제했습니다.")
			
		} catch {	// 삭제 실패
			// TODO: - 삭제 실패 오류 얼럿 노출 ✅
			displayAlert(message: "선택된 음성메모 파일 삭제 중 오류가 발생했습니다.")
		}
	}
	
	// 삭제 얼럿 띄울지 여부를 정하는 Bool
	private func setIsDisplayRemoveVoiceRecorderAlert(_ isDisplay: Bool) {
		isDisplayRemoveVoiceRecorderAlert = isDisplay
	}
	
	// 삭제 실패시 에러
	private func setErrorAlertMessage(_ message: String) {
		alertMessage = message
	}
	
	// 삭제 얼럿 띄울지 여부를 정하는 Bool
	private func setIsDisplayErrorAlert(_ isDisplay: Bool) {
		isDisplayAlert = isDisplay
	}
	
	// 얼럿 메시지를 담고 띄워주는 메서드 (성공 삭제 / 오류 발생은 문자열로 담아서 얼럿으로 띄움)
	private func displayAlert(message: String) {
		setErrorAlertMessage(message)
		setIsDisplayErrorAlert(true)
	}
}

// MARK: - 음성메모 녹음 관련
extension VoiceRecorderViewModel {
	// 플로팅 버튼으로 뜬 재생/정지 버튼 탭
	func recordBtnTapped() {
		selectedRecoredFile = nil
		
		if isPlaying {
			// TODO: - 재생 정지 메서드 호출 (현재 재생 중인 게 있다면 정지) ✅
			stopPlaying()
			// TODO: - 녹음 시작 메서드 호출 ✅
			startRecording()
			
		} else if isRecording {
			// TODO: - 녹음 정지 메서드 호출 (현재 녹음 중인 게 있다면 정지) ✅
			stopRecording()
		} else {
			// TODO: - 녹음 시작 메서드 호출 (아무것도 없으니 녹음 시작) ✅
			startRecording()
		}
	}
	
	// 녹음 시작
	// 뷰에서 직접적으로 사용X. private로 선언
	private func startRecording() {
		let fileURL = getDocumentsDirectory().appendingPathComponent("새로운 녹음 \(recordedFiles.count + 1)")
		let settings = [
			AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
			AVSampleRateKey: 12000,	// 대표 설정값
			AVNumberOfChannelsKey: 1,
			AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
		]
		
		do {	// 담아주기
			audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
			audioRecorder?.record()
			self.isRecording = true
		} catch {	// 실패하면
			displayAlert(message: "음성메모 녹음 중 오류가 발생했습니다.")
		}
	}
	
	// 음성 메모 녹음 중 종료
	private func stopRecording() {
		audioRecorder?.stop()		// 오디오 녹음 정지
		self.recordedFiles.append(self.audioRecorder!.url)	// 녹음이 끝났으니 저장
		self.isRecording = false
	}
	
	// 파일의 경로 리턴
	private func getDocumentsDirectory() -> URL {
		let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
		return paths[0]
	}
}

// MARK: - 음성메모 재생 관련
extension VoiceRecorderViewModel {
	func startPlaying(recordingURL: URL) {	// 어떤 파일 재생?
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: recordingURL)
			audioPlayer?.delegate = self
			audioPlayer?.play()
			self.isPlaying = true
			self.isPaused = false
			self.progressTimer = Timer.scheduledTimer(
				withTimeInterval: 0.1,	// 	timeInterval: 0.1 인가...?
				repeats: true
			){ _ in
				// TODO: - 현재 시각 업데이트 메서드 호출 ✅
				self.updateCurrentTime()
			}
		} catch {
			displayAlert(message: "음성메모 재생 중 오류가 발생했습니다.")
		}
	}
	
	private func updateCurrentTime() {
		self.playedTime = audioPlayer?.currentTime ?? 0
	}
	
	// 종료
	private func stopPlaying() {
		audioPlayer?.stop()								// 초기화
		playedTime = 0										// 초기화
		self.progressTimer?.invalidate()	// 초기화
		self.isPlaying = false
		self.isPaused = false
	}
	
	// 일시정지
	func pausePlaying() {
		audioPlayer?.pause()
		self.isPaused = true
	}
	
	// 재개
	func resumePlaying() {
		audioPlayer?.play()
		self.isPaused = false
	}
	
	// 플레이어가 재생이 끝났을 시점에 상태값 변경
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		self.isPlaying = false	// 재생 끝
		self.isPaused = false
	}
	
	// 파일 정보 -> 시간, 타임인터벌
	func getFileInfo(for url: URL) -> (Date?, TimeInterval?) {
		let fileManager = FileManager.default
		var creationDate: Date?
		var duration: TimeInterval?
		
		do {	// 음성메모 파일 정보 불러오기
			let fileAttributes = try fileManager.attributesOfItem(atPath: url.path)
			creationDate = fileAttributes[.creationDate] as? Date
		} catch {	// 불러오기 실패
			displayAlert(message: "선택된 음성메모 파일 정보를 불러올 수 없습니다.")
		}
		
		do { // 음성메모 파일의 재생시간 불러오기
			let audioPlayer = try AVAudioPlayer(contentsOf: url)
			duration = audioPlayer.duration
		} catch {
			displayAlert(message: "선택된 음성메모 파일의 재생 시간을 불러올 수 없습니다.")
		}
		
		return (creationDate, duration)
	}
}
