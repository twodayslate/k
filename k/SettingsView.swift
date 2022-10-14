//
//  SettingsView.swift
//  k
//
//  Created by Zachary Gorak on 10/13/22.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("keyboardOptions", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardOptions = DEFAULT_KEYBOARD_OPTIONS
    @AppStorage("showHideKeyboard", store: .init(suiteName: "group.com.twodayslate.k")) var showHideKeyboard = false
    @State var newItem = ""
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        List {
            Section {
                ForEach(keyboardOptions, id: \.self) { text in
                    Text("\(text)")
                }
                .onDelete(perform: {
                    keyboardOptions.remove(atOffsets: $0)
                    nameIsFocused = false
                })
                .onMove(perform: {
                    keyboardOptions.move(fromOffsets: $0, toOffset: $1)
                    nameIsFocused = false
                })
                HStack {
                    TextField("New Item", text: $newItem)
                        .focused($nameIsFocused)
                    Button {
                        guard !newItem.isEmpty else { return }
                        guard !keyboardOptions.contains(newItem) else { return }
                        keyboardOptions.append(newItem)
                        nameIsFocused = false
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(newItem.isEmpty || keyboardOptions.contains(newItem))
                }
            }
            
            Toggle(isOn: $showHideKeyboard, label: {
                Text("Show Hide Keyboard Button")
            })
            .onChange(of: showHideKeyboard, perform: { _ in
                nameIsFocused = false
            })
        }
        .navigationTitle("Settings")
        .toolbar {
            EditButton()
        }
    }
}
