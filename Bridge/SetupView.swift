//
//  SetupView.swift
//  Bridge
//
//  Created by Main on 5/26/25.
//

import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

struct SetupView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @Environment(\.colorScheme) var colorScheme
    
    @State private var appList: [String] = [""]
    @State private var hasSetupShortcutBeenRan: Bool = false
    
    @AppStorage("appList") private var storedAppList: String = ""
    @AppStorage("favoritesList") private var storedFavoritesList: String = "No Data"
    let pasteboard = UIPasteboard.general
    @AppStorage("isSetupCompleted") private var isSetupCompleted: Bool = false
    
    @ObservedObject var shouldRefreshAfterSetup = SetupRefreshState()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                // MARK: Header
                VStack(alignment: .center) {
                    Text("Welcome to")
                        .font(.system(.largeTitle, weight: .semibold))
                        .multilineTextAlignment(.center)
                    Text("Bridge")
                        .font(.system(.largeTitle, weight: .heavy))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.purple)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, 40)
                .padding(.bottom, 50)
                // MARK: Description
                VStack(spacing: 30) {
                    HStack {
                        Image(systemName: "ant.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 12)
                            .font(.system(.title))
                            .foregroundStyle(.purple)
                        VStack(alignment: .leading) {
                            Text("Open System Apps")
                                .font(.system(.title2, weight: .medium))
                            Text("Open applications that are inaccessible to the user.")
                                .font(.system(.callout))
                                .opacity(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "arrow.down.app.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 12)
                            .font(.system(.title))
                            .foregroundStyle(.purple)
                        VStack(alignment: .leading) {
                            Text("Export Applications")
                                .font(.system(.title2, weight: .medium))
                            Text("Export the containers of System applications.")
                                .font(.system(.callout))
                                .opacity(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "externaldrive.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding(.trailing, 12)
                            .font(.system(.title))
                            .foregroundStyle(.purple)
                        VStack(alignment: .leading) {
                            Text("Multiple Partitions")
                                .font(.system(.title2, weight: .medium))
                            Text("Open Applications on /System/Library/CoreServices and /Applications.")
                                .font(.system(.callout))
                                .opacity(0.8)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer()
                // MARK: Buttons
                VStack(spacing: 10) {
                    Button(action: {
                        Haptic.shared.play(.soft)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            openURL(URL(string: "shortcuts://run-shortcut?name=Bridge")!)
                            hasSetupShortcutBeenRan = true
                        }
                    }) {
                        HStack {
                            if hasSetupShortcutBeenRan {
                                HStack {
                                    Image(systemName: "checkmark")
                                    Text("Run Setup Shortcut")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.green.opacity(0.2))
                                .foregroundStyle(.green)
                            } else {
                                HStack {
                                    Image(systemName: "hammer.fill")
                                    Text("Run Setup Shortcut")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.purple.opacity(0.2))
                                .foregroundStyle(.purple)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    
                    Button(action: {
                        Haptic.shared.play(.soft)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                            if let string = pasteboard.string {
                                appList = string.components(separatedBy: "\n")
                                storedAppList = string
                                storedFavoritesList = "FTMInternal-4?Applications"
                                isSetupCompleted = true
                                shouldRefreshAfterSetup.shouldRefreshAfterSetup = true
                                dismiss()
                            }
                        }
                        
                    }) {
                        HStack {
                            if hasSetupShortcutBeenRan {
                                HStack {
                                    Image(systemName: "arrow.forward.circle")
                                    Text("Complete Setup")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.purple.opacity(0.2))
                                .foregroundStyle(.purple)
                            } else {
                                HStack {
                                    Image(systemName: "arrow.forward.circle.fill")
                                    Text("Complete Setup")
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.gray.opacity(0.2))
                                .foregroundStyle(.gray)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .disabled(hasSetupShortcutBeenRan ? false : true)
                    
                    Text("**Disclaimer:** This app cannot read applications that are installed by the user. It can only open and read applications that aren't shown to the user, referred to as internal applications.")
                        .font(.system(.caption))
                        .multilineTextAlignment(.center)
                        .opacity(0.6)
                }
            }
            .padding(.horizontal, 30)
            .background(
                LinearGradient(
                    colors: colorScheme == .light
                    ? [Color(hex: "#DC95FF"), Color(hex: "#FFFFFF")]
                    : [Color(hex: "#260A34"), Color(hex: "#000000")],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            )
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    SetupView()
}
