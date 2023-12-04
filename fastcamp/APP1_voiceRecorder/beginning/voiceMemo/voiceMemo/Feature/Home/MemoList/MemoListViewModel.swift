//
//  MemoListViewModel.swift
//  voiceMemo
//

import Foundation

class MemoListViewModel: ObservableObject {
	@Published var memos: [Memo]
	@Published var isEditMemoMode: Bool
	@Published var removeMemos: [Memo]
	@Published var isDisplayRemoveMemoAlert: Bool
	
	var removeMemoCount: Int {
		return removeMemos.count
	}
	
	// 내비게이션 버튼 생성인지 뭔지 타입 지정
	var navvigationBarRightBtnMode: NavigationBtnType {
		isEditMemoMode ? .complete : .edit
	}
	
	init(	// 초기화 잊지 말고 꼬옥 해주기!
		memos: [Memo] = [],
		isEditMemoMode: Bool = false,
		removeMemos: [Memo] = [],
		isDisplayRemoveMemoAlert: Bool = false
	) {
		self.memos = memos
		self.isEditMemoMode = isEditMemoMode
		self.removeMemos = removeMemos
		self.isDisplayRemoveMemoAlert = isDisplayRemoveMemoAlert
	}
}


// 비즈니스 로직 구성
extension MemoListViewModel {
	func addMemo(_ memo: Memo) {
		memos.append(memo)
	}
	
	func updateMemo(_ memo: Memo) {
		// 들어온 인덱스와 일치하는 인덱스를 찾아서, 수정된 메모를 갈아끼운다.
		if let index = memos.firstIndex(where: { $0.id == memo.id })	{ // Memo의 id값이 여기서 사용.
			memos[index] = memo
		}
	}
	
	func removeMemo(_ memo: Memo) {
		if let index = memos.firstIndex(where: { $0.id == memo.id }) {
			memos.remove(at: index)
		}
	}
	
	func navigationRightBtnTapped() {
		if isEditMemoMode {
			if removeMemos.isEmpty {
				isEditMemoMode = false
			} else {	// 메모가 있따
				// 삭제 얼럿 상태값 변경을 위한 메서드 호출
				setIsDisplayRemoveMemoAlert(true)
			}
			
		} else { // edit 모드가 아니다?
			isEditMemoMode = true
		}
	}
	
	func setIsDisplayRemoveMemoAlert(_ isDisplay: Bool) {	// true 받으면 얼럿 띄우기
		isDisplayRemoveMemoAlert = isDisplay
	}
	
	func memoRemoveSelectedBoxTapped(_ memo: Memo) {
		if let index = removeMemos.firstIndex(of: memo) {
			removeMemos.remove(at: index)
		} else {
			removeMemos.append(memo)
		}
	}
	
	func removeBtnTapped() {			// 삭제 버튼 눌렸을 때
		memos.removeAll { memo in		// 선택된 모든 것을 지움
			removeMemos.contains(memo)	// 삭제 메모리 리스트에 겹치는 것에 한해서 
		}
		removeMemos.removeAll()		// 삭제할 메모가 담긴 메모리스트 비우기
		isEditMemoMode = false		// Edit 모드 끄기
	}
}
