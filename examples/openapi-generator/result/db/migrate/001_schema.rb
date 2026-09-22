# frozen_string_literal: true

# Translated from db/schema.sql, which `openapi-generator-cli -g
# postgresql-schema` wrote from the document. Edit the document, not this.
#
# `up`, and `create_table?` rather than `create_table`: sqlite answers
# false to `supports_transactional_ddl?`, so Sequel runs this OUTSIDE a
# transaction. A boot interrupted partway through 200-odd tables leaves
# every table it managed and no version recorded, and the next boot used
# to die on the first one it had already made. Creating only what is
# missing lets a half-applied migration finish instead of wedging.
Sequel.migration do
  up do
    create_table?(:api_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_forbidden_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_internal_server_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_invalid_topics_error) do
      column :invalidTopics, String, text: true
      column :message, String, text: true
    end
    create_table?(:api_not_found) do
      column :errors, String, text: true
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_repo_archived_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_unauthorized_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:api_validation_error) do
      column :message, String, text: true
      column :url, String, text: true
    end
    create_table?(:ap_remote_follow_option) do
      column :target, String, text: true
    end
    create_table?(:access_token) do
      primary_key :id
      column :created_at, String, text: true
      column :name, String, text: true
      column :repositories, String, text: true
      column :scopes, String, text: true
      column :sha1, String, text: true
      column :token_last_eight, String, text: true
    end
    create_table?(:action_artifact) do
      primary_key :id
      column :archive_download_url, String, text: true
      column :created_at, String, text: true
      column :expired, TrueClass
      column :expires_at, String, text: true
      column :name, String, text: true
      column :run_id, Integer
      column :size_in_bytes, Integer
      column :updated_at, String, text: true
    end
    create_table?(:action_run) do
      primary_key :id
      column :ScheduleID, Integer
      column :approved_by, Integer
      column :commit_sha, String, text: true
      column :created, String, text: true
      column :duration, Integer
      column :event, String, text: true
      column :event_payload, String, text: true
      column :html_url, String, text: true
      column :index_in_repo, Integer
      column :is_fork_pull_request, TrueClass
      column :is_ref_deleted, TrueClass
      column :need_approval, TrueClass
      column :prettyref, String, text: true
      column :repository, String, text: true
      column :started, String, text: true
      column :status, String, text: true
      column :stopped, String, text: true
      column :title, String, text: true
      column :trigger_event, String, text: true
      column :trigger_user, String, text: true
      column :updated, String, text: true
      column :workflow_id, String, text: true
    end
    create_table?(:action_run_job) do
      primary_key :id
      column :attempt, Integer
      column :handle, String, text: true
      column :html_url, String, text: true
      column :name, String, text: true
      column :needs, String, text: true
      column :owner_id, Integer
      column :repo_id, Integer
      column :run_id, Integer
      column :runs_on, String, text: true
      column :status, String, text: true
      column :steps, String, text: true
      column :task_id, Integer
    end
    create_table?(:action_run_job_step) do
      column :name, String, text: true
      column :number, Integer
      column :started, String, text: true
      column :status, String, text: true
      column :stopped, String, text: true
    end
    create_table?(:action_runner) do
      primary_key :id
      column :description, String, text: true
      column :ephemeral, TrueClass
      column :labels, String, text: true
      column :name, String, text: true
      column :owner_id, Integer
      column :repo_id, Integer
      column :status, String, text: true
      column :uuid, String, text: true
      column :version, String, text: true
    end
    create_table?(:action_task) do
      primary_key :id
      column :created_at, String, text: true
      column :display_title, String, text: true
      column :event, String, text: true
      column :head_branch, String, text: true
      column :head_sha, String, text: true
      column :name, String, text: true
      column :run_number, Integer
      column :run_started_at, String, text: true
      column :status, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
      column :workflow_id, String, text: true
    end
    create_table?(:action_task_response) do
      column :total_count, Integer
      column :workflow_runs, String, text: true
    end
    create_table?(:action_variable) do
      column :data, String, text: true
      column :name, String, text: true
      column :owner_id, Integer
      column :repo_id, Integer
    end
    create_table?(:activity) do
      primary_key :id
      column :act_user, String, text: true
      column :act_user_id, Integer
      column :comment, String, text: true
      column :comment_id, Integer
      column :content, String, text: true
      column :created, String, text: true
      column :is_private, TrueClass
      column :op_type, String, text: true
      column :ref_name, String, text: true
      column :repo, String, text: true
      column :repo_id, Integer
      column :user_id, Integer
    end
    create_table?(:activity_pub) do
      column :@context, String, text: true
    end
    create_table?(:add_collaborator_option) do
      column :permission, String, text: true
    end
    create_table?(:add_time_option) do
      column :created, String, text: true
      column :time, Integer
      column :user_name, String, text: true
    end
    create_table?(:annotated_tag) do
      column :archive_download_count, String, text: true
      column :message, String, text: true
      column :object, String, text: true
      column :sha, String, text: true
      column :tag, String, text: true
      column :tagger, String, text: true
      column :url, String, text: true
      column :verification, String, text: true
    end
    create_table?(:annotated_tag_object) do
      column :sha, String, text: true
      column :type, String, text: true
      column :url, String, text: true
    end
    create_table?(:attachment) do
      primary_key :id
      column :browser_download_url, String, text: true
      column :created_at, String, text: true
      column :download_count, Integer
      column :name, String, text: true
      column :size, Integer
      column :type, String, text: true
      column :uuid, String, text: true
    end
    create_table?(:blocked_user) do
      column :block_id, Integer
      column :created_at, String, text: true
    end
    create_table?(:branch) do
      column :commit, String, text: true
      column :effective_branch_protection_name, String, text: true
      column :enable_status_check, TrueClass
      column :name, String, text: true
      column :protected, TrueClass
      column :required_approvals, Integer
      column :status_check_contexts, String, text: true
      column :user_can_merge, TrueClass
      column :user_can_push, TrueClass
    end
    create_table?(:branch_protection) do
      column :apply_to_admins, TrueClass
      column :approvals_whitelist_teams, String, text: true
      column :approvals_whitelist_username, String, text: true
      column :block_on_official_review_requests, TrueClass
      column :block_on_outdated_branch, TrueClass
      column :block_on_rejected_reviews, TrueClass
      column :branch_name, String, text: true
      column :created_at, String, text: true
      column :dismiss_stale_approvals, TrueClass
      column :enable_approvals_whitelist, TrueClass
      column :enable_merge_whitelist, TrueClass
      column :enable_push, TrueClass
      column :enable_push_whitelist, TrueClass
      column :enable_status_check, TrueClass
      column :ignore_stale_approvals, TrueClass
      column :merge_whitelist_teams, String, text: true
      column :merge_whitelist_usernames, String, text: true
      column :protected_file_patterns, String, text: true
      column :push_whitelist_deploy_keys, TrueClass
      column :push_whitelist_teams, String, text: true
      column :push_whitelist_usernames, String, text: true
      column :require_signed_commits, TrueClass
      column :required_approvals, Integer
      column :rule_name, String, text: true
      column :status_check_contexts, String, text: true
      column :unprotected_file_patterns, String, text: true
      column :updated_at, String, text: true
    end
    create_table?(:change_file_operation) do
      column :content, String, text: true
      column :from_path, String, text: true
      column :operation, String, text: true
      column :path, String, text: true
      column :sha, String, text: true
    end
    create_table?(:change_files_options) do
      column :author, String, text: true
      column :branch, String, text: true
      column :committer, String, text: true
      column :dates, String, text: true
      column :files, String, text: true
      column :force_overwrite_new_branch, TrueClass
      column :message, String, text: true
      column :new_branch, String, text: true
      column :signoff, TrueClass
    end
    create_table?(:changed_file) do
      column :additions, Integer
      column :changes, Integer
      column :contents_url, String, text: true
      column :deletions, Integer
      column :filename, String, text: true
      column :html_url, String, text: true
      column :previous_filename, String, text: true
      column :raw_url, String, text: true
      column :status, String, text: true
    end
    create_table?(:combined_status) do
      column :commit_url, String, text: true
      column :repository, String, text: true
      column :sha, String, text: true
      column :state, String, text: true
      column :statuses, String, text: true
      column :total_count, Integer
      column :url, String, text: true
    end
    create_table?(:commit_affected_files) do
      column :filename, String, text: true
      column :status, String, text: true
    end
    create_table?(:commit_date_options) do
      column :author, String, text: true
      column :committer, String, text: true
    end
    create_table?(:commit_meta) do
      column :created, String, text: true
      column :sha, String, text: true
      column :url, String, text: true
    end
    create_table?(:commit_stats) do
      column :additions, Integer
      column :deletions, Integer
      column :total, Integer
    end
    create_table?(:commit_status) do
      primary_key :id
      column :context, String, text: true
      column :created_at, String, text: true
      column :creator, String, text: true
      column :description, String, text: true
      column :status, String, text: true
      column :target_url, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
    end
    create_table?(:commit_user) do
      column :date, String, text: true
      column :email, String, text: true
      column :name, String, text: true
    end
    create_table?(:compare) do
      column :commits, String, text: true
      column :files, String, text: true
      column :total_commits, Integer
    end
    create_table?(:contents_response) do
      column :_links, String, text: true
      column :content, String, text: true
      column :download_url, String, text: true
      column :encoding, String, text: true
      column :git_url, String, text: true
      column :html_url, String, text: true
      column :last_commit_sha, String, text: true
      column :last_commit_when, String, text: true
      column :name, String, text: true
      column :path, String, text: true
      column :sha, String, text: true
      column :size, Integer
      column :submodule_git_url, String, text: true
      column :target, String, text: true
      column :type, String, text: true
      column :url, String, text: true
    end
    create_table?(:create_access_token_option) do
      column :name, String, text: true
      column :repositories, String, text: true
      column :scopes, String, text: true
    end
    create_table?(:create_branch_protection_option) do
      column :apply_to_admins, TrueClass
      column :approvals_whitelist_teams, String, text: true
      column :approvals_whitelist_username, String, text: true
      column :block_on_official_review_requests, TrueClass
      column :block_on_outdated_branch, TrueClass
      column :block_on_rejected_reviews, TrueClass
      column :branch_name, String, text: true
      column :dismiss_stale_approvals, TrueClass
      column :enable_approvals_whitelist, TrueClass
      column :enable_merge_whitelist, TrueClass
      column :enable_push, TrueClass
      column :enable_push_whitelist, TrueClass
      column :enable_status_check, TrueClass
      column :ignore_stale_approvals, TrueClass
      column :merge_whitelist_teams, String, text: true
      column :merge_whitelist_usernames, String, text: true
      column :protected_file_patterns, String, text: true
      column :push_whitelist_deploy_keys, TrueClass
      column :push_whitelist_teams, String, text: true
      column :push_whitelist_usernames, String, text: true
      column :require_signed_commits, TrueClass
      column :required_approvals, Integer
      column :rule_name, String, text: true
      column :status_check_contexts, String, text: true
      column :unprotected_file_patterns, String, text: true
    end
    create_table?(:create_branch_repo_option) do
      column :new_branch_name, String, text: true
      column :old_branch_name, String, text: true
      column :old_ref_name, String, text: true
    end
    create_table?(:create_email_option) do
      column :emails, String, text: true
    end
    create_table?(:create_file_options) do
      column :author, String, text: true
      column :branch, String, text: true
      column :committer, String, text: true
      column :content, String, text: true
      column :dates, String, text: true
      column :force_overwrite_new_branch, TrueClass
      column :message, String, text: true
      column :new_branch, String, text: true
      column :signoff, TrueClass
    end
    create_table?(:create_fork_option) do
      column :name, String, text: true
      column :organization, String, text: true
    end
    create_table?(:create_gpg_key_option) do
      column :armored_public_key, String, text: true
      column :armored_signature, String, text: true
    end
    create_table?(:create_hook_option) do
      column :active, TrueClass
      column :authorization_header, String, text: true
      column :branch_filter, String, text: true
      column :config, String, text: true
      column :events, String, text: true
      column :type, String, text: true
    end
    create_table?(:create_issue_comment_option) do
      column :body, String, text: true
      column :updated_at, String, text: true
    end
    create_table?(:create_issue_option) do
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :body, String, text: true
      column :closed, TrueClass
      column :due_date, String, text: true
      column :labels, String, text: true
      column :milestone, Integer
      column :ref, String, text: true
      column :title, String, text: true
    end
    create_table?(:create_key_option) do
      column :key, String, text: true
      column :read_only, TrueClass
      column :title, String, text: true
    end
    create_table?(:create_label_option) do
      column :color, String, text: true
      column :description, String, text: true
      column :exclusive, TrueClass
      column :is_archived, TrueClass
      column :name, String, text: true
    end
    create_table?(:create_milestone_option) do
      column :description, String, text: true
      column :due_on, String, text: true
      column :state, String, text: true
      column :title, String, text: true
    end
    create_table?(:create_o_auth2_application_options) do
      column :confidential_client, TrueClass
      column :name, String, text: true
      column :redirect_uris, String, text: true
    end
    create_table?(:create_or_update_secret_option) do
      column :data, String, text: true
    end
    create_table?(:create_org_option) do
      column :description, String, text: true
      column :email, String, text: true
      column :full_name, String, text: true
      column :location, String, text: true
      column :repo_admin_change_team_access, TrueClass
      column :username, String, text: true
      column :visibility, String, text: true
      column :website, String, text: true
    end
    create_table?(:create_pull_request_option) do
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :base, String, text: true
      column :body, String, text: true
      column :due_date, String, text: true
      column :head, String, text: true
      column :labels, String, text: true
      column :milestone, Integer
      column :title, String, text: true
    end
    create_table?(:create_pull_review_comment) do
      column :body, String, text: true
      column :extra_lines_count, Integer
      column :new_position, Integer
      column :old_position, Integer
      column :path, String, text: true
    end
    create_table?(:create_pull_review_options) do
      column :body, String, text: true
      column :comments, String, text: true
      column :commit_id, String, text: true
      column :event, String, text: true
    end
    create_table?(:create_push_mirror_option) do
      column :branch_filter, String, text: true
      column :interval, String, text: true
      column :remote_address, String, text: true
      column :remote_password, String, text: true
      column :remote_username, String, text: true
      column :sync_on_commit, TrueClass
      column :use_ssh, TrueClass
    end
    create_table?(:create_quota_group_options) do
      column :name, String, text: true
      column :rules, String, text: true
    end
    create_table?(:create_quota_rule_options) do
      column :limit, Integer
      column :name, String, text: true
      column :subjects, String, text: true
    end
    create_table?(:create_release_option) do
      column :body, String, text: true
      column :draft, TrueClass
      column :hide_archive_links, TrueClass
      column :name, String, text: true
      column :prerelease, TrueClass
      column :tag_name, String, text: true
      column :target_commitish, String, text: true
    end
    create_table?(:create_repo_option) do
      column :auto_init, TrueClass
      column :default_branch, String, text: true
      column :description, String, text: true
      column :gitignores, String, text: true
      column :issue_labels, String, text: true
      column :license, String, text: true
      column :name, String, text: true
      column :object_format_name, String, text: true
      column :private, TrueClass
      column :readme, String, text: true
      column :template, TrueClass
      column :trust_model, String, text: true
    end
    create_table?(:create_status_option) do
      column :context, String, text: true
      column :description, String, text: true
      column :state, String, text: true
      column :target_url, String, text: true
    end
    create_table?(:create_tag_option) do
      column :message, String, text: true
      column :tag_name, String, text: true
      column :target, String, text: true
    end
    create_table?(:create_tag_protection_option) do
      column :name_pattern, String, text: true
      column :whitelist_teams, String, text: true
      column :whitelist_usernames, String, text: true
    end
    create_table?(:create_team_option) do
      column :can_create_org_repo, TrueClass
      column :description, String, text: true
      column :includes_all_repositories, TrueClass
      column :name, String, text: true
      column :permission, String, text: true
      column :units, String, text: true
      column :units_map, String, text: true
    end
    create_table?(:create_user_option) do
      column :created_at, String, text: true
      column :email, String, text: true
      column :full_name, String, text: true
      column :login_name, String, text: true
      column :must_change_password, TrueClass
      column :password, String, text: true
      column :restricted, TrueClass
      column :send_notify, TrueClass
      column :source_id, Integer
      column :username, String, text: true
      column :visibility, String, text: true
    end
    create_table?(:create_variable_option) do
      column :value, String, text: true
    end
    create_table?(:create_wiki_page_options) do
      column :content_base64, String, text: true
      column :message, String, text: true
      column :title, String, text: true
    end
    create_table?(:cron) do
      column :exec_times, Integer
      column :name, String, text: true
      column :next, String, text: true
      column :prev, String, text: true
      column :schedule, String, text: true
    end
    create_table?(:delete_email_option) do
      column :emails, String, text: true
    end
    create_table?(:delete_file_options) do
      column :author, String, text: true
      column :branch, String, text: true
      column :committer, String, text: true
      column :dates, String, text: true
      column :force_overwrite_new_branch, TrueClass
      column :message, String, text: true
      column :new_branch, String, text: true
      column :sha, String, text: true
      column :signoff, TrueClass
    end
    create_table?(:delete_labels_option) do
      column :updated_at, String, text: true
    end
    create_table?(:deploy_key) do
      primary_key :id
      column :created_at, String, text: true
      column :fingerprint, String, text: true
      column :key, String, text: true
      column :key_id, Integer
      column :read_only, TrueClass
      column :repository, String, text: true
      column :title, String, text: true
      column :url, String, text: true
    end
    create_table?(:dismiss_pull_review_options) do
      column :message, String, text: true
      column :priors, TrueClass
    end
    create_table?(:dispatch_workflow_option) do
      column :inputs, String, text: true
      column :ref, String, text: true
      column :return_run_info, TrueClass
    end
    create_table?(:dispatch_workflow_run) do
      primary_key :id
      column :jobs, String, text: true
      column :run_number, Integer
    end
    create_table?(:edit_attachment_options) do
      column :browser_download_url, String, text: true
      column :name, String, text: true
    end
    create_table?(:edit_branch_protection_option) do
      column :apply_to_admins, TrueClass
      column :approvals_whitelist_teams, String, text: true
      column :approvals_whitelist_username, String, text: true
      column :block_on_official_review_requests, TrueClass
      column :block_on_outdated_branch, TrueClass
      column :block_on_rejected_reviews, TrueClass
      column :dismiss_stale_approvals, TrueClass
      column :enable_approvals_whitelist, TrueClass
      column :enable_merge_whitelist, TrueClass
      column :enable_push, TrueClass
      column :enable_push_whitelist, TrueClass
      column :enable_status_check, TrueClass
      column :ignore_stale_approvals, TrueClass
      column :merge_whitelist_teams, String, text: true
      column :merge_whitelist_usernames, String, text: true
      column :protected_file_patterns, String, text: true
      column :push_whitelist_deploy_keys, TrueClass
      column :push_whitelist_teams, String, text: true
      column :push_whitelist_usernames, String, text: true
      column :require_signed_commits, TrueClass
      column :required_approvals, Integer
      column :status_check_contexts, String, text: true
      column :unprotected_file_patterns, String, text: true
    end
    create_table?(:edit_deadline_option) do
      column :due_date, String, text: true
    end
    create_table?(:edit_git_hook_option) do
      column :content, String, text: true
    end
    create_table?(:edit_hook_option) do
      column :active, TrueClass
      column :authorization_header, String, text: true
      column :branch_filter, String, text: true
      column :config, String, text: true
      column :events, String, text: true
    end
    create_table?(:edit_issue_comment_option) do
      column :body, String, text: true
      column :updated_at, String, text: true
    end
    create_table?(:edit_issue_option) do
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :body, String, text: true
      column :due_date, String, text: true
      column :milestone, Integer
      column :ref, String, text: true
      column :state, String, text: true
      column :title, String, text: true
      column :unset_due_date, TrueClass
      column :updated_at, String, text: true
    end
    create_table?(:edit_label_option) do
      column :color, String, text: true
      column :description, String, text: true
      column :exclusive, TrueClass
      column :is_archived, TrueClass
      column :name, String, text: true
    end
    create_table?(:edit_milestone_option) do
      column :description, String, text: true
      column :due_on, String, text: true
      column :state, String, text: true
      column :title, String, text: true
    end
    create_table?(:edit_org_option) do
      column :description, String, text: true
      column :email, String, text: true
      column :full_name, String, text: true
      column :location, String, text: true
      column :repo_admin_change_team_access, TrueClass
      column :visibility, String, text: true
      column :website, String, text: true
    end
    create_table?(:edit_pull_request_option) do
      column :allow_maintainer_edit, TrueClass
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :base, String, text: true
      column :body, String, text: true
      column :due_date, String, text: true
      column :labels, String, text: true
      column :milestone, Integer
      column :state, String, text: true
      column :title, String, text: true
      column :unset_due_date, TrueClass
    end
    create_table?(:edit_quota_rule_options) do
      column :limit, Integer
      column :subjects, String, text: true
    end
    create_table?(:edit_reaction_option) do
      column :content, String, text: true
    end
    create_table?(:edit_release_option) do
      column :body, String, text: true
      column :draft, TrueClass
      column :hide_archive_links, TrueClass
      column :name, String, text: true
      column :prerelease, TrueClass
      column :tag_name, String, text: true
      column :target_commitish, String, text: true
    end
    create_table?(:edit_repo_option) do
      column :allow_fast_forward_only_merge, TrueClass
      column :allow_manual_merge, TrueClass
      column :allow_merge_commits, TrueClass
      column :allow_rebase, TrueClass
      column :allow_rebase_explicit, TrueClass
      column :allow_rebase_update, TrueClass
      column :allow_squash_merge, TrueClass
      column :archived, TrueClass
      column :autodetect_manual_merge, TrueClass
      column :default_allow_maintainer_edit, TrueClass
      column :default_branch, String, text: true
      column :default_delete_branch_after_merge, TrueClass
      column :default_merge_style, String, text: true
      column :default_update_style, String, text: true
      column :description, String, text: true
      column :enable_prune, TrueClass
      column :external_tracker, String, text: true
      column :external_wiki, String, text: true
      column :globally_editable_wiki, TrueClass
      column :has_actions, TrueClass
      column :has_issues, TrueClass
      column :has_packages, TrueClass
      column :has_projects, TrueClass
      column :has_pull_requests, TrueClass
      column :has_releases, TrueClass
      column :has_wiki, TrueClass
      column :ignore_whitespace_conflicts, TrueClass
      column :internal_tracker, String, text: true
      column :mirror_interval, String, text: true
      column :name, String, text: true
      column :private, TrueClass
      column :template, TrueClass
      column :website, String, text: true
      column :wiki_branch, String, text: true
    end
    create_table?(:edit_tag_protection_option) do
      column :name_pattern, String, text: true
      column :whitelist_teams, String, text: true
      column :whitelist_usernames, String, text: true
    end
    create_table?(:edit_team_option) do
      column :can_create_org_repo, TrueClass
      column :description, String, text: true
      column :includes_all_repositories, TrueClass
      column :name, String, text: true
      column :permission, String, text: true
      column :units, String, text: true
      column :units_map, String, text: true
    end
    create_table?(:edit_user_option) do
      column :active, TrueClass
      column :admin, TrueClass
      column :allow_create_organization, TrueClass
      column :allow_git_hook, TrueClass
      column :allow_import_local, TrueClass
      column :description, String, text: true
      column :email, String, text: true
      column :full_name, String, text: true
      column :hide_email, TrueClass
      column :location, String, text: true
      column :login_name, String, text: true
      column :max_repo_creation, Integer
      column :must_change_password, TrueClass
      column :password, String, text: true
      column :prohibit_login, TrueClass
      column :pronouns, String, text: true
      column :restricted, TrueClass
      column :source_id, Integer
      column :visibility, String, text: true
      column :website, String, text: true
    end
    create_table?(:email) do
      column :email, String, text: true
      column :primary, TrueClass
      column :user_id, Integer
      column :username, String, text: true
      column :verified, TrueClass
    end
    create_table?(:external_tracker) do
      column :external_tracker_format, String, text: true
      column :external_tracker_regexp_pattern, String, text: true
      column :external_tracker_style, String, text: true
      column :external_tracker_url, String, text: true
    end
    create_table?(:external_wiki) do
      column :external_wiki_url, String, text: true
    end
    create_table?(:file_commit_response) do
      column :author, String, text: true
      column :committer, String, text: true
      column :created, String, text: true
      column :html_url, String, text: true
      column :message, String, text: true
      column :parents, String, text: true
      column :sha, String, text: true
      column :tree, String, text: true
      column :url, String, text: true
    end
    create_table?(:file_delete_response) do
      column :commit, String, text: true
      column :content, String, text: true
      column :verification, String, text: true
    end
    create_table?(:file_links_response) do
      column :git, String, text: true
      column :html, String, text: true
      column :self, String, text: true
    end
    create_table?(:file_response) do
      column :commit, String, text: true
      column :content, String, text: true
      column :verification, String, text: true
    end
    create_table?(:files_response) do
      column :commit, String, text: true
      column :files, String, text: true
      column :verification, String, text: true
    end
    create_table?(:gpg_key) do
      primary_key :id
      column :can_certify, TrueClass
      column :can_encrypt_comms, TrueClass
      column :can_encrypt_storage, TrueClass
      column :can_sign, TrueClass
      column :created_at, String, text: true
      column :emails, String, text: true
      column :expires_at, String, text: true
      column :key_id, String, text: true
      column :primary_key_id, String, text: true
      column :public_key, String, text: true
      column :subkeys, String, text: true
      column :verified, TrueClass
    end
    create_table?(:gpg_key_email) do
      column :email, String, text: true
      column :verified, TrueClass
    end
    create_table?(:general_api_settings) do
      column :default_git_trees_per_page, Integer
      column :default_max_blob_size, Integer
      column :default_paging_num, Integer
      column :max_response_items, Integer
    end
    create_table?(:general_attachment_settings) do
      column :allowed_types, String, text: true
      column :enabled, TrueClass
      column :max_files, Integer
      column :max_size, Integer
    end
    create_table?(:general_repo_settings) do
      column :forks_disabled, TrueClass
      column :http_git_disabled, TrueClass
      column :lfs_disabled, TrueClass
      column :migrations_disabled, TrueClass
      column :mirrors_disabled, TrueClass
      column :stars_disabled, TrueClass
      column :time_tracking_disabled, TrueClass
    end
    create_table?(:general_ui_settings) do
      column :allowed_reactions, String, text: true
      column :custom_emojis, String, text: true
      column :default_theme, String, text: true
    end
    create_table?(:generate_repo_option) do
      column :avatar, TrueClass
      column :default_branch, String, text: true
      column :description, String, text: true
      column :git_content, TrueClass
      column :git_hooks, TrueClass
      column :labels, TrueClass
      column :name, String, text: true
      column :owner, String, text: true
      column :private, TrueClass
      column :protected_branch, TrueClass
      column :topics, TrueClass
      column :webhooks, TrueClass
    end
    create_table?(:git_blob) do
      column :content, String, text: true
      column :encoding, String, text: true
      column :sha, String, text: true
      column :size, Integer
      column :url, String, text: true
    end
    create_table?(:git_entry) do
      column :mode, String, text: true
      column :path, String, text: true
      column :sha, String, text: true
      column :size, Integer
      column :type, String, text: true
      column :url, String, text: true
    end
    create_table?(:git_hook) do
      column :content, String, text: true
      column :is_active, TrueClass
      column :name, String, text: true
    end
    create_table?(:git_object) do
      column :sha, String, text: true
      column :type, String, text: true
      column :url, String, text: true
    end
    create_table?(:git_tree_response) do
      column :page, Integer
      column :sha, String, text: true
      column :total_count, Integer
      column :tree, String, text: true
      column :truncated, TrueClass
      column :url, String, text: true
    end
    create_table?(:gitignore_template_info) do
      column :name, String, text: true
      column :source, String, text: true
    end
    create_table?(:hook) do
      primary_key :id
      column :active, TrueClass
      column :authorization_header, String, text: true
      column :branch_filter, String, text: true
      column :config, String, text: true
      column :content_type, String, text: true
      column :created_at, String, text: true
      column :events, String, text: true
      column :metadata, String, text: true
      column :type, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
    end
    create_table?(:internal_tracker) do
      column :allow_only_contributors_to_track_time, TrueClass
      column :enable_issue_dependencies, TrueClass
      column :enable_time_tracker, TrueClass
    end
    create_table?(:issue) do
      primary_key :id
      column :assets, String, text: true
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :body, String, text: true
      column :closed_at, String, text: true
      column :comments, Integer
      column :created_at, String, text: true
      column :due_date, String, text: true
      column :html_url, String, text: true
      column :is_locked, TrueClass
      column :labels, String, text: true
      column :milestone, String, text: true
      column :number, Integer
      column :original_author, String, text: true
      column :original_author_id, Integer
      column :pin_order, Integer
      column :pull_request, String, text: true
      column :ref, String, text: true
      column :repository, String, text: true
      column :state, String, text: true
      column :title, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
      column :user, String, text: true
    end
    create_table?(:issue_config) do
      column :blank_issues_enabled, TrueClass
      column :contact_links, String, text: true
    end
    create_table?(:issue_config_contact_link) do
      column :about, String, text: true
      column :name, String, text: true
      column :url, String, text: true
    end
    create_table?(:issue_config_validation) do
      column :message, String, text: true
      column :valid, TrueClass
    end
    create_table?(:issue_deadline) do
      column :due_date, String, text: true
    end
    create_table?(:issue_form_field) do
      column :attributes, String, text: true
      column :id, String, text: true
      column :type, String, text: true
      column :validations, String, text: true
      column :visible, String, text: true
    end
    create_table?(:issue_labels_option) do
      column :labels, String, text: true
      column :updated_at, String, text: true
    end
    create_table?(:issue_lock_option) do
      column :reason, String, text: true
    end
    create_table?(:issue_meta) do
      column :index, Integer
      column :owner, String, text: true
      column :repo, String, text: true
    end
    create_table?(:issue_template) do
      column :about, String, text: true
      column :body, String, text: true
      column :content, String, text: true
      column :file_name, String, text: true
      column :labels, String, text: true
      column :name, String, text: true
      column :ref, String, text: true
      column :title, String, text: true
    end
    create_table?(:label_template) do
      column :color, String, text: true
      column :description, String, text: true
      column :exclusive, TrueClass
      column :name, String, text: true
    end
    create_table?(:license_template_info) do
      column :body, String, text: true
      column :implementation, String, text: true
      column :key, String, text: true
      column :name, String, text: true
      column :url, String, text: true
    end
    create_table?(:licenses_template_list_entry) do
      column :key, String, text: true
      column :name, String, text: true
      column :url, String, text: true
    end
    create_table?(:list_action_run_response) do
      column :total_count, Integer
      column :workflow_runs, String, text: true
    end
    create_table?(:markdown_option) do
      column :Context, String, text: true
      column :Mode, String, text: true
      column :Text, String, text: true
      column :Wiki, TrueClass
    end
    create_table?(:markup_option) do
      column :BranchPath, String, text: true
      column :Context, String, text: true
      column :FilePath, String, text: true
      column :Mode, String, text: true
      column :Text, String, text: true
      column :Wiki, TrueClass
    end
    create_table?(:merge_pull_request_option) do
      column :Do, String, text: true
      column :MergeCommitID, String, text: true
      column :MergeMessageField, String, text: true
      column :MergeTitleField, String, text: true
      column :delete_branch_after_merge, TrueClass
      column :force_merge, TrueClass
      column :head_commit_id, String, text: true
      column :merge_when_checks_succeed, TrueClass
    end
    create_table?(:migrate_repo_options) do
      column :auth_password, String, text: true
      column :auth_token, String, text: true
      column :auth_username, String, text: true
      column :clone_addr, String, text: true
      column :description, String, text: true
      column :issues, TrueClass
      column :labels, TrueClass
      column :lfs, TrueClass
      column :lfs_endpoint, String, text: true
      column :milestones, TrueClass
      column :mirror, TrueClass
      column :mirror_interval, String, text: true
      column :private, TrueClass
      column :pull_requests, TrueClass
      column :releases, TrueClass
      column :repo_name, String, text: true
      column :repo_owner, String, text: true
      column :service, String, text: true
      column :uid, Integer
      column :wiki, TrueClass
    end
    create_table?(:milestone) do
      primary_key :id
      column :closed_at, String, text: true
      column :closed_issues, Integer
      column :created_at, String, text: true
      column :description, String, text: true
      column :due_on, String, text: true
      column :open_issues, Integer
      column :state, String, text: true
      column :title, String, text: true
      column :updated_at, String, text: true
    end
    create_table?(:new_issue_pins_allowed) do
      column :issues, TrueClass
      column :pull_requests, TrueClass
    end
    create_table?(:node_info) do
      column :metadata, String, text: true
      column :openRegistrations, TrueClass
      column :protocols, String, text: true
      column :services, String, text: true
      column :software, String, text: true
      column :usage, String, text: true
      column :version, String, text: true
    end
    create_table?(:node_info_services) do
      column :inbound, String, text: true
      column :outbound, String, text: true
    end
    create_table?(:node_info_software) do
      column :homepage, String, text: true
      column :name, String, text: true
      column :repository, String, text: true
      column :version, String, text: true
    end
    create_table?(:node_info_usage) do
      column :localComments, Integer
      column :localPosts, Integer
      column :users, String, text: true
    end
    create_table?(:node_info_usage_users) do
      column :activeHalfyear, Integer
      column :activeMonth, Integer
      column :total, Integer
    end
    create_table?(:note) do
      column :commit, String, text: true
      column :message, String, text: true
    end
    create_table?(:note_options) do
      column :message, String, text: true
    end
    create_table?(:notification_count) do
      column :new, Integer
    end
    create_table?(:notification_subject) do
      column :html_url, String, text: true
      column :latest_comment_html_url, String, text: true
      column :latest_comment_url, String, text: true
      column :state, String, text: true
      column :title, String, text: true
      column :type, String, text: true
      column :url, String, text: true
    end
    create_table?(:notification_thread) do
      primary_key :id
      column :pinned, TrueClass
      column :repository, String, text: true
      column :subject, String, text: true
      column :unread, TrueClass
      column :updated_at, String, text: true
      column :url, String, text: true
    end
    create_table?(:o_auth2_application) do
      primary_key :id
      column :client_id, String, text: true
      column :client_secret, String, text: true
      column :confidential_client, TrueClass
      column :created, String, text: true
      column :name, String, text: true
      column :redirect_uris, String, text: true
    end
    create_table?(:organization) do
      primary_key :id
      column :avatar_url, String, text: true
      column :created, String, text: true
      column :description, String, text: true
      column :email, String, text: true
      column :full_name, String, text: true
      column :location, String, text: true
      column :name, String, text: true
      column :repo_admin_change_team_access, TrueClass
      column :username, String, text: true
      column :visibility, String, text: true
      column :website, String, text: true
    end
    create_table?(:organization_permissions) do
      column :can_create_repository, TrueClass
      column :can_read, TrueClass
      column :can_write, TrueClass
      column :is_admin, TrueClass
      column :is_owner, TrueClass
    end
    create_table?(:pr_branch_info) do
      column :label, String, text: true
      column :ref, String, text: true
      column :repo, String, text: true
      column :repo_id, Integer
      column :sha, String, text: true
    end
    create_table?(:package) do
      primary_key :id
      column :created_at, String, text: true
      column :creator, String, text: true
      column :html_url, String, text: true
      column :name, String, text: true
      column :owner, String, text: true
      column :repository, String, text: true
      column :type, String, text: true
      column :version, String, text: true
    end
    create_table?(:package_file) do
      primary_key :id
      column :Size, Integer
      column :md5, String, text: true
      column :name, String, text: true
      column :sha1, String, text: true
      column :sha256, String, text: true
      column :sha512, String, text: true
    end
    create_table?(:payload_commit) do
      column :added, String, text: true
      column :author, String, text: true
      column :committer, String, text: true
      column :id, String, text: true
      column :message, String, text: true
      column :modified, String, text: true
      column :removed, String, text: true
      column :timestamp, String, text: true
      column :url, String, text: true
      column :verification, String, text: true
    end
    create_table?(:payload_commit_verification) do
      column :payload, String, text: true
      column :reason, String, text: true
      column :signature, String, text: true
      column :signer, String, text: true
      column :verified, TrueClass
    end
    create_table?(:payload_user) do
      column :email, String, text: true
      column :name, String, text: true
      column :username, String, text: true
    end
    create_table?(:public_key) do
      primary_key :id
      column :created_at, String, text: true
      column :fingerprint, String, text: true
      column :key, String, text: true
      column :key_type, String, text: true
      column :read_only, TrueClass
      column :title, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
      column :user, String, text: true
      column :verified, TrueClass
    end
    create_table?(:pull_request) do
      primary_key :id
      column :additions, Integer
      column :allow_maintainer_edit, TrueClass
      column :assignee, String, text: true
      column :assignees, String, text: true
      column :base, String, text: true
      column :body, String, text: true
      column :changed_files, Integer
      column :closed_at, String, text: true
      column :comments, Integer
      column :created_at, String, text: true
      column :deletions, Integer
      column :diff_url, String, text: true
      column :draft, TrueClass
      column :due_date, String, text: true
      column :flow, Integer
      column :head, String, text: true
      column :html_url, String, text: true
      column :is_locked, TrueClass
      column :labels, String, text: true
      column :merge_base, String, text: true
      column :merge_commit_sha, String, text: true
      column :mergeable, TrueClass
      column :merged, TrueClass
      column :merged_at, String, text: true
      column :merged_by, String, text: true
      column :milestone, String, text: true
      column :number, Integer
      column :patch_url, String, text: true
      column :pin_order, Integer
      column :requested_reviewers, String, text: true
      column :requested_reviewers_teams, String, text: true
      column :review_comments, Integer
      column :state, String, text: true
      column :title, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
      column :user, String, text: true
    end
    create_table?(:pull_request_meta) do
      column :draft, TrueClass
      column :html_url, String, text: true
      column :merged, TrueClass
      column :merged_at, String, text: true
    end
    create_table?(:pull_review) do
      primary_key :id
      column :body, String, text: true
      column :comments_count, Integer
      column :commit_id, String, text: true
      column :dismissed, TrueClass
      column :html_url, String, text: true
      column :official, TrueClass
      column :pull_request_url, String, text: true
      column :stale, TrueClass
      column :state, String, text: true
      column :submitted_at, String, text: true
      column :team, String, text: true
      column :updated_at, String, text: true
      column :user, String, text: true
    end
    create_table?(:pull_review_comment) do
      primary_key :id
      column :body, String, text: true
      column :commit_id, String, text: true
      column :created_at, String, text: true
      column :diff_hunk, String, text: true
      column :extra_lines_count, Integer
      column :html_url, String, text: true
      column :original_commit_id, String, text: true
      column :original_position, Integer
      column :path, String, text: true
      column :position, Integer
      column :pull_request_review_id, Integer
      column :pull_request_url, String, text: true
      column :resolver, String, text: true
      column :updated_at, String, text: true
      column :user, String, text: true
    end
    create_table?(:pull_review_request_options) do
      column :reviewers, String, text: true
      column :team_reviewers, String, text: true
    end
    create_table?(:push_mirror) do
      column :branch_filter, String, text: true
      column :created, String, text: true
      column :interval, String, text: true
      column :last_error, String, text: true
      column :last_update, String, text: true
      column :public_key, String, text: true
      column :remote_address, String, text: true
      column :remote_name, String, text: true
      column :repo_name, String, text: true
      column :sync_on_commit, TrueClass
    end
    create_table?(:quota_group) do
      column :name, String, text: true
      column :rules, String, text: true
    end
    create_table?(:quota_info) do
      column :groups, String, text: true
      column :used, String, text: true
    end
    create_table?(:quota_rule_info) do
      column :limit, Integer
      column :name, String, text: true
      column :subjects, String, text: true
    end
    create_table?(:quota_used) do
      column :size, String, text: true
    end
    create_table?(:quota_used_artifact) do
      column :html_url, String, text: true
      column :name, String, text: true
      column :size, Integer
    end
    create_table?(:quota_used_attachment) do
      column :api_url, String, text: true
      column :contained_in, String, text: true
      column :name, String, text: true
      column :size, Integer
    end
    create_table?(:quota_used_attachment_contained_in) do
      column :api_url, String, text: true
      column :html_url, String, text: true
    end
    create_table?(:quota_used_package) do
      column :html_url, String, text: true
      column :name, String, text: true
      column :size, Integer
      column :type, String, text: true
      column :version, String, text: true
    end
    create_table?(:quota_used_size) do
      column :assets, String, text: true
      column :git, String, text: true
      column :repos, String, text: true
    end
    create_table?(:quota_used_size_assets) do
      column :artifacts, Integer
      column :attachments, String, text: true
      column :packages, String, text: true
    end
    create_table?(:quota_used_size_assets_attachments) do
      column :issues, Integer
      column :releases, Integer
    end
    create_table?(:quota_used_size_assets_packages) do
      column :all, Integer
    end
    create_table?(:quota_used_size_git) do
      column :LFS, Integer
    end
    create_table?(:quota_used_size_repos) do
      column :private, Integer
      column :public, Integer
    end
    create_table?(:reaction) do
      column :content, String, text: true
      column :created_at, String, text: true
      column :user, String, text: true
    end
    create_table?(:reference) do
      column :object, String, text: true
      column :ref, String, text: true
      column :url, String, text: true
    end
    create_table?(:register_runner_options) do
      column :description, String, text: true
      column :ephemeral, TrueClass
      column :name, String, text: true
    end
    create_table?(:register_runner_response) do
      primary_key :id
      column :token, String, text: true
      column :uuid, String, text: true
    end
    create_table?(:registration_token) do
      column :token, String, text: true
    end
    create_table?(:rename_org_option) do
      column :new_name, String, text: true
    end
    create_table?(:rename_user_option) do
      column :new_username, String, text: true
    end
    create_table?(:replace_flags_option) do
      column :flags, String, text: true
    end
    create_table?(:repo_collaborator_permission) do
      column :permission, String, text: true
      column :role_name, String, text: true
      column :user, String, text: true
    end
    create_table?(:repo_commit) do
      column :author, String, text: true
      column :committer, String, text: true
      column :message, String, text: true
      column :tree, String, text: true
      column :url, String, text: true
      column :verification, String, text: true
    end
    create_table?(:repo_target_option) do
      column :name, String, text: true
      column :owner, String, text: true
    end
    create_table?(:repo_topic_options) do
      column :topics, String, text: true
    end
    create_table?(:repo_transfer) do
      column :doer, String, text: true
      column :recipient, String, text: true
      column :teams, String, text: true
    end
    create_table?(:repository) do
      primary_key :id
      column :allow_fast_forward_only_merge, TrueClass
      column :allow_merge_commits, TrueClass
      column :allow_rebase, TrueClass
      column :allow_rebase_explicit, TrueClass
      column :allow_rebase_update, TrueClass
      column :allow_squash_merge, TrueClass
      column :archived, TrueClass
      column :archived_at, String, text: true
      column :avatar_url, String, text: true
      column :clone_url, String, text: true
      column :created_at, String, text: true
      column :default_allow_maintainer_edit, TrueClass
      column :default_branch, String, text: true
      column :default_delete_branch_after_merge, TrueClass
      column :default_merge_style, String, text: true
      column :default_update_style, String, text: true
      column :description, String, text: true
      column :empty, TrueClass
      column :external_tracker, String, text: true
      column :external_wiki, String, text: true
      column :fork, TrueClass
      column :forks_count, Integer
      column :full_name, String, text: true
      column :globally_editable_wiki, TrueClass
      column :has_actions, TrueClass
      column :has_issues, TrueClass
      column :has_packages, TrueClass
      column :has_projects, TrueClass
      column :has_pull_requests, TrueClass
      column :has_releases, TrueClass
      column :has_wiki, TrueClass
      column :has_wiki_contents, TrueClass
      column :html_url, String, text: true
      column :ignore_whitespace_conflicts, TrueClass
      column :internal, TrueClass
      column :internal_tracker, String, text: true
      column :language, String, text: true
      column :languages_url, String, text: true
      column :link, String, text: true
      column :mirror, TrueClass
      column :mirror_interval, String, text: true
      column :mirror_updated, String, text: true
      column :name, String, text: true
      column :object_format_name, String, text: true
      column :open_issues_count, Integer
      column :open_pr_counter, Integer
      column :original_url, String, text: true
      column :owner, String, text: true
      column :parent, String, text: true
      column :permissions, String, text: true
      column :private, TrueClass
      column :release_counter, Integer
      column :repo_transfer, String, text: true
      column :size, Integer
      column :ssh_url, String, text: true
      column :stars_count, Integer
      column :template, TrueClass
      column :topics, String, text: true
      column :updated_at, String, text: true
      column :url, String, text: true
      column :watchers_count, Integer
      column :website, String, text: true
      column :wiki_branch, String, text: true
      column :wiki_clone_url, String, text: true
      column :wiki_ssh_url, String, text: true
    end
    create_table?(:repository_meta) do
      primary_key :id
      column :full_name, String, text: true
      column :name, String, text: true
      column :owner, String, text: true
    end
    create_table?(:search_results) do
      column :data, String, text: true
      column :ok, TrueClass
    end
    create_table?(:secret) do
      column :created_at, String, text: true
      column :name, String, text: true
    end
    create_table?(:server_version) do
      column :version, String, text: true
    end
    create_table?(:set_user_quota_groups_options) do
      column :groups, String, text: true
    end
    create_table?(:stop_watch) do
      column :created, String, text: true
      column :duration, String, text: true
      column :issue_index, Integer
      column :issue_title, String, text: true
      column :repo_name, String, text: true
      column :repo_owner_name, String, text: true
      column :seconds, Integer
    end
    create_table?(:submit_pull_review_options) do
      column :body, String, text: true
      column :event, String, text: true
    end
    create_table?(:sync_fork_info) do
      column :allowed, TrueClass
      column :base_commit, String, text: true
      column :commits_behind, Integer
      column :fork_commit, String, text: true
    end
    create_table?(:tag) do
      column :archive_download_count, String, text: true
      column :commit, String, text: true
      column :id, String, text: true
      column :message, String, text: true
      column :name, String, text: true
      column :tarball_url, String, text: true
      column :zipball_url, String, text: true
    end
    create_table?(:tag_archive_download_count) do
      column :tar_gz, Integer
      column :zip, Integer
    end
    create_table?(:tag_protection) do
      primary_key :id
      column :created_at, String, text: true
      column :name_pattern, String, text: true
      column :updated_at, String, text: true
      column :whitelist_teams, String, text: true
      column :whitelist_usernames, String, text: true
    end
    create_table?(:team) do
      primary_key :id
      column :can_create_org_repo, TrueClass
      column :description, String, text: true
      column :includes_all_repositories, TrueClass
      column :name, String, text: true
      column :organization, String, text: true
      column :permission, String, text: true
      column :units, String, text: true
      column :units_map, String, text: true
    end
    create_table?(:team_search_results) do
      column :data, String, text: true
      column :ok, TrueClass
    end
    create_table?(:timeline_comment) do
      primary_key :id
      column :assignee, String, text: true
      column :assignee_team, String, text: true
      column :body, String, text: true
      column :created_at, String, text: true
      column :dependent_issue, String, text: true
      column :html_url, String, text: true
      column :issue_url, String, text: true
      column :label, String, text: true
      column :milestone, String, text: true
      column :new_ref, String, text: true
      column :new_title, String, text: true
      column :old_milestone, String, text: true
      column :old_project_id, Integer
      column :old_ref, String, text: true
      column :old_title, String, text: true
      column :project_id, Integer
      column :pull_request_url, String, text: true
      column :ref_action, String, text: true
      column :ref_comment, String, text: true
      column :ref_commit_sha, String, text: true
      column :ref_issue, String, text: true
      column :removed_assignee, TrueClass
      column :resolve_doer, String, text: true
      column :review_id, Integer
      column :tracked_time, String, text: true
      column :type, String, text: true
      column :updated_at, String, text: true
      column :user, String, text: true
    end
    create_table?(:topic_name) do
      column :topics, String, text: true
    end
    create_table?(:topic_response) do
      primary_key :id
      column :created, String, text: true
      column :repo_count, Integer
      column :topic_name, String, text: true
      column :updated, String, text: true
    end
    create_table?(:topic_search_results) do
      column :topics, String, text: true
    end
    create_table?(:tracked_time) do
      primary_key :id
      column :created, String, text: true
      column :issue, String, text: true
      column :issue_id, Integer
      column :time, Integer
      column :user_id, Integer
      column :user_name, String, text: true
    end
    create_table?(:transfer_repo_option) do
      column :new_owner, String, text: true
      column :team_ids, String, text: true
    end
    create_table?(:update_branch_repo_option) do
      column :name, String, text: true
    end
    create_table?(:update_file_options) do
      column :author, String, text: true
      column :branch, String, text: true
      column :committer, String, text: true
      column :content, String, text: true
      column :dates, String, text: true
      column :force_overwrite_new_branch, TrueClass
      column :from_path, String, text: true
      column :message, String, text: true
      column :new_branch, String, text: true
      column :sha, String, text: true
      column :signoff, TrueClass
    end
    create_table?(:update_repo_avatar_option) do
      column :image, String, text: true
    end
    create_table?(:update_user_avatar_option) do
      column :image, String, text: true
    end
    create_table?(:update_variable_option) do
      column :name, String, text: true
      column :value, String, text: true
    end
    create_table?(:user_heatmap_data) do
      column :contributions, Integer
      column :timestamp, Integer
    end
    create_table?(:user_search_results) do
      column :data, String, text: true
      column :ok, TrueClass
    end
    create_table?(:user_settings) do
      column :description, String, text: true
      column :diff_view_style, String, text: true
      column :enable_repo_unit_hints, TrueClass
      column :full_name, String, text: true
      column :hide_activity, TrueClass
      column :hide_email, TrueClass
      column :hide_pronouns, TrueClass
      column :language, String, text: true
      column :location, String, text: true
      column :pronouns, String, text: true
      column :theme, String, text: true
      column :website, String, text: true
    end
    create_table?(:user_settings_options) do
      column :description, String, text: true
      column :diff_view_style, String, text: true
      column :enable_repo_unit_hints, TrueClass
      column :full_name, String, text: true
      column :hide_activity, TrueClass
      column :hide_email, TrueClass
      column :hide_pronouns, TrueClass
      column :language, String, text: true
      column :location, String, text: true
      column :pronouns, String, text: true
      column :theme, String, text: true
      column :website, String, text: true
    end
    create_table?(:verify_gpg_key_option) do
      column :armored_signature, String, text: true
      column :key_id, String, text: true
    end
    create_table?(:watch_info) do
      column :created_at, String, text: true
      column :ignored, TrueClass
      column :reason, String, text: true
      column :repository_url, String, text: true
      column :subscribed, TrueClass
      column :url, String, text: true
    end
    create_table?(:wiki_commit) do
      column :author, String, text: true
      column :commiter, String, text: true
      column :message, String, text: true
      column :sha, String, text: true
    end
    create_table?(:wiki_commit_list) do
      column :commits, String, text: true
      column :count, Integer
    end
    create_table?(:wiki_page) do
      column :commit_count, Integer
      column :content_base64, String, text: true
      column :footer, String, text: true
      column :html_url, String, text: true
      column :last_commit, String, text: true
      column :sidebar, String, text: true
      column :sub_url, String, text: true
      column :title, String, text: true
    end
    create_table?(:wiki_page_meta_data) do
      column :html_url, String, text: true
      column :last_commit, String, text: true
      column :sub_url, String, text: true
      column :title, String, text: true
    end
    create_table?(:repo_create_release_attachment_request) do
      column :attachment, String, text: true
      column :external_url, String, text: true
    end
  end
end
