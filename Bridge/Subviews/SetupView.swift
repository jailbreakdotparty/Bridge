//
//  SetupView.swift
//  Bridge
//
//  Created by Main on 10/22/25.
//

import SwiftUI
import UIKit

struct SetupView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                WelcomeSheet(title: "Bridge") {
                    WelcomeSheetRow(header: "Open Internal Applications", text: "Open applications that are not usually available to the user.", icon: "ant")
                    WelcomeSheetRow(header: "Export Bundles", text: "Not only can you open internal applications, but you can export their bundles too.", icon: "archivebox")
                    WelcomeSheetRow(header: "Various Intergrations", text: "This tool uses Private APIs and the Shortcuts application.", icon: "link")
                    Text("**Disclaimer:** This tool can NOT read or export applications that are user-installed.")
                        .font(.system(.subheadline))
                        .multilineTextAlignment(.center)
                        .opacity(0.8)
                        .frame(maxWidth: .infinity)
                        .padding(.top)
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                VStack {
                    Button(action: {
                        Haptic.shared.play(.soft)
                        let clipboardContents = weOnADebugBuild ? "FTMInternal?Applications\nOtherApp?Applications\nSpringBoard?CoreServices" : UIPasteboard.general.string ?? ""
                        if clipboardContents.isEmpty || !clipboardContents.contains("CoreServices") {
                            Alertinator.shared.alert(title: "Error!", body: "An applist was not generated properly, or no applist was generated at all.", actionLabel: "Re-Run Shortcut", action: {
                                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
                            })
                        } else {
                            let rawAppList = clipboardContents.components(separatedBy: "\n")
                            for item in rawAppList {
                                let parts = item.components(separatedBy: "?")
                                let appName = parts.first ?? ""
                                let partitionType = parts.last ?? ""
                                if partitionType == "CoreServices" {
                                    secondaryPartitionAppList.append(appName)
                                } else {
                                    mainPartitionAppList.append(appName)
                                }
                            }
                            dismiss()
                        }
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Import Applist")
                        }
                    }
                    .buttonStyle(GlassyButton(useFullWidth: true))
                }
                .padding(.bottom, 50)
            }
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    SetupView()
}
