require 'test_helper'

class GravatarTest < ActiveSupport::TestCase
  context "email_for_gravatar" do
    should "return the empty string for a nil email" do
      assert_equal "", Gravatar.email_for_gravatar(nil)
    end

    should "return the empty string for an empty string email" do
      assert_equal "", Gravatar.email_for_gravatar("")
    end

    should "return an email with no whitespace at the end" do
      assert_equal "woo", Gravatar.email_for_gravatar("woo  ")
    end

    should "return an email with no whitespace at the start" do
      assert_equal "woo", Gravatar.email_for_gravatar("  woo")
    end

    should "return an email with no whitespace at the start or end" do
      assert_equal "woo", Gravatar.email_for_gravatar("  woo  ")
    end

    should "return an email in lowercase form" do
      assert_equal "woo", Gravatar.email_for_gravatar("WOO")
    end

    should "return the string form of a non-string email" do
      assert_equal "100", Gravatar.email_for_gravatar(100)
    end
  end

  context "gravatar_url" do
    setup do
      @user = Factory(:user)
    end

    should "ask for the email_for_gravatar form of the user's email" do
      Gravatar.expects(:email_for_gravatar).with(@user.email).returns(@user.email)
      Gravatar.gravatar_url(@user)
    end

    should "get the md5 hash of the email" do
      Digest::MD5.expects(:hexdigest).with(Gravatar.email_for_gravatar(@user.email))
      Gravatar.gravatar_url(@user)
    end

    should "return the gravatar url for the hash of the user's email" do
      expected_url = "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(Gravatar.email_for_gravatar(@user.email))}"
      assert_equal expected_url, Gravatar.gravatar_url(@user)
    end

    should "convert a rating option into an r query string param" do
      expected_url = /(\?|&)r=pg/
      assert_match expected_url, Gravatar.gravatar_url(@user, :rating => 'pg')
    end

    should "convert a default option into an d query string param" do
      expected_url = /(\?|&)d=404/
      assert_match expected_url, Gravatar.gravatar_url(@user, :default => '404')
    end

    should "pass default option values 404, mm, identicon, monsterid, wavatar, or retro directly as the values of a d query string param" do
      ['404', 'mm', 'identicon', 'monsterid', 'wavatar', 'retro'].each do |default_keyword_arg|
        expected_url = /(\?|&)d=#{default_keyword_arg}/
        assert_match expected_url, Gravatar.gravatar_url(@user, :default => default_keyword_arg)
      end
    end

    should "url-encode default option values not from the keyword list when passing them as the values of a d query string param" do
      expected_url = /(\?|&)d=#{CGI::escape("http://www.wooo.com/my_default.png")}/
      assert_match expected_url, Gravatar.gravatar_url(@user, :default => "http://www.wooo.com/my_default.png")
    end
  end
end