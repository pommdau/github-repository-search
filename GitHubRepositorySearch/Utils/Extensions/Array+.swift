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

extension Array where Element: Identifiable, Element.ID == Int {
    /// IDでソートする(デフォルトは昇順)
    func sortedByID(reversed: Bool = false) -> [Element] {
        sorted { $0.id < $1.id }
    }
}
