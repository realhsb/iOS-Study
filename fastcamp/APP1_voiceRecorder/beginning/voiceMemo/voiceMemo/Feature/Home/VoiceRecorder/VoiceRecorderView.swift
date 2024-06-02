//
//  VoiceRecorderView.swift
//  voiceMemo
//

import SwiftUI

struct VoiceRecorderView: View {
	@StateObject private var voiceRecorderViewModel = VoiceRecorderViewModel()
	@EnvironmentObject private var homeViewModel: HomeViewModel // recorded.counts가 변할 떄마다 homeViewModel로 넘겨줌 
	
  var body: some View {
		ZStack {
			// 타이틀 뷰
			VStack {
				TitleView()
				
				if voiceRecorderViewModel.recordedFiles.isEmpty {	// 음성 메모가 없으면 안내 뷰
					// 안내 뷰
					AnnouncementView()
				} else {		// 메모 있으면 리스트 뷰
					// 보이스 레코더 리스트 뷰
					VoiceRecorderListView(voiceRecorderViewModel: voiceRecorderViewModel)
						.padding(.top, 15)
				}
				
				Spacer()
			}
				
			// 녹음버튼 뷰
			RecordBtnView(voiceRecoderViewModel: voiceRecorderViewModel)
				.padding(.trailing, 20)
				.padding(.bottom, 50)
		} //: ZSTACK
		.alert(
			"선택된 음성메모를 삭제하겠습니까?",
			isPresented: $voiceRecorderViewModel.isDisplayRemoveVoiceRecorderAlert
		) {
			Button("삭제", role: .destructive) {
				voiceRecorderViewModel.removeSelectedVoiceRecord()
			}
			Button("취소", role: .cancel) { }
		}
		
		.alert(
			voiceRecorderViewModel.alertMessage,
			isPresented: $voiceRecorderViewModel.isDisplayAlert
		) {
			Button("확인", role: .cancel) { }	 // 얼럿 창 닫기
		}
		.onChange(
			of: voiceRecorderViewModel.recordedFiles,
			perform: { recordedFiles in
				// todo 개수가 변할 떄마다, 호출 -> todos.count를 실시간으로 homeView에 넘겨줌
				homeViewModel.setTodosCount(recordedFiles.count)
			}
		) // of : 어떤 게 변했을 떄, 변한 값을 바인딩 / 변한값에 따라서 어떻게 동작할지 perform으로 정의
		
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
	fileprivate var body: some View {
		HStack {
			Text("음성메모")
				.font(.system(size: 30, weight: .bold))
				.foregroundColor(.customBlack)
			
			Spacer()
		}
		.padding(.horizontal, 30)
		.padding(.top, 30)
	}
}

// MARK: - 음성메모 안내 뷰
private struct AnnouncementView: View {
	fileprivate var body: some View {
		VStack {
			Rectangle()
				.fill(Color.customCoolGray)
				.frame(height: 1)
			
			Spacer()
				.frame(height: 180)
			
			Image("pencil")
				.renderingMode(.template)
			Text("현재 등록된 음성메모가 없습니다.")
			Text("하단의 녹음 버튼을 눌러 음성메모를 시작해주세요.")
			
			Spacer()
		} //: VSTACK
		.font(.system(size: 16))
		.foregroundColor(.customGray2)
	}
}

// MARK: - 음성메모 리스트 뷰
private struct VoiceRecorderListView: View {
	@ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
	
	fileprivate init(voiceRecorderViewModel: VoiceRecorderViewModel) {
		self.voiceRecorderViewModel = voiceRecorderViewModel
	}
	
	fileprivate var body: some View {
		ScrollView(.vertical) {
			VStack {
				Rectangle()
					.fill(Color.customGray2)
					.frame(height: 1)
				
				ForEach(voiceRecorderViewModel.recordedFiles, id: \.self) { recordedFile in
					// 음성메뮤 셀 뷰 호출
					VoiceRecorderCellView(
						voiceRecorderViewModel: voiceRecorderViewModel,
						recordedFile: recordedFile
					)
				}	//: FOREACH
			} //: VSTACK
		} //: SCROLLVIEW
	}
}

// MARK: - 음성메모 셀 뷰
private struct VoiceRecorderCellView: View {
	@ObservedObject private var voiceRecorderViewModel: VoiceRecorderViewModel
	private var recordedFile: URL		// 녹음된 파일 가져오기
	private var creationDate: Date?
	private var duration: TimeInterval?
	private var progressBarValue: Float {	// 지금 파일이랑 내가 선택한 파일이랑 같은지 확인
		// (1)같으면서, (2)녹임이 재생 중이거나 녹음이 일시중지일 경우
		if voiceRecorderViewModel.selectedRecoredFile == recordedFile
				&& (voiceRecorderViewModel.isPlaying) || voiceRecorderViewModel.isPaused {
			return Float(voiceRecorderViewModel.playedTime) / Float(duration ?? 1)
		} else {
			return 0
		}
	}
	
