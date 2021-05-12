require "test_helper"

class BindersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @binder = binders(:one)
  end

  test "should get index" do
    get binders_url, as: :json
    assert_response :success
  end

  test "should create binder" do
    assert_difference('Binder.count') do
      post binders_url, params: { binder: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show binder" do
    get binder_url(@binder), as: :json
    assert_response :success
  end

  test "should update binder" do
    patch binder_url(@binder), params: { binder: {  } }, as: :json
    assert_response 200
  end

  test "should destroy binder" do
    assert_difference('Binder.count', -1) do
      delete binder_url(@binder), as: :json
    end

    assert_response 204
  end
end
