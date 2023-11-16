//
//  TodoView.swift
//  voiceMemo
//

import SwiftUI

struct TodoView: View {
	@EnvironmentObject private var pathModel: PathModel	// 뒤로 나갈 때는 path 삭제
	@EnvironmentObject private var todoListViewModel: TodoListViewModel // 여기 있는 addTodo 사용함
	@StateObject private var todoViewModel = TodoViewModel()
	
  var body: some View {
		VStack {
			CustomNavigationBar(
				leftBtnAction: {
					pathModel.paths.removeLast()
				},
				rightBtnAction: {
					todoListViewModel.addTodo(
						.init(
							title: todoViewModel.title,
							time: todoViewModel.time,
							day: todoViewModel.day,
							selected: false
							)
					)
					// 작성 버튼을 만들고 나가야 함
					pathModel.paths.removeLast()
				},
				rightBtnType: .create
			)
			
			// 타이틀 뷰
			TitleView()
				.padding(.top, 20)
			
			Spacer()
				.frame(height: 20)
			
			// 투두 타이틀 뷰 (텍스트 필드)
			TodoTitleView(todoViewModel: todoViewModel)
				.padding(.leading, 20)
			
			// 시간 선택
			SelectTimeView(todoViewModel: todoViewModel)
			
			// 날짜 선택
			SelectDayView(todoViewModel: todoViewModel)
				.padding(.leading, 20)
			
			Spacer()
		}
  }
}


// MARK: - 타이틀 뷰
private struct TitleView: View {
	fileprivate var body: some View {
		HStack {
			Text("To do list를\n추가해 보세요.")
			
			Spacer()
		}
		.font(.system(size: 30, weight: .bold))
		.padding(.leading, 20)
	}
}

// MARK: - 투두 타이틀 뷰 (제목 입력 뷰)
private struct TodoTitleView: View {
	@ObservedObject private var todoViewModel: TodoViewModel	// 위에서 StateObject로 만든  todoViewModel을 넣어줄 것. 아래에서 todoViewModel을 바인딩시키기 위해서.
	
	fileprivate init(todoViewModel: TodoViewModel) {
		self.todoViewModel = todoViewModel
	}
	
	fileprivate var body: some View {
		TextField("제목을 입력하세요.", text: $todoViewModel.title)	// todoViewModel을 바인딩 시켜주기 위해.
	}
}

// MARK: - 시간 선택
private struct SelectTimeView: View {
	@ObservedObject private var todoViewModel: TodoViewModel	// 시간 선택에 대한 바인딩 진행
	
	fileprivate init(todoViewModel: TodoViewModel) {
		self.todoViewModel = todoViewModel
	}
	
	fileprivate var body: some View {
		VStack {
			Rectangle()
				.fill(Color.customGray0)
				.frame(height: 1)
			
			DatePicker(
			"",
			selection: $todoViewModel.time,
			displayedComponents: [.hourAndMinute]	// 시, 분
			)
			.labelsHidden()
			.datePickerStyle(WheelDatePickerStyle())
			.frame(maxWidth: .infinity, alignment: .center)
			
			Rectangle()
				.fill(Color.customGray0)
				.frame(height: 1)
		}
	}
}

// MARK: - 날짜 선택 뷰
private struct SelectDayView: View {
	@ObservedObject private var todoViewModel: TodoViewModel
	
	fileprivate init(todoViewModel: TodoViewModel) {
		self.todoViewModel = todoViewModel
	}
	
	fileprivate var body: some View {
		VStack(spacing: 5) {
			HStack {
				Text("날짜")
					.foregroundColor(.customIconGray)
				
				Spacer()
			}
			
			HStack {
				Button {
					todoViewModel.setIsDisplayCalendar(true)	// true가 되면 캘린더가 뜸
				} label: {
					Text("\(todoViewModel.day.formattedDay)")
						.font(.system(size: 18, weight: .medium))
				}
				
				.popover(isPresented: $todoViewModel.isDisplayCalendar) {
					DatePicker(
						"",
						selection: $todoViewModel.day,
						displayedComponents: .date
					)
					.labelsHidden()
					.datePickerStyle(GraphicalDatePickerStyle())
					.frame(maxWidth: .infinity, alignment: .center)
					.padding()
					.onChange(of: todoViewModel.day) { _ in	// todoViewModel.day이 값이 변경될 때마다 어떤 동작을 취할 것인지
						todoViewModel.setIsDisplayCalendar(false)
					}
				}
				Spacer()
			}
		}
	}
}

struct TodoView_Previews: PreviewProvider {
  static var previews: some View {
    TodoView()
  }
}
