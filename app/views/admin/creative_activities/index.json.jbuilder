json.array!(@organizers) do |organizer|
  json.extract! organizer, :name, :responsible, :tel, :address
  json.url organizer_url(organizer, format: :json)
end