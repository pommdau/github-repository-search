////
////  SearchDetailsScreen.swift
////  IKEHGitHubAPIDemo
////
////  Created by HIROKI IKEUCHI on 2025/01/23.
////
//
//import SwiftUI
//
//struct SearchDetails {
//    
////    enum SortType {
////        case followers
////        case repositories
////    }
////    
////    var query: String
////    var sort:
//}
//
//struct SearchDetailsScreen: View {
//    
//    enum SearchCategory: String, CaseIterable, Identifiable {
//        case repo
//        case user
//        
//        var id: String { rawValue }
//        
//        var title: String {
//            switch self {
//            case .repo:
//                return "Repository"
//            case .user:
//                return "User"
//            }
//        }
//    }
//    
//    // Webの検索を参考に
//    // https://github.com/search?q=Swift&type=repositories
//    enum SortBy: String, CaseIterable, Identifiable {
//        case bestMatch
//        case mostStars
//        case fewestStars
//        case mostForks
//        case fewestForks
//        case recentryUpdated
//        case leastRecentlyUpdated
//
//        var id: String { rawValue }
//        
//        var title: String {
//            switch self {
//            case .bestMatch:
//                return "Best match"
//            case .mostStars:
//                return "Most stars"
//            case .fewestStars:
//                return "Fewest stars"
//            case .mostForks:
//                return "Most forks"
//            case .fewestForks:
//                return "Fewest forks"
//            case .recentryUpdated:
//                return "Recently updated"
//            case .leastRecentlyUpdated:
//                return "Least recently updated"
//            }
//        }
//    }
//    
//    @State private var searchCategory: SearchCategory = .repo
//    @State private var sortBy: SortBy = .bestMatch
//            
//    var body: some View {
//        Form {
//            Section {
//                Picker("Category", selection: $searchCategory) {
//                    ForEach(SearchCategory.allCases) { searchCategory in
//                        Text(searchCategory.title)
//                            .tag(searchCategory)
//                    }
//                }
//                .pickerStyle(.automatic)
//                
//                Picker("Sort by:", selection: $sortBy) {
//                    ForEach(SortBy.allCases) { sortBy in
//                        Text(sortBy.title)
//                            .tag(sortBy)
//                    }
//                }
//                .pickerStyle(.automatic)
//            }
//        }
//    }
//}
//
//#Preview {
//    SearchDetailsScreen()
//}
