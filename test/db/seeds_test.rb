require "test_helper"

class SeedsTest < ActiveSupport::TestCase
  ADMIN_ENV = {
    "ROADLETTER_ADMIN_NAME" => "Kay",
    "ROADLETTER_ADMIN_EMAIL" => "kay@example.com",
    "ROADLETTER_ADMIN_PASSWORD" => "first-seed-password"
  }

  setup do
    Session.delete_all
    User.delete_all
  end

  test "creates exactly one admin from the environment" do
    with_env(ADMIN_ENV) { load_seeds }

    assert_equal 1, User.count
    assert_equal "kay@example.com", User.admin.email_address
    assert_equal "Kay", User.admin.name
    assert User.admin.authenticate("first-seed-password")
  end

  test "a second run leaves the admin untouched" do
    with_env(ADMIN_ENV) { load_seeds }
    with_env(ADMIN_ENV.merge("ROADLETTER_ADMIN_PASSWORD" => "changed-password")) { load_seeds }

    assert_equal 1, User.count
    assert User.admin.authenticate("first-seed-password")
  end

  test "creates nothing without the admin settings" do
    with_env(ADMIN_ENV.transform_values { nil }) { load_seeds }

    assert_equal 0, User.count
  end

  private
    def load_seeds
      capture_io { Rails.application.load_seed }
    end

    def with_env(values)
      previous = values.keys.index_with { |key| ENV[key] }
      values.each { |key, value| ENV[key] = value }
      yield
    ensure
      previous.each { |key, value| ENV[key] = value }
    end
end
