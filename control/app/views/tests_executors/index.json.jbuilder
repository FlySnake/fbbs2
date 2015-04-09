json.array!(@tests_executors) do |tests_executor|
  json.extract! tests_executor, :id, :title
  json.url tests_executor_url(tests_executor, format: :json)
end
