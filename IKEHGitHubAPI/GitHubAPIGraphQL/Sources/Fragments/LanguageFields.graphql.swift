// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct LanguageFields: GitHubAPIGraphQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment LanguageFields on Language { __typename color id name }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Language }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("color", String?.self),
    .field("id", GitHubAPIGraphQL.ID.self),
    .field("name", String.self),
  ] }

  /// The color defined for the current language.
  public var color: String? { __data["color"] }
  /// The Node ID of the Language object
  public var id: GitHubAPIGraphQL.ID { __data["id"] }
  /// The name of the current language.
  public var name: String { __data["name"] }
}
