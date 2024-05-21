require 'jwt'

payload = {
  sub: ARGV[0],  # Username
  role: ARGV[1], # Role (user or admin)
  iss: 'xiana-api',
  aud: 'api-consumer',
  exp: (Time.now + 3600000000).to_i  # Token expiration time (1M hour from now)
}

secret = 'your-secret-key'  # Replace with your secret key

token = JWT.encode(payload, secret, 'HS256')
puts token


