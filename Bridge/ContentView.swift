//
//  ContentView.swift
//  Bridge
//
//  Created by Main on 10/21/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @AppStorage("showSetupSheet") var showSetupSheet: Bool = false
    @State private var showSettingsView: Bool = false
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    @AppStorage("enableFavorites") var enableFavorites: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if enableFavorites {
                        ApplicationsList(appList: $favoritesAppList, label: "Favorited", icon: "star", isFavoritesList: true)
                    }
                    ApplicationsList(appList: $mainPartitionAppList, label: "/Applications", icon: "square.grid.2x2")
                    ApplicationsList(appList: $secondaryPartitionAppList, label: "/System/Library/CoreServices", icon: "externaldrive")
                }
                .frame(alignment: .leading)
                .padding(.horizontal, 15)
            }
            .navigationTitle("Bridge")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSettingsView = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                    .buttonStyle(ToolbarItemBackground())
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        openWithShortcuts.toggle()
                    }) {
                        if openWithShortcuts == true {
                            Image(systemName: "square.2.stack.3d")
                        } else {
                            Image(systemName: "arrow.up.forward.app")
                        }
                    }
                    .buttonStyle(ToolbarItemBackground())
                }
            }
        }
        .onAppear {
            if mainPartitionAppList.isEmpty && secondaryPartitionAppList.isEmpty {
                showSetupSheet = true
            }
        }
        .sheet(isPresented: $showSetupSheet) {
            SetupView()
                .interactiveDismissDisabled(weOnADebugBuild ? false : true)
        }
        .sheet(isPresented: $showSettingsView) {
            SettingsView()
        }
    }
}

// thanks skadz108
extension Array: @retroactive RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

#Preview {
    ContentView()
}
