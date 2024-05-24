//
//  ToodoListView.swift
//  voiceMemo
//

import SwiftUI

struct TodoListView: View {
	@EnvironmentObject private var pathModel: PathModel
	@EnvironmentObject private var todoListViewModel: TodoListViewModel
	// 왜 StateObject가 아니라 EnvironmentObject?
	// todoListModel 뿐만 아니라, TodoView에서도 사용!
	// todoListViewModel은 todoListView의 하위뷰로 생성된 것이 아님!
	// -> 독립적인 개체
	@EnvironmentObject private var homeViewModel: HomeViewModel
	
	var body: some View {
		ZStack {
			// todo cell list
			VStack {	// 내비게이션 바 제일 먼저
				if !todoListViewModel.todos.isEmpty {	// 내비게이션바 있을 때 + todo 아무것도 없으면 내비게이션바의 편집 버튼 비활성화
					CustomNavigationBar(
						isDisplayLeftBtn: false,
						rightBtnAction: {
							todoListViewModel.navigationRightBtnTapped()
						},
						rightBtnType: todoListViewModel.navigationBarRightBtnMode
					)
				} else {														// 내비게이션바 없을 때
					Spacer()
						.frame(height: 30)
				}
				
				TitleView()
					.padding(.top, 30)
				if todoListViewModel.todos.isEmpty {
					
					AnnouncementView()
				} else {
					TodoListContentView()
						.padding(.top, 20)
				}
			}
			
			WriteTodoBtnView()
				.padding(.trailing, 20)
				.padding(.bottom, 50)
		}
		.alert(
			"To do list \(todoListViewModel.removeTodosCount)개 삭제하시겠습니까?",
			isPresented: $todoListViewModel.isDisplayRemoveTodoAlert
		) {
			Button("삭제", role: .destructive) {
				todoListViewModel.removeBtnTapped()
			}
			
			Button("취소", role: .cancel) {}
		}
		.onChange(
			of: todoListViewModel.todos,
			perform: { todos in
				// todo 개수가 변할 떄마다, 호출 -> todos.count를 실시간으로 homeView에 넘겨줌
				homeViewModel.setTodosCount(todos.count)
			}
		) // of : 어떤 게 변했을 떄, 변한 값을 바인딩 / 변한값에 따라서 어떻게 동작할지 perform으로 정의
	}
}
	
	// 프로퍼티
//	var titleView: some View {
//		Text("title")
//	}
	
	// 메서드
	// 프로퍼티나ㅏ 메서드는 따로 상위에서 주입 받을 게 없음
	// 대신 이 뷰에서만 사용 가능. 외부에서 사용 불가. 그래서 아래처럼 struct로 빼기도 함.
//	func titleView2() -> some View {
//		Text("Title")
//	}
	
	


// MARK: - TodoList 타이틀 뷰
private struct TitleView: View {	// 3번째 방법. struct&주입 | 상위 뷰에서 주입을 받은 후 사용. -> 자주 사용되는 것은 이렇게 구현하는 게 편함. 컴포넌트로 빼기 때문에 다른 곳에서도 사용 가능
	@EnvironmentObject private var todoListViewModel: TodoListViewModel // 이런 식으로 변수 재선언 해야 함.
	
	fileprivate var body: some View {
		HStack {
			if todoListViewModel.todos.isEmpty {
				Text("To do list를\n를 추가해 보세요.")
			} else {
				Text("To do list\(todoListViewModel.todos.count)")	// todoListViewModel 안에 count를 담은 프로퍼티를 담아도 상관X. 
			}
			
			Spacer()
		}
		.font(.system(size: 30, weight: .bold))
		.padding(.leading, 20)
	}
}

// MARK: - TodoList 안내 뷰
// VM 필요 없음. 사진과 텍스트가 고정.
private struct AnnouncementView: View {
	fileprivate var body: some View {
		VStack(spacing: 15) {
			Spacer()
			
			Image("pencil")
				.renderingMode(.template)	// 나중에 색상을 텍스트와 함께 변환
			Text("\"매일 아침 5시 운동가라고 알려줘\"")
			Text("\"내일 8시 수강신청하자!\"")
			Text("\"1시 30분 점심 약속 리마인드 해줭\"")
			
			Spacer()
		}
		.font(.system(size: 16))
		.foregroundColor(.customGray2)
	}
}

// MARK: - TodoList 컨텐츠 뷰
private struct TodoListContentView: View {
	@EnvironmentObject private var todoListViewModel: TodoListViewModel
	
	fileprivate var body: some View {
		VStack {
			HStack {
				Text("할일 목록")
					.font(.system(size: 16, weight: .bold))
					.padding(.leading, 20)
				
				Spacer()
			}
			
			ScrollView(.vertical) {
				VStack(spacing: 0) {
					Rectangle()
						.fill(Color.customGray0)
						.frame(height: 1)
					
					ForEach(todoListViewModel.todos, id: \.self) { todo in
						// TODO: - Todo 셀 뷰 todo 넣어서 뷰 호출
						TodoCellView(todo: todo)
					}
				}
			}
		}
	}
}

// MARK: - Todo 셀 뷰
private struct TodoCellView: View {
	@EnvironmentObject private var todoListViewModel: TodoListViewModel
	@State private var isRemoveSelected: Bool
	private var todo: Todo
	
	fileprivate init(
		isRemoveSelected: Bool = false,
		todo: Todo								// 받아와야 하니 초기값 없음
	) {
		_isRemoveSelected = State(initialValue: isRemoveSelected)
		self.todo = todo
	}
	
	fileprivate var body: some View {
		VStack(spacing: 20) {
			HStack {
				if !todoListViewModel.isEditTodoMode {	// 편집 모드가 아닐 경우
					Button {
						todoListViewModel.selectedBoxTapped(todo)
					} label: {
						todo.selected ? Image("selectedBox") : Image("unSelectedBox")
					}
				}
				
				VStack(alignment: .leading, spacing: 5) {
					Text(todo.title)
						.font(.system(size: 16))
						.foregroundColor(todo.selected ? .customIconGray : .customBlack)
						.strikethrough(todo.selected)	// 가운데 줄 긋기 
					
					Text(todo.convertedDayAndTime)		// VM에서 가공한 시간 가져오기
						.font(.system(size: 16))
						.foregroundColor(.customIconGray)
				}
				
				Spacer()
				
				if todoListViewModel.isEditTodoMode {	// 편집 모드일 경우 -> 삭제 버튼 필요
					Button {
						isRemoveSelected.toggle()
						todoListViewModel.todoRemoveSelectedBoxTapped(todo)
					} label: {
						isRemoveSelected ? Image("selectedBox") : Image("unSelectedBox")
					}
				}
			}
			.padding(.horizontal, 20)	// HSTACK
			.padding(.top, 10)
			
			Rectangle()
				.fill(Color.customGray0)
				.frame(height: 1)
		}
	}
}

// MARK: - Todo 작성 버튼 뷰
private struct WriteTodoBtnView: View {
	@EnvironmentObject private var pathModel: PathModel
	
	fileprivate var body: some View {
		VStack {
			Spacer()
			
			HStack {
				Spacer()
				
				Button {
					pathModel.paths.append(.todoView)
				} label: {
					Image("writeBtn")
				}
			}
		}
	}
}

struct TodoListView_Previews: PreviewProvider {
  static var previews: some View {
    TodoListView()
			.environmentObject(PathModel())
			.environmentObject(TodoListViewModel())
  }
}
