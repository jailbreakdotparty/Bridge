//
//  SettingsView.swift
//  Bridge
//
//  Created by Main on 10/23/25.
//

import SwiftUI
import DeviceKit

struct SettingsView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    @AppStorage("enableFavorites") var enableFavorites: Bool = true
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Image(systemName: "info.circle")
                        .frame(width: 18, height: 22)
                    Text("About")
                }) {
                    VStack(alignment: .leading, spacing: 8) {
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
                                openURL(URL(string: "https://jailbreak.party")!)
                            }) {
                                HStack {
                                    Image(systemName: "globe")
                                    Text("Website")
                                }
                            }
                            .buttonStyle(GlassyButton(color: .blue, useFullWidth: true))
                        }
                        HStack {
                            Button(action: {
                                Haptic.shared.play(.soft)
                                openURL(URL(string: "https://jailbreak.party/discord")!)
                            }) {
                                HStack {
                                    Image("discord")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 22, maxHeight: 22)
                                    Text("Discord")
                                }
                            }
                            .buttonStyle(GlassyButton(color: .discord, useFullWidth: true))
                            Button(action: {
                                Haptic.shared.play(.soft)
                                openURL(URL(string: "https://jailbreak.party/discord")!)
                            }) {
                                HStack {
                                    Image("github")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: 22, maxHeight: 22)
                                    Text("GitHub")
                                }
                            }
                            .buttonStyle(GlassyButton(color: .gitHub, useFullWidth: true))
                        }
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                Section(header: HStack {
                    Image(systemName: device.isPad ? "ipad" : "iphone")
                        .frame(width: 18, height: 22)
                    Text("Device Information")
                }) {
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
                        Text(isBridgeSupported() ? "Your device supports Bridge fully, and can read applications in the necessary directories." : "Your device supports Bridge, however, you cannot fetch applications from your device. This may cause some applications that aren't actually installed on your device to appear.")
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
                Section(header: HStack {
                    Image(systemName: "gearshape")
                        .frame(width: 18, height: 22)
                    Text("Settings")
                }) {
                    Toggle("Enable Favorites", isOn: $enableFavorites)
                    Toggle("Open App with Shortcuts", isOn: $openWithShortcuts)
                }
                Section(header: HStack {
                    Image(systemName: "wrench.and.screwdriver")
                        .frame(width: 18, height: 22)
                    Text("Actions")
                }) {
                    VStack {
                        Button(action: {
                            Haptic.shared.play(.soft)
                            favoritesAppList.removeAll()
                        }) {
                            HStack {
                                Image(systemName: "star.slash")
                                Text("Remove Favorties")
                            }
                        }
                        .buttonStyle(GlassyButton(color: .accent, useFullWidth: true))
                        Button(action: {
                            Haptic.shared.play(.soft)
                            mainPartitionAppList.removeAll()
                            secondaryPartitionAppList.removeAll()
                            openWithShortcuts = false
                            enableFavorites = true
                            exitinator()
                        }) {
                            HStack {
                                Image(systemName: "xmark")
                                Text("Reset Application")
                            }
                        }
                        .buttonStyle(GlassyButton(color: .red, useFullWidth: true))
                    }
                    .listRowInsets(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
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
                    .buttonStyle(ToolbarItemBackground())
                }
            }
        }
    }
}
