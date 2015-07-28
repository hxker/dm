json.array!(@admins) do |employee|
  json.extract! employee, :job_number, :password_digest, :name, :permissions, :position, :age, :gender, :email, :phone, :address
  json.url admin_admins_url(employee, format: :json)
end