json.array!(@cloud_servers) do |cloud_server|
  json.extract! cloud_server, :id, :name, :description, :username, :password, :url
  json.url cloud_server_url(cloud_server, format: :json)
end
