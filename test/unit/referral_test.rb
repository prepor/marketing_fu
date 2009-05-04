require 'test/test_helper'

class ReferralTest < Test::Unit::TestCase
  context "New user from campaign link" do
    setup do
      rebuild_models
      @campaign = Campaign.create :name => 'test'
      @params = {:ref => 'test'}
      @referral = Referral.create_from_env :params => @params, :referrer => 'bla bla'
      # @user = User.create :name => 'Andrew'
    end

    should "has Campaign referrer" do
      assert_equal @campaign, @referral.referrer
    end
    
    context "after reach goal" do
      setup do
        @goal = Goal.create :name => 'create post'
        @referral.reach_goal('create post')
      end

      should "reach goal" do
        assert @referral.reach_goal?('create post')
      end
      
      should "referrer has 1 reached goal" do
        assert_equal 1, @campaign.goal_count('create post')
        assert_equal 1, @campaign.goal_counts['create post']
      end
      
      context "after second reach same goal" do
        setup do
          @referral.reach_goal('create post')
        end

        should "referrer has 1 reached goal" do
          assert_equal 1, @campaign.goal_count('create post')
          assert_equal 1, @campaign.goal_counts['create post']
        end
      end
      
    end
    
    context "after registration" do
      setup do
        @user = User.create :name => 'Andrew'
        @user.create_with_referral(@referral)
      end

      should "link user with referral" do
        assert_equal @referral, @user.referral
        assert_equal @user, @referral.user
      end
        context "after authorization with another referral" do
          setup do
            @campaign2 = Campaign.create :name => 'test2'
            @referral2 = Referral.create_from_env :params => {:ref => 'test2'}, :referrer => 'bla bla'
            @user.auth_with_referral(@referral2)     
          end

          should "has old referral" do
            assert_equal @referral, @user.referral
            assert_equal @user, @referral.user
          end
          
          should "destroyed new referral" do
            assert !Referral.find_by_id(@referral2.id)
          end
        end
  
    end
    

        

  end
  
end