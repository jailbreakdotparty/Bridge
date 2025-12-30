//
//  SettingsView.swift
//  Bridge
//
//  Created by Main on 10/23/25.
//

import SwiftUI
import DeviceKit
import PartyUI

struct SettingsView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    @AppStorage("enableFavorites") var enableFavorites: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HeaderLabel(text: "About", icon: "info.circle")) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 12) {
                            Image("Bridge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                                .background(.black)
                                .clipShape(.rect(cornerRadius: 18))
                            VStack(alignment: .leading) {
                                Text("Bridge")
                                    .font(.system(.title3, weight: .semibold))
                                Text("Version \(UIApplication.appVersion!) (\(weOnADebugBuild ? "Debug" : "Release"))")
                            }
                        }
                        VStack {
                            Button(action: {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    openURL(URL(string: "https://jailbreak.party")!)
                                }
                            }) {
                                ButtonLabel(text: "Website", icon: "globe")
                            }
                            .buttonStyle(GlassyButtonStyle(color: .blue, useFullWidth: true))
                        }
                        HStack {
                            Button(action: {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    openURL(URL(string: "https://jailbreak.party/discord")!)
                                }
                            }) {
                                ButtonLabel(text: "Discord", icon: "discord", isRegularImage: true)
                            }
                            .buttonStyle(GlassyButtonStyle(color: .discord, useFullWidth: true))
                            Button(action: {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    openURL(URL(string: "https://jailbreak.party/discord")!)
                                }
                            }) {
                                ButtonLabel(text: "GitHub", icon: "github", isRegularImage: true)
                            }
                            .buttonStyle(GlassyButtonStyle(color: .gitHub, useFullWidth: true))
                        }
                    }
                }
                Section(header: HeaderLabel(text: "Support Status", icon: device.isPad ? "ipad" : "iphone")) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 10) {
                            Image(systemName: isBridgeSupported() ? "checkmark.circle.fill" : "exclamationmark.triangle.fill")
                                .imageScale(.large)
                                .foregroundStyle(isBridgeSupported() ? .green : .yellow)
                            VStack(alignment: .leading) {
                                Text(isBridgeSupported() ? "Supported" : "Limited")
                                    .font(.system(.headline, weight: .medium))
                                Text("\(device) • \(device.isPad ? "iPadOS" : "iOS") \(UIDevice.current.systemVersion)")
                                    .font(.system(.subheadline))
                                    .opacity(0.8)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        Text(isBridgeSupported() ? "Your device supports Bridge fully, and can read applications in the necessary directories." : "Some applications could not be feteched from your personal device, so the list may not be accurate.")
                    }
                }
                Section(header: HeaderLabel(text: "Credits", icon: "person")) {
                    LinkCreditCell(image: "lunginspector", name: "lunginspector", text: "Primary Developer", link: "https://github.com/lunginspector")
                }
                Section(header: HeaderLabel(text: "Settings", icon: "gearshape")) {
                    Toggle("Enable Favorites", isOn: $enableFavorites)
                    Toggle("Open App with Shortcuts", isOn: $openWithShortcuts)
                }
                Section(header: HeaderLabel(text: "Actions", icon: "wrench.and.screwdriver")) {
                    VStack(spacing: 12) {
                        Button(action: {
                            Haptic.shared.play(.soft)
                            favoritesAppList.removeAll()
                        }) {
                            ButtonLabel(text: "Reset Favorites", icon: "star.slash")
                        }
                        .buttonStyle(GlassyButtonStyle(color: .accent, useFullWidth: true))
                        Button(action: {
                            Alertinator.shared.alert(title: "Are you sure you want to do this?", body: "This will reset all settings, favorites, and your currently imported applist.",showCancel: true, actionLabel: "Reset Application", action: {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    mainPartitionAppList.removeAll()
                                    secondaryPartitionAppList.removeAll()
                                    favoritesAppList.removeAll()
                                    customAppList.removeAll()
                                    openWithShortcuts = false
                                    enableFavorites = true
                                    exitinator()
                                }
                            })
                        }) {
                            ButtonLabel(text: "Reset Application", icon: "trash")
                        }
                        .buttonStyle(GlassyButtonStyle(color: .red, useFullWidth: true))
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}
