json.extract! usermail, :id, :name, :email, :created_at, :updated_at
json.url usermail_url(usermail, format: :json)