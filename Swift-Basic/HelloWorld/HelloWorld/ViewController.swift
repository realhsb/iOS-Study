//
//  ViewController.swift
//  HelloWorld
//
//  Created by 한수빈 on 2022/07/12.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var uiHello: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func sayHello(_ sender: Any) {
        self.uiHello.text = "Hello, World!"
    }
    
}

