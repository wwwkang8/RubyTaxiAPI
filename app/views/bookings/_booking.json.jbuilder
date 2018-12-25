json.extract! booking, :id, :destination, :status, :taxi, :created_at, :updated_at, :user_id, :created_at, :updated_at
json.url booking_url(booking, format: :json)
