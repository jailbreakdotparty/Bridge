//
//  ViewExtensions.swift
//  Bridge
//
//  Created by jailbreak.party on 10/21/25.
//

import SwiftUI
import UIKit
import PartyUI

// MARK: Buttons, Lists, Headers, and other Global Items
struct DefaultHeader: View {
    let label: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .frame(width: 24, alignment: .center)
            Text(label)
        }
        .font(.system(.callout, weight: .semibold))
        .padding(.top)
        .opacity(0.6)
        .padding(.leading, 6)
    }
}

struct DefaultDropdown: View {
    let label: String
    let icon: String
    @Binding var isExpanded: Bool
    var itemCount: Int
    
    var body: some View {
        HStack {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: icon)
                        .frame(width: 24, alignment: .center)
                    Text(label)
                    Spacer()
                    Text("\(itemCount)")
                        .frame(minWidth: 14)
                        .frame(height: 14)
                        .padding(6)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(.capsule)
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .frame(width: 24, height: 24, alignment: .center)
                }
            }
            .buttonStyle(.plain)
        }
        .font(.system(.callout, weight: .semibold))
        .padding(.top)
        .opacity(0.6)
        .padding(.leading, 6)
    }
}

// MARK: Specific Items - ContentView
struct ApplicationsList: View {
    @Binding var appList: [String]
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @State var isExpanded: Bool = true
    var label: String = ""
    var icon: String = ""
    var isFavoritesList: Bool = false
    
    var body: some View {
        Section(header: HStack {
            let appCount = appList.count
            DefaultDropdown(label: label, icon: icon, isExpanded: $isExpanded, itemCount: appCount)
        }) {
            ZStack {
                if isExpanded {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: UIApplication.isPad ? 3 : 1)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(appList, id: \.self) { item in
                            VStack {
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
            }
        }
        .onChange(of: appList) { newValue in
            isExpanded = !newValue.isEmpty
        }
        .task {
            isExpanded = !appList.isEmpty
        }
    }
}

// sigh
struct CustomApplicationsList: View {
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @State var isExpanded: Bool = true
    
    var body: some View {
        Section(header: HStack {
            let appCount = customAppList.keys.count
            DefaultDropdown(label: "Custom Applications", icon: "plus.app", isExpanded: $isExpanded, itemCount: appCount)
        }) {
            ZStack {
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
        }
        .onChange(of: customAppList) { newValue in
            isExpanded = !newValue.isEmpty
        }
        .task {
            isExpanded = !customAppList.isEmpty
        }
    }
}
