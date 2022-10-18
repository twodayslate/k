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
    @AppStorage("accessoryBarPosition", store: .init(suiteName: "group.com.twodayslate.k")) var accessoryBarPosition = Position.trailing
    @AppStorage("spaceBarTextEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var spaceBarTextEnabled = true
    @AppStorage("enabledAccessoryBarItems", store: .init(suiteName: "group.com.twodayslate.k")) var enabledAccessoryBarItems = [AccessoryBarItem]()
    @AppStorage("enabledWordListBarItems", store: .init(suiteName: "group.com.twodayslate.k")) var enabledWordListBarItems: [WordListBarItem] = DEFAULT_WORDLIST_BAR_ITEMS
    @AppStorage("wordListBarPosition", store: .init(suiteName: "group.com.twodayslate.k")) var wordListBarPosition: Position = .bottom
    @AppStorage("showWordListBarDivider", store: .init(suiteName: "group.com.twodayslate.k")) var showWordListBarDivider = false
    @AppStorage("useLastUsedWord", store: .init(suiteName: "group.com.twodayslate.k")) var useLastUsedWord = false
    @AppStorage("lastUsedWord", store: .init(suiteName: "group.com.twodayslate.k")) var lastUsedWord = ""
    @AppStorage("keyboardSoundEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardSoundEnabled = false
    @AppStorage("keyboardHapticsEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsEnabled = false
    @AppStorage("keyboardHapticsStyle", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle = .rigid
    @AppStorage("keyboardHapticsIntensity", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsIntensity = 1.0
    
    @State var newItem = ""
    @FocusState private var nameIsFocused: Bool
    
    var body: some View {
        List {
            Section("Keyboard Feedback") {
                // Sound
                Toggle(isOn: $keyboardSoundEnabled, label: {
                    Text("Sound")
                })
                .onChange(of: keyboardSoundEnabled, perform: { _ in
                    withAnimation {
                        nameIsFocused = false
                    }
                })
                
                // Haptic
                VStack {
                    Toggle(isOn: $keyboardHapticsEnabled, label: {
                        Text("Haptics")
                    })
                    .onChange(of: keyboardHapticsEnabled, perform: { _ in
                        withAnimation {
                            nameIsFocused = false
                        }
                    })
                    Text("Requires full access!")
                        .font(.footnote)
                        .foregroundColor(.gray)
                }
                
                if keyboardHapticsEnabled {
                    Picker("Haptic Style", selection: $keyboardHapticsStyle) {
                        ForEach(UIImpactFeedbackGenerator.FeedbackStyle.allCases) { style in
                            Text("\(style.description)")
                                .tag(style)
                        }
                    }
                    .onChange(of: keyboardHapticsStyle) { _ in
                        withAnimation {
                            nameIsFocused = false
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Haptic Intensity")
                            Spacer()
                            Text("\(keyboardHapticsIntensity)")
                                .foregroundColor(.gray)
                        }
                        Slider(
                            value: $keyboardHapticsIntensity,
                            in: 0...1.0,
                            label: {
                                Text("Haptic Intensity")
                            },
                            minimumValueLabel: {
                                Text("0.0")
                            },
                            maximumValueLabel: {
                                Text("1.0")
                            }
                        )
                        .onChange(of: keyboardHapticsIntensity) { _ in
                            withAnimation {
                                nameIsFocused = false
                            }
                        }
                    }
                }
            }
            Section("Word List") {
                ForEach(keyboardOptions, id: \.self) { item in
                    if item == keyboardOptions.first {
                        HStack {
                            Text("\(item)")
                            Spacer()
                            Image(systemName: "star.fill")
                                .foregroundColor(Color.yellow)
                        }
                    } else {
                        Text("\(item)")
                    }
                }
                .onDelete { offsets in
                    withAnimation { [offsets] in
                        keyboardOptions.remove(atOffsets: offsets)
                        nameIsFocused = false
                        
                        if keyboardOptions.isEmpty {
                            keyboardOptions.append(DEFAULT_KEYBOARD_OPTIONS.first ?? "k")
                        }
                    }
                    lastUsedWord = ""
                }
                .onMove { from, to in
                    withAnimation { [from, to] in
                        keyboardOptions.move(fromOffsets: from, toOffset: to)
                        nameIsFocused = false
                    }
                }
                HStack {
                    TextField("New Item", text: $newItem)
                        .focused($nameIsFocused)
                    Button {
                        withAnimation {
                            guard !newItem.isEmpty else { return }
                            guard !keyboardOptions.contains(newItem) else { return }
                            keyboardOptions.append(newItem)
                            nameIsFocused = false
                            newItem = ""
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .disabled(newItem.isEmpty || keyboardOptions.contains(newItem))
                }
            }
            
            Section("Word List Bar") {
                ForEach(enabledWordListBarItems) { item in
                    Text("\(item.name)")
                }
                .onMove(perform: { from, to in
                    withAnimation {
                        enabledWordListBarItems.move(fromOffsets: from, toOffset: to)
                        nameIsFocused = false
                    }
                })
            }
            
            Section {
                Toggle(isOn: $showHideKeyboard, label: {
                    Text("Show 'Hide Keyboard' Button")
                })
                .onChange(of: showHideKeyboard, perform: { value in
                    withAnimation {
                        if value {
                            enabledWordListBarItems.append(.hide)
                        } else {
                            enabledWordListBarItems.removeAll(where: { $0 == .hide })
                        }
                        nameIsFocused = false
                    }
                })
                Toggle(isOn: $showWordListBarDivider, label: {
                    Text("Show Divider")
                })
                .onChange(of: showWordListBarDivider, perform: { value in
                    withAnimation {
                        nameIsFocused = false
                    }
                })
                Toggle(isOn: $useLastUsedWord, label: {
                    Text("Show last used word")
                })
                .onChange(of: useLastUsedWord, perform: { value in
                    if !value {
                        lastUsedWord = ""
                    }
                    withAnimation {
                        nameIsFocused = false
                    }
                })
                Picker("Position", selection: $wordListBarPosition) {
                    ForEach([Position.top, Position.bottom]) { item in
                        Text("\(item.name)")
                            .tag(item)
                        
                    }
                }
                .pickerStyle(.automatic)
            }
            
            Section("Accessory Bar") {
                ForEach(enabledAccessoryBarItems) { item in
                    Text("\(item.name)")
                }
                .onDelete(perform: { offsets in
                    withAnimation {
                        enabledAccessoryBarItems.remove(atOffsets: offsets)
                        nameIsFocused = false
                    }
                })
                .onMove(perform: { from, to in
                    withAnimation {
                        enabledAccessoryBarItems.move(fromOffsets: from, toOffset: to)
                        nameIsFocused = false
                    }
                })
                
                ForEach(AccessoryBarItem.allCases) { item in
                    if !enabledAccessoryBarItems.contains(item) {
                        Button {
                            enabledAccessoryBarItems.append(item)
                        } label: {
                            HStack {
                                Text("\(item.name)")
                                Spacer()
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
            }
            
            if enabledAccessoryBarItems.contains(.space) {
                Toggle(isOn: $spaceBarTextEnabled, label: {
                    Text("Spacebar text")
                })
                .onChange(of: spaceBarTextEnabled) { value in
                    withAnimation {
                        nameIsFocused = false
                    }
                }
            }
            
            if enabledAccessoryBarItems.count > 0 {
                Section("Accessory Bar Location") {
                    accessoryBarLocation
                        .padding()
                }
            }
            
            Section {
                Button {
                    reset()
                    nameIsFocused = false
                } label: {
                    HStack {
                        Spacer()
                        Text("Reset")
                        Spacer()
                    }
                }
            }
        }
        .listStyle(.grouped)
        .navigationTitle("Settings")
        .toolbar {
            EditButton()
        }
    }
    
    func reset() {
        keyboardOptions = DEFAULT_KEYBOARD_OPTIONS
        showHideKeyboard = false
        accessoryBarPosition = .trailing
        enabledAccessoryBarItems.removeAll()
        enabledWordListBarItems = DEFAULT_WORDLIST_BAR_ITEMS
        showWordListBarDivider = false
        keyboardSoundEnabled = false
        keyboardHapticsEnabled = false
        keyboardHapticsStyle = .rigid
        keyboardHapticsIntensity = 1.0
        lastUsedWord = ""
        useLastUsedWord = false
        wordListBarPosition = .bottom
        spaceBarTextEnabled = true
    }
    
    @ViewBuilder
    var accessoryBarLocation: some View {
        VStack(spacing: 4) {
            if wordListBarPosition == .top {
                Button {
                    // no-op
                } label: {
                    Text("Word List Bar")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.gray)
                        }
                }
                .buttonStyle(.borderless)
                .disabled(true)
                
                if showWordListBarDivider {
                    Divider()
                }
            }
            Button {
                accessoryBarPosition = .top
                nameIsFocused = false
            } label: {
                Text("Top")
                    .foregroundColor(accessoryBarPosition == .top ? .white : .accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(accessoryBarPosition == .top ? Color.accentColor : .clear, strokeBorder: Color.accentColor)
                        
                    }
            }
            .buttonStyle(.borderless)
            HStack(spacing: 4) {
                Button {
                    accessoryBarPosition = .leading
                    nameIsFocused = false
                } label: {
                    Text("Left")
                        .foregroundColor(accessoryBarPosition == .leading ? .white : .accentColor)
                        .frame(minHeight: 80, maxHeight: .infinity)
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(accessoryBarPosition == .leading ? Color.accentColor : .clear, strokeBorder: Color.accentColor)
                        }
                }
                .buttonStyle(.borderless)
                Button {
                    // no-op
                } label: {
                    Text(keyboardOptions.first ?? "k")
                        .frame(maxWidth: .infinity, minHeight: 80, maxHeight: .infinity)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color(UIColor.gray))
                        }
                }
                .buttonStyle(.borderless)
                .disabled(true)
                
                Button {
                    accessoryBarPosition = .trailing
                    nameIsFocused = false
                } label: {
                    Text("Right")
                        .foregroundColor(accessoryBarPosition == .trailing ? .white : .accentColor)
                        .frame(minHeight: 80, maxHeight: .infinity)
                        .padding(.horizontal, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(accessoryBarPosition == .trailing ? Color.accentColor : .clear, strokeBorder: Color.accentColor)
                        }
                }
                .buttonStyle(.borderless)
            }
            Button {
                accessoryBarPosition = .bottom
                nameIsFocused = false
            } label: {
                Text("Bottom")
                    .foregroundColor(accessoryBarPosition == .bottom ? .white : .accentColor)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 4)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(accessoryBarPosition == .bottom ? Color.accentColor : .clear, strokeBorder: Color.accentColor)
                        
                    }
            }
            .buttonStyle(.borderless)
            
            if wordListBarPosition != .top {
                if showWordListBarDivider {
                    Divider()
                }
                Button {
                    // no-op
                } label: {
                    Text("Word List Bar")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background {
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(Color.gray)
                        }
                }
                .buttonStyle(.borderless)
                .disabled(true)
            }
        }
    }
}

struct SettingsViewPreview: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
