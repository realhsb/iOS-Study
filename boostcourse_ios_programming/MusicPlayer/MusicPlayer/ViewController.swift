//
//  ViewController.swift
//  MusicPlayer
//
//  Created by 한수빈 on 2022/05/19.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK : IBOutlets
    @IBOutlet var playPauseButton : UIButton!
    @IBOutlet var timeLable : UILabel!
    @IBOutlet var progressSlider : UISlider!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func touchUpPlayPauseButton(_ sender: UIButton){
        print("button tapped")
    }
    @IBAction func sliderValueChanged(_ sender: UISlider) {
        print("slider value changed")
    }
}

