//
//  KeyboardButtonStyle.swift
//  k
//
//  Created by Zachary Gorak on 10/17/22.
//

import SwiftUI

struct KeyboardButton: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    var accessory: Bool
    
    enum KeyStyle: String, Codable {
        case regular
        case accessory
        case suggestion
    }
    
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
    
    var shadowColor: Color {
        if accessory {
            switch colorScheme {
            case .dark:
                return Color(red: 37.0/255.0, green: 37.0/255.0, blue: 37.0/255.0)
            case .light:
                return Color(red: 151.0/255.0, green: 154.0/255.0, blue: 161.0/255.0)
            @unknown default:
                return Color(UIColor.black)
            }
        } else {
            switch colorScheme {
            case .dark:
                return Color(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0)
            case .light:
                return Color(red: 172.0/255.0, green: 173.0/255.0, blue: 176.0/255.0)
            @unknown default:
                return .black
            }
        }
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(backgroundColor)
            .foregroundColor(Color(UIColor.label))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .background {
                RoundedRectangle(cornerRadius: 8)
                    .fill(configuration.isPressed ? shadowColor.opacity(0.8) : shadowColor)
                    .offset(y: configuration.isPressed ? (accessory ? 1.5 : 1) : 1.5)
            }
    }
}
