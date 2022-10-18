import Foundation

/// https://stackoverflow.com/a/65598711
extension Array: RawRepresentable where Element: Codable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([Element].self, from: data)
        else {
            return nil
        }
        self = result
    }

    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

public let DEFAULT_KEYBOARD_OPTIONS = [
    "k", "k.", "K", "K.", "Okay", "Okay."]

let DEFAULT_WORDLIST_BAR_ITEMS: [WordListBarItem] = [.inputModeSwitchKey, .wordList]
