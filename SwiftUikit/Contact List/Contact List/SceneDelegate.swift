//
//  SceneDelegate.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // 1. Create a standard UIKit window
        let window = UIWindow(windowScene: windowScene)
        
        // 2. Load your Main.storyboard file programmatically
        let storyboard = UIStoryboard(name: "ContactList", bundle: nil)
        
        // 3. Instantiate the "Initial View Controller" (your Obj-C Navigation Controller)
        guard let rootVC = storyboard.instantiateInitialViewController() else {
            print("Error: No initial view controller set in Storyboard!")
            return
        }
        
        // 4. Set it as the root and display it
        window.rootViewController = rootVC
        self.window = window
        window.makeKeyAndVisible()
    }
}
