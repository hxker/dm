json.array!(@schedules) do |schedule|
  json.extract! schedule, :name
  json.url schedule_url(schedule, format: :json)
end