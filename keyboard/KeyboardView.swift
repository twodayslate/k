//
//  KeyboardView.swift
//  keyboard
//
//  Created by Zachary Gorak on 10/12/22.
//

import SwiftUI

struct ViewWrapper: UIViewRepresentable {
    var view: UIView
    
    func makeUIView(context: Context) -> UIView {
        view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // no-op
    }
}

struct KeyboardButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var accessory: Bool
    
    var backgroundColor: Color {
        if accessory {
            switch colorScheme {
            case .dark:
                return Color(red: 70.0/255.0, green: 70.0/255.0, blue: 70.0/255.0)
            case .light:
                return Color(red: 172.0/255.0, green: 177.0/255.0, blue: 187.0/255.0)
            @unknown default:
                return Color(UIColor.systemGray4)
            }
        } else {
            switch colorScheme {
            case .dark:
                return Color(red: 107.0/255.0, green: 107.0/255.0, blue: 107.0/255.0)
            case .light:
                return .white
            @unknown default:
                return .white
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .foregroundColor(Color(UIColor.label))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .shadow(radius: 3.0, y: 3)
    }
}

struct KeyboardView: View {
    var parent: KeyboardViewController
    var action: (String) -> ()
    @Binding var needsInputModeSwitchKey: Bool
    
    @State var text = "k"
        
    @AppStorage("keyboardOptions", store: .init(suiteName: "group.com.twodayslate.k")) var textOptions = DEFAULT_KEYBOARD_OPTIONS
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Button {
                action(text)
            } label: {
                Text(text)
                    .padding()
                    .font(.title)
                    .minimumScaleFactor(0.1)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(KeyboardButton(accessory: false))
            .padding([.horizontal, .top])
            .layoutPriority(1.0)
            
            HStack(spacing: 0) {
                if needsInputModeSwitchKey {
                    Image(systemName: "globe")
                        .opacity(0.0)
                        .overlay {
                            ViewWrapper(view: parent.nextKeyboardButton)
                        }
                        .padding()
                }
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(self.textOptions, id: \.self) {
                                keyboardOptionButton($0)
                            }
                        }
                        .padding(.horizontal, 4)
                    }
            }
        }
        .background(colorScheme == .dark ? Color(red: 43.0/255.0, green: 43.0/255.0, blue: 43.0/255.0) : Color(red: 210.0/255.0, green: 212.0/255.0, blue: 217.0/255.0))
        .onAppear {
            text = textOptions.first ?? "k"
        }
    }
    
    @ViewBuilder
    func keyboardOptionButton(_ text: String) -> some View {
        Button {
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
