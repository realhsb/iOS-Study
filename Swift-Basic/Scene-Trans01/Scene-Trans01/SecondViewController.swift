import UIKit
class SecondViewController: UIViewController {
     
    
    @IBAction func dismiss(_ sender: Any) {
        
        self.presentingViewController?.dismiss(animated: true)
    }
}
