# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_bdad_session',
  :secret      => 'fb4f41fb40a8ca542389b6779c96ca760bd702bbc0de949dc3dfefa9858f5354314804f998dbe49b3a3e5c61864a9d6fbfdfcc80f275c5648ae08dbdc26dcbcf'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
