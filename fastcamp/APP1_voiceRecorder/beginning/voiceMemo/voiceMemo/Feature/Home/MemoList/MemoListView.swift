//
//  MemoListView.swift
//  voiceMemo
//

import SwiftUI

struct MemoListView: View {
	@EnvironmentObject private var pathModel: PathModel
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	
  var body: some View {
		ZStack {
			VStack {
				if !memoListViewModel.memos.isEmpty {	// 메모가 있는지 확인
					CustomNavigationBar(
						isDisplayLeftBtn: false,		// 백 버튼이 없기 때문에 false
						rightBtnAction: {
							memoListViewModel.navigationRightBtnTapped()		// 메소드 넣어주기
							},
						rightBtnType: memoListViewModel.navvigationBarRightBtnMode
						)
				} else {
					Spacer()
						.frame(height: 30)
				}
				
				// 타이틀 뷰
				TitleView()
					.padding(.top, 20)
				
				// 안내 뷰 혹은 메모리스트 컨텐츠 뷰
				if memoListViewModel.memos.isEmpty {	// 메모가 없다면 안내 뷰
					AnnouncementView()
				} else {															// 메모가 있다면 콘텐츠 뷰
					MemolistContentView()
						.padding(.top, 20)
				}
			} //: VSTACK
			
			// 메모작성 플로팅 아이콘 버튼 뷰
			WriteMemoBtnView()
				.padding(.trailing, 20)
				.padding(.bottom, 50)
		} //: ZSTACK
		.alert(
			"메모 \(memoListViewModel.removeMemoCount)개 삭제하시겠습니까?",
			isPresented: $memoListViewModel.isDisplayRemoveMemoAlert
		) {
			Button("삭제", role: .destructive) {	// 기능
				memoListViewModel.removeBtnTapped()
			}
			
			Button("취소", role: .cancel) { }
		}
		
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	
	fileprivate var body: some View {
		HStack {
			if memoListViewModel.memos.isEmpty {	// 메모가 없을 경우
				Text("메모를\n추가해 보세요.")
			} else {
				Text("메모 \(memoListViewModel.memos.count)개가\n있습니다.")
			}
			
			Spacer()
		} //: HSTACK
		.font(.system(size: 30, weight: .bold))
		.padding(.leading, 20)
	}
}

// MARK: - 안내 뷰
private struct AnnouncementView: View {
	fileprivate var body: some View {
		VStack(spacing: 15) {
			Spacer()
			
			Image("pencil")
				.renderingMode(.template)
			Text("\"퇴근 9시간 전 메모\"")
			Text("\"개발 끝낸 후 퇴근하기\"")
			Text("\"밀린 알고리즘 공부하기\"")
			
			Spacer()
			
		} //: VSTACK
		.font(.system(size: 16))
		.foregroundColor(.customGray2)
	}
}

// MARK: - 메모 리스트 컨텐츠 뷰
private struct MemolistContentView: View {
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	
	fileprivate var body: some View {
		VStack {
			HStack {
				Text("메모 목록")
					.font(.system(size: 16, weight: .bold))
					.padding(.leading, 20)
				
				Spacer()
			} //: HSTACK
		} //: VSTACK
		
		ScrollView(.vertical) {		// 구분선
			VStack(spacing: 0) {
				Rectangle()
					.fill(Color.customGray0)
					.frame(height: 1)
				
				ForEach(memoListViewModel.memos, id: \.self) { memo in
					// 메모 셀 뷰 호출 (밑에서 만듦)
					MemoCellView(memo: memo)
				}
			}
		}
	}
}

// MARK: - 메모 셀 뷰
private struct MemoCellView: View {
	@EnvironmentObject private var pathModel: PathModel	// 뷰어 타입에서 는 메모뷰를 올려야 함. 이것을 클릭하면 실제로 보여줄 수 있는 걸 보여줌...(?)
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	@State private var isRemoveSelected: Bool				// 삭제 박스
	private var memo: Memo
	
	fileprivate init(
		isRemoveSelected: Bool = false,
		memo: Memo			// 주입 받음
	) {
		_isRemoveSelected = State(initialValue: isRemoveSelected)	// 초기값 설정
		self.memo = memo
	}
	
	fileprivate var body: some View {	// 클릭돼서 다음 뷰로 넘어감... 버튼으로 구현
		Button {
			// TODO: - path 관련 메모 구현 후, 구현하기
			
		} label: {
			VStack(spacing: 10) {
				HStack {
					VStack(alignment: .leading) {
						Text(memo.title)
							.lineLimit(1)	// 한 줄 제한
							.font(.system(size: 16))
							.foregroundColor(.customBlack)
							
						Text(memo.convertedDate)
							.font(.system(size: 12))
							.foregroundColor(.customIconGray)
					} //: VSTACK
					
					Spacer()
					
					if memoListViewModel.isEditMemoMode {	//edit 모드에 따라 체크박스 표시
						Button(
						action: {
							isRemoveSelected.toggle() // 박스 체크
							memoListViewModel.memoRemoveSelectedBoxTapped(memo) // 삭제할 메모 배열에 메모가 들어가거나, 빠지거나
						},
						label: { isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox") }
						)
					}
				} //: HSTACK
				.padding(.horizontal, 30)
				.padding(.top, 10)
				
				Rectangle()
					.fill(Color.customGray0)
					.frame(height: 1)
			} //: VSTACK
		}
	}
}

// MARK: - 메모 작성 버튼 뷰
private struct WriteMemoBtnView: View {
	@EnvironmentObject private var pathModel: PathModel
	
	fileprivate var body: some View {
		VStack {
			Spacer()
			
			HStack {
				Spacer()
				
				Button(action: {
					// TODO: - 메모 뷰 구현 후, 돌아와서 구현 필요!
				}, label: {
					Image("writeBtn")
				})
			} //: HSTACK
			
		} //: VSTACK
	}
}

struct MemoListView_Previews: PreviewProvider {
  static var previews: some View {
    MemoListView()		// 프리뷰로 보고 싶을 때 꼭 넣기
			.environmentObject(PathModel())
			.environmentObject(MemoListViewModel())
  }
}
