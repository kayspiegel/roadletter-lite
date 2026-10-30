# Creates the single admin on the first run, from the environment or from the
# credentials. The password is used only then: later runs leave the admin as it is.
setting = ->(key) { ENV[key].presence || Rails.application.credentials[key.downcase.to_sym] }
name, email_address, password = %w[ ROADLETTER_ADMIN_NAME ROADLETTER_ADMIN_EMAIL ROADLETTER_ADMIN_PASSWORD ].map(&setting)

if User.admin
  puts "The admin exists already. Nothing to seed."
elsif [ name, email_address, password ].all?(&:present?)
  User.seed(name:, email_address:, password:)
  puts "Created the admin #{name}."
else
  puts "No admin created. Set ROADLETTER_ADMIN_NAME, ROADLETTER_ADMIN_EMAIL and ROADLETTER_ADMIN_PASSWORD, then run bin/rails db:seed."
end
