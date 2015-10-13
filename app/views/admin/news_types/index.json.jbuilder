json.array!(@news_types) do |news_type|
  json.extract! news_type, :name
  json.url news_type_url(news_type, format: :json)
end