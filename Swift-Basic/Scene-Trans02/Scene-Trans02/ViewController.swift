//
//  ViewController.swift
//  Scene-Trans02
//
//  Created by 한수빈 on 2022/07/25.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func moveByNavi(_ sender: Any) {
        // 두번째 뷰 컨트롤러 인스턴스를 가져온다.
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") else {
            return
        }
        
        // 화면을 전환한다.
        self.navigationController?.pushViewController(uvc, animated: true)
    }
    
    
    @IBAction func movePresent(_ sender: Any) {
        // 두 번째 뷰 컨트롤러 인스턴스를 가져온다.
        guard let uvc = self.storyboard?.instantiateViewController(withIdentifier: "SecondVC") else {
            return
        }
        // 화면을 전환한다.
        self.present(uvc, animated: true)
    }
}

