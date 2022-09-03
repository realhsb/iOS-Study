import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var button: UIButton!
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        var constraintX: NSLayoutConstraint
        constraintX = button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        
        var constraintY: NSLayoutConstraint
        constraintY = button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        
        constraintX.isActive = true
        constraintY.isActive = true
        
        var widthConstraint: NSLayoutConstraint
        widthConstraint = label.widthAnchor.constraint(equalTo: button.widthAnchor, multiplier: 2.0)
        
        label.backgroundColor = UIColor.brown
        button.backgroundColor = UIColor.blue
        
        widthConstraint.isActive = true
    }


}

