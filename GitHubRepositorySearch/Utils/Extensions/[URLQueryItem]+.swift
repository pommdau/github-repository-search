import Foundation

/// [URLQueryItem]で次のようにアクセスできるようにする
/// e.g. nextLink.queryItems["page"]
extension [URLQueryItem] {
    subscript(_ key: String) -> String? {
        first(where: { $0.name == key })?.value
    }
}
