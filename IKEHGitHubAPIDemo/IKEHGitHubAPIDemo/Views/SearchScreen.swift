//
//  SearchScreen.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/01/14.
//

import SwiftUI

struct SearchScreen: View {
    
    @State private var viewState = SearchScreenViewState()
    
    var body: some View {
        NavigationStack {
            SearchResultView(
                asyncRepos: viewState.asyncRepos,
                cancelSearching: {
                    viewState.cancelSearching()
                },
                bottomCellOnAppear: { _ in
                    // 一番下のセルが表示された場合
                    viewState.handleSearchMore()
                })
        }
        .searchable(text: $viewState.keyword, prompt: "Enter Keyword")
//        .searchSuggestions {
//            SearchSuggestionView(keyword: viewState.keyword) { type in
////                switch type {
////                case .repo:
////                    viewState.handleSearchKeyword()
////                case .user:
////                    print("todo")
////                }
//                print("じっそうしてして")
//            }
//        }
        .onSubmit(of: .search) {
            viewState.handleSearchKeyword()
        }
        .toolbar {
            Button("Hoge") {
                print("hoge")
            }
        }
    }
}

enum SearchSuggestionType: CaseIterable {
    case repo
    case user
    
    var iconSystemName: String {
        switch self {
        case .repo:
            "text.book.closed"
        case .user:
            "person"
        }
    }
    
    var titleFormat: String {
        switch self {
            case .repo:
            "\"%@\"を含むリポジトリ"
        case .user:
            "\"%@\"を含む人"
        }
    }
}

struct SearchSuggestionView: View {
    
    let keyword: String
    var didSelect: (SearchSuggestionType) -> Void = { _ in }
    
    var body: some View {
        if keyword.isEmpty {
            EmptyView()
        } else {
            ForEach(SearchSuggestionType.allCases, id: \.self) { type in
                Button {
                    didSelect(type)
                } label: {
                    Label(String(format: type.titleFormat, keyword), systemImage: type.iconSystemName)
                }
                .foregroundStyle(.primary)
            }
        }
    }
}

#Preview {
    List {
        SearchSuggestionView(keyword: "Swift")
    }
}


#Preview {
    SearchScreen()
}
