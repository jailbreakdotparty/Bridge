//
//  BridgeApp.swift
//  Bridge
//
//  Created by Main on 10/21/25.
//

import SwiftUI

var weOnADebugBuild: Bool = false

@main
struct BridgeApp: App {
    init() {
        // i love skidding from skadz
        #if DEBUG
        weOnADebugBuild = true
        #else
        weOnADebugBuild = false
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}
