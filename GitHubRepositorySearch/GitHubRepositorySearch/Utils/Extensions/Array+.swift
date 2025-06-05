import Foundation

extension Array where Element: Identifiable {
    /// 配列 -> IDをキーとする辞書 への変換
    func convertToValuesDic() -> [Element.ID: Element] {
        Dictionary(
            uniqueKeysWithValues: self.map { value in
                (value.id, value)
            })
    }
}
