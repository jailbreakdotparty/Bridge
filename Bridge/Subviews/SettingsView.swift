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
    @Environment(\.openURL) var openURL
    @Environment(\.dismiss) var dismiss
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Image(systemName: "info.circle")
                        .frame(width: 22, height: 22)
                    Text("About")
                }) {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack(spacing: 14) {
                            Image("Bridge")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 65, height: 65)
                                .background(.black)
                                .clipShape(.rect(cornerRadius: 14))
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
                    .listRowInsets(EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18))
                }
                Section(header: HStack {
                    Image(systemName: "info.circle")
                        .frame(width: 22, height: 22)
                    Text("Device Information")
                }) {
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 12) {
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
                        Text(isBridgeSupported() ? "Your device supports Bridge fully, and can read applications in the necessary directories." : "Your device has limited support for Bridge, as you are running iOS 26.1 or later. You can no longer read applications in /Applications with the shortcuts application.")
                    }
                }
                Section(header: HStack {
                    Image(systemName: "hammer")
                        .frame(width: 22, height: 22)
                    Text("Actions")
                }) {
                    VStack(spacing: 12) {
                        Toggle("Open App with Shortcuts", isOn: $openWithShortcuts)
                        Button(action: {
                            Haptic.shared.play(.soft)
                            mainPartitionAppList.removeAll()
                            secondaryPartitionAppList.removeAll()
                            exitinator()
                        }) {
                            HStack {
                                Image(systemName: "xmark")
                                Text("Reset Application")
                            }
                        }
                        .buttonStyle(GlassyButton(color: .red, useFullWidth: true))
                    }
                    .listRowInsets(EdgeInsets(top: 18, leading: 18, bottom: 18, trailing: 18))
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
