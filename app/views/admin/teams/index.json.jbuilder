json.array!(@teams) do |team|
  json.extract! team, :name, :user_id, :competition_id, :team_code
  json.url team_url(team, format: :json)
end