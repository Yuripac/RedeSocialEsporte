json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :favorite_sport
  json.url user_url(user, format: :json)
end
