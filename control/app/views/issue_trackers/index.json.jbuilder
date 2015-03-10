json.array!(@issue_trackers) do |issue_tracker|
  json.extract! issue_tracker, :id, :title, :weblink, :regex
  json.url issue_tracker_url(issue_tracker, format: :json)
end
