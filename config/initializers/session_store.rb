# Be sure to restart your server when you modify this file.

Tmanager::Application.config.session_store :cookie_store, key: ENV["TM_SESSION_STORE_KEY"]

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Tmanager::Application.config.session_store :active_record_store
