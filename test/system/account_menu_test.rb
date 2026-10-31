require "application_system_test_case"

class AccountMenuTest < ApplicationSystemTestCase
  setup do
    sign_in
    assert_selector "h1", text: "Hello, Kay."
  end

  test "a click outside closes the account menu" do
    open_account_menu

    find("h1").click

    assert_no_selector ".account-menu__panel"
  end

  test "a tap outside closes the account menu on a phone" do
    emulate_width 390
    visit admin_root_path
    open_account_menu

    find(".empty-state").click

    assert_no_selector ".account-menu__panel"
  end

  test "Escape closes the account menu and returns to its trigger" do
    open_account_menu

    find("button.account-menu__item").send_keys(:escape)

    assert_no_selector ".account-menu__panel"
    assert_equal "account-menu__trigger", page.evaluate_script("document.activeElement.className")
  end

  test "a click inside the menu keeps it open" do
    open_account_menu

    find(".account-menu__email").click

    assert_selector ".account-menu__panel"
  end

  private
    def open_account_menu
      find(".account-menu__trigger").click
      assert_selector ".account-menu__panel"
    end
end
