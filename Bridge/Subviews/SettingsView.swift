//
//  SettingsView.swift
//  Bridge
//
//  Created by Main on 10/23/25.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("mainPartitionAppList") var mainPartitionAppList: [String] = []
    @AppStorage("secondaryPartitionAppList") var secondaryPartitionAppList: [String] = []
    
    var body: some View {
        NavigationStack {
            List {
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
            .navigationTitle("Settings")
        }
    }
}
