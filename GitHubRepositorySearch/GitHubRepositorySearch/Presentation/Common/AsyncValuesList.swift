import SwiftUI

// swiftlint:disable file_types_order
/// AsyncValuesを表示する汎用のList
/// - SeeAlso: [非同期処理をラクにする！SwiftUIでの設計パターンの紹介](https://zenn.dev/timetree/articles/97ad70c4611894)
/// - SeeAlso: [SwiftUI Viewの責務分離 - Speaker Deck](https://speakerdeck.com/elmetal/separation-the-responsibilities-of-swiftui-view?slide=12)
struct AsyncValuesList<
    T: Identifiable & Equatable,
    E: Error,
    DataView: View,
    InitialView: View,
    LoadingView: View,
    NoResultView: View
>: View {
    
    // MARK: - Property
    
    var asyncValues: AsyncValues<T, E>
    var initialView: InitialView
    var loadingView: LoadingView
    var dataView: ([T]) -> DataView
    var noResultView: NoResultView
        
    // MARK: - LifeCycle
    
    // swiftlint:disable:next type_contents_order
    init(
        asyncValues: AsyncValues<T, E>,
        @ViewBuilder initialView: @escaping () -> InitialView,
        @ViewBuilder loadingView: @escaping () -> LoadingView,
        @ViewBuilder dataView: @escaping ([T]) -> DataView,
        @ViewBuilder noResultView: @escaping () -> NoResultView
    ) {
        self.asyncValues = asyncValues
        self.initialView = initialView()
        self.loadingView = loadingView()
        self.dataView = dataView
        self.noResultView = noResultView()
    }
    
    // MARK: - View
    
    var body: some View {
        List {
            switch asyncValues {
            case .initial:
                initialView
            case .loading:
                loadingView
            case let .loaded(values), let .loadingMore(values), let .error(_, values):
                if values.isEmpty {
                    noResultView
                } else {
                    dataView(values)
                    if case .loadingMore = asyncValues {
                        progressView()
                    }
                }
            }
        }
        .scrollContentBackground(.hidden)
    }
    
    // MARK: - View Components
    
    @ViewBuilder
    private func progressView() -> some View {
        // https://zenn.dev/oka_yuuji/articles/807a9662f087f7
        ProgressView<EmptyView, EmptyView>()
            .frame(maxWidth: .infinity, alignment: .center)
            .id(UUID())
    }
}
// swiftlint:enable file_types_order

// MARK: - Preview

private struct PreviewModel: Identifiable, Equatable {
    
    static let sampleData: [Self] = [
        .init(name: "Apple"),
        .init(name: "Banana"),
        .init(name: "Lemon")
    ]
    
    let id: String = UUID().uuidString
    let name: String
}

private struct PreviewView: View {
    
    let asyncValues: AsyncValues<PreviewModel, Error>
    
    var body: some View {
        AsyncValuesList(asyncValues: asyncValues) {
            ContentUnavailableView.search
        } loadingView: {
            ProgressView("Loading...")
        } dataView: { values in
            ForEach(values) { value in
                Text(value.name)
            }
        } noResultView: {
            ContentUnavailableView.search
        }
    }
}

#Preview("initial") {
    PreviewView(asyncValues: .initial)
}

#Preview("loading") {
    PreviewView(asyncValues: .loading([]))
}

#Preview("loaded") {
    PreviewView(asyncValues: .loaded(PreviewModel.sampleData))
}

#Preview("loaded_no_result") {
    PreviewView(asyncValues: .loaded([]))
}

#Preview("loading_more") {
    PreviewView(asyncValues: .loadingMore(PreviewModel.sampleData))
}

#Preview("error") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), PreviewModel.sampleData))
}

#Preview("error_no_result") {
    PreviewView(asyncValues: .error(MessageError(description: "debug error"), []))
}
