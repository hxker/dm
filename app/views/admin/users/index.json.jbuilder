json.array!(@users) do |user|
  json.extract! user, :username, :nickname, :mobile, :email
  json.url user_url(user, format: :json)
end