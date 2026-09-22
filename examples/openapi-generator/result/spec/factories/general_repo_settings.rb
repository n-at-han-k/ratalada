# frozen_string_literal: true

# GeneralRepoSettings -- generated from models.json.
Factory.define(:general_repo_setting, relation: :general_repo_settings) do |f|
  f.forks_disabled { false }
  f.http_git_disabled { false }
  f.lfs_disabled { false }
  f.migrations_disabled { false }
  f.mirrors_disabled { false }
  f.stars_disabled { false }
  f.time_tracking_disabled { false }
end
