# frozen_string_literal: true

# The keys the routes look records up by, which the document has no way to
# declare -- and a primary key for a table the document gave none.
Sequel.migration do
  up do
    columns = schema(:action_artifact).map(&:first)
    alter_table(:action_artifact) do
      add_column :artifact_id, String, text: true unless columns.include?(:artifact_id)
    end
    columns = schema(:action_run).map(&:first)
    alter_table(:action_run) do
      add_column :run_id, String, text: true unless columns.include?(:run_id)
    end
    columns = schema(:action_run_job).map(&:first)
    alter_table(:action_run_job) do
      add_column :job_id, String, text: true unless columns.include?(:job_id)
    end
    columns = schema(:action_runner).map(&:first)
    alter_table(:action_runner) do
      add_column :runner_id, String, text: true unless columns.include?(:runner_id)
    end
    columns = schema(:action_task_response).map(&:first)
    alter_table(:action_task_response) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:action_variable).map(&:first)
    alter_table(:action_variable) do
      add_primary_key :id unless columns.include?(:id)
      add_column :variablename, String, text: true unless columns.include?(:variablename)
    end
    columns = schema(:activity_pub).map(&:first)
    alter_table(:activity_pub) do
      add_primary_key :id unless columns.include?(:id)
      add_column :"repository-id", String, text: true unless columns.include?(:"repository-id")
      add_column :"user-id", String, text: true unless columns.include?(:"user-id")
      add_column :"activity-id", String, text: true unless columns.include?(:"activity-id")
    end
    columns = schema(:annotated_tag).map(&:first)
    alter_table(:annotated_tag) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:attachment).map(&:first)
    alter_table(:attachment) do
      add_column :attachment_id, String, text: true unless columns.include?(:attachment_id)
    end
    columns = schema(:blocked_user).map(&:first)
    alter_table(:blocked_user) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:branch).map(&:first)
    alter_table(:branch) do
      add_primary_key :id unless columns.include?(:id)
      add_column :branch, String, text: true unless columns.include?(:branch)
    end
    columns = schema(:branch_protection).map(&:first)
    alter_table(:branch_protection) do
      add_primary_key :id unless columns.include?(:id)
      add_column :name, String, text: true unless columns.include?(:name)
    end
    columns = schema(:changed_file).map(&:first)
    alter_table(:changed_file) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:combined_status).map(&:first)
    alter_table(:combined_status) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:commit_status).map(&:first)
    alter_table(:commit_status) do
      add_column :sha, String, text: true unless columns.include?(:sha)
    end
    columns = schema(:compare).map(&:first)
    alter_table(:compare) do
      add_primary_key :id unless columns.include?(:id)
      add_column :basehead, String, text: true unless columns.include?(:basehead)
    end
    columns = schema(:contents_response).map(&:first)
    alter_table(:contents_response) do
      add_primary_key :id unless columns.include?(:id)
      add_column :filepath, String, text: true unless columns.include?(:filepath)
    end
    columns = schema(:cron).map(&:first)
    alter_table(:cron) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:email).map(&:first)
    alter_table(:email) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:file_delete_response).map(&:first)
    alter_table(:file_delete_response) do
      add_primary_key :id unless columns.include?(:id)
      add_column :filepath, String, text: true unless columns.include?(:filepath)
    end
    columns = schema(:file_response).map(&:first)
    alter_table(:file_response) do
      add_primary_key :id unless columns.include?(:id)
      add_column :filepath, String, text: true unless columns.include?(:filepath)
    end
    columns = schema(:files_response).map(&:first)
    alter_table(:files_response) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:general_api_settings).map(&:first)
    alter_table(:general_api_settings) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:general_attachment_settings).map(&:first)
    alter_table(:general_attachment_settings) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:general_repo_settings).map(&:first)
    alter_table(:general_repo_settings) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:general_ui_settings).map(&:first)
    alter_table(:general_ui_settings) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:git_blob).map(&:first)
    alter_table(:git_blob) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:git_hook).map(&:first)
    alter_table(:git_hook) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:git_tree_response).map(&:first)
    alter_table(:git_tree_response) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:gitignore_template_info).map(&:first)
    alter_table(:gitignore_template_info) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:issue).map(&:first)
    alter_table(:issue) do
      add_column :index, String, text: true unless columns.include?(:index)
    end
    columns = schema(:issue_config).map(&:first)
    alter_table(:issue_config) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:issue_config_validation).map(&:first)
    alter_table(:issue_config_validation) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:issue_deadline).map(&:first)
    alter_table(:issue_deadline) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:issue_template).map(&:first)
    alter_table(:issue_template) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:label_template).map(&:first)
    alter_table(:label_template) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:license_template_info).map(&:first)
    alter_table(:license_template_info) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:licenses_template_list_entry).map(&:first)
    alter_table(:licenses_template_list_entry) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:list_action_run_response).map(&:first)
    alter_table(:list_action_run_response) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:new_issue_pins_allowed).map(&:first)
    alter_table(:new_issue_pins_allowed) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:node_info).map(&:first)
    alter_table(:node_info) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:note).map(&:first)
    alter_table(:note) do
      add_primary_key :id unless columns.include?(:id)
      add_column :sha, String, text: true unless columns.include?(:sha)
    end
    columns = schema(:notification_count).map(&:first)
    alter_table(:notification_count) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:organization).map(&:first)
    alter_table(:organization) do
      add_column :org, String, text: true unless columns.include?(:org)
    end
    columns = schema(:organization_permissions).map(&:first)
    alter_table(:organization_permissions) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:pull_request).map(&:first)
    alter_table(:pull_request) do
      add_column :index, String, text: true unless columns.include?(:index)
    end
    columns = schema(:pull_review_comment).map(&:first)
    alter_table(:pull_review_comment) do
      add_column :comment, String, text: true unless columns.include?(:comment)
    end
    columns = schema(:push_mirror).map(&:first)
    alter_table(:push_mirror) do
      add_primary_key :id unless columns.include?(:id)
      add_column :name, String, text: true unless columns.include?(:name)
    end
    columns = schema(:quota_group).map(&:first)
    alter_table(:quota_group) do
      add_primary_key :id unless columns.include?(:id)
      add_column :quotagroup, String, text: true unless columns.include?(:quotagroup)
    end
    columns = schema(:quota_info).map(&:first)
    alter_table(:quota_info) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:quota_rule_info).map(&:first)
    alter_table(:quota_rule_info) do
      add_primary_key :id unless columns.include?(:id)
      add_column :quotarule, String, text: true unless columns.include?(:quotarule)
    end
    columns = schema(:reaction).map(&:first)
    alter_table(:reaction) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:reference).map(&:first)
    alter_table(:reference) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:registration_token).map(&:first)
    alter_table(:registration_token) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:repo_collaborator_permission).map(&:first)
    alter_table(:repo_collaborator_permission) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:repository).map(&:first)
    alter_table(:repository) do
      add_column :repo, String, text: true unless columns.include?(:repo)
    end
    columns = schema(:search_results).map(&:first)
    alter_table(:search_results) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:secret).map(&:first)
    alter_table(:secret) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:server_version).map(&:first)
    alter_table(:server_version) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:stop_watch).map(&:first)
    alter_table(:stop_watch) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:sync_fork_info).map(&:first)
    alter_table(:sync_fork_info) do
      add_primary_key :id unless columns.include?(:id)
      add_column :branch, String, text: true unless columns.include?(:branch)
    end
    columns = schema(:tag).map(&:first)
    alter_table(:tag) do
      add_column :tag, String, text: true unless columns.include?(:tag)
    end
    columns = schema(:team).map(&:first)
    alter_table(:team) do
      add_column :team, String, text: true unless columns.include?(:team)
    end
    columns = schema(:topic_name).map(&:first)
    alter_table(:topic_name) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:user_heatmap_data).map(&:first)
    alter_table(:user_heatmap_data) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:user_settings).map(&:first)
    alter_table(:user_settings) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:watch_info).map(&:first)
    alter_table(:watch_info) do
      add_primary_key :id unless columns.include?(:id)
    end
    columns = schema(:wiki_commit_list).map(&:first)
    alter_table(:wiki_commit_list) do
      add_primary_key :id unless columns.include?(:id)
      add_column :pageName, String, text: true unless columns.include?(:pageName)
    end
    columns = schema(:wiki_page).map(&:first)
    alter_table(:wiki_page) do
      add_primary_key :id unless columns.include?(:id)
      add_column :pageName, String, text: true unless columns.include?(:pageName)
    end
    columns = schema(:wiki_page_meta_data).map(&:first)
    alter_table(:wiki_page_meta_data) do
      add_primary_key :id unless columns.include?(:id)
    end
  end
end
