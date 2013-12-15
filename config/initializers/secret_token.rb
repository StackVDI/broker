# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Broker::Application.config.secret_key_base = '58de3fc1321065dbeb34b1bf4d89cf8dfa8061aa700fd227295b3170714e96990c0ffc16aaf251a0285af7ca9440312d682a5e82e9a23e830dce4238450bd725'
