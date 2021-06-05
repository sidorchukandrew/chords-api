require "test_helper"

class SetlistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @setlist = setlists(:one)
  end

  test "should get index" do
    get setlists_url, as: :json
    assert_response :success
  end

  test "should create setlist" do
    assert_difference('Setlist.count') do
      post setlists_url, params: { setlist: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show setlist" do
    get setlist_url(@setlist), as: :json
    assert_response :success
  end

  test "should update setlist" do
    patch setlist_url(@setlist), params: { setlist: {  } }, as: :json
    assert_response 200
  end

  test "should destroy setlist" do
    assert_difference('Setlist.count', -1) do
      delete setlist_url(@setlist), as: :json
    end

    assert_response 204
  end
end
