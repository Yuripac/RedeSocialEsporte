json.array!(@users) do |user|
  json.extract! user, :id, :name, :age, :favorite_sport
  json.url user_url(user, format: :json)
end
