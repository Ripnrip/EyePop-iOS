//
//  ViewController.swift
//  EyePop
//
//  Created by Gurinder Singh on 4/1/19.
//  Copyright © 2019 Faswaldo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var images = [ UIImage(named: "Walkthrough 2 Full"), UIImage(named: "Walkthrough 3 Full") ]
    var clicktrack = 0 //TODO make this swipe
    @IBOutlet weak var tutorialButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func nextImage(_ sender: Any) {
        if clicktrack == 2 {
            self.performSegue(withIdentifier: "goToMap", sender: nil)
        } else {
            tutorialButton.setImage(images[clicktrack], for: .normal)
            clicktrack += 1
        }
    }
    
}

