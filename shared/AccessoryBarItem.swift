//
//  AccessoryBarItem.swift
//  k
//
//  Created by Zachary Gorak on 10/17/22.
//

import Foundation

enum AccessoryBarItem: String, Codable {
    case space
    case backspace
    case hide
    case spacer
    
    var name: String {
        switch self {
        case .space: return "Spacebar"
        case .backspace: return "Backspace"
        case .hide: return "Hide Keyboard"
        case .spacer: return "Spacer"
        }
    }
}

extension AccessoryBarItem: CaseIterable {
    
}

extension AccessoryBarItem: Identifiable {
    var id: String {
        return self.rawValue
    }
}
