import Foundation


/// レスポンスのエラー判定条件
public enum ResponseFailType {
    /// ステータスコードが200番台でなければ失敗
    case statusCode
    /// レスポンスのBodyがエラー形式であれば失敗(OAuth2.0認証/GraphQLなどが該当)
    case responseBody
}
