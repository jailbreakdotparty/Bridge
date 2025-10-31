//
//  BridgeApp.swift
//  Bridge
//
//  Created by Main on 10/21/25.
//

import SwiftUI
import DeviceKit

var weOnADebugBuild: Bool = false
let device = Device.current

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

func doubleSystemVersion() -> Double {
    let rawSystemVersion = UIDevice.current.systemVersion
    let parsedSystemVersion = rawSystemVersion.split(separator: ".").prefix(2).joined(separator: ".")
    return Double(parsedSystemVersion) ?? 0.0
}

func isBridgeSupported() -> Bool {
    return doubleSystemVersion() <= 26.0
}
