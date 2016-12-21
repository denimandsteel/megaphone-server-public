require 'test_helper'

class Manager::AdministratorsControllerTest < ActionController::TestCase
  setup do
    @manager_administrator = manager_administrators(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:manager_administrators)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create manager_administrator" do
    assert_difference('Manager::Administrator.count') do
      post :create, manager_administrator: {  }
    end

    assert_redirected_to manager_administrator_path(assigns(:manager_administrator))
  end

  test "should show manager_administrator" do
    get :show, id: @manager_administrator
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @manager_administrator
    assert_response :success
  end

  test "should update manager_administrator" do
    patch :update, id: @manager_administrator, manager_administrator: {  }
    assert_redirected_to manager_administrator_path(assigns(:manager_administrator))
  end

  test "should destroy manager_administrator" do
    assert_difference('Manager::Administrator.count', -1) do
      delete :destroy, id: @manager_administrator
    end

    assert_redirected_to manager_administrators_path
  end
end
