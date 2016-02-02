require 'spec_helper'
require 'rails_helper'


feature "Can move from goal index to new" do
  context "when logged in" do
    before :each do
      sign_up_as_ginger_baker
      visit '/goals'
    end

    it "goal index has a 'New Goal' link to new goal page" do
      expect(page).to have_content "New Goal"
    end
 end
end


feature "Creating a goal" do
  context "when logged in" do
    before :each do
      sign_up_as_ginger_baker
      visit '/goals/new'
    end

    it "has a new goal page" do
      expect(page).to have_content 'New Goal'
    end

    it "takes a title, description, view status" do
      expect(page).to have_content 'Title'
      expect(page).to have_content 'Description'
      expect(page).to have_content 'View Status'
    end

    it "validates the presence of title" do
      fill_in 'Description', with: 'I like fitness'
      click_button 'Create New Goal'
      expect(page).to have_content 'New Goal'
      expect(page).to have_content "Title can't be blank"
    end

    it "validates the presence of description" do
      fill_in 'Title', with: 'google'
      click_button 'Create New Goal'
      expect(page).to have_content 'New Goal'
      expect(page).to have_content "Description can't be blank"
    end

    it "validates the presence of view status" do
      fill_in 'Title', with: 'google'
      click_button 'Create New Goal'
      expect(page).to have_content 'New Goal'
      expect(page).to have_content "View status is not included in the list"
    end

    it "redirects to the goal show page" do
      fill_in 'Description', with: 'I like fitness'
      fill_in 'Title', with: 'Meredith'
      choose('Public')
      click_button 'Create New Goal'

      expect(current_path).to match(/^\/goals\/(\d)+/)
      expect(page).to have_content 'Meredith'
    end

    context "on failed save" do
      before :each do
        fill_in 'Title', with: 'google'
      end

      it "displays the new link form again" do
        expect(page).to have_content 'New Goal'
      end

      it "has a pre-filled form (with the data previously input)" do
        expect(find_field('Title').value).to eq('google')
      end

      it "still allows for a successful save" do
        fill_in 'Description', with: 'google is cool'
        choose('Public')
        click_button 'Create New Goal'
        expect(page).to have_content 'google'
      end
    end
  end

  context "when logged out" do
    it "redirects to the login page" do
      visit '/goals/new'
      expect(page).to have_content 'Log In'
    end
  end
end

feature "Seeing all goals" do
  context "when logged in" do
    before :each do
      sign_up("foo")
      make_goal("yahoo", "http://yahoo.com")
      click_on "Log Out"
      sign_up_as_ginger_baker
      make_goal("google", "http://google.com")
      make_goal("amazon", "http://amazon.com")
      visit '/goals'
    end

    it "shows all the goals for all users" do
      expect(page).to have_content 'google'
      expect(page).to have_content 'yahoo'
      expect(page).to have_content 'amazon'
    end

    it "shows the current user's username" do
      expect(page).to have_content 'ginger_baker'
    end

    it "links to each of the goal's show page via goal titles" do
      click_link 'google'
      expect(page).to have_content 'google'
      expect(page).to_not have_content 'yahoo'
      expect(page).to_not have_content 'amazon'
    end
  end

  context "when logged out" do
    it "redirects to the login page" do
      visit '/goals'
      expect(page).to have_content 'Log In'
    end
  end

  context "when signed in as another user" do
    before :each do
      sign_up('ginger_baker')
      click_button 'Log Out'
      sign_up('goodbye_world')
      make_goal("facebook", "http://facebook.com")
      click_button 'Log Out'
      sign_in('ginger_baker')
    end

    it "shows others goals" do
      visit '/goals'
      expect(page).to have_content 'facebook'
    end
  end
end

feature "Showing a goal" do
  context "when logged in" do
    before :each do
      sign_up('ginger_baker')
      make_goal("google", "http://google.com")
      visit '/goals'
      click_link 'google'
    end

    it "shows the current user's username" do
      expect(page).to have_content 'ginger_baker'
    end

    it "displays the goal title" do
      expect(page).to have_content 'google'
    end

    it "displays the goal description" do
      expect(page).to have_content 'http://google.com'
    end

    it "displays a link back to the goal index" do
      expect(page).to have_content "Goals"
    end
  end
end

feature "Editing a link" do
  before :each do
    sign_up_as_ginger_baker
    make_link("google", "http://google.com")
    visit '/links'
    click_link 'google'
  end

  it "has a link on the show page to edit a link" do
    expect(page).to have_content 'Edit Link'
  end

  it "shows a form to edit the link" do
    click_link 'Edit Link'
    expect(page).to have_content 'Title'
    expect(page).to have_content 'URL'
  end

  it "has all the data pre-filled" do
    click_link 'Edit Link'
    expect(find_field('Title').value).to eq('google')
    expect(find_field('URL').value).to eq('http://google.com')
  end

  it "shows errors if editing fails" do
    click_link 'Edit Link'
    fill_in 'URL', with: ''
    click_button 'Update Link'
    expect(page).to have_content "Edit Link"
    expect(page).to have_content "Url can't be blank"
  end

  context "on successful update" do
    before :each do
      click_link 'Edit Link'
    end

    it "redirects to the link show page" do
      fill_in 'Title', with: 'DuckDuckGo'
      click_button 'Update Link'
      expect(page).to have_content 'DuckDuckGo'
    end
  end
end
