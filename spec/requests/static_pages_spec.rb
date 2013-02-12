require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
    before { visit '/static_pages/home' }

    it "should have the h1 'CommonBlock'" do
      page.should have_selector('h1', :text => 'CommonBlock')
    end

    it "should have the base title" do
      page.should have_selector('title', :text => 'CommonBlock')
    end

    it "should not have a custom page title" do
      page.should_not have_selector('title', :text => '| Home')
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      page.should have_content('Help')
    end
  end

  describe "About page" do
    it "should have the content 'About'" do
      visit '/static_pages/about'
      page.should have_content('About')
    end
  end
end
