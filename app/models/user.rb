class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  normalizes :name, with: ->(name) { name.strip }

  validates :name, presence: true
  validates :locale, inclusion: { in: I18n.available_locales.map(&:to_s) }
  validate :only_one_admin, on: :create

  class << self
    def admin
      take
    end

    def seed(name:, email_address:, password:)
      admin || create!(name:, email_address:, password:)
    end
  end

  private
    def only_one_admin
      errors.add(:base, :only_one_admin) if User.exists?
    end
end
