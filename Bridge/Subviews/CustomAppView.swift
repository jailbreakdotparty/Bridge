//
//  CustomAppView.swift
//  Bridge
//
//  Created by Main on 12/18/25.
//

import SwiftUI
import PartyUI

struct CustomAppView: View {
    @AppStorage("customAppList") var customAppList: [String: String] = [:]
    @Environment(\.dismiss) var dismiss
    @State private var appLabel: String = ""
    @State private var appBundleID: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: HStack {
                    Image(systemName: "paintpalette")
                    Text("Custom App")
                }) {
                    VStack(spacing: 12) {
                        TextField("App Label", text: $appLabel)
                                .textFieldStyle(GlassyTextFieldStyle())
                        HStack {
                            TextField("App Bundle ID", text: $appBundleID)
                                .textFieldStyle(GlassyTextFieldStyle())
                                .autocorrectionDisabled()
                                .autocapitalization(.none)
                            Button(action: {
                                appBundleID = UIPasteboard.general.string ?? ""
                            }) {
                                Image(systemName: "doc.on.doc")
                                    .frame(width: 18)
                            }
                            .buttonStyle(GlassyButtonStyle())
                            .frame(width: 50)
                        }
                        Button(action: {
                            if customAppList.values.contains(appBundleID) {
                                Alertinator.shared.alert(title: "That Bundle ID has already been added!", body: "Please try a different Bundle ID.")
                            } else {
                                customAppList[appLabel] = appBundleID
                                appBundleID = ""
                                appLabel = ""
                                dismiss()
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("Add Item")
                            }
                        }
                        .buttonStyle(GlassyButtonStyle(isDisabled: appBundleID.isEmpty, useFullWidth: true))
                    }
                }
            }
            .navigationTitle("Custom Applications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
}
