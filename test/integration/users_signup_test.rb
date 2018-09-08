require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  test "invalid signup" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: { name:  "", email: "user@invalid", password: "foo", password_confirmation: "bar" }
      }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert.alert-danger'
  end

  test "valid signup" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: {
          user: { name: "Test McTesterson", email: "test@example.com",
                  password: "password1", password_confirmation: "password1"
          }
      }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    assert t_logged_in?
  end
end
