//
//  Edge+wrapped.swift
//  keyboard
//
//  Created by Zachary Gorak on 10/17/22.
//

import Foundation
import SwiftUI

/// Edge can't be put into AppStorage so we have this instead
enum Position: String, Codable {
    case leading
    case trailing
    case top
    case bottom
    
    var name: String {
        switch self {
        case .bottom: return "Bottom"
        case .top: return "Top"
        case .trailing: return "Right"
        case .leading: return "Left"
        }
    }
}

extension Position: CaseIterable { }

extension Position: Identifiable {
    var id: String {
        self.rawValue
    }
}
