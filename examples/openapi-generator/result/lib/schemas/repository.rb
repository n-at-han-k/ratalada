# frozen_string_literal: true

class Schemas::Repository
  include OpenapiRuby::Components::Base

  # The document's own spelling: nothing here is camelized on the way out.
  skip_key_transformation true

  schema({
    "description" => "Repository represents a repository",
    "type" => "object",
    "properties" => {
      "allow_fast_forward_only_merge" => {"type" => "boolean", "x-go-name" => "AllowFastForwardOnly"},
      "allow_merge_commits" => {"type" => "boolean", "x-go-name" => "AllowMerge"},
      "allow_rebase" => {"type" => "boolean", "x-go-name" => "AllowRebase"},
      "allow_rebase_explicit" => {"type" => "boolean", "x-go-name" => "AllowRebaseMerge"},
      "allow_rebase_update" => {"type" => "boolean", "x-go-name" => "AllowRebaseUpdate"},
      "allow_squash_merge" => {"type" => "boolean", "x-go-name" => "AllowSquash"},
      "archived" => {"type" => "boolean", "x-go-name" => "Archived"},
      "archived_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "ArchivedAt",
      },
      "avatar_url" => {"type" => "string", "x-go-name" => "AvatarURL"},
      "clone_url" => {"type" => "string", "x-go-name" => "CloneURL"},
      "created_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Created",
      },
      "default_allow_maintainer_edit" => {
        "type" => "boolean",
        "x-go-name" => "DefaultAllowMaintainerEdit",
      },
      "default_branch" => {"type" => "string", "x-go-name" => "DefaultBranch"},
      "default_delete_branch_after_merge" => {
        "type" => "boolean",
        "x-go-name" => "DefaultDeleteBranchAfterMerge",
      },
      "default_merge_style" => {"type" => "string", "x-go-name" => "DefaultMergeStyle"},
      "default_update_style" => {"type" => "string", "x-go-name" => "DefaultUpdateStyle"},
      "description" => {"type" => "string", "x-go-name" => "Description"},
      "empty" => {"type" => "boolean", "x-go-name" => "Empty"},
      "external_tracker" => {"$ref" => "#/components/schemas/ExternalTracker"},
      "external_wiki" => {"$ref" => "#/components/schemas/ExternalWiki"},
      "fork" => {"type" => "boolean", "x-go-name" => "Fork"},
      "forks_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Forks",
      },
      "full_name" => {"type" => "string", "x-go-name" => "FullName"},
      "globally_editable_wiki" => {"type" => "boolean", "x-go-name" => "GloballyEditableWiki"},
      "has_actions" => {"type" => "boolean", "x-go-name" => "HasActions"},
      "has_issues" => {"type" => "boolean", "x-go-name" => "HasIssues"},
      "has_packages" => {"type" => "boolean", "x-go-name" => "HasPackages"},
      "has_projects" => {"type" => "boolean", "x-go-name" => "HasProjects"},
      "has_pull_requests" => {"type" => "boolean", "x-go-name" => "HasPullRequests"},
      "has_releases" => {"type" => "boolean", "x-go-name" => "HasReleases"},
      "has_wiki" => {
        "description" => "is the wiki enabled",
        "type" => "boolean",
        "x-go-name" => "HasWiki",
      },
      "has_wiki_contents" => {
        "description" => "have wiki pages ever been created",
        "type" => "boolean",
        "x-go-name" => "HasWikiContents",
      },
      "html_url" => {"type" => "string", "x-go-name" => "HTMLURL"},
      "id" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "ID",
      },
      "ignore_whitespace_conflicts" => {
        "type" => "boolean",
        "x-go-name" => "IgnoreWhitespaceConflicts",
      },
      "internal" => {"type" => "boolean", "x-go-name" => "Internal"},
      "internal_tracker" => {"$ref" => "#/components/schemas/InternalTracker"},
      "language" => {"type" => "string", "x-go-name" => "Language"},
      "languages_url" => {"type" => "string", "x-go-name" => "LanguagesURL"},
      "link" => {"type" => "string", "x-go-name" => "Link"},
      "mirror" => {"type" => "boolean", "x-go-name" => "Mirror"},
      "mirror_interval" => {"type" => "string", "x-go-name" => "MirrorInterval"},
      "mirror_updated" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "MirrorUpdated",
      },
      "name" => {"type" => "string", "x-go-name" => "Name"},
      "object_format_name" => {
        "description" => "ObjectFormatName of the underlying git repository",
        "type" => "string",
        "enum" => ["sha1", "sha256"],
        "x-go-name" => "ObjectFormatName",
      },
      "open_issues_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OpenIssues",
      },
      "open_pr_counter" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "OpenPulls",
      },
      "original_url" => {"type" => "string", "x-go-name" => "OriginalURL"},
      "owner" => {"$ref" => "#/components/schemas/User"},
      "parent" => {"$ref" => "#/components/schemas/Repository"},
      "permissions" => {"$ref" => "#/components/schemas/Permission"},
      "private" => {"type" => "boolean", "x-go-name" => "Private"},
      "release_counter" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Releases",
      },
      "repo_transfer" => {"$ref" => "#/components/schemas/RepoTransfer"},
      "size" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Size",
      },
      "ssh_url" => {"type" => "string", "x-go-name" => "SSHURL"},
      "stars_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Stars",
      },
      "template" => {"type" => "boolean", "x-go-name" => "Template"},
      "topics" => {
        "type" => "array",
        "items" => {"type" => "string"},
        "x-go-name" => "Topics",
      },
      "updated_at" => {
        "type" => "string",
        "format" => "date-time",
        "x-go-name" => "Updated",
      },
      "url" => {"type" => "string", "x-go-name" => "URL"},
      "watchers_count" => {
        "type" => "integer",
        "format" => "int64",
        "x-go-name" => "Watchers",
      },
      "website" => {"type" => "string", "x-go-name" => "Website"},
      "wiki_branch" => {"type" => "string", "x-go-name" => "WikiBranch"},
      "wiki_clone_url" => {"type" => "string", "x-go-name" => "WikiCloneURL"},
      "wiki_ssh_url" => {"type" => "string", "x-go-name" => "WikiSSHURL"},
    },
    "x-go-package" => "forgejo.org/modules/structs",
  })
end
