//
//  ContentView.swift
//  Bridge
//
//  Created by Main on 5/26/25.
//

import SwiftUI
import UIKit

class SetupRefreshState: ObservableObject {
    @Published var shouldRefreshAfterSetup: Bool = false
}

struct ContentView: View {
    @Environment(\.openURL) var openURL
    
    @State private var appList: [(name: String, fullLine: String)] = []
    @State private var favoritesList: [(name: String, fullLine: String)] = []
    
    let pasteboard = UIPasteboard.general
    
    @AppStorage("appList") private var storedAppList: String = "No Data"
    @AppStorage("favoritesList") private var storedFavoritesList: String = "No Data"
    @AppStorage("isSetupCompleted") private var isSetupCompleted: Bool = false
    
    @StateObject var shouldRefreshAfterSetup = SetupRefreshState()
    
    var body: some View {
        NavigationStack {
            List {
                FavoritesSection(favoritesList: $favoritesList, openURL: openURL)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
                ApplicationsSection(appList: appList, favoritesList: $favoritesList, openURL: openURL)
                    .listRowSeparator(.hidden)
                    .listRowInsets(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
            }
            .listStyle(.plain)
            .onAppear {
                appList = storedAppList
                    .components(separatedBy: "\n")
                    .filter { !$0.isEmpty }
                    .map { line in
                        let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                        let name = parts.first.map(String.init) ?? ""
                        return (name: name, fullLine: line)
                    }
                favoritesList = storedFavoritesList
                    .components(separatedBy: "\n")
                    .filter { !$0.isEmpty }
                    .map { line in
                        let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                        let name = parts.first.map(String.init) ?? ""
                        return (name: name, fullLine: line)
                    }
            }
            .navigationTitle("Bridge")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Menu {
                        Button {
                            storedAppList = "No Data"
                            isSetupCompleted = false
                            appList = []
                        } label: {
                            Label("Reset Applist", systemImage: "square.grid.2x2")
                        }
                        Button {
                            storedFavoritesList = "No Data"
                            favoritesList = []
                        } label: {
                            Label("Reset Favorites List", systemImage: "star")
                        }
                        Button {
                            storedFavoritesList = "No Data"
                            storedAppList = "No Data"
                            isSetupCompleted = false
                            appList = []
                            favoritesList = []
                            exit(0)
                        } label: {
                            Label("Reset All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        appList = storedAppList
                            .components(separatedBy: "\n")
                            .filter { !$0.isEmpty }
                            .map { line in
                                let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                                let name = parts.first.map(String.init) ?? ""
                                return (name: name, fullLine: line)
                            }
                        favoritesList = storedFavoritesList
                            .components(separatedBy: "\n")
                            .filter { !$0.isEmpty }
                            .map { line in
                                let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                                let name = parts.first.map(String.init) ?? ""
                                return (name: name, fullLine: line)
                            }
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
        }
        .onChange(of: shouldRefreshAfterSetup.shouldRefreshAfterSetup) {
            appList = storedAppList
                .components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .map { line in
                    let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                    let name = parts.first.map(String.init) ?? ""
                    return (name: name, fullLine: line)
                }
            favoritesList = storedFavoritesList
                .components(separatedBy: "\n")
                .filter { !$0.isEmpty }
                .map { line in
                    let parts = line.split(separator: "?", maxSplits: 1, omittingEmptySubsequences: true)
                    let name = parts.first.map(String.init) ?? ""
                    return (name: name, fullLine: line)
                }
        }
        .sheet(isPresented: .constant(!isSetupCompleted)) {
            SetupView(shouldRefreshAfterSetup: shouldRefreshAfterSetup)
        }
    }
}

struct FavoritesSection: View {
    @Binding var favoritesList: [(name: String, fullLine: String)]
    let openURL: OpenURLAction
    
    var body: some View {
        Section(header: Label("Favorites", systemImage: "star")) {
            ForEach(favoritesList, id: \.fullLine) { favorite in
                AppMenu(line: favorite.fullLine, displayName: favorite.name, openURL: openURL)
                    .swipeActions {
                        Button(role: .destructive) {
                            favoritesList.removeAll { $0.fullLine == favorite.fullLine }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
        }
    }
}

struct ApplicationsSection: View {
    let appList: [(name: String, fullLine: String)]
    @Binding var favoritesList: [(name: String, fullLine: String)]
    let openURL: OpenURLAction
    
    var body: some View {
        Section(header: Label("All Applications (\(appList.count) Apps)", systemImage: "list.bullet")) {
            ForEach(appList, id: \.fullLine) { app in
                AppMenu(line: app.fullLine, displayName: app.name, openURL: openURL)
                    .swipeActions {
                        Button {
                            if !favoritesList.contains(where: { $0.fullLine == app.fullLine }) {
                                favoritesList.append(app)
                            }
                        } label: {
                            Label("Add to Favorites", systemImage: "plus")
                        }
                        .tint(.green)
                    }
            }
        }
    }
}


struct AppMenu: View {
    let line: String
    let displayName: String
    let openURL: OpenURLAction
    
    var body: some View {
        Menu {
            Button {
                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Open*\(line)")!)
            } label: {
                Label("Open Application", systemImage: "arrow.up.forward.app")
            }
            Button {
                openURL(URL(string: "shortcuts://run-shortcut?name=Bridge&input=Export*\(line)")!)
            } label: {
                Label("Export Application Container", systemImage: "square.and.arrow.down.fill")
            }
        } label: {
            HStack {
                Image(systemName: "app.fill")
                Text(displayName)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(15)
            .background(.purple.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}


#Preview {
    ContentView()
}
