require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "delete current user" do
    user_to_delete = users(:andrew)
    sign_in_as user_to_delete

    delete "/users/me", headers: credentials

    assert_response :success

    u = User.find_by(email: user_to_delete.email)

    assert_nil u
  end

  test "leave team" do
    team = teams(:pro_team)
    bob = users(:bob)

    expressions_to_test = [
      "Team.find_by_name('#{team.name}').memberships.count",
      "User.find_by_email('#{bob.email}').memberships.count"
    ]

    assert_difference expressions_to_test, -1 do
        sign_in_as bob
        delete "/users/me/teams/#{team.id}", headers: credentials
    end
  end
end