	fileprivate init(
		voiceRecorderViewModel: VoiceRecorderViewModel,
		recordedFile: URL
	) {
		self.voiceRecorderViewModel = voiceRecorderViewModel
		self.recordedFile = recordedFile
		(self.creationDate, self.duration) = voiceRecorderViewModel.getFileInfo(for: recordedFile)	// 새로 추가. 위에 있는 recordedFile를 넣어줘서 creationDate과 duration 주입
	}
	
	fileprivate var body: some View {
		VStack {
			Button(
				action: {
				voiceRecorderViewModel.voiceRecordCellTapped(recordedFile)
			},
				label: {
					VStack {
						HStack {
							Text(recordedFile.lastPathComponent)				// 파일의 이름
								.font(.system(size: 15, weight: .bold))
								.foregroundColor(.customBlack)
							
							Spacer()
						} //: HSTACK
						
						Spacer()
							.frame(height: 5)
						
						HStack {
							if let creationDate = creationDate {	// nil이 아니면
								Text(creationDate.fomattedVoiceRecoderTime)		// 재생 시간
									.font(.system(size: 14))
									.foregroundColor(.customIconGray)
							}
							
							Spacer()
							
							if voiceRecorderViewModel.selectedRecoredFile != recordedFile,	// 파일이 일치하지 않을 경우
								 let duration = duration {
								Text(duration.formattedTimeInterval)
									.font(.system(size: 14))
									.foregroundColor(.customIconGray)
							}
						}
					} //: VSTACK
				}
			)
			.padding(.horizontal, 20)
		} //: VSTACK
		
		
		// 셀을 선택했을 때, 프로그래스 바가 나타나야 함!
		// url이 맞는지 확인
		if voiceRecorderViewModel.selectedRecoredFile == recordedFile {
			VStack {
				// 프로그래스바
				ProgressBar(progress: progressBarValue)		// 수시로 연산되는 프로퍼티 넣기
					.frame(height: 2)
				
				Spacer()
					.frame(height: 5)
				
				HStack {	// 남은 시간
					Text(voiceRecorderViewModel.playedTime.formattedTimeInterval)
						.font(.system(size: 10, weight: .medium))
						.foregroundColor(.customIconGray)
					
					Spacer()
					
					
					if let duration = duration {
						Text(duration.formattedTimeInterval)
							.font(.system(size: 10, weight: .medium))
							.foregroundColor(.customIconGray)
					}
				}//: HSTACK
	
				Spacer()
					.frame(height: 10)
				
					// 재생, 일시정지, 재개 btn
				HStack {
					Spacer()
					
					Button(
						action: {
							if voiceRecorderViewModel.isPaused {
								voiceRecorderViewModel.resumePlaying()
							} else {
								voiceRecorderViewModel.startPlaying(recordingURL: recordedFile)
							}
						}, label: {
							Image("play")
								.renderingMode(.template)
								.foregroundColor(.customBlack)
						}
					)
					
					Spacer()
						.frame(width: 10)
					
					Button(
						action: {
							if voiceRecorderViewModel.isPlaying {	// 재생 중일 때
								voiceRecorderViewModel.pausePlaying()	// 재생 정지
							}
						}, label: {
							Image("pause")
								.renderingMode(.template)
								.foregroundColor(.customBlack)
						}
					)
					
					Spacer()
					
					// 쓰레기통
					Button(
						action: {
							voiceRecorderViewModel.removeBtnTapped()
						}, label: {
							Image("trash")
								.renderingMode(.template)
								.resizable()
								.frame(width: 30, height: 30)
								.foregroundColor(.customBlack)
						}
					)
				}
			}//: VSTACK
			.padding(.horizontal, 20)
		}
		
		// 구분 선
		Rectangle()
			.fill(Color.customGray2)
			.frame(height: 1)
	}
}

// MARK: - 프로그레스 바
private struct ProgressBar: View {
	private var progress: Float
	
	fileprivate init(progress: Float) {
		self.progress = progress
	}
	
	fileprivate var body: some View {
		// 디바이스 사이즈. 진행률에 따라
		GeometryReader { geometry in
			ZStack(alignment: .leading) {
				Rectangle()
					.fill(Color.customGray2)
				
				Rectangle()
					.fill(Color.customGreen)
					.frame(width: CGFloat(self.progress) * geometry.size.width) // 사이즈를 가져와서, 프로그레스 진행 크기 결정
			}
		}
	}
}

// MARK: - 녹음 버튼 뷰
private struct RecordBtnView: View {
	@ObservedObject private var voiceRecoderViewModel: VoiceRecorderViewModel
	
	fileprivate init(voiceRecoderViewModel: VoiceRecorderViewModel) {
		self.voiceRecoderViewModel = voiceRecoderViewModel
	}
	
	fileprivate var body: some View {
		VStack {
			Spacer()
			
			HStack {
				Spacer()
				
				Button(
					action: {
						voiceRecoderViewModel.recordBtnTapped()
					},
					label: {
						if voiceRecoderViewModel.isRecording {
							Image("mic_recording")
						} else {
							Image("mic")
						}
					}
				)
			}
		}
	}
}

struct VoiceRecorderView_Previews: PreviewProvider {
  static var previews: some View {
    VoiceRecorderView()
  }
}
