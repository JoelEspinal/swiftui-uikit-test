//
//  Contact_ListApp.swift
//  Contact List
//
//  Created by Joel Espinal on 11/6/26.
//
import SwiftUI

@main
struct Contact_ListApp: App {
    // This tells SwiftUI to use the traditional UIKit AppDelegate class
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    

    var body: some Scene {
        // We use an empty view or a placeholder scene because
        // the SceneDelegate below will immediately overwrite it with the Storyboard.
        ObjectiveC_BridgeScene()
    }
}

// A placeholder scene required to satisfy SwiftUI's @main requirements
struct ObjectiveC_BridgeScene: Scene {
    var body: some Scene {
        #if os(iOS)
        WindowGroup {
            Color.clear // This won't even be seen
        }
        #endif
    }
}
