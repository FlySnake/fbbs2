json.array!(@enviroments) do |enviroment|
  json.extract! enviroment, :id, :title
  json.url enviroment_url(enviroment, format: :json)
end
