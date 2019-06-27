//  Created by Martin Mlostek on 02.06.19.

import UIKit
import ArcProgressView

/// The main view controller
class DemoViewController: UIViewController {

    @IBOutlet weak var arcProgressView: ArcProgressView!

    @IBAction func on0pressed() {
        arcProgressView.setProgress(0, animated: true)
    }

    @IBAction func onRandomPressed() {
        arcProgressView.setProgress(Double.random(in: 0..<1), animated: true)
    }

    @IBAction func on100pressed() {
        arcProgressView.setProgress(1.0, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        arcProgressView.setProgress(0.4, animated: true)
    }
}
