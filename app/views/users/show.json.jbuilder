# json.partial! "users/user", user: @user
json.data do
    json.call(
        message: 'User created successfully'
    )
end
