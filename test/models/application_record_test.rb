require "test_helper"

class ApplicationRecordTest < ActiveSupport::TestCase
  UUID_FORMAT = /\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/

  test "a record created at runtime gets a UUIDv7" do
    session = users(:admin).sessions.create!

    assert_match UUID_FORMAT, session.id
    assert_equal "7", session.id[14], "version nibble"
  end

  test "a fixture record gets a UUID" do
    assert_match UUID_FORMAT, users(:admin).id
  end

  test "a foreign key holds the UUID of its parent" do
    assert_equal users(:admin).id, sessions(:admin).user_id
  end
end
