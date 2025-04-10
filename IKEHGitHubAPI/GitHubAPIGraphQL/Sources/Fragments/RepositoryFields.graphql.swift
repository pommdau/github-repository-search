// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct RepositoryFields: GitHubAPIGraphQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment RepositoryFields on Repository { __typename createdAt description forkCount homepageUrl id isFork isPrivate languages(first: 10) { __typename edges { __typename node { __typename ...LanguageFields } size } totalCount totalSize } name owner { __typename avatarUrl id login url } primaryLanguage { __typename ...LanguageFields } pushedAt stargazerCount updatedAt url }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Repository }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("createdAt", GitHubAPIGraphQL.DateTime.self),
    .field("description", String?.self),
    .field("forkCount", Int.self),
    .field("homepageUrl", GitHubAPIGraphQL.URI?.self),
    .field("id", GitHubAPIGraphQL.ID.self),
    .field("isFork", Bool.self),
    .field("isPrivate", Bool.self),
    .field("languages", Languages?.self, arguments: ["first": 10]),
    .field("name", String.self),
    .field("owner", Owner.self),
    .field("primaryLanguage", PrimaryLanguage?.self),
    .field("pushedAt", GitHubAPIGraphQL.DateTime?.self),
    .field("stargazerCount", Int.self),
    .field("updatedAt", GitHubAPIGraphQL.DateTime.self),
    .field("url", GitHubAPIGraphQL.URI.self),
  ] }

  /// Identifies the date and time when the object was created.
  public var createdAt: GitHubAPIGraphQL.DateTime { __data["createdAt"] }
  /// The description of the repository.
  public var description: String? { __data["description"] }
  /// Returns how many forks there are of this repository in the whole network.
  public var forkCount: Int { __data["forkCount"] }
  /// The repository's URL.
  public var homepageUrl: GitHubAPIGraphQL.URI? { __data["homepageUrl"] }
  /// The Node ID of the Repository object
  public var id: GitHubAPIGraphQL.ID { __data["id"] }
  /// Identifies if the repository is a fork.
  public var isFork: Bool { __data["isFork"] }
  /// Identifies if the repository is private or internal.
  public var isPrivate: Bool { __data["isPrivate"] }
  /// A list containing a breakdown of the language composition of the repository.
  public var languages: Languages? { __data["languages"] }
  /// The name of the repository.
  public var name: String { __data["name"] }
  /// The User owner of the repository.
  public var owner: Owner { __data["owner"] }
  /// The primary language of the repository's code.
  public var primaryLanguage: PrimaryLanguage? { __data["primaryLanguage"] }
  /// Identifies the date and time when the repository was last pushed to.
  public var pushedAt: GitHubAPIGraphQL.DateTime? { __data["pushedAt"] }
  /// Returns a count of how many stargazers there are on this object
  public var stargazerCount: Int { __data["stargazerCount"] }
  /// Identifies the date and time when the object was last updated.
  public var updatedAt: GitHubAPIGraphQL.DateTime { __data["updatedAt"] }
  /// The HTTP URL for this repository
  public var url: GitHubAPIGraphQL.URI { __data["url"] }

  /// Languages
  ///
  /// Parent Type: `LanguageConnection`
  public struct Languages: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.LanguageConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("edges", [Edge?]?.self),
      .field("totalCount", Int.self),
      .field("totalSize", Int.self),
    ] }

    /// A list of edges.
    public var edges: [Edge?]? { __data["edges"] }
    /// Identifies the total count of items in the connection.
    public var totalCount: Int { __data["totalCount"] }
    /// The total size in bytes of files written in that language.
    public var totalSize: Int { __data["totalSize"] }

    /// Languages.Edge
    ///
    /// Parent Type: `LanguageEdge`
    public struct Edge: GitHubAPIGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.LanguageEdge }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("node", Node.self),
        .field("size", Int.self),
      ] }

      public var node: Node { __data["node"] }
      /// The number of bytes of code written in the language.
      public var size: Int { __data["size"] }

      /// Languages.Edge.Node
      ///
      /// Parent Type: `Language`
      public struct Node: GitHubAPIGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Language }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(LanguageFields.self),
        ] }

        /// The color defined for the current language.
        public var color: String? { __data["color"] }
        /// The Node ID of the Language object
        public var id: GitHubAPIGraphQL.ID { __data["id"] }
        /// The name of the current language.
        public var name: String { __data["name"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var languageFields: LanguageFields { _toFragment() }
        }
      }
    }
  }

  /// Owner
  ///
  /// Parent Type: `RepositoryOwner`
  public struct Owner: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Interfaces.RepositoryOwner }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("avatarUrl", GitHubAPIGraphQL.URI.self),
      .field("id", GitHubAPIGraphQL.ID.self),
      .field("login", String.self),
      .field("url", GitHubAPIGraphQL.URI.self),
    ] }

    /// A URL pointing to the owner's public avatar.
    public var avatarUrl: GitHubAPIGraphQL.URI { __data["avatarUrl"] }
    /// The Node ID of the RepositoryOwner object
    public var id: GitHubAPIGraphQL.ID { __data["id"] }
    /// The username used to login.
    public var login: String { __data["login"] }
    /// The HTTP URL for the owner.
    public var url: GitHubAPIGraphQL.URI { __data["url"] }
  }

  /// PrimaryLanguage
  ///
  /// Parent Type: `Language`
  public struct PrimaryLanguage: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Language }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(LanguageFields.self),
    ] }

    /// The color defined for the current language.
    public var color: String? { __data["color"] }
    /// The Node ID of the Language object
    public var id: GitHubAPIGraphQL.ID { __data["id"] }
    /// The name of the current language.
    public var name: String { __data["name"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var languageFields: LanguageFields { _toFragment() }
    }
  }
}
