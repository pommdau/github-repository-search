//
//  StarredReposResponse.swift
//  IKEHGitHubAPIDemo
//
//  Created by HIROKI IKEUCHI on 2025/02/01.
//

import Foundation

private extension StarredReposResponse {
    struct StarredRepo: Decodable {
        private enum CodingKeys: String, CodingKey {
            case starredAt = "starred_at"
            case repo
        }
        var starredAt: String
        var repo: Repo
        
        func convertToRepo() -> Repo {
            var repo = self.repo
            repo.starredAt = self.starredAt
            return repo
        }
    }
}

struct StarredReposResponse: Sendable, ResponseWithRelationLinkProtocol {
    
    var repos: [Repo]
    
    // MARK: - レスポンスのHeaderから所得される情報
    var relationLink: RelationLink? // ページング情報
}

extension StarredReposResponse: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let response = try container.decode(ListResponse<StarredRepo>.self)
        self.repos = response.items.map { $0.convertToRepo() }
    }
}

private let json = #"""
[
  {
    "starred_at" : "2024-12-17T01:54:20Z",
    "repo" : {
      "keys_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/keys{\/key_id}",
      "statuses_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/statuses\/{sha}",
      "issues_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/issues{\/number}",
      "license" : null,
      "issue_events_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/issues\/events{\/number}",
      "has_projects" : true,
      "id" : 474280432,
      "allow_forking" : true,
      "owner" : {
        "id" : 4316081,
        "organizations_url" : "https:\/\/api.github.com\/users\/bvanpeski\/orgs",
        "received_events_url" : "https:\/\/api.github.com\/users\/bvanpeski\/received_events",
        "following_url" : "https:\/\/api.github.com\/users\/bvanpeski\/following{\/other_user}",
        "login" : "bvanpeski",
        "avatar_url" : "https:\/\/avatars.githubusercontent.com\/u\/4316081?v=4",
        "url" : "https:\/\/api.github.com\/users\/bvanpeski",
        "node_id" : "MDQ6VXNlcjQzMTYwODE=",
        "subscriptions_url" : "https:\/\/api.github.com\/users\/bvanpeski\/subscriptions",
        "repos_url" : "https:\/\/api.github.com\/users\/bvanpeski\/repos",
        "type" : "User",
        "user_view_type" : "public",
        "html_url" : "https:\/\/github.com\/bvanpeski",
        "events_url" : "https:\/\/api.github.com\/users\/bvanpeski\/events{\/privacy}",
        "site_admin" : false,
        "starred_url" : "https:\/\/api.github.com\/users\/bvanpeski\/starred{\/owner}{\/repo}",
        "gists_url" : "https:\/\/api.github.com\/users\/bvanpeski\/gists{\/gist_id}",
        "gravatar_id" : "",
        "followers_url" : "https:\/\/api.github.com\/users\/bvanpeski\/followers"
      },
      "visibility" : "public",
      "default_branch" : "main",
      "events_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/events",
      "subscription_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/subscription",
      "watchers" : 210,
      "git_commits_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/git\/commits{\/sha}",
      "subscribers_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/subscribers",
      "clone_url" : "https:\/\/github.com\/bvanpeski\/SystemPreferences.git",
      "has_wiki" : true,
      "url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences",
      "pulls_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/pulls{\/number}",
      "fork" : false,
      "notifications_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/notifications{?since,all,participating}",
      "description" : "Navigating System Prefences\/Settings on macOS",
      "collaborators_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/collaborators{\/collaborator}",
      "deployments_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/deployments",
      "archived" : false,
      "topics" : [
        "macos",
        "system-preferences",
        "system-settings"
      ],
      "languages_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/languages",
      "has_issues" : true,
      "comments_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/comments{\/number}",
      "is_template" : false,
      "private" : false,
      "size" : 528,
      "git_tags_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/git\/tags{\/sha}",
      "updated_at" : "2025-01-28T13:26:51Z",
      "ssh_url" : "git@github.com:bvanpeski\/SystemPreferences.git",
      "name" : "SystemPreferences",
      "web_commit_signoff_required" : false,
      "contents_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/contents\/{+path}",
      "archive_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/{archive_format}{\/ref}",
      "milestones_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/milestones{\/number}",
      "blobs_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/git\/blobs{\/sha}",
      "node_id" : "R_kgDOHETx8A",
      "contributors_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/contributors",
      "open_issues_count" : 0,
      "permissions" : {
        "push" : false,
        "admin" : false,
        "maintain" : false,
        "triage" : false,
        "pull" : true
      },
      "forks_count" : 9,
      "has_discussions" : false,
      "trees_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/git\/trees{\/sha}",
      "svn_url" : "https:\/\/github.com\/bvanpeski\/SystemPreferences",
      "commits_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/commits{\/sha}",
      "created_at" : "2022-03-26T07:56:54Z",
      "forks_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/forks",
      "has_downloads" : true,
      "mirror_url" : null,
      "homepage" : "",
      "teams_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/teams",
      "branches_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/branches{\/branch}",
      "disabled" : false,
      "issue_comment_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/issues\/comments{\/number}",
      "merges_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/merges",
      "git_refs_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/git\/refs{\/sha}",
      "git_url" : "git:\/\/github.com\/bvanpeski\/SystemPreferences.git",
      "forks" : 9,
      "open_issues" : 0,
      "hooks_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/hooks",
      "html_url" : "https:\/\/github.com\/bvanpeski\/SystemPreferences",
      "stargazers_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/stargazers",
      "assignees_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/assignees{\/user}",
      "compare_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/compare\/{base}...{head}",
      "full_name" : "bvanpeski\/SystemPreferences",
      "tags_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/tags",
      "releases_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/releases{\/id}",
      "pushed_at" : "2024-01-27T22:02:19Z",
      "labels_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/labels{\/name}",
      "downloads_url" : "https:\/\/api.github.com\/repos\/bvanpeski\/SystemPreferences\/downloads",
      "stargazers_count" : 210,
      "watchers_count" : 210,
      "language" : null,
      "has_pages" : false
    }
  }
]
"""#
