//
//  ViewController.swift
//  SubmitValue
//
//  Created by 한수빈 on 2022/07/29.
//

import UIKit

class ViewController: UIViewController {
    
    // 이메일 주소를 입력받는 텍스트 필드
    @IBOutlet var email: UITextField!
    
    // 자동 갱신 여부를 설정하는 스위치
    @IBOutlet var isUpdate: UISwitch!
    
    // 갱신 주기를 설정하는 스테퍼
    @IBOutlet var interval: UIStepper!
    
    // 자동갱신 여부를 표시하는 레이블
    @IBOutlet var isUpdateText: UILabel!
    
    //갱신주기를 테이블로 표시하는 레이블
    @IBOutlet var intervalText: UILabel!
    
    // 자동 갱신 여부가 바뀔 때마다 호출되는 메소드
    @IBAction func onSwitch(_ sender: UISwitch) {
        if(sender.isOn == true) {
            self.isUpdateText.text = "갱신함"
        }else {
            self.isUpdateText.text = "갱신하지 않음"
        }
    }
    
    // 갱신주기가 바뀔 때마다 호출되는 메소드
    @IBAction func onStepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        self.intervalText.text = "\(value)분 마다"
    }
    
    @IBAction func onSubmit(_ sender: Any) {
        // VC2의 인스턴스 생성
        guard let rvc = self.storyboard?.instantiateViewController(withIdentifier:
                                                                    "RVC") as? ResultViewController else {
            return
        }
        
        // 값 전달
        rvc.paramEmail = self.email.text!   // 이메일
        /*
         값이 비어 있을 경우를 대비하여 옵셔널 타입으로 선언,
         그러나 이 값을 받을 VC2 쪽 paramEmail 속성은 옵셔널이 아닌 일반 문자열 타입
         형태를 맞추기 위해 옵셔널 강제 해제 연산자 ! 사용
         */
        
        rvc.paramUpdate = self.isUpdate.isOn    // 자동갱신 여부
        rvc.paramInterval = self.interval.value // 갱신 주기
        
        // 화면 이동
        // self.present(rvc, animated: true)
        
        // 내비게이션 컨트롤러를 이용한 푸시 방식의 화면 전환
        self.navigationController?.pushViewController(rvc, animated: true)
    }
    
    
    @IBAction func onPerformSegue(_ sender: Any) {
        self.performSegue(withIdentifier: "ManualSubmit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 목적지 뷰 컨트롤러의 인스턴스 읽어오기
        let dest = segue.destination
        
        guard let rvc = dest as? ResultViewController else {
            return
        }
        
        // 값 전달
        rvc.paramEmail = self.email.text!       // 이메일
        rvc.paramUpdate = self.isUpdate.isOn    // 자동갱신 여부
        rvc.paramInterval = self.interval.value // 갱신 주기
        
        
    }
}

