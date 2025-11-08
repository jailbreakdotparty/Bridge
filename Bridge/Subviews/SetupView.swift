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
                    Spacer()
                    Text("**Disclaimer:** This tool can NOT read or export applications that are user-installed.")
                        .font(.system(.subheadline))
                        .multilineTextAlignment(.center)
                        .opacity(0.8)
                        .frame(maxWidth: .infinity)
                }
                Spacer()
                VStack {
                    Button(action: {
                        // i absoutely hate this so much
                        if isBridgeSupported() {
                            Alertinator.shared.alert(title: "Warning!", body: "Make sure that you have Bridge's helper installed. If you have not installed it yet, click \"Download Shortcut.\"", showCancel: false, showContinue: true, continueAction: {
                                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
                            }, actionLabel: "Download Shortcut", action: {
                                openURL(URL(string: "https://jailbreak.party/bridge-helper")!)
                            })
                        } else {
                            Haptic.shared.play(.soft)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                let clipboardContents = staticApplist()
                                processAppList(clipboardContents: clipboardContents) { _ in
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        HStack {
                            if isBridgeSupported() {
                                Image(systemName: "square.2.stack.3d")
                                Text("Begin Setup")
                            } else {
                                Image(systemName: "arrow.forward")
                                Text("Continue")
                            }
                        }
                    }
                    .buttonStyle(GlassyButton(capsuleButton: true, useFullWidth: true))
                    if isBridgeSupported() {
                        Button(action: {
                            Haptic.shared.play(.soft)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                let clipboardContents = weOnADebugBuild ? debugApplist : UIPasteboard.general.string ?? ""
                                processAppList(clipboardContents: staticApplist()) { applistProcessed in
                                    if applistProcessed {
                                        dismiss()
                                    }
                                }
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Import Applist")
                            }
                        }
                        .buttonStyle(GlassyButton(color: .green, capsuleButton: true, useFullWidth: true))
                    }
                    if isBridgeSupported() {
                        Button("Skip & Use Static Applist", action: {
                            Alertinator.shared.alert(title: "Are you sure you want to do this?", body: "This will import an applist that was not parsed from your personal device. This may cause applications that aren't actually installed to show up.", showCancel: true, action: {
                                processAppList(clipboardContents: staticApplist()) { _ in
                                    dismiss()
                                }
                            })
                        })
                        .font(.system(.subheadline))
                        .padding(6)
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .padding(.horizontal, 15)
        }
    }
}

#Preview {
    SetupView()
}
