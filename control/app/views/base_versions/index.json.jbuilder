json.array!(@base_versions) do |base_version|
  json.extract! base_version, :id, :name
  json.url base_version_url(base_version, format: :json)
end
