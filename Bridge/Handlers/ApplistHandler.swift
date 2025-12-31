//
//  ApplistHandler.swift
//  Bridge
//
//  Created by Main on 11/5/25.
//

import SwiftUI
import Combine
import PartyUI

func processAppList(clipboardContents: String, completion: @escaping (_ applistProcessed: Bool) -> Void) {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @Environment(\.openURL) var openURL
    
    if clipboardContents.isEmpty || !clipboardContents.contains("CoreServices") {
        Alertinator.shared.alert(title: "Error!", body: "An applist was not generated properly, or no applist was generated at all.", actionLabel: "Re-Run Shortcut", action: {
            openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
        })
    } else {
        let rawAppList = clipboardContents.components(separatedBy: "\n")
        for item in rawAppList {
            print(item)
            let parts = item.components(separatedBy: "?")
            let appName = parts.first ?? ""
            let partitionType = parts.last ?? ""
            if partitionType == "CoreServices" {
                secondaryPartitionAppList.append(item)
            } else {
                mainPartitionAppList.append(item)
            }
        }
        completion(true)
    }
}

func displayAppName(item: String) -> String {
    let parts = item.components(separatedBy: "?")
    let appName = parts.first ?? ""
    return appName
}

func isApplicationInMainPartition(item: String) -> Bool {
    let parts = item.components(separatedBy: "?")
    let appName = parts.last ?? ""
    
    if appName == "Applications" {
        return true
    } else {
        return false
    }
}

func staticApplist() -> String {
    if doubleSystemVersion() < 18.0 {
        return iOS17Applist
    } else if doubleSystemVersion() < 26.0 {
        return iOS18Applist
    } else {
        return iOS26Applist
    }
}

let debugApplist = "App1?Applications\nApp2?Applications\nApp3?Applications\nApp1?CoreServices\nApp2?CoreServices\nApp3?CoreServices"
