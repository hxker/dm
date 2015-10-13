json.array!(@news) do |news|
  json.extract! news, :name
  json.url news_url(news, format: :json)
end