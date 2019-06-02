//
//  DemoViewController.swift
//  CircularProgressView_Example
//
//  Created by Martin Mlostek on 02.06.19.
//  Copyright © 2019 mlostek@gmail.com. All rights reserved.
//

import UIKit
import CircularProgressView

class DemoViewController: UIViewController {

    @IBOutlet weak var circularProgressView: CircularProgressView!
    
    @IBAction func onAnimatePressed() {
        circularProgressView.setProgress(Float.random(in: 0 ..< 1), animated: true)
    }
}
