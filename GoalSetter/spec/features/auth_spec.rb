require 'spec_helper'
require 'rails_helper'

feature "the signup process" do

  scenario "has a new user page" do
    visit new_user_url
    expect(page).to have_content "New User"
  end

  feature "signing up a user" do
    before(:each) do
      visit new_user_url
      fill_in 'username', with: "testing_username"
      fill_in 'password', with: 'spoons'
      click_on "Create User"
    end

    scenario "redirects to team index page after signup" do
      expect(page).to have_content "Team Index Page"
    end

    scenario "shows username on the homepage after signup" do
      expect(page).to have_content "testing_username"
    end
  end

  feature "logging in" do
    before(:each) do
      sign_up_as_ginger_baker
      sign_in("ginger_baker")
    end

    scenario "shows username on the homepage after login" do
        expect(page).to have_content "ginger_baker"
      end

    end

    feature "logging out" do
      before(:each) do
        sign_up_as_ginger_baker
        click_on "Log Out"
      end

      scenario "begins with logged out" do
        expect(page).to have_content "Log In"
      end

      scenario "doesn't show username 'ginger_baker' on the homepage" do
        expect(page).not_to have_content "ginger_baker"
      end
    end




end
