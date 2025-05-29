import Foundation

// TODO: UnitTest
extension Array where Element: Identifiable {
    func convertToValuesDic() -> [Element.ID: Element] {
        Dictionary(
            uniqueKeysWithValues: self.map { value in
                (value.id, value)
            })
    }
}
