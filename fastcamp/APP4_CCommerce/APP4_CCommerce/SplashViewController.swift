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
        
        lottieAnimationView.play()
    }
}
