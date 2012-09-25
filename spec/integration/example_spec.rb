require 'spec_helper'

describe 'Login page' do
  fixtures :projects, :enabled_modules, :users, :roles, :trackers, :members, :member_roles

  it 'logs in', :js => true do
    visit '/login'
    page.should have_content('Login')

    fill_in 'Login:', :with => "admin"
    fill_in 'Password:', :with => "admin"
    click_on 'Login »'

    page.should have_content('Sign out')

    #Project.find(1).enabled_module_names = [:planner]
    visit '/projects/1'

    page.should have_content('Resource Planner')
  end
end

