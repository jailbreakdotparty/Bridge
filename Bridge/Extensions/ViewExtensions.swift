//
//  ViewExtensions.swift
//  Bridge
//
//  Created by jailbreak.party on 10/21/25.
//

import SwiftUI
import UIKit

// MARK: Buttons, Lists, Headers, and other Global Items
struct GlassyButton: ButtonStyle {
    var color: Color = .accent
    var isDisabled: Bool = false
    var useLiquidGlass: Bool = true
    var useFullWidth: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .foregroundStyle(color)
                .padding()
                .frame(maxWidth: useFullWidth ? .infinity : nil)
                .background(color.opacity(0.2))
                .glassEffect(.regular.interactive(), in: .capsule)
                .clipShape(.rect(cornerRadius: 50))
        } else {
            configuration.label
                .foregroundStyle(color)
                .padding()
                .frame(maxWidth: useFullWidth ? .infinity : nil)
                .background(color.opacity(0.2))
                .clipShape(.rect(cornerRadius: 14))
        }
    }
}

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
    
    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .frame(width: 24, alignment: .center)
            Text(label)
            Spacer()
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                    .frame(width: 24, alignment: .center)
            }
            .buttonStyle(.plain)
        }
        .font(.system(.callout, weight: .semibold))
        .padding(.top)
        .opacity(0.6)
        .padding(.leading, 6)
    }
}

struct ListItemStyle: ViewModifier {
    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.accent.opacity(0.2))
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 20))
                .clipShape(.rect(cornerRadius: 20))
        } else {
            content
                .foregroundStyle(.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(.accent.opacity(0.2))
                .clipShape(.rect(cornerRadius: 14))
        }
    }
}

// MARK: Welcome Sheet
struct WelcomeSheet<Content: View>: View {
    var title: String
    @ViewBuilder var content: Content
    
    var body: some View {
        VStack {
            VStack {
                Text("Welcome To")
                    .font(.system(.title, weight: .medium))
                Text(title)
                    .font(.system(.largeTitle, weight: .bold))
                    .foregroundStyle(.accent)
            }
            .padding(.vertical, 60)
            VStack(alignment: .leading, spacing: 18) {
                content
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity)
            Spacer()
        }
    }
}

struct WelcomeSheetRow: View {
    var header: String
    var text: String
    var icon: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 40, height: 40)
                .imageScale(.large)
                .foregroundStyle(.accent)
            VStack(alignment: .leading) {
                Text(header)
                    .font(.system(.headline))
                    .foregroundStyle(.accent)
                Text(text)
                    .multilineTextAlignment(.leading)
                    .opacity(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
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
            DefaultDropdown(label: label, icon: icon, isExpanded: $isExpanded)
        }) {
            ZStack {
                if isExpanded {
                    let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: UIApplication.isPad ? 3 : 1)
                    LazyVGrid(columns: columns, spacing: 8) {
                        ForEach(appList, id: \.self) { item in
                            VStack {
                                Menu {
                                    Button(action: {
                                        handleApplication(handleType: "open", applicationName: item)
                                    }) {
                                        Label("Open App", systemImage: "arrow.up.forward")
                                    }
                                    Button(action: {
                                        handleApplication(handleType: "export", applicationName: item)
                                    }) {
                                        Label("Export Bundle", systemImage: "archivebox")
                                    }
                                    Divider()
                                    if isFavoritesList {
                                        Button(action: {
                                            favoritesAppList.removeAll { $0 == item }
                                        }) {
                                            Label("Remove Favorite", systemImage: "star.slash")
                                        }
                                    } else {
                                        Button(action: {
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
                                        Text(item)
                                            .multilineTextAlignment(.leading)
                                    }
                                }
                                .modifier(ListItemStyle())
                            }
                        }
                    }
                }
            }
        }
    }
}

