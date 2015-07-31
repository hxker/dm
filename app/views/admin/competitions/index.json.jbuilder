json.array!(@competitions) do |competition|
  json.extract! competition, :id
  json.url competition_url(competition, format: :json)
end
