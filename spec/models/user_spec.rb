# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do
  before { @user = User.new(name: "Test User", email: "test@example.com",
                            password: "foobar", password_confirmation: "foobar") }

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest)}
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin set to 'true'" do
    before { @user.toggle!(:admin) }

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = 'abc' * 50 }
    it { should_not be_valid }
  end

  describe "when email format is valid" do
    it "should be valid" do
      addrs = %w[user@foo.COM a_bc-er@a.b.org my.name@google.jp x+y@bar.baz.cn]
      addrs.each do |valid_addr|
        @user.email = valid_addr
        @user.should be_valid
      end
    end
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addrs = %w[email user@ user_at_something.com user@some+where.com email@com. @ --------- 2asdf]
      addrs.each do |invalid_addr|
        @user.email = invalid_addr
        @user.should_not be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " "}
    it { should_not be_valid }
  end

  describe "when password confirmation doesn't match password" do
    before { @user.password_confirmation = "another password" }
    it { should_not be_valid }
  end

  describe "when password confirmation is missing" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end

  describe "remember token" do
    before { @user.save }

    its(:remember_token) { should_not be_blank }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }

    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid password") }

      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end

    describe "with a password that's too short" do
      before { @user.password = @user.password_confirmation = "a" * 5 }
      it { should be_invalid }
    end

    describe "email address entered in mixed case" do
      let(:mixed_case_email) { "UPPER@lower.cOm" }

      it "should be downcased when saved" do
        @user.email = mixed_case_email
        @user.save
        @user.reload.email.should == mixed_case_email.downcase
      end
    end
  end
end
