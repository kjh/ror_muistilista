# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ror_muistilista_session',
  :secret      => '9c47127bcf8439f3186555ac4ab17033a89b999cabc7b42ef4df21fe53d6070576715b186f309b0842f28c71634cf2dfd5bb4ef230fcede14365fb47d62a911e'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
