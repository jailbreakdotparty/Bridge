//
//  ApplicationHandler.swift
//  Bridge
//
//  Created by Main on 10/24/25.
//

import SwiftUI
import UIKit

func handleApplication(handleType: String, applicationName: String) {
    @Environment(\.openURL) var openURL
    
    if handleType == "open" {
        let bundleID = "com.apple.\(applicationName)"
        if isDatAppInstalled(bundleID) {
            LSApplicationWorkspace.default().openApplication(withBundleID: bundleID)
        } else {
            Alertinator.shared.alert(title: "Error!", body: "The application was not found, so it could not be opened.", actionLabel: "Try with Shortcuts", action: {
                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Open*\(applicationName)")!)
            })
        }
    } else if handleType == "export" {
        openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Export*\(applicationName)")!)
    } else {
        Alertinator.shared.alert(title: "That was NOT supposed to happen.", body: "If you're seeing this, I probably screwed up something.")
    }
}

// thanks skadz108
func isDatAppInstalled(_ bundleID: String) -> Bool {
    typealias SBSLaunchFunction = @convention(c) (
        String,
        URL?,
        [String: Any]?,
        [String: Any]?,
        Bool
    ) -> Int32
    
    guard let sbsLib = dlopen("/System/Library/PrivateFrameworks/SpringBoardServices.framework/SpringBoardServices", RTLD_NOW) else {
        print("[!] dlopen fail !!")
        return false
    }
    
    defer {
        dlclose(sbsLib)
    }
    
    guard let sbsAddr = dlsym(sbsLib, "SBSLaunchApplicationWithIdentifierAndURLAndLaunchOptions") else {
        print("[!] dlsym fail !!")
        return false
    }
    
    print("[*] here comes the super secret trollstore detector \"sandbox escape\" app store edition")
    let sbsFunction = unsafeBitCast(sbsAddr, to: SBSLaunchFunction.self)
    
    let result = sbsFunction(bundleID, nil, nil, nil, true)
    
    return result == 9
}
