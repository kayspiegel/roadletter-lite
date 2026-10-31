require "test_helper"

class NoSignUpTest < ActionDispatch::IntegrationTest
  test "no route creates a user" do
    controllers = Rails.application.routes.routes.map { |route| route.defaults[:controller].to_s }

    assert_empty controllers.grep(/users|registrations|sign_?ups?/)
  end

  test "the usual sign-up addresses don't exist" do
    [ "/users/new", "/sign_up", "/signup", "/registrations/new", "/users" ].each do |path|
      get path
      assert_response :not_found, path
    end

    post "/users", params: { email_address: "second@example.com", password: "secret-password" }
    assert_response :not_found
    assert_equal 1, User.count
  end

  test "the sign-in page says there is one account" do
    get new_session_path

    assert_select ".auth__note", "This Roadletter has one account. There is no sign-up."
    assert_select "a[href*=sign], a[href*=regist]", count: 0
  end
end
