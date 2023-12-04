//
//  PathType.swift
//  voiceMemo
//

enum PathType: Hashable {
	case homeView
	case todoView
	case memoView(isCreateMode: Bool, memo: Memo?)	// 수정 모드가 아니면 작성페이지를, 수정 모드면 메모 띄워주기. 그래서 메모도 입력받되 없을 수도 있으니 옵셔널로 
}
