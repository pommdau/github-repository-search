// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class GetReposQuery: GraphQLQuery {
  public static let operationName: String = "GetRepos"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query GetRepos($username: String!) { user(login: $username) { __typename repositories(first: 10) { __typename nodes { __typename ...RepositoryFields } } } }"#,
      fragments: [LanguageFields.self, RepositoryFields.self]
    ))

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var __variables: Variables? { ["username": username] }

  public struct Data: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("username")]),
    ] }

    /// Lookup a user by login.
    public var user: User? { __data["user"] }

    /// User
    ///
    /// Parent Type: `User`
    public struct User: GitHubAPIGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.User }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("repositories", Repositories.self, arguments: ["first": 10]),
      ] }

      /// A list of repositories that the user owns.
      public var repositories: Repositories { __data["repositories"] }

      /// User.Repositories
      ///
      /// Parent Type: `RepositoryConnection`
      public struct Repositories: GitHubAPIGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.RepositoryConnection }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("nodes", [Node?]?.self),
        ] }

        /// A list of nodes.
        public var nodes: [Node?]? { __data["nodes"] }

        /// User.Repositories.Node
        ///
        /// Parent Type: `Repository`
        public struct Node: GitHubAPIGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Repository }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(RepositoryFields.self),
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

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var repositoryFields: RepositoryFields { _toFragment() }
          }

          public typealias Languages = RepositoryFields.Languages

          public typealias Owner = RepositoryFields.Owner

          public typealias PrimaryLanguage = RepositoryFields.PrimaryLanguage
        }
      }
    }
  }
}
