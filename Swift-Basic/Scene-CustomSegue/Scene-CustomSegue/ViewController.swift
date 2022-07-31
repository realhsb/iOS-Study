//
//  ViewController.swift
//  Scene-CustomSegue
//
//  Created by 한수빈 on 2022/07/26.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if (segue.identifier=="custom_segue"){
            NSLog("커스텀 세그가 실행됩니다.")
        } else if(segue.identifier=="action_segue"){
            NSLog("액션 세그가 실행됩니다.")
        } else {
            NSLog("알 수 없는 세그입니다.")
        }
        //NSLog("segueway identifier: \(segue.identifier!)")
    }

}

