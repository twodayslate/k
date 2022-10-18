//
//  KeyboardView.swift
//  keyboard
//
//  Created by Zachary Gorak on 10/12/22.
//

import SwiftUI
import UIKit

struct ViewWrapper: UIViewRepresentable {
    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // no-op
    }
}

struct KeyboardView: View {
    var parent: KeyboardViewController
    @Binding var needsInputModeSwitchKey: Bool
    
    @State var text = "k"
    
    @AppStorage("keyboardOptions", store: .init(suiteName: "group.com.twodayslate.k")) var textOptions = DEFAULT_KEYBOARD_OPTIONS
    @AppStorage("showHideKeyboard", store: .init(suiteName: "group.com.twodayslate.k")) var showHideKeyboard = false
    @AppStorage("swipeKeyboardKeyWordList", store: .init(suiteName: "group.com.twodayslate.k")) var swipeKeyWordList = false
    @AppStorage("enabledAccessoryBarItems", store: .init(suiteName: "group.com.twodayslate.k")) var enabledAccessoryBarItems = [AccessoryBarItem]()
    @AppStorage("accessoryBarPosition", store: .init(suiteName: "group.com.twodayslate.k")) var accessoryBarPosition: Position = .trailing
    @AppStorage("wordListBarPosition", store: .init(suiteName: "group.com.twodayslate.k")) var wordListBarPosition: Position = .bottom
    @AppStorage("showWordListBarDivider", store: .init(suiteName: "group.com.twodayslate.k")) var showWordListBarDivider = false
    @AppStorage("useLastUsedWord", store: .init(suiteName: "group.com.twodayslate.k")) var useLastUsedWord = false
    @AppStorage("lastUsedWord", store: .init(suiteName: "group.com.twodayslate.k")) var lastUsedWord = ""
    
    @AppStorage("keyboardSoundEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardSoundEnabled = false
    @AppStorage("keyboardHapticsEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsEnabled = false
    @AppStorage("keyboardHapticsStyle", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle = .rigid
    @AppStorage("keyboardHapticsIntensity", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsIntensity = 1.0
    
    @Environment(\.colorScheme) var colorScheme
    
    func action(_ text: String) {
        lastUsedWord = text
        if keyboardSoundEnabled {
            AudioServicesPlaySystemSound(.normal);
        }
        if keyboardHapticsEnabled {
            UIImpactFeedbackGenerator(style: keyboardHapticsStyle)
                .impactOccurred(intensity: keyboardHapticsIntensity)
        }
        parent.textDocumentProxy.insertText(text)
    }
    
    var gesture: SimultaneousGesture<ExclusiveGesture<_EndedGesture<DragGesture>, _EndedGesture<TapGesture>>, _EndedGesture<TapGesture>> {
        let tap = TapGesture(count: 1)
            .onEnded { value in
                action(text)
            }
        return DragGesture(minimumDistance: 10, coordinateSpace: .local)
            .onEnded { value in
                print("got value", value)
                // ensure gesture is enabled
                guard swipeKeyWordList else { return }
                // ensure the gesture isn't diagnol
                guard value.translation.height < 15 else {
                    return
                }
                guard value.translation.height > -15 else {
                    return
                }
                let index = textOptions.firstIndex(of: text) ?? 0
                if value.translation.width < 0 {
                    let newIndex = max(0, textOptions.index(before: index))
                    text = textOptions[newIndex]
                }
                if value.translation.width > 0 {
                    let newIndex = max(min(textOptions.index(after: index), textOptions.count - 1), 0)
                    text = textOptions[newIndex]
                }
            }
            .exclusively(
                before: tap
            )
            .simultaneously(
                with: tap
            )
    }
    
    var accessoryBarEnabled: Bool {
        enabledAccessoryBarItems.count > 0
    }
    
    var accessoryBar: some View {
        AccessoryBarView(parent: parent)
    }
    
    var wordListBar: some View {
        WordListView(parent: parent, needsInputModeSwitchKey: $needsInputModeSwitchKey, text: $text)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if wordListBarPosition == .top {
                wordListBar
                if showWordListBarDivider {
                    Divider()
                }
            }
        
            VStack(spacing: 0) {
                if accessoryBarEnabled, accessoryBarPosition == .top {
                    accessoryBar
                }
                HStack {
                    if accessoryBarPosition == .leading, accessoryBarEnabled {
                        accessoryBar
                    }
                    Button {
                        lastUsedWord = text
                        action(text)
                    } label: {
                        Text(text)
                            .padding()
                            .font(.title)
                            .minimumScaleFactor(0.1)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .buttonStyle(KeyboardButton(accessory: false))
                    .padding(.leading, (accessoryBarEnabled && accessoryBarPosition == .leading) ? 0 : 8)
                    .padding(.top, 8)
                    .padding(.trailing, accessoryBarEnabled && accessoryBarPosition == .trailing ? 0 : 8)
                    .layoutPriority(1.0)
                    if accessoryBarEnabled, accessoryBarPosition == .trailing {
                        accessoryBar
                    }
                }
                .layoutPriority(1.0)
                
                if accessoryBarEnabled, accessoryBarPosition == .bottom {
                    accessoryBar
                }
            }
            .padding(.bottom, wordListBarPosition == .top ? 8 : 0)
            
            if wordListBarPosition != .top {
                if showWordListBarDivider {
                    Divider()
                        .padding(.top, 8)
                }
                wordListBar
            }
        }
        .onAppear {
            if useLastUsedWord {
                if !lastUsedWord.isEmpty {
                    text = lastUsedWord
                    return
                }
            }
            text = textOptions.first ?? "k"
        }
    }
}
