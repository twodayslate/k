import Foundation

enum WordListBarItem: String, Codable {
    case inputModeSwitchKey
    case wordList
    case hide
    
    var name: String {
        switch self {
        case .inputModeSwitchKey:
            return "Input Switcher"
        case .wordList: return "Word List"
        case .hide: return "Hide Keyboard"
        }
    }
}

extension WordListBarItem: CaseIterable {}

extension WordListBarItem: Identifiable {
    var id: String {
        return self.rawValue
    }
}
