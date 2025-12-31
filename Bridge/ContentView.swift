//
//  ContentView.swift
//  Bridge
//
//  Created by Main on 10/21/25.
//

import SwiftUI
import UIKit
import PartyUI

struct ContentView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    @AppStorage("favoritesAppList") var favoritesAppList: [String] = []
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @AppStorage("showSetupSheet") var showSetupSheet: Bool = false
    @State private var showSettingsView: Bool = false
    @AppStorage("openWithShortcuts") var openWithShortcuts: Bool = false
    @AppStorage("enableFavorites") var enableFavorites: Bool = true
    @State private var showCustomAppView: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 14) {
                    CustomApplicationsList()
                    if enableFavorites {
                        ApplicationsList(appList: $favoritesAppList, label: "Favorited", icon: "star", isFavoritesList: true)
                    }
                    ApplicationsList(appList: $mainPartitionAppList, label: "/Applications", icon: "square.grid.2x2")
                    ApplicationsList(appList: $secondaryPartitionAppList, label: "/System/Library/CoreServices", icon: "externaldrive")
                }
            }
            .safeAreaInset(edge: .bottom) {
                OverlayButtonContainer(content: VStack {
                    Color.clear
                        .frame(maxHeight: 1)
                })
            }
            .listStyle(.plain)
            .navigationTitle("Bridge")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showSettingsView = true
                    }) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        showCustomAppView = true
                    }) {
                        Image(systemName: "paintpalette")
                    }
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
        .sheet(isPresented: $showCustomAppView) {
            CustomAppView()
        }
    }
}

#Preview {
    ContentView()
}
