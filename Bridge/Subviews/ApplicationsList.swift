//
//  ApplicationsList.swift
//  Bridge
//
//  Created by jailbreak.party on 10/21/25.
//

import SwiftUI
import UIKit
import PartyUI

// MARK: Specific Items - ContentView
struct ApplicationsList: View {
    @Binding var appList: [String]
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @State var isExpanded: Bool = true
    var label: String = ""
    var icon: String = ""
    var isFavoritesList: Bool = false
    
    var body: some View {
        Section(header: HStack {
            let appCount = appList.count
            HeaderDropdown(text: label, icon: icon, isExpanded: $isExpanded, useCount: true, itemCount: appCount)
                .opacity(0.5)
                .fontWeight(.semibold)
        }) {
            if isExpanded {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: UIApplication.isPad ? 3 : 1)
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(appList, id: \.self) { item in
                        Menu {
                            Button(action: {
                                Haptic.shared.play(.soft)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                    handleApplication(handleType: "open", application: item)
                                }
                            }) {
                                Label("Open App", systemImage: "arrow.up.forward")
                            }
                            if isBridgeSupported() || !isBridgeSupported() && !isApplicationInMainPartition(item: item) {
                                Button(action: {
                                    Haptic.shared.play(.soft)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        handleApplication(handleType: "export", application: item)
                                    }
                                }) {
                                    Label("Export Bundle", systemImage: "archivebox")
                                }
                            }
                            Divider()
                            if isFavoritesList {
                                Button(action: {
                                    Haptic.shared.play(.soft)
                                    favoritesAppList.removeAll { $0 == item }
                                }) {
                                    Label("Remove Favorite", systemImage: "star.slash")
                                }
                            } else {
                                Button(action: {
                                    Haptic.shared.play(.soft)
                                    if !favoritesAppList.contains(item) {
                                        favoritesAppList.append(item)
                                    } else {
                                        Alertinator.shared.alert(title: "Error!", body: "This app has already been favorited.")
                                    }
                                }) {
                                    Label("Favorite", systemImage: "star")
                                }
                            }
                        } label: {
                            HStack {
                                Image(systemName: "app")
                                    .resizable()
                                    .frame(width: 16, height: 16)
                                Text(displayAppName(item: item))
                                    .lineLimit(1)
                            }
                            .modifier(GlassyListRowBackground())
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

// sigh
struct CustomApplicationsList: View {
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @State var isExpanded: Bool = true
    
    var body: some View {
        Section(header: HStack {
            let appCount = customAppList.keys.count
            HeaderDropdown(text: "Custom Applications", icon: "paintpalette", isExpanded: $isExpanded, useCount: true, itemCount: appCount)
                .opacity(0.5)
                .fontWeight(.semibold)
        }) {
            
            if isExpanded {
                let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: UIApplication.isPad ? 3 : 1)
                LazyVGrid(columns: columns, spacing: 8) {
                    ForEach(customAppList.keys.sorted(), id: \.self) { key in
                        if let value = customAppList[key] {
                            Menu {
                                Label(value, systemImage: "plus.app")
                                Button(action: {
                                    Haptic.shared.play(.soft)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        handleApplication(handleType: "openCustomApp", application: value)
                                    }
                                }) {
                                    Label("Open App", systemImage: "arrow.up.forward")
                                }
                                Button(action: {
                                    Haptic.shared.play(.soft)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                                        customAppList.removeValue(forKey: key)
                                        customAppList[key] = nil
                                    }
                                }) {
                                    Label("Remove App", systemImage: "xmark")
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Image(systemName: "plus.app")
                                        .resizable()
                                        .frame(width: 16, height: 16)
                                    Text(key)
                                        .lineLimit(1)
                                }
                                .modifier(GlassyListRowBackground())
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}
