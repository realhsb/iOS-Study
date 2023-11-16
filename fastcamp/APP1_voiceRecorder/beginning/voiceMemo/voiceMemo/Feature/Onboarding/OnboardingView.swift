//
//  OnboardingView.swift
//  voiceMemo
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var pathModel = PathModel()
    @StateObject private var onboardingViewModel = OnboardingViewModel()
	@StateObject private var todoListViewModel = TodoListViewModel()
  var body: some View {
      // TODO: - 화면 전환 구현 필요
//      OnboardingContentView(onboardingViewModel: onboardingViewModel)
      NavigationStack(path: $pathModel.paths) {  // pathModel를 가지고 뒤로 빠지거나 왔다갔다 -> .environmentObject 로 선언
//            OnboardingContentView(onboardingViewModel: onboardingViewModel)
				TodoListView()
					.environmentObject(todoListViewModel)
              .navigationDestination(
                for: PathType.self,         // 구분자 PathType
                destination: { pathType in  // 타입에 따라 어느 뷰로 갈지
                    switch pathType {
                    case .homeView:
                        HomeView()
                            .navigationBarBackButtonHidden()
                        
                    case .todoView:
                        TodoView()
                            .navigationBarBackButtonHidden()
														.environmentObject(todoListViewModel)	// todoListViewModel을 보여줌. path 타입에 따라 todoView를 보여줌. 그래서 todoListViewModel 주입해야 함 
                        
                    case .memoView:
                        MemoView()
                            .navigationBarBackButtonHidden()
                    }
                }
              )
      }
      .environmentObject(pathModel)  // 전역적으로 사용 가능
  }
}

// MARK: - 온보딩 컨텐츠 뷰
private struct OnboardingContentView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    
    fileprivate init(onboardingViewModel: OnboardingViewModel) {    // init이 왜 fileprivate 인가? 선언시에는 파일 내에서 사용하기 위해. private으로 하면 온보딩 때 사용 불가능하기 때문.
        self.onboardingViewModel = onboardingViewModel
    }
    
    fileprivate var body: some View {
        VStack {
            // 온보딩 셀리스트 뷰
            OnboardingCellListView(onboardingViewModel: onboardingViewModel)
            
            Spacer()
            
            // 시작 버튼 뷰
            StartBtnView()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

// MARK: - 온보딩 셀 리스트 뷰
private struct OnboardingCellListView: View {
    @ObservedObject private var onboardingViewModel: OnboardingViewModel
    @State private var selectedIndex: Int
    
    init(
        onboardingViewModel: OnboardingViewModel,
        selectedIndex: Int = 0
    ) {
        self.onboardingViewModel = onboardingViewModel
        self.selectedIndex = selectedIndex
    }
    
    fileprivate var body: some View {
        TabView(selection: $selectedIndex) {
            // 온보딩 셀 (하위에 만들기)
            ForEach(Array(onboardingViewModel.onboardingContents.enumerated()), id: \.element) { index, onboardingContent in
                OnboardingCellView(onboardingContent: onboardingContent)
                    .tag(index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 1.5)
        .background(
            selectedIndex % 2 == 0
            ? Color.customSky
            : Color.customBackgroundGreen
        )
        .clipped()
    }
}

// MARK: - 온보딩 셀 뷰
private struct OnboardingCellView: View {
    private var onboardingContent: OnboardingContent
    
    fileprivate init(onboardingContent: OnboardingContent) {
        self.onboardingContent = onboardingContent
    }
    
    fileprivate var body: some View {
        VStack {
            Image(onboardingContent.imageFileName)
                .resizable()
                .scaledToFit()
            
            HStack {
                Spacer()
                
                VStack {
                    Spacer()
                        .frame(height: 46)
                    
                    Text(onboardingContent.title)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                        .frame(height: 5)
                    
                    Text(onboardingContent.subTitle)
                        .font(.system(size: 16))
                }
                
                Spacer()
            }
            .background(Color.customWhite)
            .cornerRadius(0)
        }
        .shadow(radius: 10)
    }
}

// MARK: - 시작하기 버튼 뷰
// 비즈니스 로직 받아올 필요 X
private struct StartBtnView: View {
    @EnvironmentObject private var pathModel: PathModel
    
    fileprivate var body: some View {
        Button {
            pathModel.paths.append(.homeView)   // 시작하기 버튼을 누르면 홈뷰로 넘어감
        } label: {
            HStack {
                Text("시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.customGreen)
                
                Image("startHome")
                    .renderingMode(.template)
                    .foregroundColor(.customGreen)
            }
        }
        .padding(.bottom, 50)
    }
}


struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
  }
}
