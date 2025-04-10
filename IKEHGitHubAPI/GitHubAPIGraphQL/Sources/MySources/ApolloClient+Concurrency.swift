import Foundation
import Apollo

// https://github.com/apollographql/apollo-ios/issues/2216#issuecomment-1095685427
extension ApolloClient {
    public func watch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) -> AsyncThrowingStream<GraphQLResult<Query.Data>, Error> {
        AsyncThrowingStream { continuation in
            let request = fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { response in
                switch response {
                case .success(let result):
                    continuation.yield(result)
                    if result.isFinalForCachePolicy(cachePolicy) {
                        continuation.finish()
                    }
                case .failure(let error):
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { @Sendable _ in
                request.cancel()
            }
        }
    }
}

extension GraphQLResult {
    func isFinalForCachePolicy(_ cachePolicy: CachePolicy) -> Bool {
        switch cachePolicy {
        case .returnCacheDataElseFetch:
            return true
        case .fetchIgnoringCacheData:
            return source == .server
        case .fetchIgnoringCacheCompletely:
            return source == .server
        case .returnCacheDataDontFetch:
            return source == .cache
        case .returnCacheDataAndFetch:
            return source == .server
        }
    }
}

///// unused now
//extension ApolloClient {
//    private func fetchAll<Query: GraphQLQuery>(
//        query: Query,
//        cachePolicy: CachePolicy = .default,
//        contextIdentifier: UUID? = nil,
//        queue: DispatchQueue = .main
//    ) async throws -> [Query.Data] {
//        var values: [Query.Data] = []
//        for try await result in watch(query: query, cachePolicy: cachePolicy, contextIdentifier: contextIdentifier, queue: queue) {
//            if let value = result.data {
//                values.append(value)
//            }
//        }
//        return values
//    }
//}

// [Swift Concurrency チートシート](https://zenn.dev/koher/articles/swift-concurrency-cheatsheet#%F0%9F%92%BC-case-6-%28checkedcontinuation%29%3A-%E3%82%B3%E3%83%BC%E3%83%AB%E3%83%90%E3%83%83%E3%82%AF%E3%81%8B%E3%82%89-async-%E3%81%B8%E3%81%AE%E5%A4%89%E6%8F%9B)
extension ApolloClient {
    public func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .default,
        contextIdentifier: UUID? = nil,
        queue: DispatchQueue = .main
    ) async throws -> Query.Data {
        return try await withCheckedThrowingContinuation { continuation in
            fetch(
                query: query,
                cachePolicy: cachePolicy,
                contextIdentifier: contextIdentifier,
                queue: queue
            ) { result in
                do {
                    let result = try result.get()
                    if let data = result.data {
                        continuation.resume(returning: data)
                    } else {
                        continuation.resume(throwing: ApolloClientCustomError.isResultDataNil)
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
