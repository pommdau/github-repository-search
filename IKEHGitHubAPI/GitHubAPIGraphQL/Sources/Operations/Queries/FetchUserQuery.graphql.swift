// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class FetchUserQuery: GraphQLQuery {
  public static let operationName: String = "FetchUser"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchUser($login: String!) { user(login: $login) { __typename ...UserFields } }"#,
      fragments: [UserFields.self]
    ))

  public var login: String

  public init(login: String) {
    self.login = login
  }

  public var __variables: Variables? { ["login": login] }

  public struct Data: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("user", User?.self, arguments: ["login": .variable("login")]),
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
        .fragment(UserFields.self),
      ] }

      /// A URL pointing to the user's public avatar.
      public var avatarUrl: GitHubAPIGraphQL.URI { __data["avatarUrl"] }
      /// The user's public profile bio.
      public var bio: String? { __data["bio"] }
      /// The Node ID of the User object
      public var id: GitHubAPIGraphQL.ID { __data["id"] }
      /// Whether or not this user is following the viewer. Inverse of viewerIsFollowing
      public var isFollowingViewer: Bool { __data["isFollowingViewer"] }
      /// The user's public profile location.
      public var location: String? { __data["location"] }
      /// The username used to login.
      public var login: String { __data["login"] }
      /// The user's public profile name.
      public var name: String? { __data["name"] }
      /// A list of repositories that the user owns.
      public var repositories: Repositories { __data["repositories"] }
      /// Repositories the user has starred.
      public var starredRepositories: StarredRepositories { __data["starredRepositories"] }
      /// The user's Twitter username.
      public var twitterUsername: String? { __data["twitterUsername"] }
      /// Identifies the date and time when the object was last updated.
      public var updatedAt: GitHubAPIGraphQL.DateTime { __data["updatedAt"] }
      /// Whether or not the viewer is able to follow the user.
      public var viewerCanFollow: Bool { __data["viewerCanFollow"] }
      /// Whether or not this user is followed by the viewer. Inverse of isFollowingViewer.
      public var viewerIsFollowing: Bool { __data["viewerIsFollowing"] }

      public struct Fragments: FragmentContainer {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public var userFields: UserFields { _toFragment() }
      }

      public typealias Repositories = UserFields.Repositories

      public typealias StarredRepositories = UserFields.StarredRepositories
    }
  }
}
