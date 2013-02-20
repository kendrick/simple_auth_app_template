require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "signup" do
    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_content('error') }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name", with: "Test User"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('test@example.com') }

        it { should have_selector('title', text: user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Thanks for creating an account') }

        it { should have_link('Sign out') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before do
        user.password = 'foobar'
        user.password_confirmation = 'barfoo'
        click_button "Save changes"
      end

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:updated_name)  { "Updated Name" }
      let(:updated_email) { "updated@example.com" }

      before do
        fill_in "Name",             with: updated_name
        fill_in "Email",            with: updated_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password

        click_button "Save changes"
      end

      it { should have_selector('title', text: updated_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == updated_name }
      specify { user.reload.email.should == updated_email }
    end
  end
end