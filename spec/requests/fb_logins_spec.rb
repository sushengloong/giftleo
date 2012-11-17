require 'spec_helper'

describe "FbLogins" do
  it "allows user login with facebook connect" do
    user = Factory(:user)
    visit root_path
    click_button "fb_login_button"
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      :provider => 'facebook',
      :uid => '123545'
    })
  end
end
