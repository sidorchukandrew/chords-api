require "test_helper"

class TeamTest < ActiveSupport::TestCase
  test "should auto-generate join url" do 
    team = Team.create
    assert_not_nil team.join_link
    assert_not team.join_link_enabled
  end
end
