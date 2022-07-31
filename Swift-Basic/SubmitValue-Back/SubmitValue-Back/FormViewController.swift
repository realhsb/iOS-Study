import UIKit

class FormViewController: UIViewController {
    
    @IBOutlet var email: UITextField!
    @IBOutlet var isUpdate: UISwitch!
    @IBOutlet var interval: UIStepper!
    
    @IBOutlet var isUpdateText: UILabel!
    @IBOutlet var intervalText: UILabel!
    
    @IBAction func onSwitch(_ sender: UISwitch) {
        if(sender.isOn == true){
            self.isUpdateText.text = "갱신함"
        }else {
            self.isUpdateText.text = "갱신하지 않음"
        }
    }
    
    @IBAction func onStepper(_ sender: UIStepper) {
        let value = Int(sender.value)
        self.intervalText.text = "\(value)분 마다"
    }
    
    
    
    // submit 버튼을 클릭했을 때 호출되는 메소드
    @IBAction func onSubmit(_ sender: Any) {
        
        // 1.
//        // presentingViewController 속성을 통해 이전 화면 객체를 읽어온 다음, ViewController 타입으로 캐스팅한다.
//
//        // 중요!
//        // 전달해 줄 대상 뷰 컨트롤러의 인스턴스를 찾아오는 역할
//        let preVC = self.presentingViewController
//        guard let vc = preVC as? ViewController else {
//            return
//        }
        
//        // 값을 전달한다.
//        vc.paramEmail = self.email.text
//        vc.paramUpdate = self.isUpdate.isOn
//        vc.paramInterval = self.interval.value
        
        
        // 2.
//        // AppDelegate 객체의 인스턴스를 가져온다.
//        let ad = UIApplication.shared.delegate as? AppDelegate  // 중요
//        /*
//         AppDelegate는 앱 전체를 통틀어 하나의 인스턴스만 존재, 싱글톤
//         인스턴스 직접 생성 불가, UIApplication.shared.delegate 구문을 통해 현재 생성되어 있는 인스턴스 참조
//         */
//
//        // 값을 저장한다.
//        ad?.paramEmail = self.email.text
//        ad?.paramUpdate = self.isUpdate.isOn
//        ad?.paramInterval = self.interval.value
//
//        // 이전 화면으로 복귀한다.
//        self.presentingViewController?.dismiss(animated: true)
        
        // 3.
        // Submit 버튼을 클릭했을 때 호출되는 메소드
        let ud = UserDefaults.standard
        
        // 값을 저장한다. Hash 같은 것, key는 항상 String
        ud.set(self.email.text, forKey: "email")
        ud.set(self.isUpdate.isOn, forKey: "isUpdate")
        ud.set(self.interval.value, forKey: "interval")
        
        // 이전 화면 복귀
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    
}
