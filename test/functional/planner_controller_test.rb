require File.dirname(__FILE__) + '/../test_helper'

class PlannerControllerTest < ActionController::TestCase
  fixtures :projects

  def test_index
    get :index, :id => 1

    assert_response :success
    assert_template 'index'
  end
end
