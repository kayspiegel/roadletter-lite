class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(name) { name.strip }

  validates :name, presence: true
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validate :only_one_admin, on: :create
  validates :password, presence: true, on: :password_reset

  class << self
    def admin
      take
    end

    def seed(name:, email_address:, password:)
      admin || create!(name:, email_address:, password:)
    end
  end

  # has_secure_password skips an empty password on update, so a reset checks
  # for one itself. Every session ends with the old password.
  def reset_password(passwords)
    assign_attributes(passwords)

    if save(context: :password_reset)
      sessions.destroy_all
      true
    else
      false
    end
  end

  private
    def only_one_admin
      errors.add(:base, :only_one_admin) if User.exists?
    end
end
