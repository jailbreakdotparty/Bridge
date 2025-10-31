//
//  ApplicationHandler.swift
//  Bridge
//
//  Created by Main on 10/24/25.
//

import SwiftUI
import UIKit
import Combine

func handleApplication(handleType: String, applicationName: String) {
    @Environment(\.openURL) var openURL
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    @AppStorage("showFirstTimeAlert") var showFirstTimeAlert: Bool = true
    
    if handleType == "open" {
        if showFirstTimeAlert {
            Alertinator.shared.alert(title: "Notice!", body: "Some apps may not open properly. If an app does not seem to open properly, press the icon in the top right of the toolbar. This will switch between the Shortcuts and in-app method of opening applications.")
            showFirstTimeAlert = false
        } else {
            let bundleID = "com.apple.\(applicationName)"
            if openWithShortcuts {
                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Open*\(applicationName)")!)
            } else {
                LSApplicationWorkspace.default().openApplication(withBundleID: bundleID)
            }
        }
    } else if handleType == "export" {
        openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Export*\(applicationName)")!)
    } else {
        Alertinator.shared.alert(title: "That was NOT supposed to happen.", body: "If you're seeing this, I probably screwed up something.")
    }
}
