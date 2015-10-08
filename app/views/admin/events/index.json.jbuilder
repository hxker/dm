json.array!(@events) do |event|
  json.extract! event, :name, :competition_id, :cover, :status, :team_min_num
  json.url event_url(event, format: :json)
end