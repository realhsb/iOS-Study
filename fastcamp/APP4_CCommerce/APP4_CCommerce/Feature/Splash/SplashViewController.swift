//
//  SplashViewController.swift
//  APP4_CCommerce
//
//  Created by Soop on 6/28/25.
//

import UIKit
import Lottie

class SplashViewController: UIViewController {

    @IBOutlet weak var lottieAnimationView: LottieAnimationView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)   // 상속 받았기 때문에 super 붙이기
        
        
        
        
        lottieAnimationView.play { _ in
            let storyboard = UIStoryboard(name: "Home", bundle: nil) // 스토리보드를 사용하려면 꼭 ... 설정하기 ...
            let viewController = storyboard.instantiateInitialViewController() // 스토리보드의 적용사항 반영하기
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
                window.rootViewController = viewController // 스토리보드 꼬옥 연결해주기...
            }
        }
    }
}
