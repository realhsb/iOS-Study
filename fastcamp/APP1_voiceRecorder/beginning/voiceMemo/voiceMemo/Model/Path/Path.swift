//
//  Path.swift
//  voiceMemo
//

import Foundation

class PathModel: ObservableObject {
    @Published var paths: [PathType]
    
    init(paths: [PathType] = []) {  // 빈 배열로 초기화. 앱 실행시 특정 화면을 보여주고 싶다면 해당 뷰로 초기화할 것.
        self.paths = paths
    }
}
