json.array!(@build_jobs) do |build_job|
  json.extract! build_job, :id, :banch_id, :base_version_id, :target_platform_id, :notify_user_id, :started_by_user_id, :comment, :status
  json.url build_job_url(build_job, format: :json)
end
