//
//  TodoListViewModel.swift
//  voiceMemo
//

import Foundation

class TodoListViewModel: ObservableObject {
	@Published var todos: [Todo]
	@Published var isEditTodoMode: Bool		// 편집모드인지 아닌지에 따라 뷰가 약간 다름
	@Published var removeTodos: [Todo]
	@Published var isDisplayRemoveTodoAlert: Bool		// Alert이 뜨고 삭제할지 안 할지
	
	var removeTodosCount: Int {	// count를 프로퍼티로 넣어도 됨.
		return removeTodos.count
	}
	
	var navigationBarRightBtnMode: NavigationBtnType {	// 편집모드면 -> .complete, 편집모드가 아니면 -> .edit
		isEditTodoMode ? .complete : .edit
	}
	
	init(
		todos: [Todo] = [],
		isEditModeTodoMode: Bool = false,
		removeTodos: [Todo] = [],
		isDisplayRemoveTodoAlert: Bool = false
	) {
		self.todos = todos
		self.isEditTodoMode = isEditModeTodoMode
		self.removeTodos = removeTodos
		self.isDisplayRemoveTodoAlert = isDisplayRemoveTodoAlert
	}
}

extension TodoListViewModel {	// TodoList가 실제로 체크되었는지 확인
	
	// 셀 터치시, Todo의 selected 값 toggle
	func selectedBoxTapped(_ todo: Todo) {
		if let index = todos.firstIndex(where: { $0 == todo }) {
			todos[index].selected.toggle()
		}
	}
	
	func addTodo(_ todo: Todo) {
		todos.append(todo)
	}
	
	// 우측 버튼 클릭시
	func navigationRightBtnTapped() {
		if isEditTodoMode {
			if removeTodos.isEmpty {	// 삭제되어 있는 게 비어있나
				isEditTodoMode = false
			} else {
				// Alert 부르기
				setDisplayRemoveTodoAlert(true)	// isDisplayRemoveTodoAlert 프로퍼티에 true로 바꿈. -> Alert 뜸
			}
		} else {	// edit 모드가 아니라면, edit 모드로 바꿈!
			isEditTodoMode = true
		}
	}
	
	func setDisplayRemoveTodoAlert(_ isDisplay: Bool) { // Alert 띄울 건지
		isDisplayRemoveTodoAlert = isDisplay		// 상태값 변경... 바인딩
	}
	
	func todoRemoveSelectedBoxTapped(_ todo: Todo){ // 체크박스 누를 때마다 Todo가 담겨옴! 어떤 Todo를 삭제해야 하는지.
		if let index = removeTodos.firstIndex(of: todo) { // 지금 이 Todo가 들어있냐? 검사
			removeTodos.remove(at: index)	// 체크했다가 다시 해제할 수 있으니까... Todo 있으면 삭제
		} else {
			removeTodos.append(todo)
		}
	}
	
	func removeBtnTapped() {	// remove 버튼 눌렀을 때
		todos.removeAll { todo in
			removeTodos.contains(todo)	// todos에 있는 todo가 removeTodos에 있다면 삭제
		}
		
		removeTodos.removeAll()	// 초기화
		isEditTodoMode = false	// 편집 모드 해제
	}
}
