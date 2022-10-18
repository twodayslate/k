import UIKit

extension UIImpactFeedbackGenerator.FeedbackStyle: Codable, CaseIterable, Identifiable, CustomStringConvertible {
    public var id: String {
        self.description
    }
    
    public var description: String {
        switch self {
        case .soft:
            return "Soft"
        case .medium: return "Medium"
        case .heavy: return "Heavy"
        case .light: return "Light"
        case .rigid: return "Rigid"
        @unknown default:
            return "Unknown"
        }
    }
    
    public static var allCases: [UIImpactFeedbackGenerator.FeedbackStyle] {
        return [.light, .medium, .heavy, .soft, .rigid]
    }
}
