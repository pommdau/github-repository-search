// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct UserFields: GitHubAPIGraphQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment UserFields on User { __typename avatarUrl bio id isFollowingViewer location login name repositories(first: 0) { __typename totalCount } starredRepositories(first: 0) { __typename totalCount } twitterUsername updatedAt viewerCanFollow viewerIsFollowing }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.User }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("avatarUrl", GitHubAPIGraphQL.URI.self),
    .field("bio", String?.self),
    .field("id", GitHubAPIGraphQL.ID.self),
    .field("isFollowingViewer", Bool.self),
    .field("location", String?.self),
    .field("login", String.self),
    .field("name", String?.self),
    .field("repositories", Repositories.self, arguments: ["first": 0]),
    .field("starredRepositories", StarredRepositories.self, arguments: ["first": 0]),
    .field("twitterUsername", String?.self),
    .field("updatedAt", GitHubAPIGraphQL.DateTime.self),
    .field("viewerCanFollow", Bool.self),
    .field("viewerIsFollowing", Bool.self),
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

  /// Repositories
  ///
  /// Parent Type: `RepositoryConnection`
  public struct Repositories: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.RepositoryConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("totalCount", Int.self),
    ] }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int { __data["totalCount"] }
  }

  /// StarredRepositories
  ///
  /// Parent Type: `StarredRepositoryConnection`
  public struct StarredRepositories: GitHubAPIGraphQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { GitHubAPIGraphQL.Objects.StarredRepositoryConnection }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("totalCount", Int.self),
    ] }

    /// Identifies the total count of items in the connection.
    public var totalCount: Int { __data["totalCount"] }
  }
}
