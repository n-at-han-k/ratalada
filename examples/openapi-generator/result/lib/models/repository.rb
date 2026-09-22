# frozen_string_literal: true

# Repository -- columns from models.json, over the table the migrations made.
module Models
  class Repository < ROM::Relation[:sql]
    schema(:repository, infer: false) do
      attribute :id, Types::Integer.optional
      attribute :repo, Types::String.optional
      attribute :allow_fast_forward_only_merge, Types::Bool.optional
      attribute :allow_merge_commits, Types::Bool.optional
      attribute :allow_rebase, Types::Bool.optional
      attribute :allow_rebase_explicit, Types::Bool.optional
      attribute :allow_rebase_update, Types::Bool.optional
      attribute :allow_squash_merge, Types::Bool.optional
      attribute :archived, Types::Bool.optional
      attribute :archived_at, Types::String.optional
      attribute :avatar_url, Types::String.optional
      attribute :clone_url, Types::String.optional
      attribute :created_at, Types::String.optional
      attribute :default_allow_maintainer_edit, Types::Bool.optional
      attribute :default_branch, Types::String.optional
      attribute :default_delete_branch_after_merge, Types::Bool.optional
      attribute :default_merge_style, Types::String.optional
      attribute :default_update_style, Types::String.optional
      attribute :description, Types::String.optional
      attribute :empty, Types::Bool.optional
      attribute :external_tracker, Types::Any, read: Parsed
      attribute :external_wiki, Types::Any, read: Parsed
      attribute :fork, Types::Bool.optional
      attribute :forks_count, Types::Integer.optional
      attribute :full_name, Types::String.optional
      attribute :globally_editable_wiki, Types::Bool.optional
      attribute :has_actions, Types::Bool.optional
      attribute :has_issues, Types::Bool.optional
      attribute :has_packages, Types::Bool.optional
      attribute :has_projects, Types::Bool.optional
      attribute :has_pull_requests, Types::Bool.optional
      attribute :has_releases, Types::Bool.optional
      attribute :has_wiki, Types::Bool.optional
      attribute :has_wiki_contents, Types::Bool.optional
      attribute :html_url, Types::String.optional
      attribute :ignore_whitespace_conflicts, Types::Bool.optional
      attribute :internal, Types::Bool.optional
      attribute :internal_tracker, Types::Any, read: Parsed
      attribute :language, Types::String.optional
      attribute :languages_url, Types::String.optional
      attribute :link, Types::String.optional
      attribute :mirror, Types::Bool.optional
      attribute :mirror_interval, Types::String.optional
      attribute :mirror_updated, Types::String.optional
      attribute :name, Types::String.optional
      attribute :object_format_name, Types::String.optional
      attribute :open_issues_count, Types::Integer.optional
      attribute :open_pr_counter, Types::Integer.optional
      attribute :original_url, Types::String.optional
      attribute :owner, Types::Any, read: Parsed
      attribute :parent, Types::Any, read: Parsed
      attribute :permissions, Types::Any, read: Parsed
      attribute :private, Types::Bool.optional
      attribute :release_counter, Types::Integer.optional
      attribute :repo_transfer, Types::Any, read: Parsed
      attribute :size, Types::Integer.optional
      attribute :ssh_url, Types::String.optional
      attribute :stars_count, Types::Integer.optional
      attribute :template, Types::Bool.optional
      attribute :topics, Types::Any, read: Parsed
      attribute :updated_at, Types::String.optional
      attribute :url, Types::String.optional
      attribute :watchers_count, Types::Integer.optional
      attribute :website, Types::String.optional
      attribute :wiki_branch, Types::String.optional
      attribute :wiki_clone_url, Types::String.optional
      attribute :wiki_ssh_url, Types::String.optional

      primary_key :id
    end

    auto_struct true
    struct_namespace Entities
  end
end
