// Copyright (c) 2019 mlostek@gmail.com. All rights reserved.

import UIKit

@UIApplicationMain
class DemoAppDelegate: UIResponder, UIApplicationDelegate {

    /// Main window
    var window: UIWindow?

    /// Application start
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // skip if we are a unit test
        if isUnitTest() {
            window = nil
            return false
        }
        return true
    }

    /// Helper to find out if we are in a unit test
    private func isUnitTest() -> Bool {
        return NSClassFromString("XCTestCase") != nil
    }

}
