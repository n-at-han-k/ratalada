--
-- Schema objects for PostgreSQL
-- "Forgejo API"
-- Created using 'openapi-generator' ('postgresql-schema' generator)
-- (https://openapi-generator.tech/docs/generators/postgresql-schema)
--

--
-- DROP OBJECTS
-- (remove comment prefix to start using DROP commands)
--
-- TABLES
--
-- DROP TABLE IF EXISTS APIError;
-- DROP TABLE IF EXISTS APIForbiddenError;
-- DROP TABLE IF EXISTS APIInternalServerError;
-- DROP TABLE IF EXISTS APIInvalidTopicsError;
-- DROP TABLE IF EXISTS APINotFound;
-- DROP TABLE IF EXISTS APIRepoArchivedError;
-- DROP TABLE IF EXISTS APIUnauthorizedError;
-- DROP TABLE IF EXISTS APIValidationError;
-- DROP TABLE IF EXISTS APRemoteFollowOption;
-- DROP TABLE IF EXISTS AccessToken;
-- DROP TABLE IF EXISTS ActionArtifact;
-- DROP TABLE IF EXISTS ActionRun;
-- DROP TABLE IF EXISTS ActionRunJob;
-- DROP TABLE IF EXISTS ActionRunJobStep;
-- DROP TABLE IF EXISTS ActionRunner;
-- DROP TABLE IF EXISTS ActionTask;
-- DROP TABLE IF EXISTS ActionTaskResponse;
-- DROP TABLE IF EXISTS ActionVariable;
-- DROP TABLE IF EXISTS Activity;
-- DROP TABLE IF EXISTS ActivityPub;
-- DROP TABLE IF EXISTS AddCollaboratorOption;
-- DROP TABLE IF EXISTS AddTimeOption;
-- DROP TABLE IF EXISTS AnnotatedTag;
-- DROP TABLE IF EXISTS AnnotatedTagObject;
-- DROP TABLE IF EXISTS Attachment;
-- DROP TABLE IF EXISTS BlockedUser;
-- DROP TABLE IF EXISTS Branch;
-- DROP TABLE IF EXISTS BranchProtection;
-- DROP TABLE IF EXISTS ChangeFileOperation;
-- DROP TABLE IF EXISTS ChangeFilesOptions;
-- DROP TABLE IF EXISTS ChangedFile;
-- DROP TABLE IF EXISTS CombinedStatus;
-- DROP TABLE IF EXISTS "Comment";
-- DROP TABLE IF EXISTS "Commit";
-- DROP TABLE IF EXISTS CommitAffectedFiles;
-- DROP TABLE IF EXISTS CommitDateOptions;
-- DROP TABLE IF EXISTS CommitMeta;
-- DROP TABLE IF EXISTS CommitStats;
-- DROP TABLE IF EXISTS CommitStatus;
-- DROP TABLE IF EXISTS CommitUser;
-- DROP TABLE IF EXISTS Compare;
-- DROP TABLE IF EXISTS ContentsResponse;
-- DROP TABLE IF EXISTS CreateAccessTokenOption;
-- DROP TABLE IF EXISTS CreateBranchProtectionOption;
-- DROP TABLE IF EXISTS CreateBranchRepoOption;
-- DROP TABLE IF EXISTS CreateEmailOption;
-- DROP TABLE IF EXISTS CreateFileOptions;
-- DROP TABLE IF EXISTS CreateForkOption;
-- DROP TABLE IF EXISTS CreateGPGKeyOption;
-- DROP TABLE IF EXISTS CreateHookOption;
-- DROP TABLE IF EXISTS CreateIssueCommentOption;
-- DROP TABLE IF EXISTS CreateIssueOption;
-- DROP TABLE IF EXISTS CreateKeyOption;
-- DROP TABLE IF EXISTS CreateLabelOption;
-- DROP TABLE IF EXISTS CreateMilestoneOption;
-- DROP TABLE IF EXISTS CreateOAuth2ApplicationOptions;
-- DROP TABLE IF EXISTS CreateOrUpdateSecretOption;
-- DROP TABLE IF EXISTS CreateOrgOption;
-- DROP TABLE IF EXISTS CreatePullRequestOption;
-- DROP TABLE IF EXISTS CreatePullReviewComment;
-- DROP TABLE IF EXISTS CreatePullReviewOptions;
-- DROP TABLE IF EXISTS CreatePushMirrorOption;
-- DROP TABLE IF EXISTS CreateQuotaGroupOptions;
-- DROP TABLE IF EXISTS CreateQuotaRuleOptions;
-- DROP TABLE IF EXISTS CreateReleaseOption;
-- DROP TABLE IF EXISTS CreateRepoOption;
-- DROP TABLE IF EXISTS CreateStatusOption;
-- DROP TABLE IF EXISTS CreateTagOption;
-- DROP TABLE IF EXISTS CreateTagProtectionOption;
-- DROP TABLE IF EXISTS CreateTeamOption;
-- DROP TABLE IF EXISTS CreateUserOption;
-- DROP TABLE IF EXISTS CreateVariableOption;
-- DROP TABLE IF EXISTS CreateWikiPageOptions;
-- DROP TABLE IF EXISTS Cron;
-- DROP TABLE IF EXISTS DeleteEmailOption;
-- DROP TABLE IF EXISTS DeleteFileOptions;
-- DROP TABLE IF EXISTS DeleteLabelsOption;
-- DROP TABLE IF EXISTS DeployKey;
-- DROP TABLE IF EXISTS DismissPullReviewOptions;
-- DROP TABLE IF EXISTS DispatchWorkflowOption;
-- DROP TABLE IF EXISTS DispatchWorkflowRun;
-- DROP TABLE IF EXISTS EditAttachmentOptions;
-- DROP TABLE IF EXISTS EditBranchProtectionOption;
-- DROP TABLE IF EXISTS EditDeadlineOption;
-- DROP TABLE IF EXISTS EditGitHookOption;
-- DROP TABLE IF EXISTS EditHookOption;
-- DROP TABLE IF EXISTS EditIssueCommentOption;
-- DROP TABLE IF EXISTS EditIssueOption;
-- DROP TABLE IF EXISTS EditLabelOption;
-- DROP TABLE IF EXISTS EditMilestoneOption;
-- DROP TABLE IF EXISTS EditOrgOption;
-- DROP TABLE IF EXISTS EditPullRequestOption;
-- DROP TABLE IF EXISTS EditQuotaRuleOptions;
-- DROP TABLE IF EXISTS EditReactionOption;
-- DROP TABLE IF EXISTS EditReleaseOption;
-- DROP TABLE IF EXISTS EditRepoOption;
-- DROP TABLE IF EXISTS EditTagProtectionOption;
-- DROP TABLE IF EXISTS EditTeamOption;
-- DROP TABLE IF EXISTS EditUserOption;
-- DROP TABLE IF EXISTS Email;
-- DROP TABLE IF EXISTS ExternalTracker;
-- DROP TABLE IF EXISTS ExternalWiki;
-- DROP TABLE IF EXISTS FileCommitResponse;
-- DROP TABLE IF EXISTS FileDeleteResponse;
-- DROP TABLE IF EXISTS FileLinksResponse;
-- DROP TABLE IF EXISTS FileResponse;
-- DROP TABLE IF EXISTS FilesResponse;
-- DROP TABLE IF EXISTS GPGKey;
-- DROP TABLE IF EXISTS GPGKeyEmail;
-- DROP TABLE IF EXISTS GeneralAPISettings;
-- DROP TABLE IF EXISTS GeneralAttachmentSettings;
-- DROP TABLE IF EXISTS GeneralRepoSettings;
-- DROP TABLE IF EXISTS GeneralUISettings;
-- DROP TABLE IF EXISTS GenerateRepoOption;
-- DROP TABLE IF EXISTS GitBlob;
-- DROP TABLE IF EXISTS GitEntry;
-- DROP TABLE IF EXISTS GitHook;
-- DROP TABLE IF EXISTS GitObject;
-- DROP TABLE IF EXISTS GitTreeResponse;
-- DROP TABLE IF EXISTS GitignoreTemplateInfo;
-- DROP TABLE IF EXISTS Hook;
-- DROP TABLE IF EXISTS "Identity";
-- DROP TABLE IF EXISTS InternalTracker;
-- DROP TABLE IF EXISTS Issue;
-- DROP TABLE IF EXISTS IssueConfig;
-- DROP TABLE IF EXISTS IssueConfigContactLink;
-- DROP TABLE IF EXISTS IssueConfigValidation;
-- DROP TABLE IF EXISTS IssueDeadline;
-- DROP TABLE IF EXISTS IssueFormField;
-- DROP TABLE IF EXISTS IssueLabelsOption;
-- DROP TABLE IF EXISTS IssueLockOption;
-- DROP TABLE IF EXISTS IssueMeta;
-- DROP TABLE IF EXISTS IssueTemplate;
-- DROP TABLE IF EXISTS "Label";
-- DROP TABLE IF EXISTS LabelTemplate;
-- DROP TABLE IF EXISTS LicenseTemplateInfo;
-- DROP TABLE IF EXISTS LicensesTemplateListEntry;
-- DROP TABLE IF EXISTS ListActionRunResponse;
-- DROP TABLE IF EXISTS MarkdownOption;
-- DROP TABLE IF EXISTS MarkupOption;
-- DROP TABLE IF EXISTS MergePullRequestOption;
-- DROP TABLE IF EXISTS MigrateRepoOptions;
-- DROP TABLE IF EXISTS Milestone;
-- DROP TABLE IF EXISTS NewIssuePinsAllowed;
-- DROP TABLE IF EXISTS NodeInfo;
-- DROP TABLE IF EXISTS NodeInfoServices;
-- DROP TABLE IF EXISTS NodeInfoSoftware;
-- DROP TABLE IF EXISTS NodeInfoUsage;
-- DROP TABLE IF EXISTS NodeInfoUsageUsers;
-- DROP TABLE IF EXISTS Note;
-- DROP TABLE IF EXISTS NoteOptions;
-- DROP TABLE IF EXISTS NotificationCount;
-- DROP TABLE IF EXISTS NotificationSubject;
-- DROP TABLE IF EXISTS NotificationThread;
-- DROP TABLE IF EXISTS OAuth2Application;
-- DROP TABLE IF EXISTS Organization;
-- DROP TABLE IF EXISTS OrganizationPermissions;
-- DROP TABLE IF EXISTS PRBranchInfo;
-- DROP TABLE IF EXISTS Package;
-- DROP TABLE IF EXISTS PackageFile;
-- DROP TABLE IF EXISTS PayloadCommit;
-- DROP TABLE IF EXISTS PayloadCommitVerification;
-- DROP TABLE IF EXISTS PayloadUser;
-- DROP TABLE IF EXISTS "Permission";
-- DROP TABLE IF EXISTS PublicKey;
-- DROP TABLE IF EXISTS PullRequest;
-- DROP TABLE IF EXISTS PullRequestMeta;
-- DROP TABLE IF EXISTS PullReview;
-- DROP TABLE IF EXISTS PullReviewComment;
-- DROP TABLE IF EXISTS PullReviewRequestOptions;
-- DROP TABLE IF EXISTS PushMirror;
-- DROP TABLE IF EXISTS QuotaGroup;
-- DROP TABLE IF EXISTS QuotaInfo;
-- DROP TABLE IF EXISTS QuotaRuleInfo;
-- DROP TABLE IF EXISTS QuotaUsed;
-- DROP TABLE IF EXISTS QuotaUsedArtifact;
-- DROP TABLE IF EXISTS QuotaUsedAttachment;
-- DROP TABLE IF EXISTS QuotaUsedAttachment_contained_in;
-- DROP TABLE IF EXISTS QuotaUsedPackage;
-- DROP TABLE IF EXISTS QuotaUsedSize;
-- DROP TABLE IF EXISTS QuotaUsedSizeAssets;
-- DROP TABLE IF EXISTS QuotaUsedSizeAssetsAttachments;
-- DROP TABLE IF EXISTS QuotaUsedSizeAssetsPackages;
-- DROP TABLE IF EXISTS QuotaUsedSizeGit;
-- DROP TABLE IF EXISTS QuotaUsedSizeRepos;
-- DROP TABLE IF EXISTS Reaction;
-- DROP TABLE IF EXISTS Reference;
-- DROP TABLE IF EXISTS RegisterRunnerOptions;
-- DROP TABLE IF EXISTS RegisterRunnerResponse;
-- DROP TABLE IF EXISTS RegistrationToken;
-- DROP TABLE IF EXISTS "Release";
-- DROP TABLE IF EXISTS RenameOrgOption;
-- DROP TABLE IF EXISTS RenameUserOption;
-- DROP TABLE IF EXISTS ReplaceFlagsOption;
-- DROP TABLE IF EXISTS RepoCollaboratorPermission;
-- DROP TABLE IF EXISTS RepoCommit;
-- DROP TABLE IF EXISTS repoCreateReleaseAttachment_request;
-- DROP TABLE IF EXISTS RepoTargetOption;
-- DROP TABLE IF EXISTS RepoTopicOptions;
-- DROP TABLE IF EXISTS RepoTransfer;
-- DROP TABLE IF EXISTS Repository;
-- DROP TABLE IF EXISTS RepositoryMeta;
-- DROP TABLE IF EXISTS SearchResults;
-- DROP TABLE IF EXISTS Secret;
-- DROP TABLE IF EXISTS ServerVersion;
-- DROP TABLE IF EXISTS SetUserQuotaGroupsOptions;
-- DROP TABLE IF EXISTS StopWatch;
-- DROP TABLE IF EXISTS SubmitPullReviewOptions;
-- DROP TABLE IF EXISTS SyncForkInfo;
-- DROP TABLE IF EXISTS Tag;
-- DROP TABLE IF EXISTS TagArchiveDownloadCount;
-- DROP TABLE IF EXISTS TagProtection;
-- DROP TABLE IF EXISTS Team;
-- DROP TABLE IF EXISTS TeamSearchResults;
-- DROP TABLE IF EXISTS TimelineComment;
-- DROP TABLE IF EXISTS TopicName;
-- DROP TABLE IF EXISTS TopicResponse;
-- DROP TABLE IF EXISTS TopicSearchResults;
-- DROP TABLE IF EXISTS TrackedTime;
-- DROP TABLE IF EXISTS TransferRepoOption;
-- DROP TABLE IF EXISTS UpdateBranchRepoOption;
-- DROP TABLE IF EXISTS UpdateFileOptions;
-- DROP TABLE IF EXISTS UpdateRepoAvatarOption;
-- DROP TABLE IF EXISTS UpdateUserAvatarOption;
-- DROP TABLE IF EXISTS UpdateVariableOption;
-- DROP TABLE IF EXISTS "User";
-- DROP TABLE IF EXISTS UserHeatmapData;
-- DROP TABLE IF EXISTS UserSearchResults;
-- DROP TABLE IF EXISTS UserSettings;
-- DROP TABLE IF EXISTS UserSettingsOptions;
-- DROP TABLE IF EXISTS VerifyGPGKeyOption;
-- DROP TABLE IF EXISTS WatchInfo;
-- DROP TABLE IF EXISTS WikiCommit;
-- DROP TABLE IF EXISTS WikiCommitList;
-- DROP TABLE IF EXISTS WikiPage;
-- DROP TABLE IF EXISTS WikiPageMetaData;

--
-- TYPES
--
-- DROP TYPE IF EXISTS ActionRunner_status;
-- DROP TYPE IF EXISTS Activity_opUnderscoretype;
-- DROP TYPE IF EXISTS AddCollaboratorOption_permission;
-- DROP TYPE IF EXISTS Attachment_type;
-- DROP TYPE IF EXISTS ChangeFileOperation_operation;
-- DROP TYPE IF EXISTS CreateHookOption_type;
-- DROP TYPE IF EXISTS CreateMilestoneOption_state;
-- DROP TYPE IF EXISTS CreateOrgOption_visibility;
-- DROP TYPE IF EXISTS CreateRepoOption_objectUnderscoreformatUnderscorename;
-- DROP TYPE IF EXISTS CreateRepoOption_trustUnderscoremodel;
-- DROP TYPE IF EXISTS CreateTeamOption_permission;
-- DROP TYPE IF EXISTS EditOrgOption_visibility;
-- DROP TYPE IF EXISTS EditTeamOption_permission;
-- DROP TYPE IF EXISTS MergePullRequestOption_Do;
-- DROP TYPE IF EXISTS MigrateRepoOptions_service;
-- DROP TYPE IF EXISTS Repository_objectUnderscoreformatUnderscorename;
-- DROP TYPE IF EXISTS Team_permission;


--
-- CREATE OBJECTS
--
-- TYPES
--
CREATE TYPE ActionRunner_status AS ENUM('offline', 'idle', 'active');
CREATE TYPE Activity_opUnderscoretype AS ENUM('create_repo', 'rename_repo', 'star_repo', 'watch_repo', 'commit_repo', 'create_issue', 'create_pull_request', 'transfer_repo', 'push_tag', 'comment_issue', 'merge_pull_request', 'close_issue', 'reopen_issue', 'close_pull_request', 'reopen_pull_request', 'delete_tag', 'delete_branch', 'mirror_sync_push', 'mirror_sync_create', 'mirror_sync_delete', 'approve_pull_request', 'reject_pull_request', 'comment_pull', 'publish_release', 'pull_review_dismissed', 'pull_request_ready_for_review', 'auto_merge_pull_request');
CREATE TYPE AddCollaboratorOption_permission AS ENUM('read', 'write', 'admin');
CREATE TYPE Attachment_type AS ENUM('attachment', 'external');
CREATE TYPE ChangeFileOperation_operation AS ENUM('create', 'update', 'delete');
CREATE TYPE CreateHookOption_type AS ENUM('forgejo', 'dingtalk', 'discord', 'gitea', 'gogs', 'msteams', 'slack', 'telegram', 'feishu', 'wechatwork', 'packagist');
CREATE TYPE CreateMilestoneOption_state AS ENUM('open', 'closed');
CREATE TYPE CreateOrgOption_visibility AS ENUM('public', 'limited', 'private');
CREATE TYPE CreateRepoOption_objectUnderscoreformatUnderscorename AS ENUM('sha1', 'sha256');
CREATE TYPE CreateRepoOption_trustUnderscoremodel AS ENUM('default', 'collaborator', 'committer', 'collaboratorcommitter');
CREATE TYPE CreateTeamOption_permission AS ENUM('read', 'write', 'admin');
CREATE TYPE EditOrgOption_visibility AS ENUM('public', 'limited', 'private');
CREATE TYPE EditTeamOption_permission AS ENUM('read', 'write', 'admin');
CREATE TYPE MergePullRequestOption_Do AS ENUM('merge', 'rebase', 'rebase-merge', 'squash', 'fast-forward-only', 'manually-merged');
CREATE TYPE MigrateRepoOptions_service AS ENUM('git', 'github', 'gitea', 'gitlab', 'gogs', 'onedev', 'gitbucket', 'codebase', 'forgejo', 'pagure', 'bitbucketdc');
CREATE TYPE Repository_objectUnderscoreformatUnderscorename AS ENUM('sha1', 'sha256');
CREATE TYPE Team_permission AS ENUM('none', 'read', 'write', 'admin', 'owner');

--
-- TABLES
--
--
-- Table 'APIError' generated from model 'APIError'
-- APIError is an api error with a message
--
CREATE TABLE IF NOT EXISTS APIError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE APIError IS 'APIError is an api error with a message';

--
-- Table 'APIForbiddenError' generated from model 'APIForbiddenError'
--
CREATE TABLE IF NOT EXISTS APIForbiddenError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APIInternalServerError' generated from model 'APIInternalServerError'
--
CREATE TABLE IF NOT EXISTS APIInternalServerError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APIInvalidTopicsError' generated from model 'APIInvalidTopicsError'
--
CREATE TABLE IF NOT EXISTS APIInvalidTopicsError (
    invalidTopics JSON DEFAULT NULL,
    message TEXT DEFAULT NULL
);
;

--
-- Table 'APINotFound' generated from model 'APINotFound'
--
CREATE TABLE IF NOT EXISTS APINotFound (
    errors JSON DEFAULT NULL,
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APIRepoArchivedError' generated from model 'APIRepoArchivedError'
--
CREATE TABLE IF NOT EXISTS APIRepoArchivedError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APIUnauthorizedError' generated from model 'APIUnauthorizedError'
--
CREATE TABLE IF NOT EXISTS APIUnauthorizedError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APIValidationError' generated from model 'APIValidationError'
--
CREATE TABLE IF NOT EXISTS APIValidationError (
    message TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'APRemoteFollowOption' generated from model 'APRemoteFollowOption'
--
CREATE TABLE IF NOT EXISTS APRemoteFollowOption (
    "target" TEXT DEFAULT NULL
);
;

--
-- Table 'AccessToken' generated from model 'AccessToken'
--
CREATE TABLE IF NOT EXISTS AccessToken (
    created_at TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    repositories JSON DEFAULT NULL,
    scopes JSON DEFAULT NULL,
    sha1 TEXT DEFAULT NULL,
    token_last_eight TEXT DEFAULT NULL
);
;
COMMENT ON COLUMN AccessToken.repositories IS 'Indicates that an access token only has access to the specified repositories.  Will be null if the access token is not limited to a set of specified repositories.';

--
-- Table 'ActionArtifact' generated from model 'ActionArtifact'
-- ActionArtifact represents an artifact of a workflow run
--
CREATE TABLE IF NOT EXISTS ActionArtifact (
    archive_download_url TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    expired BOOLEAN DEFAULT NULL,
    expires_at TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    run_id BIGINT DEFAULT NULL,
    size_in_bytes BIGINT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE ActionArtifact IS 'ActionArtifact represents an artifact of a workflow run';
COMMENT ON COLUMN ActionArtifact.archive_download_url IS 'the URL to download the artifact zip archive';
COMMENT ON COLUMN ActionArtifact.expired IS 'whether the artifact has expired';
COMMENT ON COLUMN ActionArtifact."id" IS 'the artifact&#39;s ID';
COMMENT ON COLUMN ActionArtifact."name" IS 'the artifact&#39;s name';
COMMENT ON COLUMN ActionArtifact.run_id IS 'the ID of the workflow run that produced this artifact';
COMMENT ON COLUMN ActionArtifact.size_in_bytes IS 'the total size of the artifact in bytes';

--
-- Table 'ActionRun' generated from model 'ActionRun'
-- ActionRun represents an action run
--
CREATE TABLE IF NOT EXISTS ActionRun (
    ScheduleID BIGINT DEFAULT NULL,
    approved_by BIGINT DEFAULT NULL,
    commit_sha TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    duration BIGINT DEFAULT NULL,
    "event" TEXT DEFAULT NULL,
    event_payload TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    index_in_repo BIGINT DEFAULT NULL,
    is_fork_pull_request BOOLEAN DEFAULT NULL,
    is_ref_deleted BOOLEAN DEFAULT NULL,
    need_approval BOOLEAN DEFAULT NULL,
    prettyref TEXT DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    started TIMESTAMP DEFAULT NULL,
    status TEXT DEFAULT NULL,
    stopped TIMESTAMP DEFAULT NULL,
    title TEXT DEFAULT NULL,
    trigger_event TEXT DEFAULT NULL,
    trigger_user TEXT DEFAULT NULL,
    updated TIMESTAMP DEFAULT NULL,
    workflow_id TEXT DEFAULT NULL
);
COMMENT ON TABLE ActionRun IS 'ActionRun represents an action run';
COMMENT ON COLUMN ActionRun.ScheduleID IS 'the cron id for the schedule trigger';
COMMENT ON COLUMN ActionRun.approved_by IS 'who approved this action run';
COMMENT ON COLUMN ActionRun.commit_sha IS 'the commit sha the action run ran on';
COMMENT ON COLUMN ActionRun.created IS 'when the action run was created';
COMMENT ON COLUMN ActionRun.duration IS 'A Duration represents the elapsed time between two instants as an int64 nanosecond count. The representation limits the largest representable duration to approximately 290 years.';
COMMENT ON COLUMN ActionRun."event" IS 'the webhook event that causes the workflow to run';
COMMENT ON COLUMN ActionRun.event_payload IS 'the payload of the webhook event that causes the workflow to run';
COMMENT ON COLUMN ActionRun.html_url IS 'the url of this action run';
COMMENT ON COLUMN ActionRun."id" IS 'the action run id';
COMMENT ON COLUMN ActionRun.index_in_repo IS 'a unique number for each run of a repository';
COMMENT ON COLUMN ActionRun.is_fork_pull_request IS 'If this is triggered by a PR from a forked repository or an untrusted user, we need to check if it is approved and limit permissions when running the workflow.';
COMMENT ON COLUMN ActionRun.is_ref_deleted IS 'has the commit/tag/… the action run ran on been deleted';
COMMENT ON COLUMN ActionRun.need_approval IS 'may need approval if it&#39;s a fork pull request';
COMMENT ON COLUMN ActionRun.prettyref IS 'the commit/tag/… the action run ran on';
COMMENT ON COLUMN ActionRun.started IS 'when the action run was started';
COMMENT ON COLUMN ActionRun.status IS 'the current status of this run';
COMMENT ON COLUMN ActionRun.stopped IS 'when the action run was stopped';
COMMENT ON COLUMN ActionRun.title IS 'the action run&#39;s title';
COMMENT ON COLUMN ActionRun.trigger_event IS 'the trigger event defined in the &#x60;on&#x60; configuration of the triggered workflow';
COMMENT ON COLUMN ActionRun.updated IS 'when the action run was last updated';
COMMENT ON COLUMN ActionRun.workflow_id IS 'the name of workflow file';

--
-- Table 'ActionRunJob' generated from model 'ActionRunJob'
-- ActionRunJob represents a job of a run
--
CREATE TABLE IF NOT EXISTS ActionRunJob (
    attempt BIGINT DEFAULT NULL,
    handle TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    needs JSON DEFAULT NULL,
    owner_id BIGINT DEFAULT NULL,
    repo_id BIGINT DEFAULT NULL,
    run_id BIGINT DEFAULT NULL,
    runs_on JSON DEFAULT NULL,
    status TEXT DEFAULT NULL,
    steps JSON DEFAULT NULL,
    task_id BIGINT DEFAULT NULL
);
COMMENT ON TABLE ActionRunJob IS 'ActionRunJob represents a job of a run';
COMMENT ON COLUMN ActionRunJob.attempt IS 'How many times the job has been attempted including the current attempt.';
COMMENT ON COLUMN ActionRunJob.handle IS 'Opaque identifier that uniquely identifies a single attempt of a job.';
COMMENT ON COLUMN ActionRunJob.html_url IS 'HTMLURL is the URL where a user can view the job using their browser.';
COMMENT ON COLUMN ActionRunJob."id" IS 'Identifier of this job.';
COMMENT ON COLUMN ActionRunJob."name" IS 'the action run job name';
COMMENT ON COLUMN ActionRunJob.needs IS 'the action run job needed ids';
COMMENT ON COLUMN ActionRunJob.owner_id IS 'the owner id';
COMMENT ON COLUMN ActionRunJob.repo_id IS 'the repository id';
COMMENT ON COLUMN ActionRunJob.run_id IS 'Identifier of the workflow run this job belongs to.';
COMMENT ON COLUMN ActionRunJob.runs_on IS 'the action run job labels to run on';
COMMENT ON COLUMN ActionRunJob.status IS 'the action run job status';
COMMENT ON COLUMN ActionRunJob.steps IS 'the steps that make up this workflow job&#39;s execution, including the \&quot;Set up job\&quot; entry (number&#x3D;0) and \&quot;Complete job\&quot; tail. Only populated by endpoints that return a single job (e.g. GET /repos/{owner}/{repo}/actions/jobs/{job_id}).';
COMMENT ON COLUMN ActionRunJob.task_id IS 'the action run job latest task id';

--
-- Table 'ActionRunJobStep' generated from model 'ActionRunJobStep'
-- ActionRunJobStep is a step in a workflow job&#39;s execution. The slice on ActionRunJob.Steps always includes a \&quot;Set up job\&quot; entry at number&#x3D;0 and a \&quot;Complete job\&quot; entry as the last element; the entries in between are the workflow&#39;s real steps in declaration order. The Number field is the value accepted by the job-logs endpoint&#39;s &#x60;?step&#x3D;&#x60; filter.
--
CREATE TABLE IF NOT EXISTS ActionRunJobStep (
    "name" TEXT DEFAULT NULL,
    "number" BIGINT DEFAULT NULL,
    started TIMESTAMP DEFAULT NULL,
    status TEXT DEFAULT NULL,
    stopped TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE ActionRunJobStep IS 'ActionRunJobStep is a step in a workflow job&#39;s execution. The slice on ActionRunJob.Steps always includes a \&quot;Set up job\&quot; entry at number&#x3D;0 and a \&quot;Complete job\&quot; entry as the last element; the entries in between are the workflow&#39;s real steps in declaration order. The Number field is the value accepted by the job-logs endpoint&#39;s &#x60;?step&#x3D;&#x60; filter.';
COMMENT ON COLUMN ActionRunJobStep."name" IS 'step name (workflow YAML &#x60;name:&#x60; for real steps; \&quot;Set up job\&quot; and \&quot;Complete job\&quot; for the head and tail respectively)';
COMMENT ON COLUMN ActionRunJobStep."number" IS 'position in the job&#39;s step list. 0 is the \&quot;Set up job\&quot; entry; the last index is the \&quot;Complete job\&quot; entry; real steps are numbered 1..N in declaration order.';
COMMENT ON COLUMN ActionRunJobStep.started IS 'when the step started';
COMMENT ON COLUMN ActionRunJobStep.status IS 'step status (success, failure, running, waiting, skipped, cancelled, ...)';
COMMENT ON COLUMN ActionRunJobStep.stopped IS 'when the step stopped';

--
-- Table 'ActionRunner' generated from model 'ActionRunner'
-- ActionRunner represents a runner
--
CREATE TABLE IF NOT EXISTS ActionRunner (
    description TEXT DEFAULT NULL,
    ephemeral BOOLEAN DEFAULT NULL,
    "id" BIGSERIAL,
    labels JSON DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    owner_id BIGINT DEFAULT NULL,
    repo_id BIGINT DEFAULT NULL,
    status ActionRunner_status DEFAULT NULL,
    uuid TEXT DEFAULT NULL,
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE ActionRunner IS 'ActionRunner represents a runner';
COMMENT ON COLUMN ActionRunner.description IS 'Description provides optional details about this runner.';
COMMENT ON COLUMN ActionRunner.ephemeral IS 'Indicates if runner is ephemeral runner';
COMMENT ON COLUMN ActionRunner."id" IS 'ID uniquely identifies this runner.';
COMMENT ON COLUMN ActionRunner.labels IS 'Labels is a list of labels attached to this runner.';
COMMENT ON COLUMN ActionRunner."name" IS 'Name of the runner; not unique.';
COMMENT ON COLUMN ActionRunner.owner_id IS 'OwnerID is the identifier of the user or organization this runner belongs to. O if the runner is owned by a repository.';
COMMENT ON COLUMN ActionRunner.repo_id IS 'RepoID is the identifier of the repository this runner belongs to. 0 if the runner belongs to a user or organization.';
COMMENT ON COLUMN ActionRunner.status IS 'Status indicates whether this runner is offline, or active, for example.';
COMMENT ON COLUMN ActionRunner.uuid IS 'UUID uniquely identifies this runner.';
COMMENT ON COLUMN ActionRunner."version" IS 'Version is the self-reported version string of Forgejo Runner.';

--
-- Table 'ActionTask' generated from model 'ActionTask'
-- ActionTask represents a ActionTask
--
CREATE TABLE IF NOT EXISTS ActionTask (
    created_at TIMESTAMP DEFAULT NULL,
    display_title TEXT DEFAULT NULL,
    "event" TEXT DEFAULT NULL,
    head_branch TEXT DEFAULT NULL,
    head_sha TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    run_number BIGINT DEFAULT NULL,
    run_started_at TIMESTAMP DEFAULT NULL,
    status TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    workflow_id TEXT DEFAULT NULL
);
COMMENT ON TABLE ActionTask IS 'ActionTask represents a ActionTask';

--
-- Table 'ActionTaskResponse' generated from model 'ActionTaskResponse'
-- ActionTaskResponse returns a ActionTask
--
CREATE TABLE IF NOT EXISTS ActionTaskResponse (
    total_count BIGINT DEFAULT NULL,
    workflow_runs JSON DEFAULT NULL
);
COMMENT ON TABLE ActionTaskResponse IS 'ActionTaskResponse returns a ActionTask';

--
-- Table 'ActionVariable' generated from model 'ActionVariable'
-- ActionVariable return value of the query API
--
CREATE TABLE IF NOT EXISTS ActionVariable (
    "data" TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    owner_id BIGINT DEFAULT NULL,
    repo_id BIGINT DEFAULT NULL
);
COMMENT ON TABLE ActionVariable IS 'ActionVariable return value of the query API';
COMMENT ON COLUMN ActionVariable."data" IS 'the value of the variable';
COMMENT ON COLUMN ActionVariable."name" IS 'the name of the variable';
COMMENT ON COLUMN ActionVariable.owner_id IS 'the owner to which the variable belongs';
COMMENT ON COLUMN ActionVariable.repo_id IS 'the repository to which the variable belongs';

--
-- Table 'Activity' generated from model 'Activity'
--
CREATE TABLE IF NOT EXISTS Activity (
    act_user TEXT DEFAULT NULL,
    act_user_id BIGINT DEFAULT NULL,
    "comment" TEXT DEFAULT NULL,
    comment_id BIGINT DEFAULT NULL,
    "content" TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    is_private BOOLEAN DEFAULT NULL,
    op_type Activity_opUnderscoretype DEFAULT NULL,
    ref_name TEXT DEFAULT NULL,
    repo TEXT DEFAULT NULL,
    repo_id BIGINT DEFAULT NULL,
    user_id BIGINT DEFAULT NULL
);
;
COMMENT ON COLUMN Activity.op_type IS 'the type of action';

--
-- Table 'ActivityPub' generated from model 'ActivityPub'
-- ActivityPub type
--
CREATE TABLE IF NOT EXISTS ActivityPub (
    @context TEXT DEFAULT NULL
);
COMMENT ON TABLE ActivityPub IS 'ActivityPub type';

--
-- Table 'AddCollaboratorOption' generated from model 'AddCollaboratorOption'
-- AddCollaboratorOption options when adding a user as a collaborator of a repository
--
CREATE TABLE IF NOT EXISTS AddCollaboratorOption (
    "permission" AddCollaboratorOption_permission DEFAULT NULL
);
COMMENT ON TABLE AddCollaboratorOption IS 'AddCollaboratorOption options when adding a user as a collaborator of a repository';

--
-- Table 'AddTimeOption' generated from model 'AddTimeOption'
-- AddTimeOption options for adding time to an issue
--
CREATE TABLE IF NOT EXISTS AddTimeOption (
    created TIMESTAMP DEFAULT NULL,
    "time" BIGINT NOT NULL,
    user_name TEXT DEFAULT NULL
);
COMMENT ON TABLE AddTimeOption IS 'AddTimeOption options for adding time to an issue';
COMMENT ON COLUMN AddTimeOption."time" IS 'time in seconds';
COMMENT ON COLUMN AddTimeOption.user_name IS 'User who spent the time (optional)';

--
-- Table 'AnnotatedTag' generated from model 'AnnotatedTag'
-- AnnotatedTag represents an annotated tag
--
CREATE TABLE IF NOT EXISTS AnnotatedTag (
    archive_download_count TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    "object" TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    tag TEXT DEFAULT NULL,
    tagger TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
COMMENT ON TABLE AnnotatedTag IS 'AnnotatedTag represents an annotated tag';

--
-- Table 'AnnotatedTagObject' generated from model 'AnnotatedTagObject'
-- AnnotatedTagObject contains meta information of the tag object
--
CREATE TABLE IF NOT EXISTS AnnotatedTagObject (
    sha TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE AnnotatedTagObject IS 'AnnotatedTagObject contains meta information of the tag object';

--
-- Table 'Attachment' generated from model 'Attachment'
-- Attachment a generic attachment
--
CREATE TABLE IF NOT EXISTS Attachment (
    browser_download_url TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    download_count BIGINT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    "type" Attachment_type DEFAULT NULL,
    uuid TEXT DEFAULT NULL
);
COMMENT ON TABLE Attachment IS 'Attachment a generic attachment';

--
-- Table 'BlockedUser' generated from model 'BlockedUser'
--
CREATE TABLE IF NOT EXISTS BlockedUser (
    block_id BIGINT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL
);
;

--
-- Table 'Branch' generated from model 'Branch'
-- Branch represents a repository branch
--
CREATE TABLE IF NOT EXISTS Branch (
    "commit" TEXT DEFAULT NULL,
    effective_branch_protection_name TEXT DEFAULT NULL,
    enable_status_check BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    protected BOOLEAN DEFAULT NULL,
    required_approvals BIGINT DEFAULT NULL,
    status_check_contexts JSON DEFAULT NULL,
    user_can_merge BOOLEAN DEFAULT NULL,
    user_can_push BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE Branch IS 'Branch represents a repository branch';

--
-- Table 'BranchProtection' generated from model 'BranchProtection'
-- BranchProtection represents a branch protection for a repository
--
CREATE TABLE IF NOT EXISTS BranchProtection (
    apply_to_admins BOOLEAN DEFAULT NULL,
    approvals_whitelist_teams JSON DEFAULT NULL,
    approvals_whitelist_username JSON DEFAULT NULL,
    block_on_official_review_requests BOOLEAN DEFAULT NULL,
    block_on_outdated_branch BOOLEAN DEFAULT NULL,
    block_on_rejected_reviews BOOLEAN DEFAULT NULL,
    branch_name TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    dismiss_stale_approvals BOOLEAN DEFAULT NULL,
    enable_approvals_whitelist BOOLEAN DEFAULT NULL,
    enable_merge_whitelist BOOLEAN DEFAULT NULL,
    enable_push BOOLEAN DEFAULT NULL,
    enable_push_whitelist BOOLEAN DEFAULT NULL,
    enable_status_check BOOLEAN DEFAULT NULL,
    ignore_stale_approvals BOOLEAN DEFAULT NULL,
    merge_whitelist_teams JSON DEFAULT NULL,
    merge_whitelist_usernames JSON DEFAULT NULL,
    protected_file_patterns TEXT DEFAULT NULL,
    push_whitelist_deploy_keys BOOLEAN DEFAULT NULL,
    push_whitelist_teams JSON DEFAULT NULL,
    push_whitelist_usernames JSON DEFAULT NULL,
    require_signed_commits BOOLEAN DEFAULT NULL,
    required_approvals BIGINT DEFAULT NULL,
    rule_name TEXT DEFAULT NULL,
    status_check_contexts JSON DEFAULT NULL,
    unprotected_file_patterns TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE BranchProtection IS 'BranchProtection represents a branch protection for a repository';

--
-- Table 'ChangeFileOperation' generated from model 'ChangeFileOperation'
-- ChangeFileOperation for creating, updating or deleting a file
--
CREATE TABLE IF NOT EXISTS ChangeFileOperation (
    "content" TEXT DEFAULT NULL,
    from_path TEXT DEFAULT NULL,
    operation ChangeFileOperation_operation NOT NULL,
    "path" TEXT NOT NULL,
    sha TEXT DEFAULT NULL
);
COMMENT ON TABLE ChangeFileOperation IS 'ChangeFileOperation for creating, updating or deleting a file';
COMMENT ON COLUMN ChangeFileOperation."content" IS 'new or updated file content, must be base64 encoded';
COMMENT ON COLUMN ChangeFileOperation.from_path IS 'old path of the file to move';
COMMENT ON COLUMN ChangeFileOperation.operation IS 'indicates what to do with the file';
COMMENT ON COLUMN ChangeFileOperation."path" IS 'path to the existing or new file';
COMMENT ON COLUMN ChangeFileOperation.sha IS 'sha is the SHA for the file that already exists, required for update or delete';

--
-- Table 'ChangeFilesOptions' generated from model 'ChangeFilesOptions'
-- ChangeFilesOptions options for creating, updating or deleting multiple files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
--
CREATE TABLE IF NOT EXISTS ChangeFilesOptions (
    author TEXT DEFAULT NULL,
    branch TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    dates TEXT DEFAULT NULL,
    files JSON NOT NULL,
    force_overwrite_new_branch BOOLEAN DEFAULT NULL,
    message TEXT DEFAULT NULL,
    new_branch TEXT DEFAULT NULL,
    signoff BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE ChangeFilesOptions IS 'ChangeFilesOptions options for creating, updating or deleting multiple files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)';
COMMENT ON COLUMN ChangeFilesOptions.branch IS 'branch (optional) to base this file from. if not given, the default branch is used';
COMMENT ON COLUMN ChangeFilesOptions.files IS 'list of file operations';
COMMENT ON COLUMN ChangeFilesOptions.force_overwrite_new_branch IS '(optional) will do a force-push if the new branch already exists';
COMMENT ON COLUMN ChangeFilesOptions.message IS 'message (optional) for the commit of this file. if not supplied, a default message will be used';
COMMENT ON COLUMN ChangeFilesOptions.new_branch IS 'new_branch (optional) will make a new branch from &#x60;branch&#x60; before creating the file';
COMMENT ON COLUMN ChangeFilesOptions.signoff IS 'Add a Signed-off-by trailer by the committer at the end of the commit log message.';

--
-- Table 'ChangedFile' generated from model 'ChangedFile'
-- ChangedFile store information about files affected by the pull request
--
CREATE TABLE IF NOT EXISTS ChangedFile (
    additions BIGINT DEFAULT NULL,
    changes BIGINT DEFAULT NULL,
    contents_url TEXT DEFAULT NULL,
    deletions BIGINT DEFAULT NULL,
    filename TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    previous_filename TEXT DEFAULT NULL,
    raw_url TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL
);
COMMENT ON TABLE ChangedFile IS 'ChangedFile store information about files affected by the pull request';

--
-- Table 'CombinedStatus' generated from model 'CombinedStatus'
-- CombinedStatus holds the combined state of several statuses for a single commit
--
CREATE TABLE IF NOT EXISTS CombinedStatus (
    commit_url TEXT DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    statuses JSON DEFAULT NULL,
    total_count BIGINT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE CombinedStatus IS 'CombinedStatus holds the combined state of several statuses for a single commit';
COMMENT ON COLUMN CombinedStatus."state" IS 'CommitStatusState holds the state of a CommitStatus It can be \&quot;pending\&quot;, \&quot;success\&quot;, \&quot;error\&quot;, \&quot;failure\&quot;, \&quot;warning\&quot;, or \&quot;skipped\&quot;';

--
-- Table 'Comment' generated from model 'Comment'
-- Comment represents a comment on a commit or issue
--
CREATE TABLE IF NOT EXISTS "Comment" (
    assets JSON DEFAULT NULL,
    body TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    issue_url TEXT DEFAULT NULL,
    original_author TEXT DEFAULT NULL,
    original_author_id BIGINT DEFAULT NULL,
    pull_request_url TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE "Comment" IS 'Comment represents a comment on a commit or issue';
COMMENT ON COLUMN "Comment".assets IS 'The attachments to the comment';
COMMENT ON COLUMN "Comment".body IS 'The body of the comment';
COMMENT ON COLUMN "Comment".created_at IS 'The time of the comment&#39;s creation';
COMMENT ON COLUMN "Comment".html_url IS 'The HTML URL of the comment';
COMMENT ON COLUMN "Comment"."id" IS 'The identifier of the comment';
COMMENT ON COLUMN "Comment".issue_url IS 'The HTML URL of the issue if the comment is posted on an issue, else empty string';
COMMENT ON COLUMN "Comment".original_author IS 'The original author that posted the comment if it was not posted locally, else empty string';
COMMENT ON COLUMN "Comment".original_author_id IS 'The ID of the original author that posted the comment if it was not posted locally, else 0';
COMMENT ON COLUMN "Comment".pull_request_url IS 'The HTML URL of the pull request if the comment is posted on a pull request, else empty string';
COMMENT ON COLUMN "Comment".updated_at IS 'The time of the comment&#39;s update';

--
-- Table 'Commit' generated from model 'Commit'
--
CREATE TABLE IF NOT EXISTS "Commit" (
    author TEXT DEFAULT NULL,
    "commit" TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    files JSON DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    parents JSON DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    stats TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'CommitAffectedFiles' generated from model 'CommitAffectedFiles'
-- CommitAffectedFiles store information about files affected by the commit
--
CREATE TABLE IF NOT EXISTS CommitAffectedFiles (
    filename TEXT DEFAULT NULL,
    status TEXT DEFAULT NULL
);
COMMENT ON TABLE CommitAffectedFiles IS 'CommitAffectedFiles store information about files affected by the commit';

--
-- Table 'CommitDateOptions' generated from model 'CommitDateOptions'
-- CommitDateOptions store dates for GIT_AUTHOR_DATE and GIT_COMMITTER_DATE
--
CREATE TABLE IF NOT EXISTS CommitDateOptions (
    author TIMESTAMP DEFAULT NULL,
    committer TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE CommitDateOptions IS 'CommitDateOptions store dates for GIT_AUTHOR_DATE and GIT_COMMITTER_DATE';

--
-- Table 'CommitMeta' generated from model 'CommitMeta'
--
CREATE TABLE IF NOT EXISTS CommitMeta (
    created TIMESTAMP DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'CommitStats' generated from model 'CommitStats'
-- CommitStats is statistics for a RepoCommit
--
CREATE TABLE IF NOT EXISTS CommitStats (
    additions BIGINT DEFAULT NULL,
    deletions BIGINT DEFAULT NULL,
    total BIGINT DEFAULT NULL
);
COMMENT ON TABLE CommitStats IS 'CommitStats is statistics for a RepoCommit';

--
-- Table 'CommitStatus' generated from model 'CommitStatus'
-- CommitStatus holds a single status of a single Commit
--
CREATE TABLE IF NOT EXISTS CommitStatus (
    context TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    creator TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    status TEXT DEFAULT NULL,
    target_url TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE CommitStatus IS 'CommitStatus holds a single status of a single Commit';
COMMENT ON COLUMN CommitStatus.status IS 'CommitStatusState holds the state of a CommitStatus It can be \&quot;pending\&quot;, \&quot;success\&quot;, \&quot;error\&quot;, \&quot;failure\&quot;, \&quot;warning\&quot;, or \&quot;skipped\&quot;';

--
-- Table 'CommitUser' generated from model 'CommitUser'
--
CREATE TABLE IF NOT EXISTS CommitUser (
    "date" TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
;

--
-- Table 'Compare' generated from model 'Compare'
--
CREATE TABLE IF NOT EXISTS Compare (
    commits JSON DEFAULT NULL,
    files JSON DEFAULT NULL,
    total_commits BIGINT DEFAULT NULL
);
;

--
-- Table 'ContentsResponse' generated from model 'ContentsResponse'
-- ContentsResponse contains information about a repo&#39;s entry&#39;s (dir, file, symlink, submodule) metadata and content
--
CREATE TABLE IF NOT EXISTS ContentsResponse (
    _links TEXT DEFAULT NULL,
    "content" TEXT DEFAULT NULL,
    download_url TEXT DEFAULT NULL,
    "encoding" TEXT DEFAULT NULL,
    git_url TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    last_commit_sha TEXT DEFAULT NULL,
    last_commit_when TIMESTAMP DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "path" TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    submodule_git_url TEXT DEFAULT NULL,
    "target" TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE ContentsResponse IS 'ContentsResponse contains information about a repo&#39;s entry&#39;s (dir, file, symlink, submodule) metadata and content';
COMMENT ON COLUMN ContentsResponse."content" IS '&#x60;content&#x60; is populated when &#x60;type&#x60; is &#x60;file&#x60;, otherwise null';
COMMENT ON COLUMN ContentsResponse."encoding" IS '&#x60;encoding&#x60; is populated when &#x60;type&#x60; is &#x60;file&#x60;, otherwise null';
COMMENT ON COLUMN ContentsResponse.submodule_git_url IS '&#x60;submodule_git_url&#x60; is populated when &#x60;type&#x60; is &#x60;submodule&#x60;, otherwise null';
COMMENT ON COLUMN ContentsResponse."target" IS '&#x60;target&#x60; is populated when &#x60;type&#x60; is &#x60;symlink&#x60;, otherwise null';
COMMENT ON COLUMN ContentsResponse."type" IS '&#x60;type&#x60; will be &#x60;file&#x60;, &#x60;dir&#x60;, &#x60;symlink&#x60;, or &#x60;submodule&#x60;';

--
-- Table 'CreateAccessTokenOption' generated from model 'CreateAccessTokenOption'
-- CreateAccessTokenOption options when create access token
--
CREATE TABLE IF NOT EXISTS CreateAccessTokenOption (
    "name" TEXT NOT NULL,
    repositories JSON DEFAULT NULL,
    scopes JSON DEFAULT NULL
);
COMMENT ON TABLE CreateAccessTokenOption IS 'CreateAccessTokenOption options when create access token';
COMMENT ON COLUMN CreateAccessTokenOption.repositories IS 'If provided and not-empty, creates an access token with access only to specified repositories.';

--
-- Table 'CreateBranchProtectionOption' generated from model 'CreateBranchProtectionOption'
-- CreateBranchProtectionOption options for creating a branch protection
--
CREATE TABLE IF NOT EXISTS CreateBranchProtectionOption (
    apply_to_admins BOOLEAN DEFAULT NULL,
    approvals_whitelist_teams JSON DEFAULT NULL,
    approvals_whitelist_username JSON DEFAULT NULL,
    block_on_official_review_requests BOOLEAN DEFAULT NULL,
    block_on_outdated_branch BOOLEAN DEFAULT NULL,
    block_on_rejected_reviews BOOLEAN DEFAULT NULL,
    branch_name TEXT DEFAULT NULL,
    dismiss_stale_approvals BOOLEAN DEFAULT NULL,
    enable_approvals_whitelist BOOLEAN DEFAULT NULL,
    enable_merge_whitelist BOOLEAN DEFAULT NULL,
    enable_push BOOLEAN DEFAULT NULL,
    enable_push_whitelist BOOLEAN DEFAULT NULL,
    enable_status_check BOOLEAN DEFAULT NULL,
    ignore_stale_approvals BOOLEAN DEFAULT NULL,
    merge_whitelist_teams JSON DEFAULT NULL,
    merge_whitelist_usernames JSON DEFAULT NULL,
    protected_file_patterns TEXT DEFAULT NULL,
    push_whitelist_deploy_keys BOOLEAN DEFAULT NULL,
    push_whitelist_teams JSON DEFAULT NULL,
    push_whitelist_usernames JSON DEFAULT NULL,
    require_signed_commits BOOLEAN DEFAULT NULL,
    required_approvals BIGINT DEFAULT NULL,
    rule_name TEXT DEFAULT NULL,
    status_check_contexts JSON DEFAULT NULL,
    unprotected_file_patterns TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateBranchProtectionOption IS 'CreateBranchProtectionOption options for creating a branch protection';

--
-- Table 'CreateBranchRepoOption' generated from model 'CreateBranchRepoOption'
-- CreateBranchRepoOption options when creating a branch in a repository
--
CREATE TABLE IF NOT EXISTS CreateBranchRepoOption (
    new_branch_name TEXT NOT NULL,
    old_branch_name TEXT DEFAULT NULL,
    old_ref_name TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateBranchRepoOption IS 'CreateBranchRepoOption options when creating a branch in a repository';
COMMENT ON COLUMN CreateBranchRepoOption.new_branch_name IS 'Name of the branch to create';
COMMENT ON COLUMN CreateBranchRepoOption.old_branch_name IS 'Name of the old branch to create from';
COMMENT ON COLUMN CreateBranchRepoOption.old_ref_name IS 'Name of the old branch/tag/commit to create from';

--
-- Table 'CreateEmailOption' generated from model 'CreateEmailOption'
-- CreateEmailOption options when creating email addresses
--
CREATE TABLE IF NOT EXISTS CreateEmailOption (
    emails JSON DEFAULT NULL
);
COMMENT ON TABLE CreateEmailOption IS 'CreateEmailOption options when creating email addresses';
COMMENT ON COLUMN CreateEmailOption.emails IS 'email addresses to add';

--
-- Table 'CreateFileOptions' generated from model 'CreateFileOptions'
-- CreateFileOptions options for creating files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
--
CREATE TABLE IF NOT EXISTS CreateFileOptions (
    author TEXT DEFAULT NULL,
    branch TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    "content" TEXT NOT NULL,
    dates TEXT DEFAULT NULL,
    force_overwrite_new_branch BOOLEAN DEFAULT NULL,
    message TEXT DEFAULT NULL,
    new_branch TEXT DEFAULT NULL,
    signoff BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE CreateFileOptions IS 'CreateFileOptions options for creating files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)';
COMMENT ON COLUMN CreateFileOptions.branch IS 'branch (optional) to base this file from. if not given, the default branch is used';
COMMENT ON COLUMN CreateFileOptions."content" IS 'content must be base64 encoded';
COMMENT ON COLUMN CreateFileOptions.force_overwrite_new_branch IS '(optional) will do a force-push if the new branch already exists';
COMMENT ON COLUMN CreateFileOptions.message IS 'message (optional) for the commit of this file. if not supplied, a default message will be used';
COMMENT ON COLUMN CreateFileOptions.new_branch IS 'new_branch (optional) will make a new branch from &#x60;branch&#x60; before creating the file';
COMMENT ON COLUMN CreateFileOptions.signoff IS 'Add a Signed-off-by trailer by the committer at the end of the commit log message.';

--
-- Table 'CreateForkOption' generated from model 'CreateForkOption'
-- CreateForkOption options for creating a fork
--
CREATE TABLE IF NOT EXISTS CreateForkOption (
    "name" TEXT DEFAULT NULL,
    organization TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateForkOption IS 'CreateForkOption options for creating a fork';
COMMENT ON COLUMN CreateForkOption."name" IS 'name of the forked repository';
COMMENT ON COLUMN CreateForkOption.organization IS 'organization name, if forking into an organization';

--
-- Table 'CreateGPGKeyOption' generated from model 'CreateGPGKeyOption'
-- CreateGPGKeyOption options create user GPG key
--
CREATE TABLE IF NOT EXISTS CreateGPGKeyOption (
    armored_public_key TEXT NOT NULL,
    armored_signature TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateGPGKeyOption IS 'CreateGPGKeyOption options create user GPG key';
COMMENT ON COLUMN CreateGPGKeyOption.armored_public_key IS 'An armored GPG key to add';

--
-- Table 'CreateHookOption' generated from model 'CreateHookOption'
-- CreateHookOption options when create a hook
--
CREATE TABLE IF NOT EXISTS CreateHookOption (
    active BOOLEAN DEFAULT 'false',
    authorization_header TEXT DEFAULT NULL,
    branch_filter TEXT DEFAULT NULL,
    config JSON NOT NULL,
    events JSON DEFAULT NULL,
    "type" CreateHookOption_type NOT NULL
);
COMMENT ON TABLE CreateHookOption IS 'CreateHookOption options when create a hook';
COMMENT ON COLUMN CreateHookOption.config IS 'CreateHookOptionConfig has all config options in it required are \&quot;content_type\&quot; and \&quot;url\&quot; Required';

--
-- Table 'CreateIssueCommentOption' generated from model 'CreateIssueCommentOption'
-- CreateIssueCommentOption options for creating a comment on an issue
--
CREATE TABLE IF NOT EXISTS CreateIssueCommentOption (
    body TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE CreateIssueCommentOption IS 'CreateIssueCommentOption options for creating a comment on an issue';
COMMENT ON COLUMN CreateIssueCommentOption.body IS 'The body of the comment';
COMMENT ON COLUMN CreateIssueCommentOption.updated_at IS 'The time of the comment&#39;s update, needs admin or repository owner permission';

--
-- Table 'CreateIssueOption' generated from model 'CreateIssueOption'
-- CreateIssueOption options to create one issue
--
CREATE TABLE IF NOT EXISTS CreateIssueOption (
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    body TEXT DEFAULT NULL,
    closed BOOLEAN DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    labels JSON DEFAULT NULL,
    milestone BIGINT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    title TEXT NOT NULL
);
COMMENT ON TABLE CreateIssueOption IS 'CreateIssueOption options to create one issue';
COMMENT ON COLUMN CreateIssueOption.assignee IS 'deprecated';
COMMENT ON COLUMN CreateIssueOption.labels IS 'list of label ids';
COMMENT ON COLUMN CreateIssueOption.milestone IS 'milestone id';

--
-- Table 'CreateKeyOption' generated from model 'CreateKeyOption'
-- CreateKeyOption options when creating a key
--
CREATE TABLE IF NOT EXISTS CreateKeyOption (
    "key" TEXT NOT NULL,
    read_only BOOLEAN DEFAULT NULL,
    title TEXT NOT NULL
);
COMMENT ON TABLE CreateKeyOption IS 'CreateKeyOption options when creating a key';
COMMENT ON COLUMN CreateKeyOption."key" IS 'An armored SSH key to add';
COMMENT ON COLUMN CreateKeyOption.read_only IS 'Describe if the key has only read access or read/write';
COMMENT ON COLUMN CreateKeyOption.title IS 'Title of the key to add';

--
-- Table 'CreateLabelOption' generated from model 'CreateLabelOption'
-- CreateLabelOption options for creating a label
--
CREATE TABLE IF NOT EXISTS CreateLabelOption (
    color TEXT NOT NULL,
    description TEXT DEFAULT NULL,
    "exclusive" BOOLEAN DEFAULT NULL,
    is_archived BOOLEAN DEFAULT NULL,
    "name" TEXT NOT NULL
);
COMMENT ON TABLE CreateLabelOption IS 'CreateLabelOption options for creating a label';

--
-- Table 'CreateMilestoneOption' generated from model 'CreateMilestoneOption'
-- CreateMilestoneOption options for creating a milestone
--
CREATE TABLE IF NOT EXISTS CreateMilestoneOption (
    description TEXT DEFAULT NULL,
    due_on TIMESTAMP DEFAULT NULL,
    "state" CreateMilestoneOption_state DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateMilestoneOption IS 'CreateMilestoneOption options for creating a milestone';

--
-- Table 'CreateOAuth2ApplicationOptions' generated from model 'CreateOAuth2ApplicationOptions'
-- CreateOAuth2ApplicationOptions holds options to create an oauth2 application
--
CREATE TABLE IF NOT EXISTS CreateOAuth2ApplicationOptions (
    confidential_client BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    redirect_uris JSON DEFAULT NULL
);
COMMENT ON TABLE CreateOAuth2ApplicationOptions IS 'CreateOAuth2ApplicationOptions holds options to create an oauth2 application';

--
-- Table 'CreateOrUpdateSecretOption' generated from model 'CreateOrUpdateSecretOption'
--
CREATE TABLE IF NOT EXISTS CreateOrUpdateSecretOption (
    "data" TEXT NOT NULL
);
;
COMMENT ON COLUMN CreateOrUpdateSecretOption."data" IS 'Data of the secret. Special characters will be retained. Line endings will be normalized to LF to match the behaviour of browsers. Encode the data with Base64 if line endings should be retained.';

--
-- Table 'CreateOrgOption' generated from model 'CreateOrgOption'
-- CreateOrgOption options for creating an organization
--
CREATE TABLE IF NOT EXISTS CreateOrgOption (
    description TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    repo_admin_change_team_access BOOLEAN DEFAULT NULL,
    username TEXT NOT NULL,
    visibility CreateOrgOption_visibility DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateOrgOption IS 'CreateOrgOption options for creating an organization';
COMMENT ON COLUMN CreateOrgOption.visibility IS 'possible values are &#x60;public&#x60; (default), &#x60;limited&#x60; or &#x60;private&#x60;';

--
-- Table 'CreatePullRequestOption' generated from model 'CreatePullRequestOption'
-- CreatePullRequestOption options when creating a pull request
--
CREATE TABLE IF NOT EXISTS CreatePullRequestOption (
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    base TEXT DEFAULT NULL,
    body TEXT DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    head TEXT DEFAULT NULL,
    labels JSON DEFAULT NULL,
    milestone BIGINT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE CreatePullRequestOption IS 'CreatePullRequestOption options when creating a pull request';

--
-- Table 'CreatePullReviewComment' generated from model 'CreatePullReviewComment'
-- CreatePullReviewComment represent a review comment for creation api
--
CREATE TABLE IF NOT EXISTS CreatePullReviewComment (
    body TEXT DEFAULT NULL,
    extra_lines_count BIGINT DEFAULT NULL,
    new_position BIGINT DEFAULT NULL,
    old_position BIGINT DEFAULT NULL,
    "path" TEXT DEFAULT NULL
);
COMMENT ON TABLE CreatePullReviewComment IS 'CreatePullReviewComment represent a review comment for creation api';
COMMENT ON COLUMN CreatePullReviewComment.extra_lines_count IS 'number of additional lines after the commented line (0 &#x3D; single line comment)';
COMMENT ON COLUMN CreatePullReviewComment.new_position IS 'if comment to new file line or 0';
COMMENT ON COLUMN CreatePullReviewComment.old_position IS 'if comment to old file line or 0';
COMMENT ON COLUMN CreatePullReviewComment."path" IS 'the tree path';

--
-- Table 'CreatePullReviewOptions' generated from model 'CreatePullReviewOptions'
-- CreatePullReviewOptions are options to create a pull review
--
CREATE TABLE IF NOT EXISTS CreatePullReviewOptions (
    body TEXT DEFAULT NULL,
    "comments" JSON DEFAULT NULL,
    commit_id TEXT DEFAULT NULL,
    "event" TEXT DEFAULT NULL
);
COMMENT ON TABLE CreatePullReviewOptions IS 'CreatePullReviewOptions are options to create a pull review';
COMMENT ON COLUMN CreatePullReviewOptions."event" IS 'ReviewStateType review state type';

--
-- Table 'CreatePushMirrorOption' generated from model 'CreatePushMirrorOption'
--
CREATE TABLE IF NOT EXISTS CreatePushMirrorOption (
    branch_filter TEXT DEFAULT NULL,
    "interval" TEXT DEFAULT NULL,
    remote_address TEXT DEFAULT NULL,
    remote_password TEXT DEFAULT NULL,
    remote_username TEXT DEFAULT NULL,
    sync_on_commit BOOLEAN DEFAULT NULL,
    use_ssh BOOLEAN DEFAULT NULL
);
;

--
-- Table 'CreateQuotaGroupOptions' generated from model 'CreateQuotaGroupOptions'
-- CreateQutaGroupOptions represents the options for creating a quota group
--
CREATE TABLE IF NOT EXISTS CreateQuotaGroupOptions (
    "name" TEXT DEFAULT NULL,
    rules JSON DEFAULT NULL
);
COMMENT ON TABLE CreateQuotaGroupOptions IS 'CreateQutaGroupOptions represents the options for creating a quota group';
COMMENT ON COLUMN CreateQuotaGroupOptions."name" IS 'Name of the quota group to create';
COMMENT ON COLUMN CreateQuotaGroupOptions.rules IS 'Rules to add to the newly created group. If a rule does not exist, it will be created.';

--
-- Table 'CreateQuotaRuleOptions' generated from model 'CreateQuotaRuleOptions'
-- CreateQuotaRuleOptions represents the options for creating a quota rule
--
CREATE TABLE IF NOT EXISTS CreateQuotaRuleOptions (
    "limit" BIGINT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    subjects JSON DEFAULT NULL
);
COMMENT ON TABLE CreateQuotaRuleOptions IS 'CreateQuotaRuleOptions represents the options for creating a quota rule';
COMMENT ON COLUMN CreateQuotaRuleOptions."limit" IS 'The limit set by the rule';
COMMENT ON COLUMN CreateQuotaRuleOptions."name" IS 'Name of the rule to create';
COMMENT ON COLUMN CreateQuotaRuleOptions.subjects IS 'The subjects affected by the rule';

--
-- Table 'CreateReleaseOption' generated from model 'CreateReleaseOption'
-- CreateReleaseOption options when creating a release
--
CREATE TABLE IF NOT EXISTS CreateReleaseOption (
    body TEXT DEFAULT NULL,
    draft BOOLEAN DEFAULT NULL,
    hide_archive_links BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    prerelease BOOLEAN DEFAULT NULL,
    tag_name TEXT NOT NULL,
    target_commitish TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateReleaseOption IS 'CreateReleaseOption options when creating a release';

--
-- Table 'CreateRepoOption' generated from model 'CreateRepoOption'
-- CreateRepoOption options when creating repository
--
CREATE TABLE IF NOT EXISTS CreateRepoOption (
    auto_init BOOLEAN DEFAULT NULL,
    default_branch TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    gitignores TEXT DEFAULT NULL,
    issue_labels TEXT DEFAULT NULL,
    license TEXT DEFAULT NULL,
    "name" TEXT NOT NULL,
    object_format_name CreateRepoOption_objectUnderscoreformatUnderscorename DEFAULT NULL,
    "private" BOOLEAN DEFAULT NULL,
    readme TEXT DEFAULT NULL,
    "template" BOOLEAN DEFAULT NULL,
    trust_model CreateRepoOption_trustUnderscoremodel DEFAULT NULL
);
COMMENT ON TABLE CreateRepoOption IS 'CreateRepoOption options when creating repository';
COMMENT ON COLUMN CreateRepoOption.auto_init IS 'Whether the repository should be auto-initialized?';
COMMENT ON COLUMN CreateRepoOption.default_branch IS 'DefaultBranch of the repository (used when initializes and in template)';
COMMENT ON COLUMN CreateRepoOption.description IS 'Description of the repository to create';
COMMENT ON COLUMN CreateRepoOption.gitignores IS 'Gitignores to use, separated by commas';
COMMENT ON COLUMN CreateRepoOption.issue_labels IS 'Label-Set to use';
COMMENT ON COLUMN CreateRepoOption.license IS 'License to use';
COMMENT ON COLUMN CreateRepoOption."name" IS 'Name of the repository to create';
COMMENT ON COLUMN CreateRepoOption.object_format_name IS 'ObjectFormatName of the underlying git repository';
COMMENT ON COLUMN CreateRepoOption."private" IS 'Whether the repository is private';
COMMENT ON COLUMN CreateRepoOption.readme IS 'Readme of the repository to create';
COMMENT ON COLUMN CreateRepoOption."template" IS 'Whether the repository is template';
COMMENT ON COLUMN CreateRepoOption.trust_model IS 'TrustModel of the repository';

--
-- Table 'CreateStatusOption' generated from model 'CreateStatusOption'
-- CreateStatusOption holds the information needed to create a new CommitStatus for a Commit
--
CREATE TABLE IF NOT EXISTS CreateStatusOption (
    context TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    target_url TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateStatusOption IS 'CreateStatusOption holds the information needed to create a new CommitStatus for a Commit';
COMMENT ON COLUMN CreateStatusOption."state" IS 'CommitStatusState holds the state of a CommitStatus It can be \&quot;pending\&quot;, \&quot;success\&quot;, \&quot;error\&quot;, \&quot;failure\&quot;, \&quot;warning\&quot;, or \&quot;skipped\&quot;';

--
-- Table 'CreateTagOption' generated from model 'CreateTagOption'
-- CreateTagOption options when creating a tag
--
CREATE TABLE IF NOT EXISTS CreateTagOption (
    message TEXT DEFAULT NULL,
    tag_name TEXT NOT NULL,
    "target" TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateTagOption IS 'CreateTagOption options when creating a tag';

--
-- Table 'CreateTagProtectionOption' generated from model 'CreateTagProtectionOption'
-- CreateTagProtectionOption options for creating a tag protection
--
CREATE TABLE IF NOT EXISTS CreateTagProtectionOption (
    name_pattern TEXT DEFAULT NULL,
    whitelist_teams JSON DEFAULT NULL,
    whitelist_usernames JSON DEFAULT NULL
);
COMMENT ON TABLE CreateTagProtectionOption IS 'CreateTagProtectionOption options for creating a tag protection';

--
-- Table 'CreateTeamOption' generated from model 'CreateTeamOption'
-- CreateTeamOption options for creating a team
--
CREATE TABLE IF NOT EXISTS CreateTeamOption (
    can_create_org_repo BOOLEAN DEFAULT NULL,
    description TEXT DEFAULT NULL,
    includes_all_repositories BOOLEAN DEFAULT NULL,
    "name" TEXT NOT NULL,
    "permission" CreateTeamOption_permission DEFAULT NULL,
    units JSON DEFAULT NULL,
    units_map JSON DEFAULT NULL
);
COMMENT ON TABLE CreateTeamOption IS 'CreateTeamOption options for creating a team';
COMMENT ON COLUMN CreateTeamOption.units IS ' Deprecated: This variable should be replaced by UnitsMap and will be dropped in later versions.';

--
-- Table 'CreateUserOption' generated from model 'CreateUserOption'
-- CreateUserOption create user options
--
CREATE TABLE IF NOT EXISTS CreateUserOption (
    created_at TIMESTAMP DEFAULT NULL,
    email TEXT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    login_name TEXT DEFAULT NULL,
    must_change_password BOOLEAN DEFAULT NULL,
    "password" TEXT DEFAULT NULL,
    restricted BOOLEAN DEFAULT NULL,
    send_notify BOOLEAN DEFAULT NULL,
    source_id BIGINT DEFAULT NULL,
    username TEXT NOT NULL,
    visibility TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateUserOption IS 'CreateUserOption create user options';
COMMENT ON COLUMN CreateUserOption.created_at IS 'For explicitly setting the user creation timestamp. Useful when users are migrated from other systems. When omitted, the user&#39;s creation timestamp will be set to \&quot;now\&quot;.';

--
-- Table 'CreateVariableOption' generated from model 'CreateVariableOption'
--
CREATE TABLE IF NOT EXISTS CreateVariableOption (
    "value" TEXT NOT NULL
);
;
COMMENT ON COLUMN CreateVariableOption."value" IS 'Value of the variable to create. Special characters will be retained. Line endings will be normalized to LF to match the behaviour of browsers. Encode the data with Base64 if line endings should be retained.';

--
-- Table 'CreateWikiPageOptions' generated from model 'CreateWikiPageOptions'
-- CreateWikiPageOptions form for creating wiki
--
CREATE TABLE IF NOT EXISTS CreateWikiPageOptions (
    content_base64 TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE CreateWikiPageOptions IS 'CreateWikiPageOptions form for creating wiki';
COMMENT ON COLUMN CreateWikiPageOptions.content_base64 IS 'content must be base64 encoded';
COMMENT ON COLUMN CreateWikiPageOptions.message IS 'optional commit message summarizing the change';
COMMENT ON COLUMN CreateWikiPageOptions.title IS 'page title. leave empty to keep unchanged';

--
-- Table 'Cron' generated from model 'Cron'
-- Cron represents a Cron task
--
CREATE TABLE IF NOT EXISTS Cron (
    exec_times BIGINT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "next" TIMESTAMP DEFAULT NULL,
    "prev" TIMESTAMP DEFAULT NULL,
    schedule TEXT DEFAULT NULL
);
COMMENT ON TABLE Cron IS 'Cron represents a Cron task';

--
-- Table 'DeleteEmailOption' generated from model 'DeleteEmailOption'
-- DeleteEmailOption options when deleting email addresses
--
CREATE TABLE IF NOT EXISTS DeleteEmailOption (
    emails JSON DEFAULT NULL
);
COMMENT ON TABLE DeleteEmailOption IS 'DeleteEmailOption options when deleting email addresses';
COMMENT ON COLUMN DeleteEmailOption.emails IS 'email addresses to delete';

--
-- Table 'DeleteFileOptions' generated from model 'DeleteFileOptions'
-- DeleteFileOptions options for deleting files (used for other File structs below) Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
--
CREATE TABLE IF NOT EXISTS DeleteFileOptions (
    author TEXT DEFAULT NULL,
    branch TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    dates TEXT DEFAULT NULL,
    force_overwrite_new_branch BOOLEAN DEFAULT NULL,
    message TEXT DEFAULT NULL,
    new_branch TEXT DEFAULT NULL,
    sha TEXT NOT NULL,
    signoff BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE DeleteFileOptions IS 'DeleteFileOptions options for deleting files (used for other File structs below) Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)';
COMMENT ON COLUMN DeleteFileOptions.branch IS 'branch (optional) to base this file from. if not given, the default branch is used';
COMMENT ON COLUMN DeleteFileOptions.force_overwrite_new_branch IS '(optional) will do a force-push if the new branch already exists';
COMMENT ON COLUMN DeleteFileOptions.message IS 'message (optional) for the commit of this file. if not supplied, a default message will be used';
COMMENT ON COLUMN DeleteFileOptions.new_branch IS 'new_branch (optional) will make a new branch from &#x60;branch&#x60; before creating the file';
COMMENT ON COLUMN DeleteFileOptions.sha IS 'sha is the SHA for the file that already exists';
COMMENT ON COLUMN DeleteFileOptions.signoff IS 'Add a Signed-off-by trailer by the committer at the end of the commit log message.';

--
-- Table 'DeleteLabelsOption' generated from model 'DeleteLabelsOption'
-- DeleteLabelOption options for deleting a label
--
CREATE TABLE IF NOT EXISTS DeleteLabelsOption (
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE DeleteLabelsOption IS 'DeleteLabelOption options for deleting a label';

--
-- Table 'DeployKey' generated from model 'DeployKey'
-- DeployKey a deploy key
--
CREATE TABLE IF NOT EXISTS DeployKey (
    created_at TIMESTAMP DEFAULT NULL,
    fingerprint TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "key" TEXT DEFAULT NULL,
    key_id BIGINT DEFAULT NULL,
    read_only BOOLEAN DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE DeployKey IS 'DeployKey a deploy key';

--
-- Table 'DismissPullReviewOptions' generated from model 'DismissPullReviewOptions'
-- DismissPullReviewOptions are options to dismiss a pull review
--
CREATE TABLE IF NOT EXISTS DismissPullReviewOptions (
    message TEXT DEFAULT NULL,
    priors BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE DismissPullReviewOptions IS 'DismissPullReviewOptions are options to dismiss a pull review';

--
-- Table 'DispatchWorkflowOption' generated from model 'DispatchWorkflowOption'
-- DispatchWorkflowOption options when dispatching a workflow
--
CREATE TABLE IF NOT EXISTS DispatchWorkflowOption (
    inputs JSON DEFAULT NULL,
    "ref" TEXT NOT NULL,
    return_run_info BOOLEAN DEFAULT 'false'
);
COMMENT ON TABLE DispatchWorkflowOption IS 'DispatchWorkflowOption options when dispatching a workflow';
COMMENT ON COLUMN DispatchWorkflowOption.inputs IS 'Input keys and values configured in the workflow file.';
COMMENT ON COLUMN DispatchWorkflowOption."ref" IS 'Git reference for the workflow';
COMMENT ON COLUMN DispatchWorkflowOption.return_run_info IS 'Flag to return the run info';

--
-- Table 'DispatchWorkflowRun' generated from model 'DispatchWorkflowRun'
-- DispatchWorkflowRun represents a workflow run
--
CREATE TABLE IF NOT EXISTS DispatchWorkflowRun (
    "id" BIGSERIAL,
    jobs JSON DEFAULT NULL,
    run_number BIGINT DEFAULT NULL
);
COMMENT ON TABLE DispatchWorkflowRun IS 'DispatchWorkflowRun represents a workflow run';
COMMENT ON COLUMN DispatchWorkflowRun."id" IS 'the workflow run id';
COMMENT ON COLUMN DispatchWorkflowRun.jobs IS 'the jobs name';
COMMENT ON COLUMN DispatchWorkflowRun.run_number IS 'a unique number for each run of a repository';

--
-- Table 'EditAttachmentOptions' generated from model 'EditAttachmentOptions'
-- EditAttachmentOptions options for editing attachments
--
CREATE TABLE IF NOT EXISTS EditAttachmentOptions (
    browser_download_url TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE EditAttachmentOptions IS 'EditAttachmentOptions options for editing attachments';
COMMENT ON COLUMN EditAttachmentOptions.browser_download_url IS '(Can only be set if existing attachment is of external type)';

--
-- Table 'EditBranchProtectionOption' generated from model 'EditBranchProtectionOption'
-- EditBranchProtectionOption options for editing a branch protection
--
CREATE TABLE IF NOT EXISTS EditBranchProtectionOption (
    apply_to_admins BOOLEAN DEFAULT NULL,
    approvals_whitelist_teams JSON DEFAULT NULL,
    approvals_whitelist_username JSON DEFAULT NULL,
    block_on_official_review_requests BOOLEAN DEFAULT NULL,
    block_on_outdated_branch BOOLEAN DEFAULT NULL,
    block_on_rejected_reviews BOOLEAN DEFAULT NULL,
    dismiss_stale_approvals BOOLEAN DEFAULT NULL,
    enable_approvals_whitelist BOOLEAN DEFAULT NULL,
    enable_merge_whitelist BOOLEAN DEFAULT NULL,
    enable_push BOOLEAN DEFAULT NULL,
    enable_push_whitelist BOOLEAN DEFAULT NULL,
    enable_status_check BOOLEAN DEFAULT NULL,
    ignore_stale_approvals BOOLEAN DEFAULT NULL,
    merge_whitelist_teams JSON DEFAULT NULL,
    merge_whitelist_usernames JSON DEFAULT NULL,
    protected_file_patterns TEXT DEFAULT NULL,
    push_whitelist_deploy_keys BOOLEAN DEFAULT NULL,
    push_whitelist_teams JSON DEFAULT NULL,
    push_whitelist_usernames JSON DEFAULT NULL,
    require_signed_commits BOOLEAN DEFAULT NULL,
    required_approvals BIGINT DEFAULT NULL,
    status_check_contexts JSON DEFAULT NULL,
    unprotected_file_patterns TEXT DEFAULT NULL
);
COMMENT ON TABLE EditBranchProtectionOption IS 'EditBranchProtectionOption options for editing a branch protection';

--
-- Table 'EditDeadlineOption' generated from model 'EditDeadlineOption'
-- EditDeadlineOption options for creating a deadline
--
CREATE TABLE IF NOT EXISTS EditDeadlineOption (
    due_date TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE EditDeadlineOption IS 'EditDeadlineOption options for creating a deadline';

--
-- Table 'EditGitHookOption' generated from model 'EditGitHookOption'
-- EditGitHookOption options when modifying one Git hook
--
CREATE TABLE IF NOT EXISTS EditGitHookOption (
    "content" TEXT DEFAULT NULL
);
COMMENT ON TABLE EditGitHookOption IS 'EditGitHookOption options when modifying one Git hook';

--
-- Table 'EditHookOption' generated from model 'EditHookOption'
-- EditHookOption options when modify one hook
--
CREATE TABLE IF NOT EXISTS EditHookOption (
    active BOOLEAN DEFAULT NULL,
    authorization_header TEXT DEFAULT NULL,
    branch_filter TEXT DEFAULT NULL,
    config JSON DEFAULT NULL,
    events JSON DEFAULT NULL
);
COMMENT ON TABLE EditHookOption IS 'EditHookOption options when modify one hook';

--
-- Table 'EditIssueCommentOption' generated from model 'EditIssueCommentOption'
-- EditIssueCommentOption options for editing a comment
--
CREATE TABLE IF NOT EXISTS EditIssueCommentOption (
    body TEXT NOT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE EditIssueCommentOption IS 'EditIssueCommentOption options for editing a comment';
COMMENT ON COLUMN EditIssueCommentOption.body IS 'The body of the comment';
COMMENT ON COLUMN EditIssueCommentOption.updated_at IS 'The time of the comment&#39;s update, needs admin or repository owner permission';

--
-- Table 'EditIssueOption' generated from model 'EditIssueOption'
-- EditIssueOption options for editing an issue
--
CREATE TABLE IF NOT EXISTS EditIssueOption (
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    body TEXT DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    milestone BIGINT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    unset_due_date BOOLEAN DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE EditIssueOption IS 'EditIssueOption options for editing an issue';
COMMENT ON COLUMN EditIssueOption.assignee IS 'deprecated';

--
-- Table 'EditLabelOption' generated from model 'EditLabelOption'
-- EditLabelOption options for editing a label
--
CREATE TABLE IF NOT EXISTS EditLabelOption (
    color TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "exclusive" BOOLEAN DEFAULT NULL,
    is_archived BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE EditLabelOption IS 'EditLabelOption options for editing a label';

--
-- Table 'EditMilestoneOption' generated from model 'EditMilestoneOption'
-- EditMilestoneOption options for editing a milestone
--
CREATE TABLE IF NOT EXISTS EditMilestoneOption (
    description TEXT DEFAULT NULL,
    due_on TIMESTAMP DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE EditMilestoneOption IS 'EditMilestoneOption options for editing a milestone';

--
-- Table 'EditOrgOption' generated from model 'EditOrgOption'
-- EditOrgOption options for editing an organization
--
CREATE TABLE IF NOT EXISTS EditOrgOption (
    description TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    repo_admin_change_team_access BOOLEAN DEFAULT NULL,
    visibility EditOrgOption_visibility DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE EditOrgOption IS 'EditOrgOption options for editing an organization';
COMMENT ON COLUMN EditOrgOption.visibility IS 'possible values are &#x60;public&#x60;, &#x60;limited&#x60; or &#x60;private&#x60;';

--
-- Table 'EditPullRequestOption' generated from model 'EditPullRequestOption'
-- EditPullRequestOption options when modify pull request
--
CREATE TABLE IF NOT EXISTS EditPullRequestOption (
    allow_maintainer_edit BOOLEAN DEFAULT NULL,
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    base TEXT DEFAULT NULL,
    body TEXT DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    labels JSON DEFAULT NULL,
    milestone BIGINT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    unset_due_date BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE EditPullRequestOption IS 'EditPullRequestOption options when modify pull request';

--
-- Table 'EditQuotaRuleOptions' generated from model 'EditQuotaRuleOptions'
-- EditQuotaRuleOptions represents the options for editing a quota rule
--
CREATE TABLE IF NOT EXISTS EditQuotaRuleOptions (
    "limit" BIGINT DEFAULT NULL,
    subjects JSON DEFAULT NULL
);
COMMENT ON TABLE EditQuotaRuleOptions IS 'EditQuotaRuleOptions represents the options for editing a quota rule';
COMMENT ON COLUMN EditQuotaRuleOptions."limit" IS 'The limit set by the rule';
COMMENT ON COLUMN EditQuotaRuleOptions.subjects IS 'The subjects affected by the rule';

--
-- Table 'EditReactionOption' generated from model 'EditReactionOption'
-- EditReactionOption contain the reaction type
--
CREATE TABLE IF NOT EXISTS EditReactionOption (
    "content" TEXT DEFAULT NULL
);
COMMENT ON TABLE EditReactionOption IS 'EditReactionOption contain the reaction type';

--
-- Table 'EditReleaseOption' generated from model 'EditReleaseOption'
-- EditReleaseOption options when editing a release
--
CREATE TABLE IF NOT EXISTS EditReleaseOption (
    body TEXT DEFAULT NULL,
    draft BOOLEAN DEFAULT NULL,
    hide_archive_links BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    prerelease BOOLEAN DEFAULT NULL,
    tag_name TEXT DEFAULT NULL,
    target_commitish TEXT DEFAULT NULL
);
COMMENT ON TABLE EditReleaseOption IS 'EditReleaseOption options when editing a release';

--
-- Table 'EditRepoOption' generated from model 'EditRepoOption'
-- EditRepoOption options when editing a repository&#39;s properties
--
CREATE TABLE IF NOT EXISTS EditRepoOption (
    allow_fast_forward_only_merge BOOLEAN DEFAULT NULL,
    allow_manual_merge BOOLEAN DEFAULT NULL,
    allow_merge_commits BOOLEAN DEFAULT NULL,
    allow_rebase BOOLEAN DEFAULT NULL,
    allow_rebase_explicit BOOLEAN DEFAULT NULL,
    allow_rebase_update BOOLEAN DEFAULT NULL,
    allow_squash_merge BOOLEAN DEFAULT NULL,
    archived BOOLEAN DEFAULT NULL,
    autodetect_manual_merge BOOLEAN DEFAULT NULL,
    default_allow_maintainer_edit BOOLEAN DEFAULT NULL,
    default_branch TEXT DEFAULT NULL,
    default_delete_branch_after_merge BOOLEAN DEFAULT NULL,
    default_merge_style TEXT DEFAULT NULL,
    default_update_style TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    enable_prune BOOLEAN DEFAULT NULL,
    external_tracker TEXT DEFAULT NULL,
    external_wiki TEXT DEFAULT NULL,
    globally_editable_wiki BOOLEAN DEFAULT NULL,
    has_actions BOOLEAN DEFAULT NULL,
    has_issues BOOLEAN DEFAULT NULL,
    has_packages BOOLEAN DEFAULT NULL,
    has_projects BOOLEAN DEFAULT NULL,
    has_pull_requests BOOLEAN DEFAULT NULL,
    has_releases BOOLEAN DEFAULT NULL,
    has_wiki BOOLEAN DEFAULT NULL,
    ignore_whitespace_conflicts BOOLEAN DEFAULT NULL,
    internal_tracker TEXT DEFAULT NULL,
    mirror_interval TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "private" BOOLEAN DEFAULT NULL,
    "template" BOOLEAN DEFAULT NULL,
    website TEXT DEFAULT NULL,
    wiki_branch TEXT DEFAULT NULL
);
COMMENT ON TABLE EditRepoOption IS 'EditRepoOption options when editing a repository&#39;s properties';
COMMENT ON COLUMN EditRepoOption.allow_fast_forward_only_merge IS 'either &#x60;true&#x60; to allow fast-forward-only merging pull requests, or &#x60;false&#x60; to prevent fast-forward-only merging.';
COMMENT ON COLUMN EditRepoOption.allow_manual_merge IS 'either &#x60;true&#x60; to allow mark pr as merged manually, or &#x60;false&#x60; to prevent it.';
COMMENT ON COLUMN EditRepoOption.allow_merge_commits IS 'either &#x60;true&#x60; to allow merging pull requests with a merge commit, or &#x60;false&#x60; to prevent merging pull requests with merge commits.';
COMMENT ON COLUMN EditRepoOption.allow_rebase IS 'either &#x60;true&#x60; to allow rebase-merging pull requests, or &#x60;false&#x60; to prevent rebase-merging.';
COMMENT ON COLUMN EditRepoOption.allow_rebase_explicit IS 'either &#x60;true&#x60; to allow rebase with explicit merge commits (--no-ff), or &#x60;false&#x60; to prevent rebase with explicit merge commits.';
COMMENT ON COLUMN EditRepoOption.allow_rebase_update IS 'either &#x60;true&#x60; to allow updating pull request branch by rebase, or &#x60;false&#x60; to prevent it.';
COMMENT ON COLUMN EditRepoOption.allow_squash_merge IS 'either &#x60;true&#x60; to allow squash-merging pull requests, or &#x60;false&#x60; to prevent squash-merging.';
COMMENT ON COLUMN EditRepoOption.archived IS 'set to &#x60;true&#x60; to archive this repository.';
COMMENT ON COLUMN EditRepoOption.autodetect_manual_merge IS 'either &#x60;true&#x60; to enable AutodetectManualMerge, or &#x60;false&#x60; to prevent it. Note: In some special cases, misjudgments can occur.';
COMMENT ON COLUMN EditRepoOption.default_allow_maintainer_edit IS 'set to &#x60;true&#x60; to allow edits from maintainers by default';
COMMENT ON COLUMN EditRepoOption.default_branch IS 'sets the default branch for this repository.';
COMMENT ON COLUMN EditRepoOption.default_delete_branch_after_merge IS 'set to &#x60;true&#x60; to delete pr branch after merge by default';
COMMENT ON COLUMN EditRepoOption.default_merge_style IS 'set to a merge style to be used by this repository: \&quot;merge\&quot;, \&quot;rebase\&quot;, \&quot;rebase-merge\&quot;, \&quot;squash\&quot;, \&quot;fast-forward-only\&quot;, \&quot;manually-merged\&quot;, or \&quot;rebase-update-only\&quot;.';
COMMENT ON COLUMN EditRepoOption.default_update_style IS 'set to a update style to be used by this repository: \&quot;rebase\&quot; or \&quot;merge\&quot;';
COMMENT ON COLUMN EditRepoOption.description IS 'a short description of the repository.';
COMMENT ON COLUMN EditRepoOption.enable_prune IS 'enable prune - remove obsolete remote-tracking references when mirroring';
COMMENT ON COLUMN EditRepoOption.globally_editable_wiki IS 'set the globally editable state of the wiki';
COMMENT ON COLUMN EditRepoOption.has_actions IS 'either &#x60;true&#x60; to enable actions unit, or &#x60;false&#x60; to disable them.';
COMMENT ON COLUMN EditRepoOption.has_issues IS 'either &#x60;true&#x60; to enable issues for this repository or &#x60;false&#x60; to disable them.';
COMMENT ON COLUMN EditRepoOption.has_packages IS 'either &#x60;true&#x60; to enable packages unit, or &#x60;false&#x60; to disable them.';
COMMENT ON COLUMN EditRepoOption.has_projects IS 'either &#x60;true&#x60; to enable project unit, or &#x60;false&#x60; to disable them.';
COMMENT ON COLUMN EditRepoOption.has_pull_requests IS 'either &#x60;true&#x60; to allow pull requests, or &#x60;false&#x60; to prevent pull request.';
COMMENT ON COLUMN EditRepoOption.has_releases IS 'either &#x60;true&#x60; to enable releases unit, or &#x60;false&#x60; to disable them.';
COMMENT ON COLUMN EditRepoOption.has_wiki IS 'either &#x60;true&#x60; to enable the wiki for this repository or &#x60;false&#x60; to disable it.';
COMMENT ON COLUMN EditRepoOption.ignore_whitespace_conflicts IS 'either &#x60;true&#x60; to ignore whitespace for conflicts, or &#x60;false&#x60; to not ignore whitespace.';
COMMENT ON COLUMN EditRepoOption.mirror_interval IS 'set to a string like &#x60;8h30m0s&#x60; to set the mirror interval time';
COMMENT ON COLUMN EditRepoOption."name" IS 'name of the repository';
COMMENT ON COLUMN EditRepoOption."private" IS 'either &#x60;true&#x60; to make the repository private or &#x60;false&#x60; to make it public. Note: you will get a 422 error if the organization restricts changing repository visibility to organization owners and a non-owner tries to change the value of private.';
COMMENT ON COLUMN EditRepoOption."template" IS 'either &#x60;true&#x60; to make this repository a template or &#x60;false&#x60; to make it a normal repository';
COMMENT ON COLUMN EditRepoOption.website IS 'a URL with more information about the repository.';
COMMENT ON COLUMN EditRepoOption.wiki_branch IS 'sets the branch used for this repository&#39;s wiki.';

--
-- Table 'EditTagProtectionOption' generated from model 'EditTagProtectionOption'
-- EditTagProtectionOption options for editing a tag protection
--
CREATE TABLE IF NOT EXISTS EditTagProtectionOption (
    name_pattern TEXT DEFAULT NULL,
    whitelist_teams JSON DEFAULT NULL,
    whitelist_usernames JSON DEFAULT NULL
);
COMMENT ON TABLE EditTagProtectionOption IS 'EditTagProtectionOption options for editing a tag protection';

--
-- Table 'EditTeamOption' generated from model 'EditTeamOption'
-- EditTeamOption options for editing a team
--
CREATE TABLE IF NOT EXISTS EditTeamOption (
    can_create_org_repo BOOLEAN DEFAULT NULL,
    description TEXT DEFAULT NULL,
    includes_all_repositories BOOLEAN DEFAULT NULL,
    "name" TEXT NOT NULL,
    "permission" EditTeamOption_permission DEFAULT NULL,
    units JSON DEFAULT NULL,
    units_map JSON DEFAULT NULL
);
COMMENT ON TABLE EditTeamOption IS 'EditTeamOption options for editing a team';
COMMENT ON COLUMN EditTeamOption.units IS ' Deprecated: This variable should be replaced by UnitsMap and will be dropped in later versions.';

--
-- Table 'EditUserOption' generated from model 'EditUserOption'
-- EditUserOption edit user options
--
CREATE TABLE IF NOT EXISTS EditUserOption (
    active BOOLEAN DEFAULT NULL,
    "admin" BOOLEAN DEFAULT NULL,
    allow_create_organization BOOLEAN DEFAULT NULL,
    allow_git_hook BOOLEAN DEFAULT NULL,
    allow_import_local BOOLEAN DEFAULT NULL,
    description TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    hide_email BOOLEAN DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    login_name TEXT DEFAULT NULL,
    max_repo_creation BIGINT DEFAULT NULL,
    must_change_password BOOLEAN DEFAULT NULL,
    "password" TEXT DEFAULT NULL,
    prohibit_login BOOLEAN DEFAULT NULL,
    pronouns TEXT DEFAULT NULL,
    restricted BOOLEAN DEFAULT NULL,
    source_id BIGINT DEFAULT NULL,
    visibility TEXT DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE EditUserOption IS 'EditUserOption edit user options';

--
-- Table 'Email' generated from model 'Email'
-- Email an email address belonging to a user
--
CREATE TABLE IF NOT EXISTS Email (
    email TEXT DEFAULT NULL,
    "primary" BOOLEAN DEFAULT NULL,
    user_id BIGINT DEFAULT NULL,
    username TEXT DEFAULT NULL,
    verified BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE Email IS 'Email an email address belonging to a user';

--
-- Table 'ExternalTracker' generated from model 'ExternalTracker'
-- ExternalTracker represents settings for external tracker
--
CREATE TABLE IF NOT EXISTS ExternalTracker (
    external_tracker_format TEXT DEFAULT NULL,
    external_tracker_regexp_pattern TEXT DEFAULT NULL,
    external_tracker_style TEXT DEFAULT NULL,
    external_tracker_url TEXT DEFAULT NULL
);
COMMENT ON TABLE ExternalTracker IS 'ExternalTracker represents settings for external tracker';
COMMENT ON COLUMN ExternalTracker.external_tracker_format IS 'External Issue Tracker URL Format. Use the placeholders {user}, {repo} and {index} for the username, repository name and issue index.';
COMMENT ON COLUMN ExternalTracker.external_tracker_regexp_pattern IS 'External Issue Tracker issue regular expression';
COMMENT ON COLUMN ExternalTracker.external_tracker_style IS 'External Issue Tracker Number Format, either &#x60;numeric&#x60;, &#x60;alphanumeric&#x60;, or &#x60;regexp&#x60;';
COMMENT ON COLUMN ExternalTracker.external_tracker_url IS 'URL of external issue tracker.';

--
-- Table 'ExternalWiki' generated from model 'ExternalWiki'
-- ExternalWiki represents setting for external wiki
--
CREATE TABLE IF NOT EXISTS ExternalWiki (
    external_wiki_url TEXT DEFAULT NULL
);
COMMENT ON TABLE ExternalWiki IS 'ExternalWiki represents setting for external wiki';
COMMENT ON COLUMN ExternalWiki.external_wiki_url IS 'URL of external wiki.';

--
-- Table 'FileCommitResponse' generated from model 'FileCommitResponse'
--
CREATE TABLE IF NOT EXISTS FileCommitResponse (
    author TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    parents JSON DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    tree TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'FileDeleteResponse' generated from model 'FileDeleteResponse'
-- FileDeleteResponse contains information about a repo&#39;s file that was deleted
--
CREATE TABLE IF NOT EXISTS FileDeleteResponse (
    "commit" TEXT DEFAULT NULL,
    "content" JSON DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
COMMENT ON TABLE FileDeleteResponse IS 'FileDeleteResponse contains information about a repo&#39;s file that was deleted';

--
-- Table 'FileLinksResponse' generated from model 'FileLinksResponse'
-- FileLinksResponse contains the links for a repo&#39;s file
--
CREATE TABLE IF NOT EXISTS FileLinksResponse (
    git TEXT DEFAULT NULL,
    html TEXT DEFAULT NULL,
    "self" TEXT DEFAULT NULL
);
COMMENT ON TABLE FileLinksResponse IS 'FileLinksResponse contains the links for a repo&#39;s file';

--
-- Table 'FileResponse' generated from model 'FileResponse'
-- FileResponse contains information about a repo&#39;s file
--
CREATE TABLE IF NOT EXISTS FileResponse (
    "commit" TEXT DEFAULT NULL,
    "content" TEXT DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
COMMENT ON TABLE FileResponse IS 'FileResponse contains information about a repo&#39;s file';

--
-- Table 'FilesResponse' generated from model 'FilesResponse'
-- FilesResponse contains information about multiple files from a repo
--
CREATE TABLE IF NOT EXISTS FilesResponse (
    "commit" TEXT DEFAULT NULL,
    files JSON DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
COMMENT ON TABLE FilesResponse IS 'FilesResponse contains information about multiple files from a repo';

--
-- Table 'GPGKey' generated from model 'GPGKey'
-- GPGKey a user GPG key to sign commit and tag in repository
--
CREATE TABLE IF NOT EXISTS GPGKey (
    can_certify BOOLEAN DEFAULT NULL,
    can_encrypt_comms BOOLEAN DEFAULT NULL,
    can_encrypt_storage BOOLEAN DEFAULT NULL,
    can_sign BOOLEAN DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    emails JSON DEFAULT NULL,
    expires_at TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    key_id TEXT DEFAULT NULL,
    primary_key_id TEXT DEFAULT NULL,
    public_key TEXT DEFAULT NULL,
    subkeys JSON DEFAULT NULL,
    verified BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE GPGKey IS 'GPGKey a user GPG key to sign commit and tag in repository';

--
-- Table 'GPGKeyEmail' generated from model 'GPGKeyEmail'
-- GPGKeyEmail an email attached to a GPGKey
--
CREATE TABLE IF NOT EXISTS GPGKeyEmail (
    email TEXT DEFAULT NULL,
    verified BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE GPGKeyEmail IS 'GPGKeyEmail an email attached to a GPGKey';

--
-- Table 'GeneralAPISettings' generated from model 'GeneralAPISettings'
-- GeneralAPISettings contains global api settings exposed by it
--
CREATE TABLE IF NOT EXISTS GeneralAPISettings (
    default_git_trees_per_page BIGINT DEFAULT NULL,
    default_max_blob_size BIGINT DEFAULT NULL,
    default_paging_num BIGINT DEFAULT NULL,
    max_response_items BIGINT DEFAULT NULL
);
COMMENT ON TABLE GeneralAPISettings IS 'GeneralAPISettings contains global api settings exposed by it';

--
-- Table 'GeneralAttachmentSettings' generated from model 'GeneralAttachmentSettings'
-- GeneralAttachmentSettings contains global Attachment settings exposed by API
--
CREATE TABLE IF NOT EXISTS GeneralAttachmentSettings (
    allowed_types TEXT DEFAULT NULL,
    enabled BOOLEAN DEFAULT NULL,
    max_files BIGINT DEFAULT NULL,
    max_size BIGINT DEFAULT NULL
);
COMMENT ON TABLE GeneralAttachmentSettings IS 'GeneralAttachmentSettings contains global Attachment settings exposed by API';

--
-- Table 'GeneralRepoSettings' generated from model 'GeneralRepoSettings'
-- GeneralRepoSettings contains global repository settings exposed by API
--
CREATE TABLE IF NOT EXISTS GeneralRepoSettings (
    forks_disabled BOOLEAN DEFAULT NULL,
    http_git_disabled BOOLEAN DEFAULT NULL,
    lfs_disabled BOOLEAN DEFAULT NULL,
    migrations_disabled BOOLEAN DEFAULT NULL,
    mirrors_disabled BOOLEAN DEFAULT NULL,
    stars_disabled BOOLEAN DEFAULT NULL,
    time_tracking_disabled BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE GeneralRepoSettings IS 'GeneralRepoSettings contains global repository settings exposed by API';

--
-- Table 'GeneralUISettings' generated from model 'GeneralUISettings'
-- GeneralUISettings contains global ui settings exposed by API
--
CREATE TABLE IF NOT EXISTS GeneralUISettings (
    allowed_reactions JSON DEFAULT NULL,
    custom_emojis JSON DEFAULT NULL,
    default_theme TEXT DEFAULT NULL
);
COMMENT ON TABLE GeneralUISettings IS 'GeneralUISettings contains global ui settings exposed by API';

--
-- Table 'GenerateRepoOption' generated from model 'GenerateRepoOption'
-- GenerateRepoOption options when creating repository using a template
--
CREATE TABLE IF NOT EXISTS GenerateRepoOption (
    avatar BOOLEAN DEFAULT NULL,
    default_branch TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    git_content BOOLEAN DEFAULT NULL,
    git_hooks BOOLEAN DEFAULT NULL,
    labels BOOLEAN DEFAULT NULL,
    "name" TEXT NOT NULL,
    "owner" TEXT NOT NULL,
    "private" BOOLEAN DEFAULT NULL,
    protected_branch BOOLEAN DEFAULT NULL,
    topics BOOLEAN DEFAULT NULL,
    webhooks BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE GenerateRepoOption IS 'GenerateRepoOption options when creating repository using a template';
COMMENT ON COLUMN GenerateRepoOption.avatar IS 'include avatar of the template repo';
COMMENT ON COLUMN GenerateRepoOption.default_branch IS 'Default branch of the new repository';
COMMENT ON COLUMN GenerateRepoOption.description IS 'Description of the repository to create';
COMMENT ON COLUMN GenerateRepoOption.git_content IS 'include git content of default branch in template repo';
COMMENT ON COLUMN GenerateRepoOption.git_hooks IS 'include git hooks in template repo';
COMMENT ON COLUMN GenerateRepoOption.labels IS 'include labels in template repo';
COMMENT ON COLUMN GenerateRepoOption."name" IS 'Name of the repository to create';
COMMENT ON COLUMN GenerateRepoOption."owner" IS 'The organization or person who will own the new repository';
COMMENT ON COLUMN GenerateRepoOption."private" IS 'Whether the repository is private';
COMMENT ON COLUMN GenerateRepoOption.protected_branch IS 'include protected branches in template repo';
COMMENT ON COLUMN GenerateRepoOption.topics IS 'include topics in template repo';
COMMENT ON COLUMN GenerateRepoOption.webhooks IS 'include webhooks in template repo';

--
-- Table 'GitBlob' generated from model 'GitBlob'
-- GitBlob represents a git blob
--
CREATE TABLE IF NOT EXISTS GitBlob (
    "content" TEXT DEFAULT NULL,
    "encoding" TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE GitBlob IS 'GitBlob represents a git blob';

--
-- Table 'GitEntry' generated from model 'GitEntry'
-- GitEntry represents a git tree
--
CREATE TABLE IF NOT EXISTS GitEntry (
    "mode" TEXT DEFAULT NULL,
    "path" TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE GitEntry IS 'GitEntry represents a git tree';

--
-- Table 'GitHook' generated from model 'GitHook'
-- GitHook represents a Git repository hook
--
CREATE TABLE IF NOT EXISTS GitHook (
    "content" TEXT DEFAULT NULL,
    is_active BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE GitHook IS 'GitHook represents a Git repository hook';

--
-- Table 'GitObject' generated from model 'GitObject'
--
CREATE TABLE IF NOT EXISTS GitObject (
    sha TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'GitTreeResponse' generated from model 'GitTreeResponse'
-- GitTreeResponse returns a git tree
--
CREATE TABLE IF NOT EXISTS GitTreeResponse (
    page BIGINT DEFAULT NULL,
    sha TEXT DEFAULT NULL,
    total_count BIGINT DEFAULT NULL,
    tree JSON DEFAULT NULL,
    truncated BOOLEAN DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE GitTreeResponse IS 'GitTreeResponse returns a git tree';

--
-- Table 'GitignoreTemplateInfo' generated from model 'GitignoreTemplateInfo'
-- GitignoreTemplateInfo name and text of a gitignore template
--
CREATE TABLE IF NOT EXISTS GitignoreTemplateInfo (
    "name" TEXT DEFAULT NULL,
    "source" TEXT DEFAULT NULL
);
COMMENT ON TABLE GitignoreTemplateInfo IS 'GitignoreTemplateInfo name and text of a gitignore template';

--
-- Table 'Hook' generated from model 'Hook'
-- Hook a hook is a web hook when one repository changed
--
CREATE TABLE IF NOT EXISTS Hook (
    active BOOLEAN DEFAULT NULL,
    authorization_header TEXT DEFAULT NULL,
    branch_filter TEXT DEFAULT NULL,
    config JSON DEFAULT NULL,
    content_type TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    events JSON DEFAULT NULL,
    "id" BIGSERIAL,
    metadata JSON DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE Hook IS 'Hook a hook is a web hook when one repository changed';
COMMENT ON COLUMN Hook.config IS 'Deprecated: use Metadata instead';

--
-- Table 'Identity' generated from model 'Identity'
-- Identity for a person&#39;s identity like an author or committer
--
CREATE TABLE IF NOT EXISTS "Identity" (
    email TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE "Identity" IS 'Identity for a person&#39;s identity like an author or committer';

--
-- Table 'InternalTracker' generated from model 'InternalTracker'
-- InternalTracker represents settings for internal tracker
--
CREATE TABLE IF NOT EXISTS InternalTracker (
    allow_only_contributors_to_track_time BOOLEAN DEFAULT NULL,
    enable_issue_dependencies BOOLEAN DEFAULT NULL,
    enable_time_tracker BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE InternalTracker IS 'InternalTracker represents settings for internal tracker';
COMMENT ON COLUMN InternalTracker.allow_only_contributors_to_track_time IS 'Let only contributors track time (Built-in issue tracker)';
COMMENT ON COLUMN InternalTracker.enable_issue_dependencies IS 'Enable dependencies for issues and pull requests (Built-in issue tracker)';
COMMENT ON COLUMN InternalTracker.enable_time_tracker IS 'Enable time tracking (Built-in issue tracker)';

--
-- Table 'Issue' generated from model 'Issue'
-- Issue represents an issue in a repository
--
CREATE TABLE IF NOT EXISTS Issue (
    assets JSON DEFAULT NULL,
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    body TEXT DEFAULT NULL,
    closed_at TIMESTAMP DEFAULT NULL,
    "comments" BIGINT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    is_locked BOOLEAN DEFAULT NULL,
    labels JSON DEFAULT NULL,
    milestone TEXT DEFAULT NULL,
    "number" BIGINT DEFAULT NULL,
    original_author TEXT DEFAULT NULL,
    original_author_id BIGINT DEFAULT NULL,
    pin_order BIGINT DEFAULT NULL,
    pull_request TEXT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE Issue IS 'Issue represents an issue in a repository';
COMMENT ON COLUMN Issue."state" IS 'StateType issue state type';

--
-- Table 'IssueConfig' generated from model 'IssueConfig'
--
CREATE TABLE IF NOT EXISTS IssueConfig (
    blank_issues_enabled BOOLEAN DEFAULT NULL,
    contact_links JSON DEFAULT NULL
);
;

--
-- Table 'IssueConfigContactLink' generated from model 'IssueConfigContactLink'
--
CREATE TABLE IF NOT EXISTS IssueConfigContactLink (
    about TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'IssueConfigValidation' generated from model 'IssueConfigValidation'
--
CREATE TABLE IF NOT EXISTS IssueConfigValidation (
    message TEXT DEFAULT NULL,
    "valid" BOOLEAN DEFAULT NULL
);
;

--
-- Table 'IssueDeadline' generated from model 'IssueDeadline'
-- IssueDeadline represents an issue deadline
--
CREATE TABLE IF NOT EXISTS IssueDeadline (
    due_date TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE IssueDeadline IS 'IssueDeadline represents an issue deadline';

--
-- Table 'IssueFormField' generated from model 'IssueFormField'
-- IssueFormField represents a form field
--
CREATE TABLE IF NOT EXISTS IssueFormField (
    "attributes" JSON DEFAULT NULL,
    "id" TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    validations JSON DEFAULT NULL,
    visible JSON DEFAULT NULL
);
COMMENT ON TABLE IssueFormField IS 'IssueFormField represents a form field';

--
-- Table 'IssueLabelsOption' generated from model 'IssueLabelsOption'
-- IssueLabelsOption a collection of labels
--
CREATE TABLE IF NOT EXISTS IssueLabelsOption (
    labels JSON DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE IssueLabelsOption IS 'IssueLabelsOption a collection of labels';
COMMENT ON COLUMN IssueLabelsOption.labels IS 'Labels can be a list of integers representing label IDs or a list of strings representing label names';

--
-- Table 'IssueLockOption' generated from model 'IssueLockOption'
--
CREATE TABLE IF NOT EXISTS IssueLockOption (
    reason TEXT DEFAULT NULL
);
;

--
-- Table 'IssueMeta' generated from model 'IssueMeta'
-- IssueMeta basic issue information
--
CREATE TABLE IF NOT EXISTS IssueMeta (
    "index" BIGINT NOT NULL,
    "owner" TEXT NOT NULL,
    repo TEXT NOT NULL
);
COMMENT ON TABLE IssueMeta IS 'IssueMeta basic issue information';

--
-- Table 'IssueTemplate' generated from model 'IssueTemplate'
-- IssueTemplate represents an issue template for a repository
--
CREATE TABLE IF NOT EXISTS IssueTemplate (
    about TEXT DEFAULT NULL,
    body JSON DEFAULT NULL,
    "content" TEXT DEFAULT NULL,
    file_name TEXT DEFAULT NULL,
    labels JSON DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE IssueTemplate IS 'IssueTemplate represents an issue template for a repository';

--
-- Table 'Label' generated from model 'Label'
-- Label a label to an issue or a pr
--
CREATE TABLE IF NOT EXISTS "Label" (
    color TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "exclusive" BOOLEAN DEFAULT NULL,
    "id" BIGSERIAL,
    is_archived BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE "Label" IS 'Label a label to an issue or a pr';

--
-- Table 'LabelTemplate' generated from model 'LabelTemplate'
-- LabelTemplate info of a Label template
--
CREATE TABLE IF NOT EXISTS LabelTemplate (
    color TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "exclusive" BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE LabelTemplate IS 'LabelTemplate info of a Label template';

--
-- Table 'LicenseTemplateInfo' generated from model 'LicenseTemplateInfo'
-- LicensesInfo contains information about a License
--
CREATE TABLE IF NOT EXISTS LicenseTemplateInfo (
    body TEXT DEFAULT NULL,
    "implementation" TEXT DEFAULT NULL,
    "key" TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE LicenseTemplateInfo IS 'LicensesInfo contains information about a License';

--
-- Table 'LicensesTemplateListEntry' generated from model 'LicensesTemplateListEntry'
-- LicensesListEntry is used for the API
--
CREATE TABLE IF NOT EXISTS LicensesTemplateListEntry (
    "key" TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE LicensesTemplateListEntry IS 'LicensesListEntry is used for the API';

--
-- Table 'ListActionRunResponse' generated from model 'ListActionRunResponse'
-- ListActionRunResponse return a list of ActionRun
--
CREATE TABLE IF NOT EXISTS ListActionRunResponse (
    total_count BIGINT DEFAULT NULL,
    workflow_runs JSON DEFAULT NULL
);
COMMENT ON TABLE ListActionRunResponse IS 'ListActionRunResponse return a list of ActionRun';

--
-- Table 'MarkdownOption' generated from model 'MarkdownOption'
-- MarkdownOption markdown options
--
CREATE TABLE IF NOT EXISTS MarkdownOption (
    Context TEXT DEFAULT NULL,
    "Mode" TEXT DEFAULT NULL,
    "Text" TEXT DEFAULT NULL,
    Wiki BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE MarkdownOption IS 'MarkdownOption markdown options';
COMMENT ON COLUMN MarkdownOption.Context IS 'Context to render';
COMMENT ON COLUMN MarkdownOption."Mode" IS 'Mode to render (comment, gfm, markdown)';
COMMENT ON COLUMN MarkdownOption."Text" IS 'Text markdown to render';
COMMENT ON COLUMN MarkdownOption.Wiki IS 'Is it a wiki page ?';

--
-- Table 'MarkupOption' generated from model 'MarkupOption'
-- MarkupOption markup options
--
CREATE TABLE IF NOT EXISTS MarkupOption (
    BranchPath TEXT DEFAULT NULL,
    Context TEXT DEFAULT NULL,
    FilePath TEXT DEFAULT NULL,
    "Mode" TEXT DEFAULT NULL,
    "Text" TEXT DEFAULT NULL,
    Wiki BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE MarkupOption IS 'MarkupOption markup options';
COMMENT ON COLUMN MarkupOption.BranchPath IS 'The current branch path where the form gets posted';
COMMENT ON COLUMN MarkupOption.Context IS 'Context to render';
COMMENT ON COLUMN MarkupOption.FilePath IS 'File path for detecting extension in file mode';
COMMENT ON COLUMN MarkupOption."Mode" IS 'Mode to render (comment, gfm, markdown, file)';
COMMENT ON COLUMN MarkupOption."Text" IS 'Text markup to render';
COMMENT ON COLUMN MarkupOption.Wiki IS 'Is it a wiki page ?';

--
-- Table 'MergePullRequestOption' generated from model 'MergePullRequestOption'
-- MergePullRequestForm form for merging Pull Request
--
CREATE TABLE IF NOT EXISTS MergePullRequestOption (
    "Do" MergePullRequestOption_Do NOT NULL,
    MergeCommitID TEXT DEFAULT NULL,
    MergeMessageField TEXT DEFAULT NULL,
    MergeTitleField TEXT DEFAULT NULL,
    delete_branch_after_merge BOOLEAN DEFAULT NULL,
    force_merge BOOLEAN DEFAULT NULL,
    head_commit_id TEXT DEFAULT NULL,
    merge_when_checks_succeed BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE MergePullRequestOption IS 'MergePullRequestForm form for merging Pull Request';

--
-- Table 'MigrateRepoOptions' generated from model 'MigrateRepoOptions'
-- MigrateRepoOptions options for migrating repository&#39;s this is used to interact with api v1
--
CREATE TABLE IF NOT EXISTS MigrateRepoOptions (
    auth_password TEXT DEFAULT NULL,
    auth_token TEXT DEFAULT NULL,
    auth_username TEXT DEFAULT NULL,
    clone_addr TEXT NOT NULL,
    description TEXT DEFAULT NULL,
    issues BOOLEAN DEFAULT NULL,
    labels BOOLEAN DEFAULT NULL,
    lfs BOOLEAN DEFAULT NULL,
    lfs_endpoint TEXT DEFAULT NULL,
    milestones BOOLEAN DEFAULT NULL,
    mirror BOOLEAN DEFAULT NULL,
    mirror_interval TEXT DEFAULT NULL,
    "private" BOOLEAN DEFAULT NULL,
    pull_requests BOOLEAN DEFAULT NULL,
    releases BOOLEAN DEFAULT NULL,
    repo_name TEXT NOT NULL,
    repo_owner TEXT DEFAULT NULL,
    service MigrateRepoOptions_service DEFAULT NULL,
    uid BIGINT DEFAULT NULL,
    wiki BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE MigrateRepoOptions IS 'MigrateRepoOptions options for migrating repository&#39;s this is used to interact with api v1';
COMMENT ON COLUMN MigrateRepoOptions.repo_owner IS 'Name of User or Organisation who will own Repo after migration';
COMMENT ON COLUMN MigrateRepoOptions.uid IS 'deprecated (only for backwards compatibility)';

--
-- Table 'Milestone' generated from model 'Milestone'
-- Milestone milestone is a collection of issues on one repository
--
CREATE TABLE IF NOT EXISTS Milestone (
    closed_at TIMESTAMP DEFAULT NULL,
    closed_issues BIGINT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    description TEXT DEFAULT NULL,
    due_on TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    open_issues BIGINT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE Milestone IS 'Milestone milestone is a collection of issues on one repository';
COMMENT ON COLUMN Milestone."state" IS 'StateType issue state type';

--
-- Table 'NewIssuePinsAllowed' generated from model 'NewIssuePinsAllowed'
-- NewIssuePinsAllowed represents an API response that says if new Issue Pins are allowed
--
CREATE TABLE IF NOT EXISTS NewIssuePinsAllowed (
    issues BOOLEAN DEFAULT NULL,
    pull_requests BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE NewIssuePinsAllowed IS 'NewIssuePinsAllowed represents an API response that says if new Issue Pins are allowed';

--
-- Table 'NodeInfo' generated from model 'NodeInfo'
-- NodeInfo contains standardized way of exposing metadata about a server running one of the distributed social networks
--
CREATE TABLE IF NOT EXISTS NodeInfo (
    metadata JSON DEFAULT NULL,
    openRegistrations BOOLEAN DEFAULT NULL,
    protocols JSON DEFAULT NULL,
    services TEXT DEFAULT NULL,
    software TEXT DEFAULT NULL,
    "usage" TEXT DEFAULT NULL,
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE NodeInfo IS 'NodeInfo contains standardized way of exposing metadata about a server running one of the distributed social networks';

--
-- Table 'NodeInfoServices' generated from model 'NodeInfoServices'
-- NodeInfoServices contains the third party sites this server can connect to via their application API
--
CREATE TABLE IF NOT EXISTS NodeInfoServices (
    inbound JSON DEFAULT NULL,
    outbound JSON DEFAULT NULL
);
COMMENT ON TABLE NodeInfoServices IS 'NodeInfoServices contains the third party sites this server can connect to via their application API';

--
-- Table 'NodeInfoSoftware' generated from model 'NodeInfoSoftware'
-- NodeInfoSoftware contains Metadata about server software in use
--
CREATE TABLE IF NOT EXISTS NodeInfoSoftware (
    homepage TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE NodeInfoSoftware IS 'NodeInfoSoftware contains Metadata about server software in use';

--
-- Table 'NodeInfoUsage' generated from model 'NodeInfoUsage'
-- NodeInfoUsage contains usage statistics for this server
--
CREATE TABLE IF NOT EXISTS NodeInfoUsage (
    localComments BIGINT DEFAULT NULL,
    localPosts BIGINT DEFAULT NULL,
    users TEXT DEFAULT NULL
);
COMMENT ON TABLE NodeInfoUsage IS 'NodeInfoUsage contains usage statistics for this server';

--
-- Table 'NodeInfoUsageUsers' generated from model 'NodeInfoUsageUsers'
-- NodeInfoUsageUsers contains statistics about the users of this server
--
CREATE TABLE IF NOT EXISTS NodeInfoUsageUsers (
    activeHalfyear BIGINT DEFAULT NULL,
    activeMonth BIGINT DEFAULT NULL,
    total BIGINT DEFAULT NULL
);
COMMENT ON TABLE NodeInfoUsageUsers IS 'NodeInfoUsageUsers contains statistics about the users of this server';

--
-- Table 'Note' generated from model 'Note'
-- Note contains information related to a git note
--
CREATE TABLE IF NOT EXISTS Note (
    "commit" TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL
);
COMMENT ON TABLE Note IS 'Note contains information related to a git note';

--
-- Table 'NoteOptions' generated from model 'NoteOptions'
--
CREATE TABLE IF NOT EXISTS NoteOptions (
    message TEXT DEFAULT NULL
);
;

--
-- Table 'NotificationCount' generated from model 'NotificationCount'
-- NotificationCount number of unread notifications
--
CREATE TABLE IF NOT EXISTS NotificationCount (
    "new" BIGINT DEFAULT NULL
);
COMMENT ON TABLE NotificationCount IS 'NotificationCount number of unread notifications';

--
-- Table 'NotificationSubject' generated from model 'NotificationSubject'
-- NotificationSubject contains the notification subject (Issue/Pull/Commit)
--
CREATE TABLE IF NOT EXISTS NotificationSubject (
    html_url TEXT DEFAULT NULL,
    latest_comment_html_url TEXT DEFAULT NULL,
    latest_comment_url TEXT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE NotificationSubject IS 'NotificationSubject contains the notification subject (Issue/Pull/Commit)';
COMMENT ON COLUMN NotificationSubject."state" IS 'StateType issue state type';
COMMENT ON COLUMN NotificationSubject."type" IS 'NotifySubjectType represent type of notification subject';

--
-- Table 'NotificationThread' generated from model 'NotificationThread'
-- NotificationThread expose Notification on API
--
CREATE TABLE IF NOT EXISTS NotificationThread (
    "id" BIGSERIAL,
    pinned BOOLEAN DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    subject TEXT DEFAULT NULL,
    unread BOOLEAN DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE NotificationThread IS 'NotificationThread expose Notification on API';

--
-- Table 'OAuth2Application' generated from model 'OAuth2Application'
--
CREATE TABLE IF NOT EXISTS OAuth2Application (
    client_id TEXT DEFAULT NULL,
    client_secret TEXT DEFAULT NULL,
    confidential_client BOOLEAN DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    redirect_uris JSON DEFAULT NULL
);
;

--
-- Table 'Organization' generated from model 'Organization'
-- Organization represents an organization
--
CREATE TABLE IF NOT EXISTS Organization (
    avatar_url TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    description TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "location" TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    repo_admin_change_team_access BOOLEAN DEFAULT NULL,
    username TEXT DEFAULT NULL,
    visibility TEXT DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE Organization IS 'Organization represents an organization';
COMMENT ON COLUMN Organization.username IS 'deprecated';

--
-- Table 'OrganizationPermissions' generated from model 'OrganizationPermissions'
-- OrganizationPermissions list different users permissions on an organization
--
CREATE TABLE IF NOT EXISTS OrganizationPermissions (
    can_create_repository BOOLEAN DEFAULT NULL,
    can_read BOOLEAN DEFAULT NULL,
    can_write BOOLEAN DEFAULT NULL,
    is_admin BOOLEAN DEFAULT NULL,
    is_owner BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE OrganizationPermissions IS 'OrganizationPermissions list different users permissions on an organization';

--
-- Table 'PRBranchInfo' generated from model 'PRBranchInfo'
-- PRBranchInfo information about a branch
--
CREATE TABLE IF NOT EXISTS PRBranchInfo (
    "label" TEXT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    repo TEXT DEFAULT NULL,
    repo_id BIGINT DEFAULT NULL,
    sha TEXT DEFAULT NULL
);
COMMENT ON TABLE PRBranchInfo IS 'PRBranchInfo information about a branch';

--
-- Table 'Package' generated from model 'Package'
-- Package represents a package
--
CREATE TABLE IF NOT EXISTS Package (
    created_at TIMESTAMP DEFAULT NULL,
    creator TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    "owner" TEXT DEFAULT NULL,
    repository TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE Package IS 'Package represents a package';

--
-- Table 'PackageFile' generated from model 'PackageFile'
-- PackageFile represents a package file
--
CREATE TABLE IF NOT EXISTS PackageFile (
    "Size" BIGINT DEFAULT NULL,
    "id" BIGSERIAL,
    md5 TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    sha1 TEXT DEFAULT NULL,
    sha256 TEXT DEFAULT NULL,
    sha512 TEXT DEFAULT NULL
);
COMMENT ON TABLE PackageFile IS 'PackageFile represents a package file';

--
-- Table 'PayloadCommit' generated from model 'PayloadCommit'
-- PayloadCommit represents a commit
--
CREATE TABLE IF NOT EXISTS PayloadCommit (
    added JSON DEFAULT NULL,
    author TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    "id" TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    modified JSON DEFAULT NULL,
    removed JSON DEFAULT NULL,
    "timestamp" TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
COMMENT ON TABLE PayloadCommit IS 'PayloadCommit represents a commit';
COMMENT ON COLUMN PayloadCommit."id" IS 'sha1 hash of the commit';

--
-- Table 'PayloadCommitVerification' generated from model 'PayloadCommitVerification'
-- PayloadCommitVerification represents the GPG verification of a commit
--
CREATE TABLE IF NOT EXISTS PayloadCommitVerification (
    payload TEXT DEFAULT NULL,
    reason TEXT DEFAULT NULL,
    signature TEXT DEFAULT NULL,
    signer TEXT DEFAULT NULL,
    verified BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE PayloadCommitVerification IS 'PayloadCommitVerification represents the GPG verification of a commit';

--
-- Table 'PayloadUser' generated from model 'PayloadUser'
-- PayloadUser represents the author or committer of a commit
--
CREATE TABLE IF NOT EXISTS PayloadUser (
    email TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    username TEXT DEFAULT NULL
);
COMMENT ON TABLE PayloadUser IS 'PayloadUser represents the author or committer of a commit';
COMMENT ON COLUMN PayloadUser."name" IS 'Full name of the commit author';

--
-- Table 'Permission' generated from model 'Permission'
-- Permission represents a set of permissions
--
CREATE TABLE IF NOT EXISTS "Permission" (
    "admin" BOOLEAN DEFAULT NULL,
    pull BOOLEAN DEFAULT NULL,
    push BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE "Permission" IS 'Permission represents a set of permissions';

--
-- Table 'PublicKey' generated from model 'PublicKey'
-- PublicKey publickey is a user key to push code to repository
--
CREATE TABLE IF NOT EXISTS PublicKey (
    created_at TIMESTAMP DEFAULT NULL,
    fingerprint TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "key" TEXT DEFAULT NULL,
    "key_type" TEXT DEFAULT NULL,
    read_only BOOLEAN DEFAULT NULL,
    title TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    "user" TEXT DEFAULT NULL,
    verified BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE PublicKey IS 'PublicKey publickey is a user key to push code to repository';

--
-- Table 'PullRequest' generated from model 'PullRequest'
-- PullRequest represents a pull request
--
CREATE TABLE IF NOT EXISTS PullRequest (
    additions BIGINT DEFAULT NULL,
    allow_maintainer_edit BOOLEAN DEFAULT NULL,
    assignee TEXT DEFAULT NULL,
    assignees JSON DEFAULT NULL,
    base TEXT DEFAULT NULL,
    body TEXT DEFAULT NULL,
    changed_files BIGINT DEFAULT NULL,
    closed_at TIMESTAMP DEFAULT NULL,
    "comments" BIGINT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    deletions BIGINT DEFAULT NULL,
    diff_url TEXT DEFAULT NULL,
    draft BOOLEAN DEFAULT NULL,
    due_date TIMESTAMP DEFAULT NULL,
    flow BIGINT DEFAULT NULL,
    head TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    is_locked BOOLEAN DEFAULT NULL,
    labels JSON DEFAULT NULL,
    merge_base TEXT DEFAULT NULL,
    merge_commit_sha TEXT DEFAULT NULL,
    mergeable BOOLEAN DEFAULT NULL,
    merged BOOLEAN DEFAULT NULL,
    merged_at TIMESTAMP DEFAULT NULL,
    merged_by TEXT DEFAULT NULL,
    milestone TEXT DEFAULT NULL,
    "number" BIGINT DEFAULT NULL,
    patch_url TEXT DEFAULT NULL,
    pin_order BIGINT DEFAULT NULL,
    requested_reviewers JSON DEFAULT NULL,
    requested_reviewers_teams JSON DEFAULT NULL,
    review_comments BIGINT DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE PullRequest IS 'PullRequest represents a pull request';
COMMENT ON COLUMN PullRequest.review_comments IS 'number of review comments made on the diff of a PR review (not including comments on commits or issues in a PR)';
COMMENT ON COLUMN PullRequest."state" IS 'StateType issue state type';

--
-- Table 'PullRequestMeta' generated from model 'PullRequestMeta'
-- PullRequestMeta PR info if an issue is a PR
--
CREATE TABLE IF NOT EXISTS PullRequestMeta (
    draft BOOLEAN DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    merged BOOLEAN DEFAULT NULL,
    merged_at TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE PullRequestMeta IS 'PullRequestMeta PR info if an issue is a PR';

--
-- Table 'PullReview' generated from model 'PullReview'
-- PullReview represents a pull request review
--
CREATE TABLE IF NOT EXISTS PullReview (
    body TEXT DEFAULT NULL,
    comments_count BIGINT DEFAULT NULL,
    commit_id TEXT DEFAULT NULL,
    dismissed BOOLEAN DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    official BOOLEAN DEFAULT NULL,
    pull_request_url TEXT DEFAULT NULL,
    stale BOOLEAN DEFAULT NULL,
    "state" TEXT DEFAULT NULL,
    submitted_at TIMESTAMP DEFAULT NULL,
    team TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE PullReview IS 'PullReview represents a pull request review';
COMMENT ON COLUMN PullReview."state" IS 'ReviewStateType review state type';

--
-- Table 'PullReviewComment' generated from model 'PullReviewComment'
-- PullReviewComment represents a comment on a pull request review
--
CREATE TABLE IF NOT EXISTS PullReviewComment (
    body TEXT DEFAULT NULL,
    commit_id TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    diff_hunk TEXT DEFAULT NULL,
    extra_lines_count BIGINT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    original_commit_id TEXT DEFAULT NULL,
    original_position INTEGER DEFAULT NULL,
    "path" TEXT DEFAULT NULL,
    "position" INTEGER DEFAULT NULL,
    pull_request_review_id BIGINT DEFAULT NULL,
    pull_request_url TEXT DEFAULT NULL,
    resolver TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE PullReviewComment IS 'PullReviewComment represents a comment on a pull request review';
COMMENT ON COLUMN PullReviewComment.extra_lines_count IS 'number of additional lines after the commented line (0 &#x3D; single line comment)';

--
-- Table 'PullReviewRequestOptions' generated from model 'PullReviewRequestOptions'
-- PullReviewRequestOptions are options to add or remove pull review requests
--
CREATE TABLE IF NOT EXISTS PullReviewRequestOptions (
    reviewers JSON DEFAULT NULL,
    team_reviewers JSON DEFAULT NULL
);
COMMENT ON TABLE PullReviewRequestOptions IS 'PullReviewRequestOptions are options to add or remove pull review requests';

--
-- Table 'PushMirror' generated from model 'PushMirror'
-- PushMirror represents information of a push mirror
--
CREATE TABLE IF NOT EXISTS PushMirror (
    branch_filter TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    "interval" TEXT DEFAULT NULL,
    last_error TEXT DEFAULT NULL,
    last_update TIMESTAMP DEFAULT NULL,
    public_key TEXT DEFAULT NULL,
    remote_address TEXT DEFAULT NULL,
    remote_name TEXT DEFAULT NULL,
    repo_name TEXT DEFAULT NULL,
    sync_on_commit BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE PushMirror IS 'PushMirror represents information of a push mirror';

--
-- Table 'QuotaGroup' generated from model 'QuotaGroup'
-- QuotaGroup represents a quota group
--
CREATE TABLE IF NOT EXISTS QuotaGroup (
    "name" TEXT DEFAULT NULL,
    rules JSON DEFAULT NULL
);
COMMENT ON TABLE QuotaGroup IS 'QuotaGroup represents a quota group';
COMMENT ON COLUMN QuotaGroup."name" IS 'Name of the group';
COMMENT ON COLUMN QuotaGroup.rules IS 'Rules associated with the group';

--
-- Table 'QuotaInfo' generated from model 'QuotaInfo'
-- QuotaInfo represents information about a user&#39;s quota
--
CREATE TABLE IF NOT EXISTS QuotaInfo (
    "groups" JSON DEFAULT NULL,
    used TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaInfo IS 'QuotaInfo represents information about a user&#39;s quota';
COMMENT ON COLUMN QuotaInfo."groups" IS 'QuotaGroupList represents a list of quota groups';

--
-- Table 'QuotaRuleInfo' generated from model 'QuotaRuleInfo'
-- QuotaRuleInfo contains information about a quota rule
--
CREATE TABLE IF NOT EXISTS QuotaRuleInfo (
    "limit" BIGINT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    subjects JSON DEFAULT NULL
);
COMMENT ON TABLE QuotaRuleInfo IS 'QuotaRuleInfo contains information about a quota rule';
COMMENT ON COLUMN QuotaRuleInfo."limit" IS 'The limit set by the rule';
COMMENT ON COLUMN QuotaRuleInfo."name" IS 'Name of the rule (only shown to admins)';
COMMENT ON COLUMN QuotaRuleInfo.subjects IS 'Subjects the rule affects';

--
-- Table 'QuotaUsed' generated from model 'QuotaUsed'
-- QuotaUsed represents the quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsed (
    "size" TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsed IS 'QuotaUsed represents the quota usage of a user';

--
-- Table 'QuotaUsedArtifact' generated from model 'QuotaUsedArtifact'
-- QuotaUsedArtifact represents an artifact counting towards a user&#39;s quota
--
CREATE TABLE IF NOT EXISTS QuotaUsedArtifact (
    html_url TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedArtifact IS 'QuotaUsedArtifact represents an artifact counting towards a user&#39;s quota';
COMMENT ON COLUMN QuotaUsedArtifact.html_url IS 'HTML URL to the action run containing the artifact';
COMMENT ON COLUMN QuotaUsedArtifact."name" IS 'Name of the artifact';
COMMENT ON COLUMN QuotaUsedArtifact."size" IS 'Size of the artifact (compressed)';

--
-- Table 'QuotaUsedAttachment' generated from model 'QuotaUsedAttachment'
-- QuotaUsedAttachment represents an attachment counting towards a user&#39;s quota
--
CREATE TABLE IF NOT EXISTS QuotaUsedAttachment (
    api_url TEXT DEFAULT NULL,
    contained_in TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedAttachment IS 'QuotaUsedAttachment represents an attachment counting towards a user&#39;s quota';
COMMENT ON COLUMN QuotaUsedAttachment.api_url IS 'API URL for the attachment';
COMMENT ON COLUMN QuotaUsedAttachment."name" IS 'Filename of the attachment';
COMMENT ON COLUMN QuotaUsedAttachment."size" IS 'Size of the attachment (in bytes)';

--
-- Table 'QuotaUsedAttachment_contained_in' generated from model 'QuotaUsedAttachmentUnderscorecontainedUnderscorein'
-- Context for the attachment: URLs to the containing object
--
CREATE TABLE IF NOT EXISTS QuotaUsedAttachment_contained_in (
    api_url TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedAttachment_contained_in IS 'Context for the attachment: URLs to the containing object';
COMMENT ON COLUMN QuotaUsedAttachment_contained_in.api_url IS 'API URL for the object that contains this attachment';
COMMENT ON COLUMN QuotaUsedAttachment_contained_in.html_url IS 'HTML URL for the object that contains this attachment';

--
-- Table 'QuotaUsedPackage' generated from model 'QuotaUsedPackage'
-- QuotaUsedPackage represents a package counting towards a user&#39;s quota
--
CREATE TABLE IF NOT EXISTS QuotaUsedPackage (
    html_url TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedPackage IS 'QuotaUsedPackage represents a package counting towards a user&#39;s quota';
COMMENT ON COLUMN QuotaUsedPackage.html_url IS 'HTML URL to the package version';
COMMENT ON COLUMN QuotaUsedPackage."name" IS 'Name of the package';
COMMENT ON COLUMN QuotaUsedPackage."size" IS 'Size of the package version';
COMMENT ON COLUMN QuotaUsedPackage."type" IS 'Type of the package';
COMMENT ON COLUMN QuotaUsedPackage."version" IS 'Version of the package';

--
-- Table 'QuotaUsedSize' generated from model 'QuotaUsedSize'
-- QuotaUsedSize represents the size-based quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSize (
    assets TEXT DEFAULT NULL,
    git TEXT DEFAULT NULL,
    repos TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSize IS 'QuotaUsedSize represents the size-based quota usage of a user';

--
-- Table 'QuotaUsedSizeAssets' generated from model 'QuotaUsedSizeAssets'
-- QuotaUsedSizeAssets represents the size-based asset usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSizeAssets (
    artifacts BIGINT DEFAULT NULL,
    attachments TEXT DEFAULT NULL,
    packages TEXT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSizeAssets IS 'QuotaUsedSizeAssets represents the size-based asset usage of a user';
COMMENT ON COLUMN QuotaUsedSizeAssets.artifacts IS 'Storage size used for the user&#39;s artifacts';

--
-- Table 'QuotaUsedSizeAssetsAttachments' generated from model 'QuotaUsedSizeAssetsAttachments'
-- QuotaUsedSizeAssetsAttachments represents the size-based attachment quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSizeAssetsAttachments (
    issues BIGINT DEFAULT NULL,
    releases BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSizeAssetsAttachments IS 'QuotaUsedSizeAssetsAttachments represents the size-based attachment quota usage of a user';
COMMENT ON COLUMN QuotaUsedSizeAssetsAttachments.issues IS 'Storage size used for the user&#39;s issue &amp; comment attachments';
COMMENT ON COLUMN QuotaUsedSizeAssetsAttachments.releases IS 'Storage size used for the user&#39;s release attachments';

--
-- Table 'QuotaUsedSizeAssetsPackages' generated from model 'QuotaUsedSizeAssetsPackages'
-- QuotaUsedSizeAssetsPackages represents the size-based package quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSizeAssetsPackages (
    "all" BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSizeAssetsPackages IS 'QuotaUsedSizeAssetsPackages represents the size-based package quota usage of a user';
COMMENT ON COLUMN QuotaUsedSizeAssetsPackages."all" IS 'Storage suze used for the user&#39;s packages';

--
-- Table 'QuotaUsedSizeGit' generated from model 'QuotaUsedSizeGit'
-- QuotaUsedSizeGit represents the size-based git (lfs) quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSizeGit (
    LFS BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSizeGit IS 'QuotaUsedSizeGit represents the size-based git (lfs) quota usage of a user';
COMMENT ON COLUMN QuotaUsedSizeGit.LFS IS 'Storage size of the user&#39;s Git LFS objects';

--
-- Table 'QuotaUsedSizeRepos' generated from model 'QuotaUsedSizeRepos'
-- QuotaUsedSizeRepos represents the size-based repository quota usage of a user
--
CREATE TABLE IF NOT EXISTS QuotaUsedSizeRepos (
    "private" BIGINT DEFAULT NULL,
    "public" BIGINT DEFAULT NULL
);
COMMENT ON TABLE QuotaUsedSizeRepos IS 'QuotaUsedSizeRepos represents the size-based repository quota usage of a user';
COMMENT ON COLUMN QuotaUsedSizeRepos."private" IS 'Storage size of the user&#39;s private repositories';
COMMENT ON COLUMN QuotaUsedSizeRepos."public" IS 'Storage size of the user&#39;s public repositories';

--
-- Table 'Reaction' generated from model 'Reaction'
-- Reaction contain one reaction
--
CREATE TABLE IF NOT EXISTS Reaction (
    "content" TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE Reaction IS 'Reaction contain one reaction';

--
-- Table 'Reference' generated from model 'Reference'
--
CREATE TABLE IF NOT EXISTS Reference (
    "object" TEXT DEFAULT NULL,
    "ref" TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL
);
;

--
-- Table 'RegisterRunnerOptions' generated from model 'RegisterRunnerOptions'
--
CREATE TABLE IF NOT EXISTS RegisterRunnerOptions (
    description TEXT DEFAULT NULL,
    ephemeral BOOLEAN DEFAULT NULL,
    "name" TEXT NOT NULL
);
;
COMMENT ON COLUMN RegisterRunnerOptions.description IS 'Description of the runner to register.';
COMMENT ON COLUMN RegisterRunnerOptions.ephemeral IS 'Register as ephemeral runner https://forgejo.org/docs/latest/admin/actions/security/#ephemeral-runners';
COMMENT ON COLUMN RegisterRunnerOptions."name" IS 'Name of the runner to register. The name of the runner does not have to be unique.';

--
-- Table 'RegisterRunnerResponse' generated from model 'RegisterRunnerResponse'
--
CREATE TABLE IF NOT EXISTS RegisterRunnerResponse (
    "id" BIGSERIAL,
    "token" TEXT DEFAULT NULL,
    uuid TEXT DEFAULT NULL
);
;

--
-- Table 'RegistrationToken' generated from model 'RegistrationToken'
-- RegistrationToken is a string used to register a runner with a server
--
CREATE TABLE IF NOT EXISTS RegistrationToken (
    "token" TEXT DEFAULT NULL
);
COMMENT ON TABLE RegistrationToken IS 'RegistrationToken is a string used to register a runner with a server';

--
-- Table 'Release' generated from model 'Release'
-- Release represents a repository release
--
CREATE TABLE IF NOT EXISTS "Release" (
    archive_download_count TEXT DEFAULT NULL,
    assets JSON DEFAULT NULL,
    author TEXT DEFAULT NULL,
    body TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    draft BOOLEAN DEFAULT NULL,
    hide_archive_links BOOLEAN DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    prerelease BOOLEAN DEFAULT NULL,
    published_at TIMESTAMP DEFAULT NULL,
    tag_name TEXT DEFAULT NULL,
    tarball_url TEXT DEFAULT NULL,
    target_commitish TEXT DEFAULT NULL,
    upload_url TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL,
    zipball_url TEXT DEFAULT NULL
);
COMMENT ON TABLE "Release" IS 'Release represents a repository release';

--
-- Table 'RenameOrgOption' generated from model 'RenameOrgOption'
-- RenameOrgOption options when renaming an organization
--
CREATE TABLE IF NOT EXISTS RenameOrgOption (
    new_name TEXT NOT NULL
);
COMMENT ON TABLE RenameOrgOption IS 'RenameOrgOption options when renaming an organization';
COMMENT ON COLUMN RenameOrgOption.new_name IS 'New username for this org. This name cannot be in use yet by any other user.';

--
-- Table 'RenameUserOption' generated from model 'RenameUserOption'
-- RenameUserOption options when renaming a user
--
CREATE TABLE IF NOT EXISTS RenameUserOption (
    new_username TEXT NOT NULL
);
COMMENT ON TABLE RenameUserOption IS 'RenameUserOption options when renaming a user';
COMMENT ON COLUMN RenameUserOption.new_username IS 'New username for this user. This name cannot be in use yet by any other user.';

--
-- Table 'ReplaceFlagsOption' generated from model 'ReplaceFlagsOption'
-- ReplaceFlagsOption options when replacing the flags of a repository
--
CREATE TABLE IF NOT EXISTS ReplaceFlagsOption (
    flags JSON DEFAULT NULL
);
COMMENT ON TABLE ReplaceFlagsOption IS 'ReplaceFlagsOption options when replacing the flags of a repository';

--
-- Table 'RepoCollaboratorPermission' generated from model 'RepoCollaboratorPermission'
-- RepoCollaboratorPermission to get repository permission for a collaborator
--
CREATE TABLE IF NOT EXISTS RepoCollaboratorPermission (
    "permission" TEXT DEFAULT NULL,
    role_name TEXT DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE RepoCollaboratorPermission IS 'RepoCollaboratorPermission to get repository permission for a collaborator';

--
-- Table 'RepoCommit' generated from model 'RepoCommit'
--
CREATE TABLE IF NOT EXISTS RepoCommit (
    author TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    tree TEXT DEFAULT NULL,
    url TEXT DEFAULT NULL,
    verification TEXT DEFAULT NULL
);
;

--
-- Table 'repoCreateReleaseAttachment_request' generated from model 'repoCreateReleaseAttachmentUnderscorerequest'
--
CREATE TABLE IF NOT EXISTS repoCreateReleaseAttachment_request (
    attachment BYTEA DEFAULT NULL,
    external_url TEXT DEFAULT NULL
);
;
COMMENT ON COLUMN repoCreateReleaseAttachment_request.attachment IS 'attachment to upload (this parameter is incompatible with &#x60;external_url&#x60;)';
COMMENT ON COLUMN repoCreateReleaseAttachment_request.external_url IS 'url to external asset (this parameter is incompatible with &#x60;attachment&#x60;)';

--
-- Table 'RepoTargetOption' generated from model 'RepoTargetOption'
--
CREATE TABLE IF NOT EXISTS RepoTargetOption (
    "name" TEXT NOT NULL,
    "owner" TEXT NOT NULL
);
;
COMMENT ON COLUMN RepoTargetOption."name" IS 'Name of repository';
COMMENT ON COLUMN RepoTargetOption."owner" IS 'Name of user or organisation that owns the repository';

--
-- Table 'RepoTopicOptions' generated from model 'RepoTopicOptions'
-- RepoTopicOptions a collection of repo topic names
--
CREATE TABLE IF NOT EXISTS RepoTopicOptions (
    topics JSON DEFAULT NULL
);
COMMENT ON TABLE RepoTopicOptions IS 'RepoTopicOptions a collection of repo topic names';
COMMENT ON COLUMN RepoTopicOptions.topics IS 'list of topic names';

--
-- Table 'RepoTransfer' generated from model 'RepoTransfer'
-- RepoTransfer represents a pending repo transfer
--
CREATE TABLE IF NOT EXISTS RepoTransfer (
    doer TEXT DEFAULT NULL,
    recipient TEXT DEFAULT NULL,
    teams JSON DEFAULT NULL
);
COMMENT ON TABLE RepoTransfer IS 'RepoTransfer represents a pending repo transfer';

--
-- Table 'Repository' generated from model 'Repository'
-- Repository represents a repository
--
CREATE TABLE IF NOT EXISTS Repository (
    allow_fast_forward_only_merge BOOLEAN DEFAULT NULL,
    allow_merge_commits BOOLEAN DEFAULT NULL,
    allow_rebase BOOLEAN DEFAULT NULL,
    allow_rebase_explicit BOOLEAN DEFAULT NULL,
    allow_rebase_update BOOLEAN DEFAULT NULL,
    allow_squash_merge BOOLEAN DEFAULT NULL,
    archived BOOLEAN DEFAULT NULL,
    archived_at TIMESTAMP DEFAULT NULL,
    avatar_url TEXT DEFAULT NULL,
    clone_url TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    default_allow_maintainer_edit BOOLEAN DEFAULT NULL,
    default_branch TEXT DEFAULT NULL,
    default_delete_branch_after_merge BOOLEAN DEFAULT NULL,
    default_merge_style TEXT DEFAULT NULL,
    default_update_style TEXT DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "empty" BOOLEAN DEFAULT NULL,
    external_tracker TEXT DEFAULT NULL,
    external_wiki TEXT DEFAULT NULL,
    fork BOOLEAN DEFAULT NULL,
    forks_count BIGINT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    globally_editable_wiki BOOLEAN DEFAULT NULL,
    has_actions BOOLEAN DEFAULT NULL,
    has_issues BOOLEAN DEFAULT NULL,
    has_packages BOOLEAN DEFAULT NULL,
    has_projects BOOLEAN DEFAULT NULL,
    has_pull_requests BOOLEAN DEFAULT NULL,
    has_releases BOOLEAN DEFAULT NULL,
    has_wiki BOOLEAN DEFAULT NULL,
    has_wiki_contents BOOLEAN DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    ignore_whitespace_conflicts BOOLEAN DEFAULT NULL,
    internal BOOLEAN DEFAULT NULL,
    internal_tracker TEXT DEFAULT NULL,
    "language" TEXT DEFAULT NULL,
    languages_url TEXT DEFAULT NULL,
    "link" TEXT DEFAULT NULL,
    mirror BOOLEAN DEFAULT NULL,
    mirror_interval TEXT DEFAULT NULL,
    mirror_updated TIMESTAMP DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    object_format_name Repository_objectUnderscoreformatUnderscorename DEFAULT NULL,
    open_issues_count BIGINT DEFAULT NULL,
    open_pr_counter BIGINT DEFAULT NULL,
    original_url TEXT DEFAULT NULL,
    "owner" TEXT DEFAULT NULL,
    parent TEXT DEFAULT NULL,
    permissions TEXT DEFAULT NULL,
    "private" BOOLEAN DEFAULT NULL,
    release_counter BIGINT DEFAULT NULL,
    repo_transfer TEXT DEFAULT NULL,
    "size" BIGINT DEFAULT NULL,
    ssh_url TEXT DEFAULT NULL,
    stars_count BIGINT DEFAULT NULL,
    "template" BOOLEAN DEFAULT NULL,
    topics JSON DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    url TEXT DEFAULT NULL,
    watchers_count BIGINT DEFAULT NULL,
    website TEXT DEFAULT NULL,
    wiki_branch TEXT DEFAULT NULL,
    wiki_clone_url TEXT DEFAULT NULL,
    wiki_ssh_url TEXT DEFAULT NULL
);
COMMENT ON TABLE Repository IS 'Repository represents a repository';
COMMENT ON COLUMN Repository.has_wiki IS 'is the wiki enabled';
COMMENT ON COLUMN Repository.has_wiki_contents IS 'have wiki pages ever been created';
COMMENT ON COLUMN Repository.object_format_name IS 'ObjectFormatName of the underlying git repository';

--
-- Table 'RepositoryMeta' generated from model 'RepositoryMeta'
-- RepositoryMeta basic repository information
--
CREATE TABLE IF NOT EXISTS RepositoryMeta (
    full_name TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    "name" TEXT DEFAULT NULL,
    "owner" TEXT DEFAULT NULL
);
COMMENT ON TABLE RepositoryMeta IS 'RepositoryMeta basic repository information';

--
-- Table 'SearchResults' generated from model 'SearchResults'
-- SearchResults results of a successful search
--
CREATE TABLE IF NOT EXISTS SearchResults (
    "data" JSON DEFAULT NULL,
    ok BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE SearchResults IS 'SearchResults results of a successful search';

--
-- Table 'Secret' generated from model 'Secret'
-- Secret represents a secret
--
CREATE TABLE IF NOT EXISTS Secret (
    created_at TIMESTAMP DEFAULT NULL,
    "name" TEXT DEFAULT NULL
);
COMMENT ON TABLE Secret IS 'Secret represents a secret';
COMMENT ON COLUMN Secret."name" IS 'the secret&#39;s name';

--
-- Table 'ServerVersion' generated from model 'ServerVersion'
-- ServerVersion wraps the version of the server
--
CREATE TABLE IF NOT EXISTS ServerVersion (
    "version" TEXT DEFAULT NULL
);
COMMENT ON TABLE ServerVersion IS 'ServerVersion wraps the version of the server';

--
-- Table 'SetUserQuotaGroupsOptions' generated from model 'SetUserQuotaGroupsOptions'
-- SetUserQuotaGroupsOptions represents the quota groups of a user
--
CREATE TABLE IF NOT EXISTS SetUserQuotaGroupsOptions (
    "groups" JSON NOT NULL
);
COMMENT ON TABLE SetUserQuotaGroupsOptions IS 'SetUserQuotaGroupsOptions represents the quota groups of a user';
COMMENT ON COLUMN SetUserQuotaGroupsOptions."groups" IS 'Quota groups the user shall have';

--
-- Table 'StopWatch' generated from model 'StopWatch'
-- StopWatch represent a running stopwatch
--
CREATE TABLE IF NOT EXISTS StopWatch (
    created TIMESTAMP DEFAULT NULL,
    duration TEXT DEFAULT NULL,
    issue_index BIGINT DEFAULT NULL,
    issue_title TEXT DEFAULT NULL,
    repo_name TEXT DEFAULT NULL,
    repo_owner_name TEXT DEFAULT NULL,
    seconds BIGINT DEFAULT NULL
);
COMMENT ON TABLE StopWatch IS 'StopWatch represent a running stopwatch';

--
-- Table 'SubmitPullReviewOptions' generated from model 'SubmitPullReviewOptions'
-- SubmitPullReviewOptions are options to submit a pending pull review
--
CREATE TABLE IF NOT EXISTS SubmitPullReviewOptions (
    body TEXT DEFAULT NULL,
    "event" TEXT DEFAULT NULL
);
COMMENT ON TABLE SubmitPullReviewOptions IS 'SubmitPullReviewOptions are options to submit a pending pull review';
COMMENT ON COLUMN SubmitPullReviewOptions."event" IS 'ReviewStateType review state type';

--
-- Table 'SyncForkInfo' generated from model 'SyncForkInfo'
-- SyncForkInfo information about syncing a fork
--
CREATE TABLE IF NOT EXISTS SyncForkInfo (
    allowed BOOLEAN DEFAULT NULL,
    base_commit TEXT DEFAULT NULL,
    commits_behind BIGINT DEFAULT NULL,
    fork_commit TEXT DEFAULT NULL
);
COMMENT ON TABLE SyncForkInfo IS 'SyncForkInfo information about syncing a fork';

--
-- Table 'Tag' generated from model 'Tag'
-- Tag represents a repository tag
--
CREATE TABLE IF NOT EXISTS Tag (
    archive_download_count TEXT DEFAULT NULL,
    "commit" TEXT DEFAULT NULL,
    "id" TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    tarball_url TEXT DEFAULT NULL,
    zipball_url TEXT DEFAULT NULL
);
COMMENT ON TABLE Tag IS 'Tag represents a repository tag';

--
-- Table 'TagArchiveDownloadCount' generated from model 'TagArchiveDownloadCount'
-- TagArchiveDownloadCount counts how many times a archive was downloaded
--
CREATE TABLE IF NOT EXISTS TagArchiveDownloadCount (
    tar_gz BIGINT DEFAULT NULL,
    zip BIGINT DEFAULT NULL
);
COMMENT ON TABLE TagArchiveDownloadCount IS 'TagArchiveDownloadCount counts how many times a archive was downloaded';

--
-- Table 'TagProtection' generated from model 'TagProtection'
-- TagProtection represents a tag protection
--
CREATE TABLE IF NOT EXISTS TagProtection (
    created_at TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    name_pattern TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    whitelist_teams JSON DEFAULT NULL,
    whitelist_usernames JSON DEFAULT NULL
);
COMMENT ON TABLE TagProtection IS 'TagProtection represents a tag protection';

--
-- Table 'Team' generated from model 'Team'
-- Team represents a team in an organization
--
CREATE TABLE IF NOT EXISTS Team (
    can_create_org_repo BOOLEAN DEFAULT NULL,
    description TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    includes_all_repositories BOOLEAN DEFAULT NULL,
    "name" TEXT DEFAULT NULL,
    organization TEXT DEFAULT NULL,
    "permission" Team_permission DEFAULT NULL,
    units JSON DEFAULT NULL,
    units_map JSON DEFAULT NULL
);
COMMENT ON TABLE Team IS 'Team represents a team in an organization';
COMMENT ON COLUMN Team.units IS ' Deprecated: This variable should be replaced by UnitsMap and will be dropped in later versions.';

--
-- Table 'TeamSearchResults' generated from model 'TeamSearchResults'
--
CREATE TABLE IF NOT EXISTS TeamSearchResults (
    "data" JSON DEFAULT NULL,
    ok BOOLEAN DEFAULT NULL
);
;

--
-- Table 'TimelineComment' generated from model 'TimelineComment'
-- TimelineComment represents a timeline comment (comment of any type) on a commit or issue
--
CREATE TABLE IF NOT EXISTS TimelineComment (
    assignee TEXT DEFAULT NULL,
    assignee_team TEXT DEFAULT NULL,
    body TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NULL,
    dependent_issue TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    issue_url TEXT DEFAULT NULL,
    "label" TEXT DEFAULT NULL,
    milestone TEXT DEFAULT NULL,
    new_ref TEXT DEFAULT NULL,
    new_title TEXT DEFAULT NULL,
    old_milestone TEXT DEFAULT NULL,
    old_project_id BIGINT DEFAULT NULL,
    old_ref TEXT DEFAULT NULL,
    old_title TEXT DEFAULT NULL,
    project_id BIGINT DEFAULT NULL,
    pull_request_url TEXT DEFAULT NULL,
    ref_action TEXT DEFAULT NULL,
    ref_comment TEXT DEFAULT NULL,
    ref_commit_sha TEXT DEFAULT NULL,
    ref_issue TEXT DEFAULT NULL,
    removed_assignee BOOLEAN DEFAULT NULL,
    resolve_doer TEXT DEFAULT NULL,
    review_id BIGINT DEFAULT NULL,
    tracked_time TEXT DEFAULT NULL,
    "type" TEXT DEFAULT NULL,
    updated_at TIMESTAMP DEFAULT NULL,
    "user" TEXT DEFAULT NULL
);
COMMENT ON TABLE TimelineComment IS 'TimelineComment represents a timeline comment (comment of any type) on a commit or issue';
COMMENT ON COLUMN TimelineComment.ref_commit_sha IS 'commit SHA where issue/PR was referenced';
COMMENT ON COLUMN TimelineComment.removed_assignee IS 'whether the assignees were removed or added';

--
-- Table 'TopicName' generated from model 'TopicName'
-- TopicName a list of repo topic names
--
CREATE TABLE IF NOT EXISTS TopicName (
    topics JSON DEFAULT NULL
);
COMMENT ON TABLE TopicName IS 'TopicName a list of repo topic names';

--
-- Table 'TopicResponse' generated from model 'TopicResponse'
-- TopicResponse for returning topics
--
CREATE TABLE IF NOT EXISTS TopicResponse (
    created TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    repo_count BIGINT DEFAULT NULL,
    topic_name TEXT DEFAULT NULL,
    updated TIMESTAMP DEFAULT NULL
);
COMMENT ON TABLE TopicResponse IS 'TopicResponse for returning topics';

--
-- Table 'TopicSearchResults' generated from model 'TopicSearchResults'
--
CREATE TABLE IF NOT EXISTS TopicSearchResults (
    topics JSON DEFAULT NULL
);
;

--
-- Table 'TrackedTime' generated from model 'TrackedTime'
-- TrackedTime worked time for an issue / pr
--
CREATE TABLE IF NOT EXISTS TrackedTime (
    created TIMESTAMP DEFAULT NULL,
    "id" BIGSERIAL,
    issue TEXT DEFAULT NULL,
    issue_id BIGINT DEFAULT NULL,
    "time" BIGINT DEFAULT NULL,
    user_id BIGINT DEFAULT NULL,
    user_name TEXT DEFAULT NULL
);
COMMENT ON TABLE TrackedTime IS 'TrackedTime worked time for an issue / pr';
COMMENT ON COLUMN TrackedTime.issue_id IS 'deprecated (only for backwards compatibility)';
COMMENT ON COLUMN TrackedTime."time" IS 'Time in seconds';
COMMENT ON COLUMN TrackedTime.user_id IS 'deprecated (only for backwards compatibility)';

--
-- Table 'TransferRepoOption' generated from model 'TransferRepoOption'
-- TransferRepoOption options when transfer a repository&#39;s ownership
--
CREATE TABLE IF NOT EXISTS TransferRepoOption (
    new_owner TEXT NOT NULL,
    team_ids JSON DEFAULT NULL
);
COMMENT ON TABLE TransferRepoOption IS 'TransferRepoOption options when transfer a repository&#39;s ownership';
COMMENT ON COLUMN TransferRepoOption.team_ids IS 'ID of the team or teams to add to the repository. Teams can only be added to organization-owned repositories.';

--
-- Table 'UpdateBranchRepoOption' generated from model 'UpdateBranchRepoOption'
-- UpdateBranchRepoOption options when updating a branch in a repository
--
CREATE TABLE IF NOT EXISTS UpdateBranchRepoOption (
    "name" TEXT NOT NULL
);
COMMENT ON TABLE UpdateBranchRepoOption IS 'UpdateBranchRepoOption options when updating a branch in a repository';
COMMENT ON COLUMN UpdateBranchRepoOption."name" IS 'New branch name';

--
-- Table 'UpdateFileOptions' generated from model 'UpdateFileOptions'
-- UpdateFileOptions options for updating files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)
--
CREATE TABLE IF NOT EXISTS UpdateFileOptions (
    author TEXT DEFAULT NULL,
    branch TEXT DEFAULT NULL,
    committer TEXT DEFAULT NULL,
    "content" TEXT NOT NULL,
    dates TEXT DEFAULT NULL,
    force_overwrite_new_branch BOOLEAN DEFAULT NULL,
    from_path TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    new_branch TEXT DEFAULT NULL,
    sha TEXT NOT NULL,
    signoff BOOLEAN DEFAULT NULL
);
COMMENT ON TABLE UpdateFileOptions IS 'UpdateFileOptions options for updating files Note: &#x60;author&#x60; and &#x60;committer&#x60; are optional (if only one is given, it will be used for the other, otherwise the authenticated user will be used)';
COMMENT ON COLUMN UpdateFileOptions.branch IS 'branch (optional) to base this file from. if not given, the default branch is used';
COMMENT ON COLUMN UpdateFileOptions."content" IS 'content must be base64 encoded';
COMMENT ON COLUMN UpdateFileOptions.force_overwrite_new_branch IS '(optional) will do a force-push if the new branch already exists';
COMMENT ON COLUMN UpdateFileOptions.from_path IS 'from_path (optional) is the path of the original file which will be moved/renamed to the path in the URL';
COMMENT ON COLUMN UpdateFileOptions.message IS 'message (optional) for the commit of this file. if not supplied, a default message will be used';
COMMENT ON COLUMN UpdateFileOptions.new_branch IS 'new_branch (optional) will make a new branch from &#x60;branch&#x60; before creating the file';
COMMENT ON COLUMN UpdateFileOptions.sha IS 'sha is the SHA for the file that already exists';
COMMENT ON COLUMN UpdateFileOptions.signoff IS 'Add a Signed-off-by trailer by the committer at the end of the commit log message.';

--
-- Table 'UpdateRepoAvatarOption' generated from model 'UpdateRepoAvatarOption'
-- UpdateRepoAvatarUserOption options when updating the repo avatar
--
CREATE TABLE IF NOT EXISTS UpdateRepoAvatarOption (
    image TEXT DEFAULT NULL
);
COMMENT ON TABLE UpdateRepoAvatarOption IS 'UpdateRepoAvatarUserOption options when updating the repo avatar';
COMMENT ON COLUMN UpdateRepoAvatarOption.image IS 'image must be base64 encoded';

--
-- Table 'UpdateUserAvatarOption' generated from model 'UpdateUserAvatarOption'
-- UpdateUserAvatarUserOption options when updating the user avatar
--
CREATE TABLE IF NOT EXISTS UpdateUserAvatarOption (
    image TEXT DEFAULT NULL
);
COMMENT ON TABLE UpdateUserAvatarOption IS 'UpdateUserAvatarUserOption options when updating the user avatar';
COMMENT ON COLUMN UpdateUserAvatarOption.image IS 'image must be base64 encoded';

--
-- Table 'UpdateVariableOption' generated from model 'UpdateVariableOption'
--
CREATE TABLE IF NOT EXISTS UpdateVariableOption (
    "name" TEXT DEFAULT NULL,
    "value" TEXT NOT NULL
);
;
COMMENT ON COLUMN UpdateVariableOption."name" IS 'New name for the variable. If the field is empty, the variable name won&#39;t be updated. Forgejo will convert it to uppercase.';
COMMENT ON COLUMN UpdateVariableOption."value" IS 'Value of the variable to update. Special characters will be retained. Line endings will be normalized to LF to match the behaviour of browsers. Encode the data with Base64 if line endings should be retained.';

--
-- Table 'User' generated from model 'User'
-- User represents a user
--
CREATE TABLE IF NOT EXISTS "User" (
    active BOOLEAN DEFAULT NULL,
    avatar_url TEXT DEFAULT NULL,
    created TIMESTAMP DEFAULT NULL,
    description TEXT DEFAULT NULL,
    email TEXT DEFAULT NULL,
    followers_count BIGINT DEFAULT NULL,
    following_count BIGINT DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    "id" BIGSERIAL,
    is_admin BOOLEAN DEFAULT NULL,
    "language" TEXT DEFAULT NULL,
    last_login TIMESTAMP DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    login TEXT DEFAULT NULL,
    login_name TEXT,
    prohibit_login BOOLEAN DEFAULT NULL,
    pronouns TEXT DEFAULT NULL,
    restricted BOOLEAN DEFAULT NULL,
    source_id BIGINT DEFAULT NULL,
    starred_repos_count BIGINT DEFAULT NULL,
    visibility TEXT DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE "User" IS 'User represents a user';
COMMENT ON COLUMN "User".active IS 'Is user active';
COMMENT ON COLUMN "User".avatar_url IS 'URL to the user&#39;s avatar';
COMMENT ON COLUMN "User".description IS 'the user&#39;s description';
COMMENT ON COLUMN "User".followers_count IS 'user counts';
COMMENT ON COLUMN "User".full_name IS 'the user&#39;s full name';
COMMENT ON COLUMN "User".html_url IS 'URL to the user&#39;s profile page';
COMMENT ON COLUMN "User"."id" IS 'the user&#39;s id';
COMMENT ON COLUMN "User".is_admin IS 'Is the user an administrator';
COMMENT ON COLUMN "User"."language" IS 'User locale';
COMMENT ON COLUMN "User"."location" IS 'the user&#39;s location';
COMMENT ON COLUMN "User".login IS 'the user&#39;s username';
COMMENT ON COLUMN "User".login_name IS 'the user&#39;s authentication sign-in name.';
COMMENT ON COLUMN "User".prohibit_login IS 'Is user login prohibited';
COMMENT ON COLUMN "User".pronouns IS 'the user&#39;s pronouns';
COMMENT ON COLUMN "User".restricted IS 'Is user restricted';
COMMENT ON COLUMN "User".source_id IS 'The ID of the user&#39;s Authentication Source';
COMMENT ON COLUMN "User".visibility IS 'User visibility level option: public, limited, private';
COMMENT ON COLUMN "User".website IS 'the user&#39;s website';

--
-- Table 'UserHeatmapData' generated from model 'UserHeatmapData'
-- UserHeatmapData represents the data needed to create a heatmap
--
CREATE TABLE IF NOT EXISTS UserHeatmapData (
    contributions BIGINT DEFAULT NULL,
    "timestamp" BIGINT DEFAULT NULL
);
COMMENT ON TABLE UserHeatmapData IS 'UserHeatmapData represents the data needed to create a heatmap';
COMMENT ON COLUMN UserHeatmapData."timestamp" IS 'TimeStamp defines a timestamp';

--
-- Table 'UserSearchResults' generated from model 'UserSearchResults'
--
CREATE TABLE IF NOT EXISTS UserSearchResults (
    "data" JSON DEFAULT NULL,
    ok BOOLEAN DEFAULT NULL
);
;

--
-- Table 'UserSettings' generated from model 'UserSettings'
-- UserSettings represents user settings
--
CREATE TABLE IF NOT EXISTS UserSettings (
    description TEXT DEFAULT NULL,
    diff_view_style TEXT DEFAULT NULL,
    enable_repo_unit_hints BOOLEAN DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    hide_activity BOOLEAN DEFAULT NULL,
    hide_email BOOLEAN DEFAULT NULL,
    hide_pronouns BOOLEAN DEFAULT NULL,
    "language" TEXT DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    pronouns TEXT DEFAULT NULL,
    theme TEXT DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE UserSettings IS 'UserSettings represents user settings';
COMMENT ON COLUMN UserSettings.hide_email IS 'Privacy';

--
-- Table 'UserSettingsOptions' generated from model 'UserSettingsOptions'
-- UserSettingsOptions represents options to change user settings
--
CREATE TABLE IF NOT EXISTS UserSettingsOptions (
    description TEXT DEFAULT NULL,
    diff_view_style TEXT DEFAULT NULL,
    enable_repo_unit_hints BOOLEAN DEFAULT NULL,
    full_name TEXT DEFAULT NULL,
    hide_activity BOOLEAN DEFAULT NULL,
    hide_email BOOLEAN DEFAULT NULL,
    hide_pronouns BOOLEAN DEFAULT NULL,
    "language" TEXT DEFAULT NULL,
    "location" TEXT DEFAULT NULL,
    pronouns TEXT DEFAULT NULL,
    theme TEXT DEFAULT NULL,
    website TEXT DEFAULT NULL
);
COMMENT ON TABLE UserSettingsOptions IS 'UserSettingsOptions represents options to change user settings';
COMMENT ON COLUMN UserSettingsOptions.hide_email IS 'Privacy';

--
-- Table 'VerifyGPGKeyOption' generated from model 'VerifyGPGKeyOption'
-- VerifyGPGKeyOption options verifies user GPG key
--
CREATE TABLE IF NOT EXISTS VerifyGPGKeyOption (
    armored_signature TEXT DEFAULT NULL,
    key_id TEXT NOT NULL
);
COMMENT ON TABLE VerifyGPGKeyOption IS 'VerifyGPGKeyOption options verifies user GPG key';
COMMENT ON COLUMN VerifyGPGKeyOption.key_id IS 'An Signature for a GPG key token';

--
-- Table 'WatchInfo' generated from model 'WatchInfo'
-- WatchInfo represents an API watch status of one repository
--
CREATE TABLE IF NOT EXISTS WatchInfo (
    created_at TIMESTAMP DEFAULT NULL,
    ignored BOOLEAN DEFAULT NULL,
    reason JSON DEFAULT NULL,
    repository_url TEXT DEFAULT NULL,
    subscribed BOOLEAN DEFAULT NULL,
    url TEXT DEFAULT NULL
);
COMMENT ON TABLE WatchInfo IS 'WatchInfo represents an API watch status of one repository';

--
-- Table 'WikiCommit' generated from model 'WikiCommit'
-- WikiCommit page commit/revision
--
CREATE TABLE IF NOT EXISTS WikiCommit (
    author TEXT DEFAULT NULL,
    commiter TEXT DEFAULT NULL,
    message TEXT DEFAULT NULL,
    sha TEXT DEFAULT NULL
);
COMMENT ON TABLE WikiCommit IS 'WikiCommit page commit/revision';

--
-- Table 'WikiCommitList' generated from model 'WikiCommitList'
-- WikiCommitList commit/revision list
--
CREATE TABLE IF NOT EXISTS WikiCommitList (
    commits JSON DEFAULT NULL,
    "count" BIGINT DEFAULT NULL
);
COMMENT ON TABLE WikiCommitList IS 'WikiCommitList commit/revision list';

--
-- Table 'WikiPage' generated from model 'WikiPage'
-- WikiPage a wiki page
--
CREATE TABLE IF NOT EXISTS WikiPage (
    commit_count BIGINT DEFAULT NULL,
    content_base64 TEXT DEFAULT NULL,
    footer TEXT DEFAULT NULL,
    html_url TEXT DEFAULT NULL,
    last_commit TEXT DEFAULT NULL,
    sidebar TEXT DEFAULT NULL,
    sub_url TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE WikiPage IS 'WikiPage a wiki page';
COMMENT ON COLUMN WikiPage.content_base64 IS 'Page content, base64 encoded';

--
-- Table 'WikiPageMetaData' generated from model 'WikiPageMetaData'
-- WikiPageMetaData wiki page meta information
--
CREATE TABLE IF NOT EXISTS WikiPageMetaData (
    html_url TEXT DEFAULT NULL,
    last_commit TEXT DEFAULT NULL,
    sub_url TEXT DEFAULT NULL,
    title TEXT DEFAULT NULL
);
COMMENT ON TABLE WikiPageMetaData IS 'WikiPageMetaData wiki page meta information';

