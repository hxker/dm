json.array!(@districts) do |district|
  json.extract! district, 
  json.url district_url(district, format: :json)
end