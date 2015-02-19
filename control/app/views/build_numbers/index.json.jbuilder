json.array!(@build_numbers) do |build_number|
  json.extract! build_number, :id, :branch, :commit, :number
  json.url build_number_url(build_number, format: :json)
end
