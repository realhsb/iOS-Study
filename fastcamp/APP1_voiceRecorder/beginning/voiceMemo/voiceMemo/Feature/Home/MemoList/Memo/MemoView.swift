//
//  MemoView.swift
//  voiceMemo
//

import SwiftUI

struct MemoView: View {
	@EnvironmentObject private var pathModel: PathModel
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	@StateObject var memoViewModel: MemoViewModel // Memo
	@State var isCreateMode: Bool = true			// Memo
 
  var body: some View {
		ZStack {
			VStack {
				CustomNavigationBar(
					leftBtnAction: {
						pathModel.paths.removeLast()
					},
					rightBtnAction: {
						if isCreateMode {	// 생성 모드
							memoListViewModel.addMemo(memoViewModel.memo)
						} else {				// 수정 모드
							memoListViewModel.updateMemo(memoViewModel.memo)
						}
						pathModel.paths.removeLast()
					},
					rightBtnType: isCreateMode ? .create : .complete
				)
				
				// 메모 타이틀 인풋 뷰
				MemoTitleInputView(
					memoViewModel: memoViewModel,
					isCreateMode: $isCreateMode
				)
				
				// 메모 콘텐츠 인풋 뷰
				MemoContentInputView(memoViewModel: memoViewModel)
					.padding(.top, 10)
				
			} //: VSTACK
			
			if !isCreateMode {	// 생성 모드가 아닐 경우만 삭제 버튼 있음
				// 삭제 플로팅 버튼 뷰
				RemoveMemoBtnView(memoViewModel: memoViewModel)
					.padding(.trailing, 20)
					.padding(.bottom, 10)
			}
			
		} //: ZSTACK
  }
}

// MARK: - 메모 제목 입력 뷰
private struct MemoTitleInputView: View {
	@ObservedObject private var memoViewModel: MemoViewModel
	@FocusState private var isTitleFieldFocus: Bool
	@Binding private var isCreateMode: Bool
	
	fileprivate init(
		memoViewModel: MemoViewModel,
		isCreateMode: Binding<Bool>		// 바인딩 변수이므로, Bool이 아닌 Binding<Bool>fh tjsdjs
	) {
		self.memoViewModel = memoViewModel
		self._isCreateMode = isCreateMode			// 언더바 넣어서 값 넣기
	}
	
	fileprivate var body: some View {
		TextField(
			"제목을 입력하세요.",
			text: $memoViewModel.memo.title
		)
		.font(.system(size: 30))
		.padding(.horizontal, 20)
		.focused($isTitleFieldFocus)
		.onAppear {	// 이 뷰가 나타났을 때
			if isCreateMode {
				isTitleFieldFocus = true
			}
		}
	}
}

// MARK: - 메모 본문 입력 뷰
private struct MemoContentInputView: View {
	@ObservedObject private var memoViewModel: MemoViewModel		// ObservedObject로 주입 받기
	
	fileprivate init(memoViewModel: MemoViewModel) {
		self.memoViewModel = memoViewModel
	}
	
	fileprivate var body: some View {
		ZStack(alignment: .topLeading) {
			TextEditor(text: $memoViewModel.memo.content)
				.font(.system(size: 20))
			
			if memoViewModel.memo.content.isEmpty {
				Text("메모를 입력하세요.")
					.font(.system(size: 16))
					.foregroundColor(.customGray1)
					.allowsHitTesting(false)		// 터치가 먹지 않게 함. Text가 아닌 위의 TextEditor에 터치가 먹도록 함.
					.padding(.top, 10)
					.padding(.leading, 5)
			}
		}
		.padding(.horizontal, 20)
	}
}

// MARK: - 메모 삭제 버튼 뷰
private struct RemoveMemoBtnView: View {
	@EnvironmentObject private var pathModel: PathModel
	@EnvironmentObject private var memoListViewModel: MemoListViewModel
	@ObservedObject private var memoViewModel: MemoViewModel
	
	fileprivate init(memoViewModel : MemoViewModel) {
		self.memoViewModel = memoViewModel
	}
	
	fileprivate var body: some View {
		VStack {
			Spacer()
			
			HStack {
				Spacer()
				
				Button(
					action: {
					memoListViewModel.removeMemo(memoViewModel.memo)	// 메모 지우기
					pathModel.paths.removeLast()											// 뒤로 나오기
				}, label: {
					Image("trash")
						.resizable()
						.frame(width: 40, height: 40)
				})
			} //: HSTACK
		} //: VSTACK
	}
}

struct MemoView_Previews: PreviewProvider {
  static var previews: some View {
		MemoView(
			memoViewModel: .init(
				memo: .init(
					title: "",
					content: "",
					date: Date()
				)
			)
		)
  }
}
