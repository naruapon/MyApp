//
//  ViewController.swift
//  TestApp
//
//  Created by AirNP on 9/22/2559 BE.
//  Copyright © 2559 AirNP. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var displayLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }




    
    @IBAction func saySomethingTapped(_ sender: UIButton) {
        displayLabel.text = "Hello World!"
    }
    
}

