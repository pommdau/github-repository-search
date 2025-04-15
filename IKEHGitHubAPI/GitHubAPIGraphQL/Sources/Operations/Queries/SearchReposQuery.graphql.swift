// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchReposQuery: GraphQLQuery {
  public static let operationName: String = "SearchRepos"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchRepos($query: String!, $first: Int = 10, $after: String) { search(after: $after, first: $first, query: $query, type: REPOSITORY) { __typename repositoryCount edges { __typename cursor node { __typename ... on Repository { ...RepositoryFields } } } pageInfo { __typename endCursor hasNextPage } } }"#,
      fragments: [LanguageFields.self, RepositoryFields.self]
    ))

  public var query: String
  public var first: GraphQLNullable<Int>
  public var after: GraphQLNullable<String>

  public init(
    query: String,
    first: GraphQLNullable<Int> = 10,
    after: GraphQLNullable<String>
  ) {
    self.query = query
    self.first = first
    self.after = after
  }

  public var __variables: Variables? { [
    "query": query,
    "first": first,
    "after": after
  ] }

  public struct Data: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("search", Search.self, arguments: [
        "after": .variable("after"),
        "first": .variable("first"),
        "query": .variable("query"),
        "type": "REPOSITORY"
      ]),
    ] }

    /// Perform a search across resources, returning a maximum of 1,000 results.
    public var search: Search { __data["search"] }

    /// Search
    ///
    /// Parent Type: `SearchResultItemConnection`
    public struct Search: GitHubAPIGraphQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.SearchResultItemConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("repositoryCount", Int.self),
        .field("edges", [Edge?]?.self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// The total number of repositories that matched the search query. Regardless of
      /// the total number of matches, a maximum of 1,000 results will be available
      /// across all types.
      public var repositoryCount: Int { __data["repositoryCount"] }
      /// A list of edges.
      public var edges: [Edge?]? { __data["edges"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Search.Edge
      ///
      /// Parent Type: `SearchResultItemEdge`
      public struct Edge: GitHubAPIGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.SearchResultItemEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("cursor", String.self),
          .field("node", Node?.self),
        ] }

        /// A cursor for use in pagination.
        public var cursor: String { __data["cursor"] }
        /// The item at the end of the edge.
        public var node: Node? { __data["node"] }

        /// Search.Edge.Node
        ///
        /// Parent Type: `SearchResultItem`
        public struct Node: GitHubAPIGraphQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Unions.SearchResultItem }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .inlineFragment(AsRepository.self),
          ] }

          public var asRepository: AsRepository? { _asInlineFragment() }

          /// Search.Edge.Node.AsRepository
          ///
          /// Parent Type: `Repository`
          public struct AsRepository: GitHubAPIGraphQL.InlineFragment {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public typealias RootEntityType = SearchReposQuery.Data.Search.Edge.Node
            public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Repository }
            public static var __selections: [ApolloAPI.Selection] { [
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

      /// Search.PageInfo
      ///
      /// Parent Type: `PageInfo`
      public struct PageInfo: GitHubAPIGraphQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.PageInfo }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("endCursor", String?.self),
          .field("hasNextPage", Bool.self),
        ] }

        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? { __data["endCursor"] }
        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool { __data["hasNextPage"] }
      }
    }
  }
}
