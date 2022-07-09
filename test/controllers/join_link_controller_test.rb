require "test_helper"

class JoinLinkControllerTest < ActionDispatch::IntegrationTest
  test "should return team if join link exists and is enabled" do
    pro_team_join_link = teams(:pro_team).join_link

    get "/join/#{pro_team_join_link}", xhr: true

    assert_not_empty @response.body
    assert_response :success
  end

  test "should return not_found if join link exists but not enabled" do
    disabled_pro_team_join_link = teams(:disabled_pro_team).join_link

    get "/join/#{disabled_pro_team_join_link}", xhr: true
    
    assert_response :not_found
  end

  test "should return not_found if join link does not exist" do
    random_join_link = 1

    get "/join/#{random_join_link}", xhr: true

    assert_response :not_found
  end

  test "should join team if user authenticates and join link enabled" do
    sign_in_as users(:cody)
    join_link = teams(:pro_team).join_link

    post "/join/#{join_link}", headers: credentials

    assert_response :success

    cody = users(:cody)

    assert_equal(cody.teams.count, 1) 

    joined_team = cody.teams.first

    assert_equal(joined_team.name, "Pro Team")
  end

  test "should not join team if user doesn't authenticate" do
    join_link = teams(:pro_team).join_link

    post "/join/#{join_link}"

    assert_response :unauthorized
  end


  test "should not join team if user authenticates but join link disabled" do
    sign_in_as users(:cody)
    join_link = teams(:disabled_pro_team).join_link

    post "/join/#{join_link}", headers: credentials

    assert_response :not_found

    cody = users(:cody)
    assert_equal(cody.teams.count, 0) 
  end

  test "should not join team if user authenticates and join link does not exist" do
    sign_in_as users(:cody)
    random_join_link = 1

    post "/join/#{random_join_link}", headers: credentials

    assert_response :not_found

    cody = users(:cody)
    assert_equal(cody.teams.count, 0) 
  end
end
