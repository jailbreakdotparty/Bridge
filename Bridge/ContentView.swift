//
//  ContentView.swift
//  Bridge
//
//  Created by Main on 5/26/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    @Environment(\.openURL) var openURL
    
    @State private var appList: [String] = [""]
    @State private var favoritesList: [String] = [""]
    
    let pasteboard = UIPasteboard.general
    
    @AppStorage("appList") private var storedAppList: String = "No Data"
    @AppStorage("favoritesList") private var storedFavoritesList: String = "No Data"
    @AppStorage("isSetupCompleted") private var isSetupCompleted: Bool = false
    
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
                appList = storedAppList.components(separatedBy: "\n")
                favoritesList = storedFavoritesList.components(separatedBy: "\n")
            }
            .navigationTitle("Bridge")
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Menu {
                        Button {
                            storedAppList = "No Data"
                            isSetupCompleted = false
                            appList = storedAppList.components(separatedBy: "\n")
                        } label: {
                            Label("Reset Applist", systemImage: "square.grid.2x2")
                        }
                        Button {
                            storedFavoritesList = "No Data"
                            favoritesList = storedFavoritesList.components(separatedBy: "\n")
                        } label: {
                            Label("Reset Favorites List", systemImage: "star")
                        }
                        Button {
                            storedFavoritesList = "No Data"
                            storedAppList = "No Data"
                            isSetupCompleted = false
                            appList = storedAppList.components(separatedBy: "\n")
                            favoritesList = storedFavoritesList.components(separatedBy: "\n")
                        } label: {
                            Label("Reset All", systemImage: "trash")
                        }
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        appList = storedAppList.components(separatedBy: "\n")
                        favoritesList = storedFavoritesList.components(separatedBy: "\n")
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                    }
                }
            }
        }
        .sheet(isPresented: .constant(!isSetupCompleted)) {
            SetupView()
        }
    }
}

struct FavoritesSection: View {
    @Binding var favoritesList: [String]
    let openURL: OpenURLAction
    
    var body: some View {
        Section(header: Label("Favorites", systemImage: "star")) {
            ForEach(favoritesList, id: \.self) { line in
                AppMenu(line: line, openURL: openURL)
                    .swipeActions {
                        Button(role: .destructive) {
                            favoritesList.removeAll { $0 == line }
                        } label: {
                            Label("Remove", systemImage: "trash")
                        }
                    }
            }
        }
    }
}

struct ApplicationsSection: View {
    let appList: [String]
    @Binding var favoritesList: [String]
    let openURL: OpenURLAction
    
    var body: some View {
        Section(header: Label("All Applications", systemImage: "list.bullet")) {
            
            ForEach(appList, id: \.self) { line in
                AppMenu(line: line, openURL: openURL)
                    .swipeActions {
                        Button {
                            if !favoritesList.contains(line) {
                                favoritesList.append(line)
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
                Text(line)
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
