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

extension EdgeInsets {
    static let dropdownRowInsets = EdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
    static let itemRowInsets = EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
}

func doubleSystemVersion() -> Double {
    let rawSystemVersion = UIDevice.current.systemVersion
    let parsedSystemVersion = rawSystemVersion.split(separator: ".").prefix(2).joined(separator: ".")
    return Double(parsedSystemVersion) ?? 0.0
}

func isBridgeSupported() -> Bool {
    return doubleSystemVersion() <= 26.0
}
