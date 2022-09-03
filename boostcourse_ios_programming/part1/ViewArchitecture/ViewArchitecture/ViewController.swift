//
//  ViewController.swift
//  ViewArchitecture
//
//  Created by 한수빈 on 2022/08/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 서브뷰 생성
        let frame = CGRect(x: 60, y: 120, width: 240, height: 120)
        let subView = UIView(frame: frame)
        
        // 서브뷰 색상
        subView.backgroundColor = UIColor.blue
        
        // 서브뷰 추가
        view.addSubview(subView)
        
        // 서브뷰 제거
        subView.removeFromSuperview()
    }
}

