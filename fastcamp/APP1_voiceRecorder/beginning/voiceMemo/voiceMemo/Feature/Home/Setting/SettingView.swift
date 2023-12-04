//
//  SettingView.swift
//  voiceMemo
//

import SwiftUI

struct SettingView: View {
  var body: some View {
		VStack {
			// 타이틀 뷰
			TitleView()
			
			Spacer()
				.frame(height: 35)
			
			// 총 탭 카운트 뷰
			TotalTabCountView()
			
			Spacer()
				.frame(height: 40)
			
			// 총 탭 무브 뷰
			TotalTapMoveView()
			
			Spacer()
		}
  }
}

// MARK: - 타이틀 뷰
private struct TitleView: View {
	fileprivate var body: some View {
		HStack {
			Text("설정")
				.font(.system(size: 30, weight: .bold))
				.foregroundColor(.customBlack)
			
			Spacer()
		}//: HSTACK
		.padding(.horizontal, 30)
		.padding(.top, 45)
	}
}


// MARK: - 전체 탭 설정된 카운트 뷰
private struct TotalTabCountView: View {
	fileprivate var body: some View {
		// 각각 탭 카운트 뷰(todolist, 메모장, 음성메모)
		HStack {
			TabCountView(title: "To do", count: 1)	// count 값을 홈이랑도 전달
			
			Spacer()
				.frame(width: 70)
			TabCountView(title: "메모", count: 2)	// count 값을 홈이랑도 전달
			
			Spacer()
				.frame(width: 70)
			
			TabCountView(title: "음성메모", count: 3)	// count 값을 홈이랑도 전달
		}
	}
}

// MARK: - 각 탭 설정된 카운트 뷰 (공통 뷰 컴포넌트)
private struct TabCountView: View {
	private var title: String
	private var count: Int
	
	fileprivate init(
		title: String,
		count: Int
	) {
		self.title = title
		self.count = count
	}
	
	fileprivate var body: some View {
		VStack(spacing: 5) {
			Text(title)
				.font(.system(size: 14))
				.foregroundColor(.customBlack)
			
			Text("\(count)")
				.font(.system(size: 30, weight: .medium))
				.foregroundColor(.customBlack)
		}//: VSTACK
	}
}

// MARK: - 전체 탭 이동 뷰
private struct TotalTapMoveView: View {
	fileprivate var body: some View {
		VStack {
			Rectangle()
				.fill(Color.customGray2)
				.frame(height: 1)
			
			// 각 탭 4개 이동 뷰 컴포넌트
			
			TabMoveView(
				title: "To do List",
				tabAction: { }		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "메모장",
				tabAction: { }		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "음성메모",
				tabAction: { }		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "타이머",
				tabAction: { }		// Home에서 tabAction 구현
			)
		} //: VSTACK
	}
}

// MARK: - 각 탭 이동 뷰
private struct TabMoveView: View {
	private var title: String
	private var tabAction: () -> Void
	
	fileprivate init(
		title: String,
		tabAction: @escaping () -> Void
	) {
		self.title = title
		self.tabAction = tabAction
	}
	
	fileprivate var body: some View {
		Button(
			action: tabAction,
			label: {
				HStack {
					Text(title)
						.font(.system(size: 14))
						.foregroundColor(.customBlack)
					
					Spacer()
					
					Image("arrowRight")
				}
			}
		)
		.padding(.all, 20)
	}
}

struct SettingView_Previews: PreviewProvider {
  static var previews: some View {
    SettingView()
  }
}
