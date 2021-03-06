require 'test/test_helper'

class ReferrerTest < Test::Unit::TestCase
  context "A HttpReferrer" do
    setup do
      @referral = Referral.create_from_env :params => {}, :referrer => 'http://proplay.ru/about_igc'
      @referrer = @referral.referrer
    end

    should "be right" do
      assert @referrer.is_a? HttpReferrer
    end
  end
  
  context "A Keyword" do
    setup do
      @referral = Referral.create_from_env :params => {}, :referrer => 'http://yandex.ru/yandsearch?rpt=rad&text=hello'
      @referrer = @referral.referrer
    end

    should "be right" do
      assert @referrer.is_a? Keyword
    end
  end
  
  context "A User referrer" do
    setup do
      @user = User.create :login => 'prepor'
      @referral = Referral.create_from_env :params => {:uref => 'prepor'}, :referrer => 'http://yandex.ru/yandsearch?rpt=rad&text=hello'
      @referrer = @referral.referrer
    end

    should "be right" do
      assert @referrer.is_a? User
    end
    
    context "by other user" do
      setup do
        @user2 = User.create :login => 'zedmor'
        @user2.create_with_referral(@referral)        
      end

      should "apply block for referrer" do
        @user2.for_referrer do |user|
          user.update_attribute :login, 'zedmor_t'
        end
        assert_equal 'zedmor_t', @user.reload.login
      end
    end
    
  end
end