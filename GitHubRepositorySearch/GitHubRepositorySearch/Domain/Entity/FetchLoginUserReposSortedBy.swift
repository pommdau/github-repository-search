enum FetchLoginUserReposSortedBy: String, CaseIterable, Identifiable, Equatable {
    case fullNameAsc // デフォルト
    case fullNameDesc
    case recentlyUpdated
    case leastRecentlyUpdated
    case recentlyPushed
    case leastRecentlyPushed
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .fullNameAsc:
            return "Full name (A-Z)"
        case .fullNameDesc:
            return "Full name (Z-A)"
        case .recentlyUpdated:
            return "Recently updated"
        case .leastRecentlyUpdated:
            return "Least recently updated"
        case .recentlyPushed:
            return "Recently pushed"
        case .leastRecentlyPushed:
            return "Least recently pushed"
        }
    }
    
    // MARK: - Query Parameter
        
    var sort: String? {
        switch self {
        case .fullNameAsc, .fullNameDesc:
            return "full_name"
        case .recentlyUpdated, .leastRecentlyUpdated:
            return "updated"
        case .recentlyPushed, .leastRecentlyPushed:
            return "pushed"
        }
    }
    
    var direction: String? {
        switch self {
        case .fullNameDesc, .recentlyUpdated, .recentlyPushed:
            return "desc"
        case .fullNameAsc, .leastRecentlyUpdated, .leastRecentlyPushed:
            return "asc"
        }
    }
}
