//
//  SetupView.swift
//  Bridge
//
//  Created by Main on 10/22/25.
//

import SwiftUI
import UIKit
import PartyUI

struct SetupView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @State private var hasShortcutRun: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                WelcomeSheet(title: "Bridge", cellContent: VStack {
                    VStack(spacing: 25) {
                        WelcomeSheetCell(icon: "ant", title: "Open Internal Applications", context: "Open applications that aren't available normally.")
                        WelcomeSheetCell(icon: "archivebox", title: "Export Bundles", context: "Export the bundles of various applications inside of specific partitions.")
                        WelcomeSheetCell(icon: "character.cursor.ibeam", title: "Open by Bundle ID", context: "You can also open an application by it's specific BID by adding it.")
                        Text("**Disclaimer:** This tool can NOT read or export applications that are user-installed.")
                            .font(.system(.subheadline))
                            .multilineTextAlignment(.center)
                            .opacity(0.8)
                            .frame(maxWidth: .infinity)
                    }
                }, buttonContent: VStack {
                    Button(action: {
                        if isBridgeSupported() {
                            if !hasShortcutRun {
                                Alertinator.shared.alert(title: "Warning!", body: "Make sure that you have Bridge's helper installed. If you have not installed it yet, click \"Download Shortcut.\"", showCancel: false, showContinue: true, continueAction: {
                                    openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
                                    hasShortcutRun = true
                                }, actionLabel: "Download Shortcut", action: {
                                    openURL(URL(string: "https://jailbreak.party/bridge-helper")!)
                                })
                            } else {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    let clipboardContents = weOnADebugBuild ? debugApplist : UIPasteboard.general.string ?? ""
                                    processAppList(clipboardContents: staticApplist()) { applistProcessed in
                                        if applistProcessed {
                                            dismiss()
                                        }
                                    }
                                }
                            }
                        } else {
                            Haptic.shared.play(.soft)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                let clipboardContents = staticApplist()
                                processAppList(clipboardContents: clipboardContents) { _ in
                                    dismiss()
                                }
                            }
                        }
                    }) {
                        if isBridgeSupported() {
                            ButtonLabel(text: hasShortcutRun ? "Continue" : "Run Shortcut", icon: hasShortcutRun ? "arrow.right" : "square.2.stack.3d")
                        } else {
                            ButtonLabel(text: "Continue", icon: "arrow.right")
                        }
                    }
                    .buttonStyle(GlassyButtonStyle())
                    
                    if isBridgeSupported() {
                        Button(action: {
                            Alertinator.shared.alert(title: "Are you sure you want to do this?", body: "This will import an applist that was not parsed from your personal device. This may cause applications that aren't actually installed to show up.", showCancel: true, action: {
                                processAppList(clipboardContents: staticApplist()) { _ in
                                    dismiss()
                                }
                            })
                        }) {
                            Text("Skip Setup")
                                .font(.callout)
                                .padding(.top, 6)
                        }
                    }
                })
            }
            .padding(.horizontal, 20)
            .background {
                if colorScheme == .dark {
                    AuroraBackground(color1: "591F76", color2: "5B2477", color3: "510D74", color4: "4D1867", background: "1F092A")
                        .ignoresSafeArea()
                } else {
                    AuroraBackground(color1: "E8B9FF", color2: "DB94FF", color3: "D684FF", color4: "DF9FFF", background: "F0D2FF")
                        .ignoresSafeArea()
                }
            }
        }
    }
}

#Preview {
    SetupView()
}
