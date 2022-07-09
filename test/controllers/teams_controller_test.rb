require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  test "should prevent toggling join link if not authorized" do
    sign_in_as bob

    updates = { team: { join_link_enabled: true }, join_link_enabled: true }
    pro_team_id = teams(:pro_team).id
    put "/teams/#{pro_team_id}", params: updates, headers: credentials

    assert_response :forbidden
  end

  test "should allow editing team details without add_members permission" do
    sign_in_as bob

    updates = { team: { name: "New team name" }, name: "New team name" }
    pro_team_id = teams(:pro_team).id
    put "/teams/#{pro_team_id}", params: updates, headers: credentials

    assert_response :success
  end
  
end