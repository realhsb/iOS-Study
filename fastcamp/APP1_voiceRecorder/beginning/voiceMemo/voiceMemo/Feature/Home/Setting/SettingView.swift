//
//  SettingView.swift
//  voiceMemo
//

import SwiftUI

struct SettingView: View {
	@EnvironmentObject private var homeViewModel: HomeViewModel
	
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
	@EnvironmentObject private var homeViewModel: HomeViewModel
	
	fileprivate var body: some View {
		// 각각 탭 카운트 뷰(todolist, 메모장, 음성메모)
		HStack {
			TabCountView(title: "To do", count: homeViewModel.todosCount)	// count 값을 홈이랑도 전달 -> 개수를 홈뷰 모델에 어떻게 주입시킬 건지? (TodoListView에서 설정)
			
			Spacer()
				.frame(width: 70)
			TabCountView(title: "메모", count: homeViewModel.memosCount)	// count 값을 홈이랑도 전달
			
			Spacer()
				.frame(width: 70)
			
			TabCountView(title: "음성메모", count: homeViewModel.voiceRecordersCount)	// count 값을 홈이랑도 전달
		}
	}
}

// MARK: - 각 탭 설정된 카운트 뷰 (공통 뷰 컴포넌트)
private struct TabCountView: View {
	@EnvironmentObject private var homeViewModel: HomeViewModel
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
	@EnvironmentObject private var homeViewModel: HomeViewModel
	
	fileprivate var body: some View {
		VStack {
			Rectangle()
				.fill(Color.customGray2)
				.frame(height: 1)
			
			// 각 탭 4개 이동 뷰 컴포넌트
			
			TabMoveView(
				title: "To do List",
				tabAction: {
					// 현재 선택된 탭을 변경
					// 탭뷰에 바인딩된 셀렉션을 변경하고 뷰로 띄움
					homeViewModel.changeSelectedTab(.todoList)
				}		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "메모장",
				tabAction: {
					homeViewModel.changeSelectedTab(.memo)
				}		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "음성메모",
				tabAction: {
					homeViewModel.changeSelectedTab(.voiceRecorder)
				}		// Home에서 tabAction 구현
			)
			
			TabMoveView(
				title: "타이머",
				tabAction: {
					homeViewModel.changeSelectedTab(.timer)
				}		// Home에서 tabAction 구현
			)
			// 설정은 안 해도 됨. 설정 페이지에서 설정 누를 일은 없다
			
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
			.environmentObject(HomeViewModel())
  }
}
