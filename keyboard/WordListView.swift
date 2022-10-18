import SwiftUI

struct WordListView: View {
    var parent: KeyboardViewController
    
    @Binding var needsInputModeSwitchKey: Bool
    @Binding var text: String
    
    @AppStorage("enabledWordListBarItems", store: .init(suiteName: "group.com.twodayslate.k")) var enabledWordListBarItems: [WordListBarItem] = DEFAULT_WORDLIST_BAR_ITEMS
    
    @AppStorage("keyboardOptions", store: .init(suiteName: "group.com.twodayslate.k")) var textOptions = DEFAULT_KEYBOARD_OPTIONS
    
    @AppStorage("keyboardSoundEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardSoundEnabled = false
    @AppStorage("keyboardHapticsEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsEnabled = false
    @AppStorage("keyboardHapticsStyle", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle = .rigid
    @AppStorage("keyboardHapticsIntensity", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsIntensity = 1.0
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(enabledWordListBarItems) { item in
                switch item {
                case .wordList:
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.textOptions, id: \.self) {
                                keyboardOptionButton($0)
                            }
                        }
                        .padding(.horizontal, 4)
                        
                    }
                    .mask {
                        GeometryReader { reader in
                            let gradientSize = 4 / max(10, reader.size.width)
                            LinearGradient(
                                stops: [
                                    .init(color: .black.opacity(0.0), location: 0.0),
                                    .init(color: .black, location: gradientSize),
                                    .init(color: .black, location: 1.0 - gradientSize),
                                    .init(color: .black.opacity(0.0), location: 1.0),
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                    }
                case .hide:
                    Button {
                        if keyboardSoundEnabled {
                            AudioServicesPlaySystemSound(.modifier)
                        }
                        if keyboardHapticsEnabled {
                            if keyboardHapticsEnabled {
                                UIImpactFeedbackGenerator(style: keyboardHapticsStyle)
                                    .impactOccurred(intensity: keyboardHapticsIntensity)
                            }
                        }
                        parent.dismissKeyboard()
                    } label: {
                        Image(systemName: "globe")
                            .opacity(0.0)
                            .overlay {
                                Image(systemName: "keyboard.chevron.compact.down")
                                    .foregroundColor(Color(UIColor.label))
                            }
                            .padding(8)
                    }
                    
                case .inputModeSwitchKey:
                    if needsInputModeSwitchKey {
                        Image(systemName: "globe")
                            .opacity(0.0)
                            .overlay {
                                ViewWrapper(view: parent.nextKeyboardButton)
                            }
                            .padding(8)
                    }
                }
            }
            
        }
    }
    
    @ViewBuilder
    func keyboardOptionButton(_ text: String) -> some View {
        Button {
            if keyboardSoundEnabled {
                AudioServicesPlaySystemSound(.modifier)
            }
            if keyboardHapticsEnabled {
                if keyboardHapticsEnabled {
                    UIImpactFeedbackGenerator(style: keyboardHapticsStyle)
                        .impactOccurred(intensity: keyboardHapticsIntensity)
                }
            }
            self.text = text
        } label: {
            Text(text)
                .font(.footnote)
                .lineLimit(1)
                .padding(8)
                .frame(minWidth: 30)
        }
        .buttonStyle(KeyboardButton(accessory: true))
        .padding(.vertical, 8)
    }
}
