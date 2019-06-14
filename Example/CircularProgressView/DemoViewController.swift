//  Created by Martin Mlostek on 02.06.19.

import UIKit
import CircularProgressView

/// The main view controller
class DemoViewController: UIViewController {

    @IBOutlet weak var circularProgressView: CircularProgressView!

    @IBAction func on0pressed() {
        circularProgressView.setProgress(0, animated: true)
    }

    @IBAction func onRandomPressed() {
        circularProgressView.setProgress(Double.random(in: 0..<1), animated: true)
    }

    @IBAction func on100pressed() {
        circularProgressView.setProgress(1.0, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        circularProgressView.setProgress(0.4, animated: true)
    }
}