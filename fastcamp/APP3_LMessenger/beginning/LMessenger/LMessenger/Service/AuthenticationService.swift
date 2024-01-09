//
//  AuthenticationService.swift
//  LMessenger
//
//  Created by Subeen on 1/4/24.
//

import Foundation
import Combine
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

enum AuthenticationError: Error {
    case clientIDError  // client id가 없음
    case tokenError     // 토큰 없음
    case invalidated
}

// 뷰모델과 서비스, 프로바이더 레이어를 컴바인으로 연결

protocol AuthenticationServiceType {
    func checkAuthenticationState() -> String?  // 로그인 유지
    
    // 서비스에서 다루는 에러타입 추가
    func signInWithGoogle() -> AnyPublisher<User, ServiceError>
}

class AuthenticationService: AuthenticationServiceType {
    
    func checkAuthenticationState() -> String? {
        // 파베 사용. 현재 유저 정보가 있는지 체크 -> 그에 대한 유저 정보 추출
        if let user = Auth.auth().currentUser {
            return user.uid
        } else {
            return nil
        }
    }
    // 구현체 완성! 서비스에 추가하기.
    /* 구글 로그인은 컴바인을 제공하지 않음
     응답으로 컴플리션 핸들러 구현, 그 핸들러를 가지고 퓨처로 퍼블리셔 생성
    */
    
    // 아래 작업한 내용을 가지고 퍼블리셔 만들기
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> { // 성공하면 User 정보가 방출됨 
        Future { [weak self] promise in // 이 작업이 완료되면, 결과값을 방출하고 끝내는 퍼블리셔
            self?.signInWithGoogle { result in
                switch result {
                case let .success(user):
                    promise(.success(user)) // 성공 시 유저 정보 보내기
                case let .failure(error):
                    promise(.failure(.error(error)))
                }
            }
        }.eraseToAnyPublisher()
        // 만든 퍼블리셔 뷰모델에 연결하기
    }
}

extension AuthenticationService {
    
    // 구글 로그인
    private func signInWithGoogle(completion: @escaping (Result<User, Error>) -> Void) {
        // 파베 앱 통해서 유저 아이디 가져오기
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            // 없다면 컴플리션에 failure를 파라미터로 전달
            completion(.failure(AuthenticationError.clientIDError))
            return
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // 구글로그인이 뜰 창
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result , error in
            // 완료시
            if let error {
                completion(.failure(error))
                return
            }
            
            // 로그인 완료시
            // id 토큰, 액세스 토큰으로 crendentional을 만들어 파베의 인증 진행
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                completion(.failure(AuthenticationError.tokenError))   // error2 : 토큰이 없을 경우
                return
            }
            
            let accessToken = user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // TODO: 구글로그인 성공시 // [weak self] result 로 설정
            self?.authenticateUserWithFirebase(credential: credential, completion: completion)
        }
    }
    
    // firebase 인증
    private func authenticateUserWithFirebase(credential: AuthCredential, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error {
                completion(.failure(error))
                return
            }
            
            guard let result else {
                completion(.failure(AuthenticationError.invalidated))
                return
            }
            
            // 유저 정보 세팅
            let firebaseUser = result.user
            let user: User = .init(id: firebaseUser.uid,
                                   name: firebaseUser.displayName ?? "",
                                   phoneNumber: firebaseUser.phoneNumber,
                                   profileURL: firebaseUser.photoURL?.absoluteString)
            
            completion(.success(user))  // 인증 성공
        }
    }
}

// 프리뷰용 서비스 
class StubAuthenticationService: AuthenticationServiceType {
    
    func checkAuthenticationState() -> String? {
        return nil
    }
     
    func signInWithGoogle() -> AnyPublisher<User, ServiceError> {
        Empty().eraseToAnyPublisher()
    }
}
