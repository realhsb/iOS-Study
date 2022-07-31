//
//  ViewController.swift
//  Scene-Trans01
//
//  Created by 한수빈 on 2022/07/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func moveNext(_ sender: Any) {
        
        // 이동할 뷰 컨트롤러 객체를 StoryboardID 정보를 이용하여 참조.
        /*
         스크린에 새로 표시할 뷰 컨트롤러를 스토리보드로부터 읽어와 인스턴스화하는 부분
         */
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") else {
            return
        }
             
            // 화면 전환할 때의 애니메이션 타입
            uvc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            
            // 인자값으로 뷰 컨트롤러 인스턴스를 넣고 프레젠트 메소드 호출
            self.present(uvc, animated: true)
        
            
            
    }
    
}

