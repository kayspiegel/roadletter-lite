require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "locale defaults to English" do
    assert_equal "en", User.new.locale
  end

  test "locale is limited to English and German" do
    admin = users(:admin)

    admin.locale = "de"
    assert admin.valid?

    admin.locale = "fr"
    assert_not admin.valid?
  end

  test "a name is required" do
    admin = users(:admin)
    admin.name = " "

    assert_not admin.valid?
  end

  test "there is only ever one admin" do
    second = User.new(name: "Second", email_address: "second@example.com", password: "secret-password")

    assert_not second.save
    assert_equal 1, User.count
  end

  test "admin is the single user" do
    assert_equal users(:admin), User.admin
  end

  test "admin is nil before the seed has run" do
    Session.delete_all
    User.delete_all
    assert_nil User.admin
  end
end
