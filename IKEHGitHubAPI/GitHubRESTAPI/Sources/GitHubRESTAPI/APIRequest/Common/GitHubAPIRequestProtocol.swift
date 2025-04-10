import Foundation
import HTTPTypes
import HTTPTypesFoundation


// MARK: - GitHubRESTAPIRequestProtocol

public protocol GitHubRESTAPIRequestProtocol {
    
    // MARK: Response
    /// レスポンスのデータモデル
    associatedtype Response: Decodable
    var responseFailType: ResponseFailType { get }
            
    // MARK: URL
    /// e.g. "https://api.github.com"
    var baseURL: URL? { get }
    /// e.g. "/search/repositories"
    var path: String { get }
    var queryItems: [URLQueryItem] { get }
    
    // MARK: Data
    
    var method: HTTPRequest.Method { get }
    var header: HTTPTypes.HTTPFields { get }
    var body: Data? { get }
}

// MARK: - 共通処理

public extension GitHubRESTAPIRequestProtocol {
    
    // MARK: Response
    
    var responseFailType: ResponseFailType {
        .statusCode
    }
    
    // MARK: URL
    
    /// クエリパラメータを含めたURL
    var url: URL? {
        guard
            let baseURL,
            var components = URLComponents(
                url: path.isEmpty ? baseURL : baseURL.appendingPathComponent(path),
                resolvingAgainstBaseURL: true
            )
        else {
            return nil
        }
        // 0個の場合末尾に?がついてしまうのを防止
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        return components.url
    }
    
    // MARK: - Request
    
    /// プロパティの値からHTTPRequestを作成
    func buildHTTPRequest() -> HTTPRequest? {
        guard let url else {
            return nil
        }
        print(url.absoluteString)
        return HTTPRequest(
            method: method,
            url: url,
            headerFields: header
        )
    }
}
