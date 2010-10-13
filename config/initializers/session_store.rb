# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_rsvp_session',
  :secret      => '97d4979895af1a5cf2227b60f34aff08ac99bd12b708c2c2fc7a3ff26597cf7bce2a079d506a27325907543a99a315fbafc0852ab95a0a3780d45f7a1435478c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
