import SwiftUI
import AudioToolbox

struct AccessoryBarView: View {
    var parent: KeyboardViewController
    
    @AppStorage("enabledAccessoryBarItems", store: .init(suiteName: "group.com.twodayslate.k")) var enabledAccessoryBarItems = [AccessoryBarItem]()
    @AppStorage("accessoryBarPosition", store: .init(suiteName: "group.com.twodayslate.k")) var accessoryBarPosition: Position = .trailing
    @AppStorage("spaceBarTextEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var spaceBarTextEnabled = true
    
    @AppStorage("keyboardSoundEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardSoundEnabled = false
    @AppStorage("keyboardHapticsEnabled", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsEnabled = false
    @AppStorage("keyboardHapticsStyle", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsStyle: UIImpactFeedbackGenerator.FeedbackStyle = .rigid
    @AppStorage("keyboardHapticsIntensity", store: .init(suiteName: "group.com.twodayslate.k")) var keyboardHapticsIntensity = 1.0
    
    var body: some View {
        switch accessoryBarPosition {
        case .leading, .trailing:
            leftRightSpace
        case .top, .bottom:
            topBottomSpace
        }
    }
    
    var hideKeyboardButton: some View {
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
            Image(systemName: "delete.left")
                .opacity(0.0)
                .overlay {
                    Image(systemName: "keyboard.chevron.compact.down")
                        .foregroundColor(Color(UIColor.label))
                }
                .padding(6)
        }
        .buttonStyle(KeyboardButton(accessory: true))
    }
    
    var backspaceButton: some View {
        Button {
            if keyboardSoundEnabled {
                AudioServicesPlaySystemSound(.delete)
            }
            if keyboardHapticsEnabled {
                if keyboardHapticsEnabled {
                    UIImpactFeedbackGenerator(style: keyboardHapticsStyle)
                        .impactOccurred(intensity: keyboardHapticsIntensity)
                }
            }
            parent.textDocumentProxy.deleteBackward()
        } label: {
            Image(systemName: "delete.left")
                .padding(6)
        }
        .buttonStyle(KeyboardButton(accessory: true))
    }
    
    @ViewBuilder
    var spaceButtonForTopBottom: some View {
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
            parent.textDocumentProxy.insertText(" ")
        } label: {
            ZStack {
                Image(systemName: "delete.left")
                    .padding(6)
                    .opacity(0.0)
                
                Text(spaceBarTextEnabled ? "space" : " ")
                    .font(.callout)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
        }
        .buttonStyle(KeyboardButton(accessory: false))
    }
    
    @ViewBuilder
    var topBottomSpace: some View {
        HStack {
            ForEach(enabledAccessoryBarItems) { item in
                switch item {
                case .space:
                    spaceButtonForTopBottom
                case .backspace:
                    backspaceButton
                case .hide:
                    hideKeyboardButton
                case .spacer:
                    Spacer()
                }
            }
        }
        .padding([.horizontal, .top], 8)
    }
    
    var spaceButtonForLeftRight: some View {
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
            parent.textDocumentProxy.insertText(" ")
        } label: {
            ZStack {
                Image(systemName: "delete.left")
                    .padding(6)
                    .opacity(0.0)
                Text(" ")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .overlay {
                        if spaceBarTextEnabled {
                            Text("space")
                                .font(.callout)
                                .fixedSize(horizontal: true, vertical: false)
                                .rotationEffect(.degrees(accessoryBarPosition == .leading ? -90 : 90))
                                .frame(maxHeight: .infinity)
                        }
                    }
            }
                
        }
        .buttonStyle(KeyboardButton(accessory: false))
    }
    
    @ViewBuilder
    var leftRightSpace: some View {
        VStack {
            ForEach(enabledAccessoryBarItems) { item in
                switch item {
                case .space:
                    spaceButtonForLeftRight
                case .backspace:
                    backspaceButton
                case .hide:
                    hideKeyboardButton
                case .spacer:
                    Spacer()
                }
            }
        }
        .padding(.leading, accessoryBarPosition == .leading ? 8 : 0)
        .padding(.top, 8)
        .padding(.trailing, accessoryBarPosition == .trailing ? 8 : 0)
    }
}
