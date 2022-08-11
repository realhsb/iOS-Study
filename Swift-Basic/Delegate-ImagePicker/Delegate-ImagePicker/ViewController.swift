import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var imgView: UIImageView!
    
    @IBAction func pick(_ sender: Any) {
        // 이미지 피커 컨트롤러 인스턴스 생성
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true // 이미지 소스로 사진 라이브러리 선택
        
        // 추가된 부분) 델리게이트 지정
        picker.delegate = self
        
        // 이미지 피커 컨트롤러 실행
        self.present(picker, animated: false)
    }
    
    
}

// MARK:- 이미지 피커 컨트롤러 델리게이트 메소드
extension ViewController : UIImagePickerControllerDelegate {
    // 이미지 피커에서 이미지를 선택하지 않고 취소헀을 때 호출되는 메소드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 피커 컨트롤러 창 닫기
        picker.dismiss(animated: false) {() in      // 트레일링 클러저 문법
        /*
         dismiss 메소드를 호출하는 대상은 반드시 프레젠테이션 방식으로 자신을 노출시켜준 뷰 컨트롤러
         picker.presentingViewController?.dismiss ( = self.presentingViewController) 가 아니라
         왜 picker 인스턴스에서 메소드를 호출하는가?
         -> 내부적으로 알아서 self.presentingViewController로 연결함
         
         */
        
        // 알림창 호출
        let alert = UIAlertController(title: "", message: "이미지 선택이 취소되었습니다.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))
        self.present(alert, animated: false)
        }
    }
    /*
     이미지 피커 컨트롤러가 조금 늦게 닫히고 알림창 구문이 호출될 경우 알림창이 실행되지 않는 버그 발생 가능
     dismiss(animated:complete:)메소드를 사용하여 이미지 피커 컨트롤러 창이 완전히 닫힌 후에 다음 로직이
     실행하도록 수정
     */
    
    
    // 이미지 피커에서 이미지를 선택했을 떄 호출되는 메소드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 이미지 피커 컨트롤러 창 닫기
        picker.dismiss(animated: false) { () in
            // 이미지를 이미지 뷰에 표시
            /*
             읽어온 값은 이미지 데이터를 담고 있지만 Any 타입, UIImage타입으로 캐스팅
             */
            let img = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = img
        }
    }
}

// MARK:- 내비게이션 컨트롤러 델리게이트 메소드
extension ViewController : UINavigationControllerDelegate {
    
}
