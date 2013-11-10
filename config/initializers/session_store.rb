# Be sure to restart your server when you modify this file.

LearnApp::Application.config.session_store :cookie_store, key: '_learn_app_session'#, :domain => all

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# LearnApp::Application.config.session_store :active_record_store
# requires Rails 3.0 RC or head
# change top level domain size
#request.domain(1)
#request.subdomain(1)
Rails.application.config.session_store :cookie_store, :key => '_learn_app_session', :domain => "learnocracy.org"